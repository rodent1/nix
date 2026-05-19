{
  flake.modules.nixos.core =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        age
        btop
        curl
        coreutils
        dig
        duf
        dust
        envsubst
        eza
        fastfetch
        fd
        findutils
        fzf
        git
        jq
        killall
        nfs-utils
        nix-your-shell
        ouch
        ripgrep
        sd
        shellcheck
        systemd-manager-tui
        tlrc
        tree
        unzip
        wget
        yq-go
      ];

      programs.neovim = {
        enable = true;

        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
      };
    };
}
