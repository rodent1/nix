let
  hasSuffix = suffix: content:
    let
      inherit (builtins) stringLength substring;
      lenContent = stringLength content;
      lenSuffix = stringLength suffix;
    in
    lenContent >= lenSuffix
    && substring (lenContent - lenSuffix) lenContent content == suffix
  ;

  mkHost =
    { type
    , hostPlatform
    , address ? null
    , pubkey ? null
    , homeDirectory ? null
    , remoteBuild ? true
    , large ? false
    }:
    if type == "nixos" then
      assert address != null && pubkey != null;
      assert (hasSuffix "linux" hostPlatform);
      {
        inherit type hostPlatform address pubkey remoteBuild large;
      }
    else if type == "home-manager" then
      assert homeDirectory != null;
      {
        inherit type hostPlatform homeDirectory large;
      }
    else throw "unknown host type '${type}'";
in
{
  gamer = mkHost {
    type = "nixos";
    address = "laptop";
    hostPlatform = "x86_64-linux";
    pubkey = "ssh-ed25519 ...";
  };

  laptop = mkHost {
    type = "nixos";
    address = "laptop";
    hostPlatform = "x86_64-linux";
    pubkey = "ssh-ed25519 ...";
  };
}
