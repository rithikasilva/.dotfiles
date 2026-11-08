import { View, div } from "gpui-kit";
import { theme } from "herdr";

export default class EmptyMachine extends View {
  render() {
    const t = theme();
    return div().size_full().bg(t.background);
  }
}
