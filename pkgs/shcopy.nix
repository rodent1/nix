{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "shcopy";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "aymanbagabas";
    repo = "shcopy";
    rev = "v${version}";
    hash = "sha256-lEYMBBtBGAJjU0F1HgvuH0inW6S5E9DyKxwQ6A9tdM4=";
  };

  vendorHash = "sha256-kD73EozkeUd23pwuy71bcNmth2lEKom0CUPDUNPNB1Q=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.ProjectName=${pname}"
    "-X=main.CommitSHA=${src.rev}"
  ];

  meta = with lib; {
    description = "Copy text to your system clipboard locally and remotely using ANSI OSC52 sequence";
    homepage = "https://github.com/aymanbagabas/shcopy";
    license = licenses.mit;
    maintainers = with maintainers; [ rodent1 ];
    mainProgram = "shcopy";
  };
}
