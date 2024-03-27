{ pkgs, ... }: {
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
      tmux
      vim
      wget
      yq-go
    ];
  };
}
