{ 
  system ? builtins.currentSystem
  ,pkgs ? import <nixpkgs> { inherit system; }
  ,libX11 ? pkgs.xorg.libX11
  ,libXinerama ? pkgs.xorg.libXinerama
  ,libXft ? pkgs.xorg.libXft
  ,rwm ? pkgs.callPackage ./rwm/default.nix { }
  ,xrandr ? pkgs.xorg.xrandr
  ,xf86_input_wacom ? pkgs.xf86_input_wacom
  , ...
}:

with pkgs;
let 
  rotate_sh = writeScript "rotate.sh" ''
    #!/usr/bin/env bash
    
    # Find the line in "xrandr -q --verbose" output that contains current screen orientation and "strip" out current orientation.
    rotation="$(${xrandr}/bin/xrandr -q --verbose | grep 'connected' | egrep -o  '\) (normal|left|inverted|right) \(' | egrep -o '(normal|left|inverted|right)')"
    
    stylus="Wacom ISDv4 90 Pen stylus"
    eraser="Wacom ISDv4 90 Pen eraser"
    
    # Using current screen orientation proceed to rotate screen and input tools.
    case "$rotation" in
        normal)
        # rotate to the left
        ${xrandr}/bin/xrandr -o inverted
        ${xf86_input_wacom}/bin/xsetwacom set "$stylus" rotate half
        ${xf86_input_wacom}/bin/xsetwacom set "$eraser" rotate half
        ;;
        inverted)
        # rotate to normal
        ${xrandr}/bin/xrandr -o normal
        ${xf86_input_wacom}/bin/xsetwacom set "$stylus" rotate none
        ${xf86_input_wacom}/bin/xsetwacom set "$eraser" rotate none
        ;;
    esac
  '';
in
stdenv.mkDerivation {
  name = "dwm-6.2";
  src = ./.;
  buildInputs = [ libX11 libXinerama libXft rwm ];

  prePatch = ''
    sed -i "s@/usr/local@$out@" config.mk
    sed -i "s@inc/@${rwm}/usr/include@" config.mk
    sed -i "s@lib/@${rwm}/lib@" config.mk
    sed -i "s@rotate.sh@${rotate_sh}@" config.h
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
