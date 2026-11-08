// Text-only spaces list: names and branches, without directory or project icons.
//
// A space that is a linked git worktree of another open space's repo is listed
// under that space, labelled by its branch. This is display-only: unlike the
// shipped `spaces` mod it never calls space.move, so Herdr's own space order
// (and so ctrl-1..9 / space.next) is untouched.

import { View, div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { exec, hc, machines, panes, run, spaces, theme, shared } from "herdr";

function status(t, space) {
  if (!space.status || space.status === "idle") return null;
  return div().size(7).flex_none().rounded_full().bg(t[space.status] ?? t.dim);
}

// Where a space is now: its first terminal's live folder, else where new terminals start.
function where(space, allPanes) {
  const tabs = new Set(space.tabs.map((tab) => tab.id));
  return allPanes.find((pane) => tabs.has(pane.tab) && pane.cwd)?.cwd ?? (space.folder || null);
}

export default class DotfilesSpaces extends View {
  init(_props, cx) {
    this.remoteMachines = [];
    this.cx = cx;
    this.git = {}; // key -> { repo, linked }; null: not a git repo; missing: not known yet
    this.pending = new Set(); // keys being asked
    this.tried = {}; // key -> when it was last asked, so a failed ask is retried gently
    const all = spaces();
    const workbench = shared("dotfiles.workbench-space");
    const current = all.find((space) => space.active);
    if (current?.id === workbench) {
      const previous = all.find((space) => space.id === shared("dotfiles.coding-space")) ?? all.find((space) => space.id !== workbench && !space.machine);
      if (previous) run("space.select", { id: previous.id });
    }
    this.refreshMachines(cx);
    cx.timer.every(15000, (cx) => this.refreshMachines(cx));
  }

  // Is this folder a linked worktree, and of which repo? Same questions the shipped
  // spaces mod asks: a worktree's top-level differs from its repo's own .git folder.
  async probe(key, on, cwd) {
    this.pending.add(key);
    this.tried[key] = Date.now();
    try {
      const r = await exec("git", ["rev-parse", "--path-format=absolute", "--show-toplevel", "--git-common-dir"], { cwd, on });
      if (r.code === 0) {
        const [top, common] = r.stdout.trim().split("\n");
        this.git[key] = { repo: JSON.stringify([on, common]), linked: common !== `${top}/.git` };
      } else if (/not a git repository/i.test(r.stderr)) {
        this.git[key] = null; // only git's own "no" is remembered; anything else is asked again
      }
    } catch {
      // Couldn't ask (the machine is away, the folder is gone): look again later.
    }
    this.pending.delete(key);
    this.cx.notify();
  }

  // The spaces as rows: each linked worktree moves under its main checkout's space.
  nest(list) {
    const allPanes = panes();
    const rows = list.map((space) => {
      const cwd = where(space, allPanes);
      const key = JSON.stringify([space.machine ?? null, cwd]);
      if (cwd && !(key in this.git) && !this.pending.has(key) && Date.now() - (this.tried[key] ?? 0) > 15000) this.probe(key, space.machine ?? null, cwd);
      return { space, g: cwd ? this.git[key] ?? null : null, tree: null };
    });
    const mains = new Set(rows.filter((r) => r.g && !r.g.linked).map((r) => r.g.repo));
    const nested = (r) => r.g?.linked && mains.has(r.g.repo);
    const out = [];
    const placed = new Set(); // repos whose worktrees are already listed (under the first of its spaces)
    for (const r of rows) {
      if (nested(r)) continue;
      out.push(r);
      if (!r.g || r.g.linked || placed.has(r.g.repo)) continue;
      placed.add(r.g.repo);
      const kids = rows.filter((k) => nested(k) && k.g.repo === r.g.repo);
      kids.forEach((k, n) => out.push({ ...k, tree: n === kids.length - 1 ? "└─" : "├─" }));
    }
    return out;
  }

  async refreshMachines(cx) {
    try {
      const result = await hc(["machine", "ls", "--json"]);
      if (result.code === 0) this.remoteMachines = (JSON.parse(result.stdout).machines ?? []).filter((machine) => machine.state === "connected");
    } catch {}
    cx.notify();
  }

  render() {
    const t = theme();
    const scope = shared("dotfiles.machine-scope") ?? "local";
    const collapsed = Boolean(shared("sidebar.collapsed"));
    const allSpaces = spaces().filter((space) => scope === "all" || ((space.machine ?? "local") === scope && space.id !== shared("dotfiles.workbench-space")));
    const remoteMachines = [...new Map([...machines(), ...this.remoteMachines].filter((machine) => machine.name).map((machine) => [machine.name, machine])).values()];
    const emptyRemoteMachines = remoteMachines.filter((machine) => (scope === "all" || scope === machine.name) && !allSpaces.some((space) => space.machine === machine.name));
    const row = ({ space, tree }) =>
      h_flex()
        .id("dotfiles-space-" + space.id)
        .h(36)
        .px(10)
        .gap(8)
        .items_center()
        .rounded(8)
        .cursor_pointer()
        .when(space.active, (element) => element.bg(t.selected))
        .hover((style) => style.bg(t.hover))
        .on_click(() => run("space.select", { id: space.id }))
        // A nested worktree shares its parent's name, so it is labelled by its branch instead.
        .when(Boolean(tree) && !collapsed, (element) => element.pl(20).child(div().flex_none().text_size(11).text_color(t.dim).child(tree)))
        .when(!collapsed, (element) => element.child(div().flex_1().min_w(0).truncate().text_color(space.active ? t.foreground : t.muted).child(tree ? space.branch ?? space.name : scope === "all" ? `${space.machine ?? "local"} · ${space.name}` : space.name)))
        .when(!collapsed && !tree && Boolean(space.branch), (element) => element.child(div().max_w(130).truncate().text_size(11).text_color(t.dim).child(space.branch)))
        .when(collapsed, (element) => element.justify_center().child(status(t, space) ?? div().size(7).rounded_full().border_1().border_color(t.dim)))
        .when(!collapsed && Boolean(status(t, space)), (element) => element.child(status(t, space)));
    const remoteRow = (machine) =>
      h_flex()
        .id("dotfiles-remote-machine-" + machine.name)
        .h(36)
        .px(10)
        .gap(8)
        .items_center()
        .rounded(8)
        .cursor_pointer()
        .hover((style) => style.bg(t.hover))
        .on_click(() => run("space.new", { machine: machine.name }))
        .child(div().flex_1().min_w(0).truncate().text_color(t.muted).child(machine.name))
        .child(div().flex_none().text_size(11).text_color(t.dim).child("Open workspace"));

    return v_flex()
      .size_full()
      .min_h(0)
      .bg(t.chrome)
      .text_size(13)
      .child(
        h_flex()
          .h(31)
          .px(16)
          .items_center()
          .text_size(11.5)
          .text_color(t.dim)
          .child(collapsed ? "S" : "Spaces"),
      )
      .child(v_flex().id("dotfiles-space-list").flex_1().min_h(0).px(8).pb(14).overflow_y_scrollbar().mode("always").children(emptyRemoteMachines.map(remoteRow)).children(this.nest(allSpaces).map(row)));
  }
}
