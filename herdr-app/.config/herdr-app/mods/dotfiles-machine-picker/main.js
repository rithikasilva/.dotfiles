import { View, div } from "gpui-kit";
import { v_flex, h_flex, InputState, Input } from "gpui-base";
import { hc, machines, spaces, run, shared, setShared, theme, props, closeOverlay } from "herdr";

export default class MachinePicker extends View {
  init(_props, cx) {
    this.remote = [];
    this.filter = "";
    this.at = 0;
    this.input = InputState.new({ placeholder: "Find a machine…" });
    this.input.on("change", (_event, cx) => { this.filter = this.input.value(); this.at = 0; cx.notify(); });
    this.input.on("submit", () => { const entry = this.filtered()[this.at]; if (entry) this.select(entry[0]); });
    this.input.focus();
    cx.timer.after(600, () => this.input.focus());
    cx.spawn(async (cx) => {
      try {
        const result = await hc(["machine", "ls", "--json"]);
        if (result.code === 0) this.remote = JSON.parse(result.stdout).machines ?? [];
      } catch {}
      cx.notify();
    });
  }
  filtered() {
    const remote = [...new Set([...machines().map((m) => m.name), ...this.remote.map((m) => m.name)].filter(Boolean))].sort();
    const options = [["local", "local", ""], ...remote.map((name) => [name, name, ""]), ["all", "All Machines", ""]];
    const terms = this.filter.toLowerCase().trim().split(/\s+/).filter(Boolean);
    return options.filter(([, label, detail]) => terms.every((term) => `${label} ${detail}`.toLowerCase().includes(term)));
  }
  select(scope) {
    const current = spaces().find((space) => space.active);
    if (current) setShared(`dotfiles.last-space.${current.machine ?? "local"}`, current.id);
    setShared("dotfiles.machine-scope", scope);
    closeOverlay(props().overlay);
    if (scope === "all") return;
    const choices = spaces().filter((space) => (space.machine ?? "local") === scope && space.id !== shared("dotfiles.workbench-space"));
    const target = choices.find((space) => space.id === shared(`dotfiles.last-space.${scope}`)) ?? choices[0];
    if (target) run("space.select", { id: target.id });
  }
  render() {
    const t = theme();
    const options = this.filtered();
    this.at = Math.max(0, Math.min(this.at, options.length - 1));
    return v_flex().id("machine-picker").w_full().min_h(0).p(18).gap(10).bg(t.popover).text_size(13)
      .on_key_down((event, cx) => {
        if (event.key === "escape") { closeOverlay(props().overlay); cx.stop_propagation(); return; }
        if (event.key === "down" && options.length) this.at = (this.at + 1) % options.length;
        else if (event.key === "up" && options.length) this.at = (this.at + options.length - 1) % options.length;
        else return;
        cx.stop_propagation(); cx.notify();
      })
      .child(h_flex().items_center().child(div().flex_1().text_size(15).font_semibold().text_color(t.foreground).child("Machines")).child(div().text_size(11).text_color(t.dim).child("Esc")))
      .child(h_flex().h(36).flex_none().px(10).items_center().rounded(9).border_1().border_color(t.accent).bg(t.background)
        .child(Input.new(this.input).flex_1().h_full().text_size(12.8).text_color(t.foreground)))
      .child(v_flex().min_h(0).max_h(320).overflow_y_scroll().gap(2)
        .children(options.map(([id, label, detail], index) => h_flex().id(`machine-choice-${id}`).px(10).py(8).rounded(7).gap(12).items_center().cursor_pointer()
          .when(index === this.at, (el) => el.bg(t.hover)).hover((s) => s.bg(t.hover)).on_click(() => this.select(id))
          .child(div().flex_1().truncate().text_color(t.foreground).child(label))
          .when(Boolean(detail), (el) => el.child(div().text_size(11).text_color(t.dim).child(detail)))
          .when((shared("dotfiles.machine-scope") ?? "local") === id, (el) => el.child(div().text_size(11).text_color(t.dim).child("Current")))))
        .when(options.length === 0, (el) => el.child(div().px(10).py(8).text_color(t.dim).child("No machines match."))));
  }
}
