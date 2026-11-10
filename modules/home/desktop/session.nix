{
  internal.homeModules.desktop =
    { pkgs, ... }:
    {
      home.file.".face".source = ./_assets/profile.jpg;
      home.packages = with pkgs; [
        ffmpegthumbnailer
        unstable.waytator
      ];
    };
}
