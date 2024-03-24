{
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    inputs.vscode-server.nixosModules.default
  ];

  config = {
    wsl = {
      enable = true;
      defaultUser = "stianrs";
    };
    environment.systemPackages = with pkgs; [
      wslu
    ];
    programs.nix-ld = {
      enable = true;
      # nix-ld-rs seems to be broken in a recent update. wont build
      # package = inputs.nix-ld-rs.packages.${pkgs.system}.nix-ld-rs;
    };
    services.vscode-server.enable = true;
  };
}
