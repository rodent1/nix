{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # VSCode Fix
    ./common/editor/vscode-server
    # Shell
    ./common/shell/atuin/default.nix
    ./common/shell/bat/default.nix
    ./common/shell/eza/default.nix
    ./common/shell/fish/default.nix
    ./common/shell/git/default.nix
    ./common/shell/starship/default.nix

  ];

  home = {
    username = lib.mkDefault "stianrs";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "23.11";
  };
}
