{ pkgs }:

pkgs.writeShellScriptBin "image2png" ''
  GREEN='\033[0;32m'
  RED='\033[0;31m'
  NC='\033[0m'

  echo -e "🖼️  ''${GREEN}Starting conversion to PNG...''${NC}"

  if ls *.jpg 1> /dev/null 2>&1 || ls *.jpeg 1> /dev/null 2>&1 || ls *.JPG 1> /dev/null 2>&1; then
      ${pkgs.imagemagick}/bin/mogrify -format png *.jpg *.jpeg *.JPG *.JPEG 2>/dev/null
      echo -e "🧹  ''${GREEN}Cleaning up old JPG files...''${NC}"
      rm -f *.jpg *.jpeg *.JPG *.JPEG
      echo -e "✅  ''${GREEN}Done! All images are now PNG.''${NC}"
  else
      echo -e "''${RED}No JPG/JPEG files found.''${NC}"
  fi
''
