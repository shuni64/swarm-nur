{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  cargo-tauri,
  nodejs,
  npmHooks,
  pkg-config,
  makeWrapper,
  glib-networking,
  gtk3,
  webkitgtk_4_1,
  gst_all_1,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "swarmfm-player";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "gwashark";
    repo = "swarmfm-player";
    rev = "977983cfbec0ae3374fb1f92848ee0ba1d936162";
    hash = "sha256-Upd5IA8I2ZhCPdsCb3dtlCU8FW4CBT2OVg5uF7brLgg=";
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-FnKHuN55fOHJivcTTQRQaRZLsx3F0LqJETrsMFI5HXc=";
  };

  cargoHash = "sha256-e2kzyrhnydvpd4F6YDzs7wteRVsZzahlpFXEtzDxBSo=";

  cargoRoot = "src-tauri";

  buildAndTestSubdir = "src-tauri";

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    makeWrapper
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    gtk3
    webkitgtk_4_1
  ];

  postInstall =
    let
      gstSearchPath = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-bad
      ];
    in
    ''
      wrapProgram $out/bin/swarmfm \
        --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules" \
        --prefix GST_PLUGIN_PATH : "${gstSearchPath}"
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A Swarm FM Player for your Computer";
    homepage = "https://github.com/gwashark/swarmfm-player";
    changelog = "https://github.com/gwashark/swarmfm-player/releases/tag/v${version}";
    mainProgram = "swarmfm-player";
    license = lib.licenses.unfree;
  };
}
