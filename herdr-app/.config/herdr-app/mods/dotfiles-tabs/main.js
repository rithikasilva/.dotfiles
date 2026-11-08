// Dotfiles-owned tabs, without the new-tab or Files/Changes controls.

import { View, div, svg, image } from "gpui-kit";
import { h_flex } from "gpui-base";
import { spaces, panes, run, openOverlay, theme, window, layout, settings, shared, setShared, nextCommand } from "herdr";

function find(node, id) {
  if (node?.id === id) return node;
  for (const child of node?.children ?? []) {
    const found = find(child, id);
    if (found) return found;
  }
  return null;
}

export default class DotfilesTabs extends View {
  init(_initial, cx) {
    this.pressed = null;
    if (!shared("dotfiles.machine-scope")) setShared("dotfiles.machine-scope", "local");
    cx.spawn(async () => { for (;;) { const command = await nextCommand(); if (command === "new-shell") this.newShell(); } });
    cx.timer.every(250, () => this.syncMachineView());
  }

  newShell() {
    const scope = shared("dotfiles.machine-scope") ?? "local";
    const active = spaces().find((space) => space.active);
    if (scope === "all" || (active && (active.machine ?? "local") === scope && active.id !== shared("dotfiles.workbench-space"))) run("tab.new", { space: active?.id });
    else run("space.new", { machine: scope === "local" ? "" : scope });
  }

  syncMachineView() {
    if (shared("layout") !== "dev") return;
    const scope = shared("dotfiles.machine-scope") ?? "local";
    const current = spaces().find((space) => space.active);
    const choices = spaces().filter((space) => (space.machine ?? "local") === scope && space.id !== shared("dotfiles.workbench-space"));
    const selected = scope === "all" || (current && choices.some((space) => space.id === current.id));
    if (!selected && choices.length) { run("space.select", { id: choices[0].id }); return; }
    const desired = selected ? "main" : "empty-machine";
    if (find(layout(), "machine-view")?.active !== desired) run("layout.select", { stack: "machine-view", child: desired });
  }

  render() {
    const t = theme();
    const space = spaces().find((item) => item.active);
    const scope = shared("dotfiles.machine-scope") ?? "local";
    const shown = scope === "all" || (space?.machine ?? "local") === scope ? space?.tabs ?? [] : [];
    const stop = (_event, cx) => cx.stop_propagation();
    const button = (id, label, action) => div().id(id).size(26).flex_none().flex().items_center().justify_center().rounded(6).text_color(t.dim).hover((style) => style.bg(t.hover).text_color(t.foreground))
      .on_mouse_down("left", stop).on_click(action).child(label);
    const item = (tab, index) => {
      const program = panes().find((pane) => pane.tab === tab.id && pane.program?.agent)?.program ?? panes().find((pane) => pane.tab === tab.id)?.program;
      const name = /^tb\d+$/.test(tab.name) ? program?.name ?? "Terminal" : tab.name;
      return h_flex().id(`tab-${tab.id}`).h(29).px(10).gap(7).rounded(7).items_center().flex_none().text_size(12.8)
        .border(1).border_color(tab.active ? t.border : t.chrome).bg(tab.active ? t.raised : t.chrome).text_color(tab.active ? t.foreground : t.muted)
        .hover((style) => style.bg(t.hover))
        .on_mouse_down("left", (event, cx) => { cx.stop_propagation(); this.pressed = index; if (event.click_count === 2) run("tab.rename", { id: tab.id }); })
        .on_mouse_up("left", () => {
          const from = this.pressed;
          this.pressed = null;
          if (from !== null && from !== index) run("tab.move", { id: shown[from].id, index: space.tabs.findIndex((candidate) => candidate.id === tab.id) + 1 });
          else run("tab.select", { id: tab.id });
        })
        .on_mouse_down("right", (_event, cx) => { cx.stop_propagation(); openOverlay({ mod: "menu", kind: "popup", width: 200, props: { tab: "tab", target: { id: tab.id, space: space.id } } }); })
        .when(Boolean(program?.icon), (element) => element.child(program.tint ? svg(program.icon).size(14).text_color(t.muted) : image(program.icon).size(14)))
        .child(div().max_w(170).truncate().child(tab.zoomed ? `${name} Z` : name))
        .when(tab.status === "working", (element) => element.child(svg("mods/workspace-chrome/spinner.svg").size(12).flex_none().text_color(t.working).spin(900)))
        .when(tab.status === "blocked" || tab.status === "done", (element) => element.child(div().size(6).rounded(3).bg(t[tab.status])))
        .when(tab.active, (element) => element.child(div().id(`close-${tab.id}`).text_color(t.dim).on_mouse_down("left", stop).on_click((_event, cx) => { cx.stop_propagation(); run("tab.close", { id: tab.id }); }).child(svg("mods/pane/close.svg").size(12))));
    };
    const root = layout();
    const sidebar = find(root, "sidebar");
    const appWindow = window();
    const lightsPadding = appWindow?.platform === "macos" && appWindow.titlebar === "none" && !appWindow.fullscreen && root?.traffic_lights
      ? Math.max(10, (root.traffic_lights[0] + 64) / settings().zoom - (sidebar?.hidden ? 0 : sidebar?.size?.px ?? 0))
      : 10;
    return h_flex().size_full().min_w(0).px(10).pl(lightsPadding).gap(3).items_center().bg(t.chrome).border_b(1).border_color(t.border)
      .on_mouse_up("left", () => { this.pressed = null; })
      .on_scroll_wheel((event) => { if (Math.abs(event.delta.y) >= 1) run(event.delta.y > 0 ? "tab.prev" : "tab.next"); })
      .child(h_flex().id("tab-scroll").flex_1().min_w(0).h_full().items_center().gap(3).overflow_x_scrollbar().children(shown.map(item)))
      .when(appWindow?.buttons, (element) => element.child(button("minimize", appWindow.platform === "windows" ? svg("mods/tabs/win-min.svg").size(16) : "−", () => run("window.minimize")))
        .child(button("maximize", appWindow.platform === "windows" ? svg(`mods/tabs/${appWindow.maximized ? "win-restore" : "win-max"}.svg`).size(16) : "□", () => run("window.maximize")))
        .child(button("close-window", appWindow.platform === "windows" ? svg("mods/tabs/win-close.svg").size(16) : svg("mods/pane/close.svg").size(13), () => run("window.close"))));
  }
}
