{ pkgs }:

# The string inside quotes here ":3" is what you will type in the terminal
pkgs.writeShellScriptBin ":3" ''
  echo "sudo make me a sandwich :3"
''
