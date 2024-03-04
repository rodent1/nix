{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pkgs.minio-client
  ];
}
