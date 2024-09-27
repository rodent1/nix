# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  gh-copilot-darwin-amd64 = {
    pname = "gh-copilot-darwin-amd64";
    version = "1.0.5";
    src = fetchurl {
      url = "https://github.com/github/gh-copilot/releases/download/v1.0.5/darwin-amd64";
      sha256 = "sha256-YFQh4vDtT+mjAIMt0IEtleOFTlxkHMbJq/SrI+IzNjc=";
    };
  };
  gh-copilot-darwin-arm64 = {
    pname = "gh-copilot-darwin-arm64";
    version = "1.0.5";
    src = fetchurl {
      url = "https://github.com/github/gh-copilot/releases/download/v1.0.5/darwin-arm64";
      sha256 = "sha256-qVsItCI3LxPraOLtEvVaoTzhoGEcIySTWooMBSMLvAc=";
    };
  };
  gh-copilot-linux-amd64 = {
    pname = "gh-copilot-linux-amd64";
    version = "1.0.5";
    src = fetchurl {
      url = "https://github.com/github/gh-copilot/releases/download/v1.0.5/linux-amd64";
      sha256 = "sha256-QKrDFCVCWYYX2jM8le2X/OLhNcwxR+liUtXHhW7jcSw=";
    };
  };
  gh-copilot-linux-arm64 = {
    pname = "gh-copilot-linux-arm64";
    version = "1.0.5";
    src = fetchurl {
      url = "https://github.com/github/gh-copilot/releases/download/v1.0.5/linux-arm64";
      sha256 = "sha256-+l1hBwep/YMP7EOrEIn2xCIiVgWB0JCWz+fj2ZfivNQ=";
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
    version = "v1.8.0";
    src = fetchFromGitHub {
      owner = "siderolabs";
      repo = "talos";
      rev = "v1.8.0";
      fetchSubmodules = false;
      sha256 = "sha256-Ezie6RQsigmJgdvnSVk6awuUu2kODSio9DNg4bow76M=";
    };
  };
}
