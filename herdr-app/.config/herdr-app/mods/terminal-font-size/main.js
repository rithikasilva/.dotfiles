import { View, div } from "gpui-kit";
import { appHome, nextCommand, readTextFile, writeTextFile } from "herdr";

const DEFAULT_FONT_SIZE = 14;
const STEP = 1;
const MIN_FONT_SIZE = 8;
const MAX_FONT_SIZE = 32;

export default class TerminalFontSize extends View {
  init(_props, cx) {
    cx.spawn(async (cx) => {
      for (;;) {
        const command = await nextCommand();
        if (command === "increase") {
          await this.changeFontSize(STEP);
        } else if (command === "decrease") {
          await this.changeFontSize(-STEP);
        } else if (command === "reset") {
          await this.resetFontSize();
        }
        cx.notify();
      }
    });
  }

  async changeFontSize(delta) {
    await this.updateSettings((settings) => {
      const current = Number.isFinite(settings.font_size)
        ? settings.font_size
        : DEFAULT_FONT_SIZE;
      settings.font_size = Math.max(
        MIN_FONT_SIZE,
        Math.min(MAX_FONT_SIZE, current + delta),
      );
    });
  }

  async resetFontSize() {
    await this.updateSettings((settings) => {
      delete settings.font_size;
    });
  }

  async updateSettings(change) {
    const path = `${appHome()}/settings.json`;

    for (let attempt = 0; attempt < 3; attempt += 1) {
      const text = await readTextFile(path);
      let settings = {};
      try {
        settings = text === null ? {} : JSON.parse(text);
      } catch (error) {
        console.error("terminal-font-size: settings.json is invalid", error);
        return;
      }

      change(settings);
      try {
        await writeTextFile(path, `${JSON.stringify(settings, null, 2)}\n`, text);
        return;
      } catch (error) {
        if (attempt === 2) {
          console.error("terminal-font-size: could not update settings", error);
        }
      }
    }
  }

  render() {
    return div().id("terminal-font-size");
  }
}
