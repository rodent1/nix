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
      unstable.just
      unstable.just-lsp
      lefthook
      openssl
      ripgrep
      rustic
      sops
      tlrc
      wget
      yamlfmt
      yq-go
    ];
  };
}
