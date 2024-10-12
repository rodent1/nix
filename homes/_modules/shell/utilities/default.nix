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
      gum
      httpie
      jo
      jq
      openssl
      tlrc
      wget
      yq-go
    ];
  };
}
