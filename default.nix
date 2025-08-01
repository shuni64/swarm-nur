# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:

# TODO: replace use of rec with either makeExtensible or by placing packages in a nixpkgs overlay
# it would be nice to not require explicitly specifying internal dependencies
rec {
  # The `lib`, `modules`, and `overlays` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  example-package = pkgs.callPackage ./pkgs/example-package { };

  # TODO: should probably move python packages into their own file or directory at some point
  a-neuro-who-cant-sing = pkgs.python3Packages.callPackage ./pkgs/a-neuro-who-cant-sing { inherit zengl; };
  zengl = pkgs.python3Packages.callPackage ./pkgs/zengl { };

  # some-qt5-package = pkgs.libsForQt5.callPackage ./pkgs/some-qt5-package { };
  # ...
}
