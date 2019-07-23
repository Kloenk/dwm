with import <nixpkgs> {};
mkShell {
  buildInputs = [ xorg.libXinerama xorg.libXft xorg.libX11 rust-cbindgen ];
  shellHook = ''
    exec make
  '';
}
