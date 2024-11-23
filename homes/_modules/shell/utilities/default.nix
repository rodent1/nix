{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      binutils
      broot
      coreutils
      curl
      du-dust
      envsubst
      fd
      findutils
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
    ];
  };
}
