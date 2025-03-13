# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  gh-copilot-darwin-amd64 = {
    pname = "gh-copilot-darwin-amd64";
    version = "1.1.0";
    src = fetchurl {
      url = "https://github.com/github/gh-copilot/releases/download/v1.1.0/darwin-amd64";
      sha256 = "sha256-1tN734huSBzke8j8H/dyFS90LsWGFuGtLdYdrLbGeOs=";
    };
  };
  gh-copilot-darwin-arm64 = {
    pname = "gh-copilot-darwin-arm64";
    version = "1.1.0";
    src = fetchurl {
      url = "https://github.com/github/gh-copilot/releases/download/v1.1.0/darwin-arm64";
      sha256 = "sha256-lGhgND1E4jWZmoAaPXcxNlew9eqWOrMHAYVnpFnqeio=";
    };
  };
  gh-copilot-linux-amd64 = {
    pname = "gh-copilot-linux-amd64";
    version = "1.1.0";
    src = fetchurl {
      url = "https://github.com/github/gh-copilot/releases/download/v1.1.0/linux-amd64";
      sha256 = "sha256-KIiwIv0VzJf0GVkuDsevEah48hv4VybLuBhy4dJvggo=";
    };
  };
  gh-copilot-linux-arm64 = {
    pname = "gh-copilot-linux-arm64";
    version = "1.1.0";
    src = fetchurl {
      url = "https://github.com/github/gh-copilot/releases/download/v1.1.0/linux-arm64";
      sha256 = "sha256-hNXDIB7r3Hdo7g2pPZKAYYrOaBJmAq7UKc+ZnRnVeoA=";
    };
  };
  gh-tidy = {
    pname = "gh-tidy";
    version = "99d0dd50c2b6eb6615ae0f4b6064cfeb14b451da";
    src = fetchFromGitHub {
      owner = "HaywardMorihara";
      repo = "gh-tidy";
      rev = "99d0dd50c2b6eb6615ae0f4b6064cfeb14b451da";
      fetchSubmodules = false;
      sha256 = "sha256-TKQlLnOAozaDkqC7tNlR7KMSqk17sjCe/RTpATBbZlk=";
    };
    date = "2024-02-16";
  };
  kubecolor-catppuccin = {
    pname = "kubecolor-catppuccin";
    version = "1d4c2888f7de077e1a837a914a1824873d16762d";
    src = fetchFromGitHub {
      owner = "vkhitrin";
      repo = "kubecolor-catppuccin";
      rev = "1d4c2888f7de077e1a837a914a1824873d16762d";
      fetchSubmodules = false;
      sha256 = "sha256-gTneUh6yMcH6dVKrH00G61a+apasu9tiMyYjvNdOiOw=";
    };
    date = "2024-05-24";
  };
  talosctl = {
    pname = "talosctl";
    version = "v1.9.5";
    src = fetchFromGitHub {
      owner = "siderolabs";
      repo = "talos";
      rev = "v1.9.5";
      fetchSubmodules = false;
      sha256 = "sha256-2YKZfW62yOA8uV3bn6at/9YV3OHjiMuqA1SUupyAAx4=";
    };
  };
  usage = {
    pname = "usage";
    version = "v2.0.5";
    src = fetchFromGitHub {
      owner = "jdx";
      repo = "usage";
      rev = "v2.0.5";
      fetchSubmodules = false;
      sha256 = "sha256-No/BDBW/NRnF81UOuAMrAs4cXEdzEAxnmkn67mReUcM=";
    };
  };
}
