{
  description = "A Nix-flake-based C# development environment (tailored for V Rising mod dev)"; #Stolen from: https://github.com/NorseManGef/csharptemplate/blob/master/flake.nix

  inputs= {
    nixpkgs = { 
        url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
        };
    };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { 
            inherit system; 
            config.allowUnfree = true; 
            config.permittedInsecurePackages = [
                "dotnet-sdk-6.0.428"
                "dotnet-runtime-6.0.36"
            ];
            };
        }
      );
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell.override
          {
            # Override stdenv in order to change compiler:
            # stdenv = pkgs.clangStdenv;
          }
          {
            packages = with pkgs; [
              dotnet-sdk_6
              dotnet-runtime_6
              python3
            ];
            shellHook = ''
              export PS1="\n\[\033[38;2;255;0;0m\][V Rising]\[\e[0m\] \[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\$\[\033[0m\] "
            ''; #Make red V Rising text appear when in dev environment. Change color with: https://plinkon.github.io/Colorify/
          };
      });
    };
}