{
  internal.nixosModules.default =
    {
      lib,
      config,
      ...
    }:
    let
      isWSL = config.wsl.enable or false;
    in
    {

      config = {
        programs._1password.enable = true;
        programs._1password-gui = lib.mkIf (!isWSL) {
          enable = true;
          # Certain features, including CLI integration and system authentication support,
          # require enabling PolKit integration on some desktop environments (e.g. Plasma).
          polkitPolicyOwners = [ "stianrs" ];
        };
      };
    };
}
