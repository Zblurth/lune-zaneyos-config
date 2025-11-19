{ pkgs }:

pkgs.writeShellScriptBin "fr" ''
  # 1. Go to the folder (crucial for git commands to work)
  cd ~/zaneyos || { echo "Error: ~/zaneyos not found"; exit 1; }

  # 2. Stage all new files automatically so Nix can see them
  git add .

  # 3. Run the actual rebuild
  zcli rebuild
''

pkgs.writeShellScriptBin "frc" ''
  echo "Starting ZaneyOS Cleanup..."
  zcli cleanup
''
