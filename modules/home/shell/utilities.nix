{ ... }:
{
  flake.homeModules.shellUtilities =
    { pkgs, ... }:
    {
      config.home.packages = with pkgs; [
        age
        btop
        curl
        coreutils
        devenv
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
        go-task
        httpie
        jq
        just
        killall
        lefthook
        nfs-utils
        nix-your-shell
        openssl
        ouch
        ripgrep
        sd
        shellcheck
        systemd-manager-tui
        tlrc
        tree
        unzip
        wget
        yamlfmt
        yq-go
      ];
    };
}
