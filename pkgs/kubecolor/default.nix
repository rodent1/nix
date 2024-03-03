{ lib, pkgs, fetchFromGitHub }:
{

  kubecolor = buildGoModule rec {
      pname = "kubecolor";
      version = "0.0.25";

      src = fetchFromGitHub {
        owner = "hidetatz";
        repo = "kubecolor";
        rev = "v${version}";
        # obtained from `nix-shell -p nix-prefetch-github --run "nix-prefetch-github hidetatz kubecolor --rev v0.0.25"`
        hash = "sha256-FyKTI7Br9BjSpmf9ch2E4EZAWM7/jowZfRrCn4GTcps=";
      };

    meta = with lib; {
      description = "colorizes kubectl output";
      homepage = "https://github.com/hidetatz/kubecolor";
      license = licenses.mit;
      maintainers = with maintainers; [ hidetatz ];
    };
  };
}
