{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    inputs.vscode-server.nixosModules.default
  ];

  wsl = {
    enable = true;
    defaultUser = "stianrs";
  };

  programs.nix-ld = {
    enable = true;
    package = inputs.nix-ld-rs.packages.${pkgs.hostPlatform.system}.nix-ld-rs;
  };

  services.vscode-server = {
    enable = true;
    nodejsPackage = pkgs.nodejs_20;
  };

  environment.systemPackages = with pkgs; [
    wslu
  ];
}
