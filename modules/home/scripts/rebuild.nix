{ pkgs }:

pkgs.writeShellScriptBin "fr" ''
  # 1. Go to the folder
  cd ~/zaneyos || { echo "Error: ~/zaneyos not found"; exit 1; }

  # 2. Stage new files
  git add .

  # 3. Run the rebuild
  zcli rebuild
''
