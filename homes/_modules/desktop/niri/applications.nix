{
  pkgs,
}:

{
  browser = "${pkgs.firefox}/bin/firefox";
  terminal = "${pkgs.ghostty}/bin/ghostty";
  fileManager = "${pkgs.nautilus}/bin/nautilus";
  appLauncher = "${pkgs.fuzzel}/bin/fuzzel";
}
