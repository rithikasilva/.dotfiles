import { View, div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { spaces, run, theme, home, shared, setShared } from "herdr";

export default class WorkbenchChats extends View {
  init(_initial, cx) {
    const all = spaces();
    const workbench = all.find((space) => !space.machine && space.name === "Workbench" && space.folder === `${home()}/.dotfiles/tracking`);
    const current = all.find((space) => space.active);
    if (current && current.id !== workbench?.id && current.id !== shared("dotfiles.workbench-space")) setShared("dotfiles.coding-space", current.id);
    if (workbench) {
      setShared("dotfiles.workbench-space", workbench.id);
      if (!workbench.active) run("space.select", { id: workbench.id });
    }
    this.ensure(cx);
    cx.timer.every(500, (cx) => this.ensure(cx));
  }
  ensure(cx) {
    if (shared("layout") !== "planning") return;
    const all = spaces();
    const workbench = all.find((space) => !space.machine && space.name === "Workbench" && space.folder === `${home()}/.dotfiles/tracking`);
    if (workbench) {
      this.creating = false;
      if (shared("dotfiles.workbench-space") !== workbench.id) setShared("dotfiles.workbench-space", workbench.id);
      if (!workbench.active) run("space.select", { id: workbench.id });
      return;
    }
    if (this.creating || !all.length) return;
    this.creating = true;
    run("space.new", { name: "Workbench", folder: `${home()}/.dotfiles/tracking`, machine: "" });
    cx.timer.after(10000, () => { this.creating = false; });
  }
  render() {
    const t = theme();
    const collapsed = Boolean(shared("sidebar.collapsed"));
    const space = spaces().find((item) => item.id === shared("dotfiles.workbench-space"));
    return v_flex().size_full().min_h(0).bg(t.chrome).text_size(13)
      .child(h_flex().h(36).px(16).items_center().child(div().flex_1().text_size(11.5).text_color(t.dim).child(collapsed ? "C" : "Chats"))
        .when(!collapsed && Boolean(space), (el) => el.child(div().id("new-chat").px(6).rounded(5).cursor_pointer().text_color(t.muted).hover((s) => s.bg(t.hover)).on_click(() => run("tab.new", { space: space.id })).child("+"))))
      .when(!collapsed && !space, (el) => el.child(div().px(16).text_size(12).text_color(t.dim).child("Workbench space unavailable.")))
      .child(v_flex().flex_1().min_h(0).px(8).overflow_y_scrollbar().children((space?.tabs ?? []).map((tab) =>
        h_flex().id(`workbench-chat-${tab.id}`).h(36).px(10).items_center().rounded(8).cursor_pointer()
          .when(tab.active, (el) => el.bg(t.selected)).hover((s) => s.bg(t.hover))
          .on_click(() => run("tab.select", { id: tab.id }))
          .when(collapsed, (el) => el.justify_center())
          .when(!collapsed, (el) => el.child(div().flex_1().min_w(0).truncate().text_color(tab.active ? t.foreground : t.muted).child(tab.name)))
          .when(collapsed, (el) => el.child(tab.status && tab.status !== "idle" ? div().size(7).rounded_full().bg(t[tab.status] ?? t.dim) : div().size(7).rounded_full().border_1().border_color(t.dim)))
          .when(!collapsed && Boolean(tab.status && tab.status !== "idle"), (el) => el.child(div().size(7).rounded_full().bg(t[tab.status] ?? t.dim))))));
  }
}
