{
  internal.homeModules.default =
    { pkgs, ... }:
    {
      config = {
        home.packages = with pkgs; [
          age
          curl
          coreutils
          devenv
          dig
          duf
          dust
          envsubst
          fastfetch
          fd
          findutils
          fzf
          go-task
          httpie
          jq
          just
          killall
          lefthook
          nfs-utils
          openssl
          ouch
          ripgrep
          sd
          systemd-manager-tui
          tlrc
          tree
          unzip
          wget
          yamlfmt
          yq-go
        ];
      };
    };
}
