{ pkgs }:

pkgs.writeShellScriptBin "gp" ''
  # Stop if we can't find the folder
  cd ~/zaneyos || { echo "Error: ~/zaneyos not found"; exit 1; }

  # Add changes
  git add .

  # Commit - use arguments as message, or default to "Auto Update"
  if [ -z "$*" ]; then
    git commit -m "Auto Update"
  else
    git commit -m "$*"
  fi

  # Push to GitHub
  git push
''
