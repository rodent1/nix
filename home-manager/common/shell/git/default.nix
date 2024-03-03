  {
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.gh.enable = true;
  programs.git = {
    enable = true;
    userName = "Stian Rossavik Sporaland";
    userEmail = "mail@stianrs.dev";

    extraConfig = {
      core = {
        autocrlf = "input";
      };
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = true;
      };
      rebase = {
        autoStash = true;
      };
    };
    aliases = {
      co = "checkout";
      pl = "pull";
      l = "log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ (%cn)\" --decorate";
    };
    ignores = [
      # Mac OS X hidden files
      ".DS_Store"
      # Windows files
      "Thumbs.db"
      # asdf
      ".tool-versions"
      # mise
      ".mise.toml"
      # Sops
      ".decrypted~*"
      "*.decrypted.*"
      # Python virtualenvs
      ".venv"
    ];
  };

  programs.gpg.enable = true;
}
