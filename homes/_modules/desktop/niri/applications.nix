{
  pkgs,
}:

{
  browser = "${pkgs.firefox}/bin/firefox";
  terminal = "ghostty";
  fileManager = "thunar";
  appLauncher = "${pkgs.fuzzel}/bin/fuzzel";
}
