// Minimal clone of Herdr's workspace chrome for the dotfiles-owned layout.
// The macOS traffic lights are drawn by the layout, so this header deliberately
// leaves their area empty instead of rendering a competing app logo.

import { View, div, svg } from "gpui-kit";
import { h_flex, v_flex } from "gpui-base";
import { theme, run, props, window, shared, setShared, updates, layout, nextCommand } from "herdr";

function find(node, id) {
  if (node?.id === id) return node;
  for (const child of node?.children ?? []) {
    const found = find(child, id);
    if (found) return found;
  }
  return null;
}

const narrow = () => (find(layout(), "sidebar")?.size?.px ?? Infinity) < 160;

function toggleSidebar() {
  const width = find(layout(), "sidebar")?.size?.px;
  if (!narrow()) setShared("sidebar.width", width);
  setShared("sidebar.collapsed", !narrow());
  run("layout.resize", { id: "sidebar", px: narrow() ? (shared("sidebar.width") ?? 268) : window()?.platform === "macos" ? 76 : 44 });
}

export default class DotfilesWorkspaceChrome extends View {
  init(_initial, cx) {
    if (props()?.footer) return;
    cx.spawn(async () => {
      for (;;) {
        const command = await nextCommand();
        if (command === "toggle-sidebar") toggleSidebar();
        if (command === "expand-sidebar") {
          setShared("sidebar.collapsed", false);
          run("layout.resize", { id: "sidebar", px: shared("sidebar.width") ?? 268 });
          run("layout.show", { id: "sidebar" });
        }
      }
    });
  }
  button(id, label, action) {
    const t = theme();
    return div().id(id).size(26).flex_none().flex().items_center().justify_center().rounded(6).text_color(t.muted).hover((s) => s.bg(t.hover).text_color(t.foreground))
      .on_mouse_down("left", (_event, cx) => cx.stop_propagation()).on_click(action).child(label);
  }

  render() {
    const t = theme();
    const collapsed = narrow();
    if (props()?.footer) {
      const row = (id, icon, label, dim, action) => h_flex().id(id).h(28).px(8).gap(9).items_center().rounded(8)
        .text_color(dim ? t.dim : t.muted).hover((s) => s.bg(t.hover).text_color(t.foreground)).cursor_pointer()
        .on_click(action).child(svg("mods/workspace-chrome/" + icon + ".svg").size(14))
        .when(!collapsed, (element) => element.child(label));
      return v_flex().size_full().bg(t.chrome).border_t(1).border_color(t.border).px(8).pt(4).pb(8).text_size(13)
        .child(row("settings", "settings", "Settings", false, () => run("app.settings"))
          .when(Boolean(updates().app.ready), (element) => element.child(div().size(6).rounded_full().bg(t.accent))))
        .child(row("machine", "plus", "Add machine", true, () => run("mod.open", { name: "machine-add" })));
    }
    return h_flex().size_full().bg(t.chrome).pl(collapsed ? 6 : 14).pr(10).gap(4).items_center().text_size(13.5)
      .when(window()?.platform === "macos" && !window()?.fullscreen && !collapsed, (element) => element.pl(76))
      .child(div().flex_1())
      .when(!collapsed, (element) => element.child(this.button("search", svg("mods/workspace-chrome/search.svg").size(15), () => run("mod.open", { name: "picker" }))))
      .when(!(collapsed && window()?.platform === "macos"), (element) => element.child(this.button("sidebar-toggle", svg("mods/workspace-chrome/sidebar.svg").size(15), toggleSidebar)));
  }
}
