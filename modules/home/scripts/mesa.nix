{ pkgs }:

pkgs.writeShellScriptBin "mesa" ''
  glxinfo | grep "OpenGL version"
''
