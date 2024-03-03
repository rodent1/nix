{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./common/vscode-fix.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "stianrs";
    homeDirectory = "/home/stianrs";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  programs.gh.enable = true;
  programs.git = {
    enable = true;
    userName = "Stian Rossavik Sporaland";
    userEmail = "mail@stianrs.dev";

    extraConfig = {
      core = {
        autocrlf = "input";
      };
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = true;
      };
      rebase = {
        autoStash = true;
      };
    };
    aliases = {
      co = "checkout";
      pl = "pull";
      l = "log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ (%cn)\" --decorate";
    };
    ignores = [
      # Mac OS X hidden files
      ".DS_Store"
      # Windows files
      "Thumbs.db"
      # asdf
      ".tool-versions"
      # mise
      ".mise.toml"
      # Sops
      ".decrypted~*"
      "*.decrypted.*"
      # Python virtualenvs
      ".venv"
    ];
  };
  programs.gpg.enable = true;

  home.packages = [
    pkgs.git-filter-repo
    pkgs.pinentry
    pkgs.tig
  ];


  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
