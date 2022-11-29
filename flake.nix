{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages."${system}";
    in
    {
      packages.${system}.default = pkgs.poetry2nix.mkPoetryApplication {
        projectDir = self;
      };

      devShells.${system}.default = pkgs.mkShell
        {
          buildInputs = with pkgs; [
            poetry
            portaudio
            python3Packages.virtualenv # run virtualenv .
            python3Packages.pyqt5 # avoid installing via pip
            python3Packages.pyusb # fixes the pyusb 'No backend available' when installed directly via pip
          ];

          shellHook = with pkgs; ''
            # fixes libstdc++ issues and libgl.so issues
              LD_LIBRARY_PATH=${stdenv.cc.cc.lib}/lib/:/run/opengl-driver/lib
              # fixes xcb issues :
              QT_PLUGIN_PATH=${qt5.qtbase}/${qt5.qtbase.qtPluginPrefix}
          '';
        };
    };
}
