{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  libGL,
}:

buildPythonPackage rec {
  pname = "zengl";
  version = "2.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "zengl";
    owner = "szabolcsdombi";
    rev = "refs/tags/${version}";
    hash = "sha256-VBGShCgofogZ8jsvJcdQ9LcYpRjXucKicfrly680lLU=";
  };

  postPatch = ''
    substituteInPlace _zengl.py --replace-fail "'libGL.so'" "'${libGL}/lib/libGL.so'"
  '';

  build-system = [ setuptools ];

  dependencies = [ ];

  nativeCheckInputs = [ ];

  meta = {
    changelog = "https://github.com/szabolcsdombi/zengl/blob/${version}/CHANGELOG.md";
    description = "OpenGL Rendering Pipelines for Python";
    homepage = "https://github.com/szabolcsdombi/zengl";
    license = lib.licenses.mit;
  };
}
