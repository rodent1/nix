# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
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
  tmux-fish = {
    pname = "tmux-fish";
    version = "db0030b7f4f78af4053dc5c032c7512406961ea5";
    src = fetchFromGitHub {
      owner = "budimanjojo";
      repo = "tmux.fish";
      rev = "db0030b7f4f78af4053dc5c032c7512406961ea5";
      fetchSubmodules = false;
      sha256 = "sha256-rRibn+FN8VNTSC1HmV05DXEa6+3uOHNx03tprkcjjs8=";
    };
    date = "2025-04-07";
  };
}
