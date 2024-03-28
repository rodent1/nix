{pkgs, ...}: {
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
      jo
      jq
      minio-client
      unstable.terraform
      vim
      wget
      yq-go
    ];
  };
}
