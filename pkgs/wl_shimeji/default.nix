{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  pkg-config,
  which,
  libarchive,
  uthash,
  wayland,
  wayland-protocols,
  wayland-scanner,
  pillow,
  nix-update-script,
}:

buildPythonApplication {
  pname = "wl_shimeji";
  version = "git";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "CluelessCatBurger";
    repo = "wl_shimeji";
    rev = "faad975374a3ea7eaacc1526607ce210858d7a72";
    hash = "sha256-OGakNE3o7b6dGAEkDdTlHjmEFniCV6Xu7kHdgxzEgro=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    which
  ];

  buildInputs = [
    libarchive
    uthash
    wayland
    wayland-protocols
    wayland-scanner
  ];

  dependencies = [
    pillow
  ];

  preInstall = ''
    export PREFIX=$out
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Shimeji reimplementation for Wayland in C";
    homepage = "https://github.com/CluelessCatBurger/wl_shimeji";
    mainProgram = "swarmfm-player";
    license = lib.licenses.gpl2;
  };
}
