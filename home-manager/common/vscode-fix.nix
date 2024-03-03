{ config, ... }:

{
  config.home.file = {
    vscode = {
      target = ".vscode-server/server-env-setup";
      text = ''
        # Make sure that basic commands are available
        PATH=$PATH:/run/current-system/sw/bin/
    };
  };
}
