{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system} = {
        envycontrol = pkgs.python314Packages.buildPythonPackage {
          pname = "envycontrol";
          version = "3.5.2";
          src = self;
          format = "setuptools";
        };
        default = self.packages.${system}.envycontrol;
      };

      buildInputs = with pkgs; [ pciutils ];

      devShells.default = pkgs.mkShellNoCC {
        packages = with pkgs; [
          (python314.withPackages(ps: with ps; [ setuptools ]))
          pciutils
        ];
      };
    };
}
