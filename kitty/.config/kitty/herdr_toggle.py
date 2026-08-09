from typing import List

from kitty.boss import Boss
from kittens.tui.handler import result_handler

TAB_TITLE = "herdr"


def main(args: List[str]) -> str:
    return ""


@result_handler(no_ui=True)
def handle_result(args: List[str], answer: str, target_window_id: int, boss: Boss) -> None:
    is_herdr_focused = boss.active_tab is not None and boss.active_tab.effective_title == TAB_TITLE

    tabs = boss.match_tabs(f"title:^{TAB_TITLE}$")
    tab = next(tabs, None)

    if tab is not None:
        if is_herdr_focused:
            boss.goto_tab(0)  # previously active tab, not tab index 0
        else:
            boss.set_active_tab(tab)
    else:
        boss.launch(
            "--type=tab",
            f"--tab-title={TAB_TITLE}",
            "herdr",
        )
