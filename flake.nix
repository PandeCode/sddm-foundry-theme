{
  description = "SDDM theme of factory game";

  outputs =
    {
      self,
      nixpkgs,
      nixutils,
      ...
    }:
    let
      forAllPkgs = nixutils.lib.forAllPkgs nixpkgs;
    in
    {
      packages = forAllPkgs (pkgs: {
        default = pkgs.callPackage ./package.nix { };
      });

      overlays.default = final: _: {
        sddm-foundry-theme = final.callPackage ./package.nix { };
      };

      formatter = forAllPkgs (pkgs: pkgs.treefmt.withConfig nixutils.lib.treefmtModule);

      checks = forAllPkgs (pkgs: {
        formatting = self.formatter.${pkgs.stdenv.hostPlatform.system}.check self;
      });
    };

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";

    # my lib and the shared formatter config
    nixutils = {
      type = "github";
      owner = "PandeCode";
      repo = "nixutils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
