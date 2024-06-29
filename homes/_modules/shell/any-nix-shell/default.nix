{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [
      any-nix-shell
    ];

    programs.fish = {
      interactiveShellInit = "${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source";
    };
  };
}
