{ nixpkgs ? import <nixpkgs> { }
}:

with nixpkgs;

stdenv.mkDerivation rec {
  name = "hue-plus";
  env = buildEnv { name = name; paths = buildInputs; };
  buildInputs = [
    portaudio
    poetry
    libGL
    # It is essential **not** to add `pip` here as
    # it would prevent proper virtualenv creation.
  ];
  shellHook = ''
    # set SOURCE_DATE_EPOCH so that we can use python wheels
    SOURCE_DATE_EPOCH=$(date +%s)
  '';
}
