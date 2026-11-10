import { View, div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { spaces, run, theme, home, shared, setShared } from "herdr";

export default class WorkbenchChats extends View {
  init() {
    const all = spaces();
    const workbench = all.find((space) => !space.machine && space.name === "Workbench" && space.folder === `${home()}/.dotfiles/tracking`);
    const current = all.find((space) => space.active);
    if (workbench) setShared("dotfiles.workbench-space", workbench.id);
    if (current && current.id !== workbench?.id) setShared("dotfiles.coding-space", current.id);
  }

  selectSpace(space, workbench) {
    if (space.id !== workbench?.id) setShared("dotfiles.coding-space", space.id);
    run("space.select", { id: space.id });
  }

  render() {
    const t = theme();
    const collapsed = Boolean(shared("sidebar.collapsed"));
    const all = spaces();
    const current = all.find((space) => space.active);
    const workbench = all.find((space) => !space.machine && space.name === "Workbench" && space.folder === `${home()}/.dotfiles/tracking`);
    const work = (current && current.id !== workbench?.id ? current : null)
      ?? all.find((space) => space.id === shared("dotfiles.coding-space") && space.id !== workbench?.id)
      ?? all.find((space) => space.id !== workbench?.id && !space.machine);
    const visible = [workbench, work].filter(Boolean);
    return v_flex().size_full().min_h(0).bg(t.chrome).text_size(13)
      .child(div().h(36).px(16).flex().items_center().text_size(11.5).text_color(t.dim).child(collapsed ? "S" : "Spaces"))
      .children(visible.map((space) => h_flex().id(`planning-space-${space.id}`).h(36).mx(8).px(10).items_center().rounded(8).cursor_pointer()
        .when(space.active, (el) => el.bg(t.selected)).hover((s) => s.bg(t.hover))
        .on_click(() => this.selectSpace(space, workbench))
        .child(div().flex_1().min_w(0).truncate().text_color(space.active ? t.foreground : t.muted).child(collapsed ? (space.name ?? "S").slice(0, 1) : space.name ?? "Untitled"))))
      .child(div().h(36).px(16).flex().items_center().text_size(11.5).text_color(t.dim).child(collapsed ? "T" : "Tabs"))
      .child(v_flex().flex_1().min_h(0).px(8).overflow_y_scrollbar().children((current?.tabs ?? []).map((tab) =>
        h_flex().id(`workbench-chat-${tab.id}`).h(36).px(10).items_center().rounded(8).cursor_pointer()
          .when(tab.active, (el) => el.bg(t.selected)).hover((s) => s.bg(t.hover))
          .on_click(() => run("tab.select", { id: tab.id }))
          .when(collapsed, (el) => el.justify_center())
          .when(!collapsed, (el) => el.child(div().flex_1().min_w(0).truncate().text_color(tab.active ? t.foreground : t.muted).child(tab.name)))
          .when(collapsed, (el) => el.child(tab.status && tab.status !== "idle" ? div().size(7).rounded_full().bg(t[tab.status] ?? t.dim) : div().size(7).rounded_full().border_1().border_color(t.dim)))
          .when(!collapsed && Boolean(tab.status && tab.status !== "idle"), (el) => el.child(div().size(7).rounded_full().bg(t[tab.status] ?? t.dim))))));
  }
}
