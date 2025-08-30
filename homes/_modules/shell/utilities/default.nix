{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      binutils
      broot
      coreutils
      curl
      duf
      dust
      envsubst
      fd
      findutils
      fzf
      gawk
      gnused
      go-task
      gum
      httpie
      jo
      jq
      openssl
      rustic
      tlrc
      wget
      yq-go
      unstable.just
      unstable.yamlfmt
    ];

    programs.zoxide = {
      enable = true;
    };
  };
}
