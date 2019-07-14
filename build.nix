with import <nixpkgs> {};
mkShell {
  buildInputs = [ xorg.libXinerama xorg.libXft xorg.libX11  ];
  shellHook = ''
    exec make
  '';
}
