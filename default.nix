{ 
  system ? builtins.currentSystem
  ,pkgs ? import <nixpkgs> { inherit system; }
  ,libX11 ? pkgs.xorg.libX11
  ,libXinerama ? pkgs.xorg.libXinerama
  ,libXft ? pkgs.xorg.libXft
  ,rwm ? pkgs.callPackage ./rwm/default.nix { }
  , ...
}:

with pkgs;
stdenv.mkDerivation {
  name = "dwm-6.2";
  src = ./.;
  buildInputs = [ libX11 libXinerama libXft rwm ];

  prePatch = ''
    sed -i "s@/usr/local@$out@" config.mk
    sed -i "s@inc/@${rwm}/usr/include@" config.mk
    sed -i "s@lib/@${rwm}/lib@" config.mk
  ''; # TODO rwm?

  buildPhase = " make ";

  meta = {
    homepage = https://github.com/kloenk/dwm;
    description = "Dynamic window manager for X, patched by Kloenk";
    license = stdenv.lib.licenses.mit;
    # TODO add maintainer
    platforms = with stdenv.lib.platforms; all;
  };
}
