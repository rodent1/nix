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
      nativeSystemd = false;
    };
    environment.systemPackages = with pkgs; [wslu socat procps util-linux];
    programs.nix-ld = {
      enable = true;
      package = inputs.nix-ld-rs.packages.${pkgs.system}.nix-ld-rs;
    };
    services.vscode-server.enable = true;
  };
}
