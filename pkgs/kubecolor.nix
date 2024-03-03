{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubecolor";
  version = "0.0.25";

  src = fetchFromGitHub {
    owner = "hidetatz";
    repo = pname;
    rev = "v0.0.25";
    sha256 = "sha256-FyKTI7Br9BjSpmf9ch2E4EZAWM7/jowZfRrCn4GTcps=";
  };

  vendorSha256 = null;  // Replace with actual hash, you will get this after the first build attempt

  # Optional: Add Go package dependencies if there are any
  # buildInputs = [ ];

  # Optional: Set Go-related build options
  # buildFlagsArray = [ ];

  meta = with lib; {
    description = "Colorize your kubectl output";
    homepage = "https://github.com/hidetatz/kubecolor";
    license = licenses.mit;
    maintainers = with maintainers; [ hidetatz ];
  };
}
