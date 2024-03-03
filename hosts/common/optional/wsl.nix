{ inputs, config, lib, pkgs, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
    inputs.vscode-server.nixosModules.default
    inputs.nix-ld-rs.nixosModules.nix-ld
  ];

  wsl = {
    enable = true;
    defaultUser = "stianrs";
    startMenuLaunchers = true;
    wslConf.automount.root = "/mnt";
    extraBin = with pkgs; [
      { src = "${coreutils}/bin/uname"; }
      { src = "${coreutils}/bin/dirname"; }
      { src = "${coreutils}/bin/readlink"; }
    ];
  };

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
  };
  services.vscode-server.enable = true;
}
