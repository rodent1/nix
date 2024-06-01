{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  config = {
    wsl = {
      enable = true;
      defaultUser = "stianrs";
    };
    environment.systemPackages = with pkgs; [wslu];
    programs.nix-ld = {
      enable = true;
      package = inputs.nix-ld-rs.packages.${pkgs.system}.nix-ld-rs;
    };
  };
}
