{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [ _1password ];

    # TODO: Make this a WSL only thing
    programs.fish = {
      functions = {
        op = {
          description = "Op.exe shorthand";
          wraps = "op.exe";
          body = builtins.readFile ./functions/op.fish;
        };
      };
    };
  };
}
