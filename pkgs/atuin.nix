{
  lib,
  pkgs,
  stdenv,
  installShellFiles,
  nixosTests,
  nix-update-script,
}:
let
  sourceData = pkgs.callPackage _sources/generated.nix { };
  vendorHash = lib.importJSON _sources/vendorhash.json;
  packageData = sourceData.atuin;

  inherit (pkgs.unstable.fenix.minimal) toolchain;
  rustPlatform = pkgs.unstable.makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  };
in
rustPlatform.buildRustPackage {
  inherit (packageData) pname src;
  version = lib.strings.removePrefix "v" packageData.version;

  useFetchCargoVendor = true;
  cargoHash = vendorHash.atuin;

  # atuin's default features include 'check-updates', which do not make sense
  # for distribution builds. List all other default features.
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "client"
    "sync"
    "server"
    "clipboard"
    "daemon"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd atuin \
      --bash <($out/bin/atuin gen-completions -s bash) \
      --fish <($out/bin/atuin gen-completions -s fish) \
      --zsh <($out/bin/atuin gen-completions -s zsh)
  '';

  passthru = {
    tests = {
      inherit (nixosTests) atuin;
    };
    updateScript = nix-update-script { };
  };

  checkFlags = [
    # tries to make a network access
    "--skip=registration"
    # No such file or directory (os error 2)
    "--skip=sync"
    # PermissionDenied (Operation not permitted)
    "--skip=change_password"
    "--skip=multi_user_test"
    "--skip=store::var::tests::build_vars"
    # Tries to touch files
    "--skip=build_aliases"
  ];

  meta = {
    description = "Replacement for a shell history which records additional commands context with optional encrypted synchronization between machines";
    homepage = "https://github.com/atuinsh/atuin";
    license = lib.licenses.mit;
    mainProgram = "atuin";
  };
}
