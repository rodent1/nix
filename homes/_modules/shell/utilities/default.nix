{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      binutils
      coreutils
      curl
      du-dust
      envsubst
      findutils
      fish
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
