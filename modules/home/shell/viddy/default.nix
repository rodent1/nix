{
  internal.homeModules.default =
    {
      pkgs,
      ...
    }:
    {
      config = {
        home.packages = with pkgs; [
          viddy
        ];

        programs.fish.functions = {
          watch = {
            wraps = "viddy";
            body = ''
              set -lx KUBECOLOR_FORCE_COLORS auto
              viddy -d -n 2 --shell fish $argv[1..-1]
            '';
          };
        };
      };
    };
}
