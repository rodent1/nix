{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "kubecolor";
  version = "0.0.25";

  src = fetchFromGitHub {
    owner = "hidetatz";
    repo = "kubecolor";
    rev = "v${version}";
    hash = "sha256-FyKTI7Br9BjSpmf9ch2E4EZAWM7/jowZfRrCn4GTcps=";
  };

  vendorHash = "sha256-DLj7ztOFNmDru1sO+ezecQeRbIbOq49M4EcJuWLNstI=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  meta = with lib; {
    description = "Colorizes kubectl output";
    homepage = "https://github.com/hidetatz/kubecolor";
    license = licenses.mit;
    maintainers = with maintainers; [];
    mainProgram = "kubecolor";
  };
}
