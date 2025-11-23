{ pkgs }:

pkgs.writeShellScriptBin "screenshootin" ''
  # 1. Create a temp file
  tmpfile=$(mktemp /tmp/screenshot-XXXXXXXX.png)

  # 2. Capture to the file
  grim -g "$(slurp)" "$tmpfile"

  # 3. Explicitly copy image to clipboard
  wl-copy --type image/png < "$tmpfile"

  # 4. Open Swappy
  cat "$tmpfile" | swappy -f -

  # 5. Cleanup
  #rm "$tmpfile"
''
