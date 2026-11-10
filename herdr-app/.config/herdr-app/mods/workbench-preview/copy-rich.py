#!/usr/bin/env python3
"""Copy a Markdown file as rich text and HTML on macOS."""
import argparse
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

PASTEBOARD = r'''
ObjC.import("AppKit");
function run(args) {
  const board = args[3] ? $.NSPasteboard.pasteboardWithName($(args[3])) : $.NSPasteboard.generalPasteboard;
  const rtf = $.NSData.dataWithContentsOfFile($(args[0]));
  const html = $.NSData.dataWithContentsOfFile($(args[1]));
  const plainData = $.NSData.dataWithContentsOfFile($(args[2]));
  if (!rtf || !html || !plainData) throw new Error("Could not read converted content");
  const plain = $.NSString.alloc.initWithDataEncoding(plainData, $.NSUTF8StringEncoding);
  if (!plain) throw new Error("Could not read plain text");
  board.clearContents;
  if (!board.setDataForType(rtf, $.NSPasteboardTypeRTF) ||
      !board.setDataForType(html, $.NSPasteboardTypeHTML) ||
      !board.setStringForType(plain, $.NSPasteboardTypeString)) {
    throw new Error("Could not write to the clipboard");
  }
}
'''


def convert(pandoc: str, markdown: str, output: str) -> str:
    result = subprocess.run(
        [pandoc, '--from=gfm', f'--to={output}', '--standalone'],
        input=markdown, text=True, capture_output=True, check=False,
    )
    if result.returncode:
        raise RuntimeError(result.stderr.strip() or 'Markdown conversion failed')
    return result.stdout


def copy(path: Path, pasteboard: str = '') -> None:
    pandoc = shutil.which('pandoc')
    if not pandoc:
        raise RuntimeError('Pandoc is required. Install it with: brew install pandoc')
    markdown = path.read_text(encoding='utf-8')
    rtf = convert(pandoc, markdown, 'rtf')
    html = convert(pandoc, markdown, 'html5')
    plain = convert(pandoc, markdown, 'plain')
    # Outlook does not preserve HTML form controls. Use visible checkbox glyphs.
    html = re.sub(r'<input\b[^>]*\btype="checkbox"[^>]*>',
                  lambda m: '☑ ' if re.search(r'\bchecked(?:=|\s|/|>)', m.group()) else '☐ ', html)
    with tempfile.TemporaryDirectory(prefix='herdr-copy-') as tmp:
        paths = [Path(tmp) / name for name in ('page.rtf', 'page.html', 'page.txt')]
        for file, text in zip(paths, (rtf, html, plain)):
            file.write_text(text, encoding='utf-8')
        result = subprocess.run(
            ['/usr/bin/osascript', '-l', 'JavaScript', '-e', PASTEBOARD, *(str(p) for p in paths), pasteboard],
            text=True, capture_output=True, check=False,
        )
        if result.returncode:
            raise RuntimeError(result.stderr.strip() or 'Could not write to the clipboard')


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('path', type=Path)
    parser.add_argument('--test-pasteboard', default='', help=argparse.SUPPRESS)
    args = parser.parse_args()
    if sys.platform != 'darwin':
        print('Formatted copy currently requires macOS.', file=sys.stderr)
        return 1
    try:
        copy(args.path, args.test_pasteboard)
    except (OSError, RuntimeError) as error:
        print(error, file=sys.stderr)
        return 1
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
