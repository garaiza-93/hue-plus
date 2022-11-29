{ nixpkgs ? import <nixpkgs> { }
}:

with nixpkgs;
mkShell {
  buildInputs = [
    poetry
    portaudio
    python3Packages.virtualenv # run virtualenv .
    python3Packages.pyqt5 # avoid installing via pip
    python3Packages.pyusb # fixes the pyusb 'No backend available' when installed directly via pip
  ];

  shellHook = ''
    # fixes libstdc++ issues and libgl.so issues
      LD_LIBRARY_PATH=${stdenv.cc.cc.lib}/lib/:/run/opengl-driver/lib
      # fixes xcb issues :
      QT_PLUGIN_PATH=${qt5.qtbase}/${qt5.qtbase.qtPluginPrefix}
  '';
}
