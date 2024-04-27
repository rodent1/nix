{
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
    inputs.vscode-server.nixosModules.default
  ];

  config = {
    wsl = {
      enable = true;
      defaultUser = "stianrs";
      docker-desktop.enable = true;
    };

    environment.systemPackages = with pkgs; [wslu];
    programs.nix-ld = {
      enable = true;
      package = inputs.nix-ld-rs.packages.${pkgs.system}.nix-ld-rs;
    };

    services.vscode-server.enable = true;
    services.vscode-server.extraRuntimeDependencies = [pkgs.coreutils];
  };
}
