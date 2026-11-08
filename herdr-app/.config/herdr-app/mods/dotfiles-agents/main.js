// A compact Herdr-TUI-style agent list: chat title over the live Git branch.

import { View, div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { agents, panes, run, spaces, theme } from "herdr";

function chatTitle(agent, allSpaces) {
  const tab = allSpaces.flatMap((space) => space.tabs).find((item) => item.id === agent.tab);
  if (tab?.named) return tab.name;
  // Herdr terminal titles commonly use "chat title | working-directory".
  // Keep the chat portion only; paths never belong in this list.
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

export default class DotfilesAgents extends View {
  render() {
    const t = theme();
    const allAgents = agents();
    const allPanes = panes();
    const allSpaces = spaces();
    const branchByPane = new Map(allPanes.map((pane) => [pane.pane, pane.branch]));
    const ordered = [...allAgents].sort((left, right) => right.seq - left.seq);

    const row = (agent) => {
      const branch = branchByPane.get(agent.pane) ?? "no branch";
      const focused = agent.focused;
      return h_flex()
        .id("dotfiles-agent-" + agent.address)
        .h(46)
        .px(10)
        .gap(8)
        .items_center()
        .rounded(8)
        .cursor_pointer()
        .when(focused, (element) => element.bg(t.selected))
        .hover((style) => style.bg(t.hover))
        .on_click(() => run("pane.focus", { pane: agent.pane }))
        .child(
          v_flex()
            .flex_1()
            .min_w(0)
            .justify_center()
            .gap(2)
            .child(div().truncate().text_color(focused ? t.foreground : t.muted).child(chatTitle(agent, allSpaces)))
            .child(div().truncate().text_size(11).text_color(t.dim).child(branch)),
        )
        .child(status(t, agent));
    };

    return v_flex()
      .size_full()
      .min_h(0)
      .bg(t.chrome)
      .border_t(1)
      .border_color(t.border)
      .text_size(13)
      .child(h_flex().px(16).h(41).pt(14).pb(5).flex_none().items_center().child(div().text_size(11.5).font_medium().text_color(t.dim).child("Agents")))
      .when(allAgents.length === 0, (element) => element.child(div().px(12).text_size(12).text_color(t.dim).child("No agent status yet.")))
      .child(v_flex().id("dotfiles-agent-list").flex_1().min_h(0).px(8).overflow_y_scrollbar().mode("always").children(ordered.map(row)));
  }
}
