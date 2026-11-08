// A compact Herdr-TUI-style agent list: chat title over the live Git branch.

import { View, div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { agents, panes, run, spaces, theme, shared } from "herdr";

function chatTitle(agent, allSpaces) {
  const tab = allSpaces.flatMap((space) => space.tabs).find((item) => item.id === agent.tab);
  if (tab?.named) return tab.name;
  const live = (agent.title ?? "").split(/\s+\|\s+/, 1)[0].replace(/^[^\p{L}\p{N}]+/u, "").trim();
  const isDirectory = /^(~[/\\]|\/|[A-Za-z]:[\\/])/.test(live);
  return live && !isDirectory && live.toLowerCase() !== agent.program?.key ? live : agent.program?.name || "Agent";
}

function status(t, agent) {
  if (agent.status === "working") return div().size(8).flex_none().rounded_full().bg(t.working);
  if (agent.status === "blocked") return div().size(8).flex_none().rounded_full().bg(t.blocked);
  if (agent.status === "done") return div().size(8).flex_none().rounded_full().bg(t.done);
  return div().size(8).flex_none().rounded_full().border(1.5).border_color(t.idle ?? t.dim);
}

export default class DotfilesAgentSummary extends View {
  render() {
    const t = theme();
    const scope = shared("dotfiles.machine-scope") ?? "local";
    const collapsed = Boolean(shared("sidebar.collapsed"));
    const visibleSpaces = spaces().filter((space) => scope === "all" || ((space.machine ?? "local") === scope && space.id !== shared("dotfiles.workbench-space")));
    const allAgents = agents().filter((agent) => visibleSpaces.some((space) => space.id === agent.space));
    const branchByPane = new Map(panes().map((pane) => [pane.pane, pane.branch]));
    const allSpaces = spaces();
    const ordered = [...allAgents].sort((left, right) => right.seq - left.seq);
    const row = (agent) => {
      const branch = branchByPane.get(agent.pane) ?? "no branch";
      const focused = agent.focused;
      return h_flex()
        .id("dotfiles-agent-summary-" + agent.address)
        .h(46)
        .px(10)
        .gap(8)
        .items_center()
        .rounded(8)
        .cursor_pointer()
        .when(focused, (element) => element.bg(t.selected))
        .hover((style) => style.bg(t.hover))
        .on_click(() => run("pane.focus", { pane: agent.pane }))
        .when(collapsed, (element) => element.justify_center())
        .when(!collapsed, (element) => element.child(
          v_flex()
            .flex_1()
            .min_w(0)
            .justify_center()
            .gap(2)
            .child(div().truncate().text_color(focused ? t.foreground : t.muted).child(chatTitle(agent, allSpaces)))
            .child(div().truncate().text_size(11).text_color(t.dim).child(branch)),
        ))
        .child(status(t, agent));
    };
    return v_flex()
      .size_full()
      .min_h(0)
      .bg(t.chrome)
      .border_t(1)
      .border_color(t.border)
      .text_size(13)
      .child(h_flex().px(16).h(41).pt(14).pb(5).flex_none().items_center().child(div().text_size(11.5).font_medium().text_color(t.dim).child(collapsed ? "A" : "Agents")))
      .when(!collapsed && allAgents.length === 0, (element) => element.child(div().px(12).text_size(12).text_color(t.dim).child("No agent status yet.")))
      .child(v_flex().id("dotfiles-agent-summary-list").flex_1().min_h(0).px(8).overflow_y_scrollbar().mode("always").children(ordered.map(row)));
  }
}
