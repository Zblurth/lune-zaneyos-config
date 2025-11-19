{ pkgs }:

pkgs.writeShellScriptBin "frc" ''
  echo "Starting ZaneyOS Cleanup..."
  zcli cleanup
''
