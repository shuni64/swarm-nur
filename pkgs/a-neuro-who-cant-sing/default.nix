{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  numpy,
  pillow,
  pygame,
  zengl,
}:

buildPythonApplication rec {
  pname = "a-neuro-who-cant-sing";
  version = "1.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "samvanmaele";
    repo = "A-neuro-who-can-t-sing";
    rev = "196b744f1aab997932ebf5e158fc02272fc7130f";
    hash = "sha256-Wz2b2MncepkBqrmCJF/oPAKmABFgybPI3XtwPSsTyro=";
  };

  build-system = [ ];

  dependencies = [
    numpy
    pillow
    pygame
    zengl
  ];

  installPhase = ''
    mkdir -p $out/bin

    # write shebang so that wrapPythonPrograms picks it up
    echo "$(echo -e '#!/usr/bin/python\n' | cat - main.py)" > $out/bin/a-neuro-who-cant-sing
    chmod +x $out/bin/a-neuro-who-cant-sing

    find gfx/ models/ sfx/ -type f -exec install -vDm755 {} $out/share/{} \;
  '';

  makeWrapperArgs = [
    # kinda horrid but patching it to support other working directories would be a pain
    "--chdir $out/share"
  ];

  meta = {
    homepage = "https://igglybuff-ever.itch.io/a-neuro-who-cant-sing";
    license = lib.licenses.unfree;
    mainProgram = "a-neuro-who-cant-sing";
  };
}
