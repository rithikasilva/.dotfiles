import { View, div } from "gpui-kit";
import { h_flex, v_flex, TextView, InputState, Input } from "gpui-base";
import { home, readTextFile, watchFolder, theme, focused, exec } from "herdr";

export default class WorkbenchPreview extends View {
  init(_initial, cx) {
    this.root = `${home()}/.dotfiles/tracking`;
    const defaults = ["backlog.md", "active.md", "completed.md"].map((name) => `${this.root}/${name}`);
    let saved = [];
    try { const value = JSON.parse(localStorage.getItem("workbench.extra-files") ?? "[]"); if (Array.isArray(value)) saved = value.filter((path) => typeof path === "string" && path.startsWith("/") && /\.(md|markdown|mdx)$/i.test(path)); } catch {}
    this.files = [...new Set([...defaults, ...saved])];
    this.selected = this.files[0];
    this.text = null;
    this.request = 0;
    this.input = InputState.new({ placeholder: "Filter Markdown files…" });
    this.query = "";
    this.matches = [];
    this.at = 0;
    this.input.on("change", (_event, cx) => { this.query = this.input.value(); this.at = 0; cx.notify(); });
    this.input.on("submit", (_event, cx) => { if (this.matches[this.at]) this.openPath(this.matches[this.at], cx); });
    this.load(cx);
    this.watch(cx);
    cx.timer.every(5000, (cx) => this.load(cx));
  }
  watch(cx) {
    const dir = this.selected.slice(0, this.selected.lastIndexOf("/")) || "/";
    const token = this.watching = {};
    cx.spawn(async (cx) => {
      try { while (this.watching === token) { const changed = await watchFolder(dir); if (this.watching === token && changed.includes(this.selected)) this.load(cx); } } catch {}
    });
  }
  select(path, cx) {
    if (path === this.selected) return;
    this.selected = path;
    this.error = null;
    this.load(cx);
    this.watch(cx);
    cx.notify();
  }
  openPicker(cx) {
    this.opening = !this.opening;
    if (!this.opening) { cx.notify(); return; }
    this.input.focus();
    this.pickerLoading = true;
    this.pathError = null;
    const cwd = focused()?.cwd;
    const roots = [...new Set([this.root, ...(cwd && cwd !== home() ? [cwd] : [])])];
    cx.spawn(async (cx) => {
      try {
        const results = await Promise.all(roots.map((root) => exec("find", [root, "-maxdepth", "4", "-type", "f", "(", "-iname", "*.md", "-o", "-iname", "*.markdown", "-o", "-iname", "*.mdx", ")", "-not", "-path", "*/.git/*", "-not", "-path", "*/node_modules/*", "-print0"])));
        this.candidates = [...new Set(results.flatMap((result) => result.stdout.split("\0").filter(Boolean)))].sort((a, b) => a.localeCompare(b));
        if (results.every((result) => result.code !== 0)) this.pathError = "Could not list Markdown files.";
      } catch { this.pathError = "Could not list Markdown files."; }
      finally { this.pickerLoading = false; cx.notify(); }
    });
    cx.notify();
  }
  openPath(path, cx) {
    if (!this.files.includes(path)) this.files.push(path);
    localStorage.setItem("workbench.extra-files", JSON.stringify(this.files.slice(3)));
    this.opening = false;
    this.pathError = null;
    this.input.set_value(""); this.query = "";
    this.select(path, cx);
    cx.notify();
  }
  closePath(path, cx) {
    const index = this.files.indexOf(path);
    if (index < 3) return;
    this.files.splice(index, 1);
    localStorage.setItem("workbench.extra-files", JSON.stringify(this.files.slice(3)));
    if (this.selected === path) this.select(this.files[Math.max(0, index - 1)], cx);
    cx.notify();
  }
  load(cx) {
    const request = ++this.request;
    const file = this.selected;
    cx.spawn(async (cx) => {
      let text = null, error = null;
      try {
        text = await readTextFile(file);
        if (text === null) error = "File not found";
      } catch { error = "Cannot read this file"; }
      if (request !== this.request || file !== this.selected) return;
      if (error) {
        if (this.error === error) return;
        this.error = error;
      } else {
        if (text === this.text && file === this.textFile && !this.error) return;
        this.text = text.slice(0, 400000);
        this.textFile = file;
        this.error = null;
      }
      cx.notify();
    });
  }
  render(cx) {
    const t = theme();
    const terms = this.query.toLowerCase().split(/\s+/).filter(Boolean);
    this.matches = (this.candidates ?? []).filter((path) => terms.every((word) => path.toLowerCase().includes(word)));
    this.at = Math.max(0, Math.min(this.at, this.matches.length - 1));
    return v_flex().size_full().min_h(0).bg(t.background).text_color(t.foreground)
      .child(h_flex().h(46).flex_none().px(8).gap(4).items_center().bg(t.chrome).border_b(1).border_color(t.border)
        .child(h_flex().id("workbench-file-tabs").flex_1().min_w(0).gap(4).items_center().overflow_x_scrollbar()
          .children(this.files.map((path, index) => h_flex().id(`file-tab-${index}`).h(30).px(9).gap(6).items_center().flex_none().rounded(7).cursor_pointer()
            .text_size(12).text_color(path === this.selected ? t.foreground : t.muted)
            .when(path === this.selected, (el) => el.bg(t.raised).border_1().border_color(t.border))
            .hover((s) => s.bg(t.hover)).on_click((_event, cx) => this.select(path, cx))
            .child(div().max_w(130).truncate().child(path.split("/").pop()))
            .when(index >= 3, (el) => el.child(div().id(`close-file-${index}`).px(3).text_color(t.dim).hover((s) => s.text_color(t.foreground))
              .on_mouse_down("left", (_event, cx) => cx.stop_propagation())
              .on_click((_event, cx) => { cx.stop_propagation(); this.closePath(path, cx); }).child("×"))))))
        .child(div().id("open-markdown").size(28).flex_none().flex().items_center().justify_center().rounded(6).cursor_pointer().text_color(t.muted)
          .hover((s) => s.bg(t.hover).text_color(t.foreground)).on_click((_event, cx) => this.openPicker(cx)).child("+")))
      .when(this.opening, (el) => el.child(v_flex().px(10).py(8).gap(6).border_b(1).border_color(t.border)
        .child(h_flex().items_center().child(div().flex_1().font_semibold().text_size(12).child("Markdown"))
          .child(div().text_size(11).text_color(t.dim).child("Tracking and current folder")))
        .child(h_flex().h(34).px(9).items_center().rounded(7).border_1().border_color(t.accent).bg(t.background)
          .on_key_down((event, cx) => {
            if (event.key === "down" && this.matches.length) this.at = (this.at + 1) % this.matches.length;
            else if (event.key === "up" && this.matches.length) this.at = (this.at + this.matches.length - 1) % this.matches.length;
            else if (event.key === "escape") this.opening = false;
            else return;
            cx.stop_propagation(); cx.notify();
          })
          .child(Input.new(this.input).flex_1().h_full().text_size(12).text_color(t.foreground)))
        .child(v_flex().max_h(220).overflow_y_scroll().gap(2)
          .children(this.matches.slice(0, 200).map((path, index) => h_flex().id(`markdown-choice-${index}`).h(30).px(8).gap(8).items_center().rounded(6).cursor_pointer()
            .when(index === this.at, (item) => item.bg(t.hover)).hover((s) => s.bg(t.hover))
            .on_click((_event, cx) => this.openPath(path, cx))
            .child(div().min_w(0).truncate().text_size(12).text_color(t.foreground).child(path.split("/").pop()))
            .child(div().flex_1().min_w(0).truncate().text_size(11).text_color(t.dim).child(path.slice(0, path.lastIndexOf("/"))))))
          .when(!this.matches.length, (item) => item.child(div().p(8).text_size(12).text_color(t.dim).child(this.pathError || (this.pickerLoading ? "Loading…" : "No Markdown files match.")))))))
      .child(this.error ? div().p(14).text_color(t.dim).child(this.error)
        : this.text === null ? div().p(14).text_color(t.dim).child("Loading…")
        : div().flex_1().min_h(0).px(20).py(14).text_size(14)
          .child(TextView.markdown(`tracking-markdown-${this.textFile}`, this.text).scrollable(true).selectable(true).size_full()));
  }
}
