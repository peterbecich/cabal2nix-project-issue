{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/haskell-updates";
    flake-parts.url = "github:hercules-ci/flake-parts";
    haskell-flake.url = "github:srid/haskell-flake";
    flake-root.url = "github:srid/flake-root";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

  };
  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [ inputs.haskell-flake.flakeModule ];

      perSystem = { self', pkgs, ... }: {

        # Typically, you just want a single project named "default". But
        # multiple projects are also possible, each using different GHC version.
        haskellProjects.default = {
          # The base package set representing a specific GHC version.
          # By default, this is pkgs.haskellPackages.
          # You may also create your own. See https://zero-to-flakes.com/haskell-flake/package-set
          # basePackages = pkgs.haskellPackages;

          # Extra package information. See https://zero-to-flakes.com/haskell-flake/dependency
          #
          # Note that local packages are automatically included in `packages`
          # (defined by `defaults.packages` option).
          #
          # packages = {
          #   aeson.source = "1.5.0.0"; # Hackage version override
          #   shower.source = inputs.shower;
          # };
          settings = {
            tls = { super, ... }:
              { custom = _: super.tls_2_0_1; };
            tls-session-manager = { super, ... }:
              { custom = _: super.tls-session-manager_0_0_5; };

          };

          devShell = {
           # Enabled by default
           enable = true;

           # Programs you want to make available in the shell.
           # Default programs can be disabled by setting to 'null'
           tools = hp: { fourmolu = hp.fourmolu; ghcid = null; };

           # hlsCheck.enable = true;
          };
        };

        # haskell-flake doesn't set the default package, but you can do it here.
        packages.default = self'.packages.example;
      };
    };
}
