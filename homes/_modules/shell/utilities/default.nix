{ pkgs, flake-packages, ... }:
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
      flake-packages.${pkgs.system}.shcopy
      tlrc
      wget
      yq-go
    ];
  };
}
