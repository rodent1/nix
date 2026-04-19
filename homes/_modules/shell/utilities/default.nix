{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      age
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
      lefthook
      openssl
      rustic
      sops
      tlrc
      wget
      yq-go
      unstable.just
      unstable.yamlfmt
    ];
  };
}
