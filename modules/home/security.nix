{ self, ... }:
{
  flake.homeModules.security = {
    imports = [
      self.homeModules.securityOnepassword
      self.homeModules.securityGnugpg
      self.homeModules.securityOpnix
      self.homeModules.securitySsh
      self.homeModules.securityWsl2SshAgent
    ];
  };
}
