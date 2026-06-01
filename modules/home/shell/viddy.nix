{ ... }:
{
  flake.homeModules.shellViddy =
    { pkgs, ... }:
    {
      config = {
        home.packages = [ pkgs.viddy ];

        programs.fish.functions.watch = {
          wraps = "viddy";
          body = "viddy -d -n 2 --shell fish $argv[1..-1]";
        };
      };
    };
}
