with import <nixpkgs> {};
mkShell {
  buildInputs = [ xorg.libXinerama xorg.libXft xorg.libX11 xorg.libXrender ];
  shellHook = ''
    exec make
  '';
}
