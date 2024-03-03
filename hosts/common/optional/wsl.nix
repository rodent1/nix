{ inputs, config, lib, pkgs ... }:
{
  imports = [
    # Import WSL's NixOS module
    inputs.nixos-wsl.nixosModules.wsl
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
    libraries = [
      # Required by NodeJS installed by VS Code's Remote WSL extension
      pkgs.stdenv.cc.cc
    ];

  # Use `nix-ld-rs` instead of `nix-ld`, because VS Code's Remote WSL extension launches a non-login non-interactive shell, which is not supported by `nix-ld`, while `nix-ld-rs` works in non-login non-interactive shells.
  package = inputs.nix-ld-rs.packages.${pkgs.system}.nix-ld-rs;
}
