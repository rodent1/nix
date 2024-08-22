# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  gh-copilot-darwin-amd64 = {
    pname = "gh-copilot-darwin-amd64";
    version = "1.0.4";
    src = fetchurl {
      url = "https://github.com/github/gh-copilot/releases/download/v1.0.4/darwin-amd64";
      sha256 = "sha256-G/ePdxtdMiLhkDX0juCDNXKp/RT0LqZHyk7plYwudy4=";
    };
  };
  gh-copilot-darwin-arm64 = {
    pname = "gh-copilot-darwin-arm64";
    version = "1.0.4";
    src = fetchurl {
      url = "https://github.com/github/gh-copilot/releases/download/v1.0.4/darwin-arm64";
      sha256 = "sha256-Uf2JRoDq8jY3aWrqhvGYaRcUZY7i6BcO/+eGZIlI9Ig=";
    };
  };
  gh-copilot-linux-amd64 = {
    pname = "gh-copilot-linux-amd64";
    version = "1.0.4";
    src = fetchurl {
      url = "https://github.com/github/gh-copilot/releases/download/v1.0.4/linux-amd64";
      sha256 = "sha256-7WkX0d+Iou+RHKFttAEiFVbCQpOy7H+KgvE+rsokHNQ=";
    };
  };
  gh-copilot-linux-arm64 = {
    pname = "gh-copilot-linux-arm64";
    version = "1.0.4";
    src = fetchurl {
      url = "https://github.com/github/gh-copilot/releases/download/v1.0.4/linux-arm64";
      sha256 = "sha256-Qy14K0dUq73Qu6+m9c/NIVaTd++cANQqUQ0+1VFPqiM=";
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
  kubecolor = {
    pname = "kubecolor";
    version = "v0.0.25";
    src = fetchFromGitHub {
      owner = "hidetatz";
      repo = "kubecolor";
      rev = "v0.0.25";
      fetchSubmodules = false;
      sha256 = "sha256-FyKTI7Br9BjSpmf9ch2E4EZAWM7/jowZfRrCn4GTcps=";
    };
  };
  shcopy = {
    pname = "shcopy";
    version = "v0.1.4";
    src = fetchFromGitHub {
      owner = "aymanbagabas";
      repo = "shcopy";
      rev = "v0.1.4";
      fetchSubmodules = false;
      sha256 = "sha256-2eOzrtWTPLoTR0Bz518SNPKxasRs9QPDP1LAo/kGnMA=";
    };
  };
  tmux-fish = {
    pname = "tmux-fish";
    version = "e95dbc11fa57d738cd837cb659d50b73ec0a8d90";
    src = fetchFromGitHub {
      owner = "budimanjojo";
      repo = "tmux.fish";
      rev = "e95dbc11fa57d738cd837cb659d50b73ec0a8d90";
      fetchSubmodules = false;
      sha256 = "sha256-tNq/F9NQZZ1pd0ZWPzQVwuHABCVECmXRN12ovGSUUFU=";
    };
    date = "2024-04-19";
  };
}
