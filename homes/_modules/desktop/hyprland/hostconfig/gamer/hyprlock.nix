{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    programs.hyprlock.settings = {
      background = {
        monitor = "DP-1";
        path = "$HOME/.config/background";
        blur_passes = 0;
        color = "$base";
      };

      input-field = {
        monitor = "DP-1";
        size = "300, 60";
        outline_thickness = 4;
        dots_size = 0.2;
        dots_spacing = 0.2;
        dots_center = true;
        outer_color = "$accent";
        inner_color = "$surface0";
        font_color = "$text";
        fade_on_empty = false;
        placeholder_text = "Logged in as $USER";
        hide_input = false;
        check_color = "$accent";
        fail_color = "$red";
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        capslock_color = "$yellow";
        position = "0,-47";
        halign = "center";
        valign = "center";
      };

      image = {
        monitor = "DP-1";
        path = "$HOME/.face";
        size = 100;
        border_color = "$accent";
        position = "0,75";
        halign = "center";
        valign = "center";
      };

      label = [
        # TIME
        {
          monitor = "DP-1";
          text = "$TIME";
          color = "$text";
          font_size = 90;
          font_family = "$font";
          position = "-30, 0";
          halign = "right";
          valign = "top";
        }
        # DATE
        {
          monitor = "DP-1";
          text = "cmd[update:43200000] date +\"%A, %d %B %Y\"";
          color = "$text";
          font_size = 25;
          font_family = "$font";
          position = "-30, -150";
          halign = "right";
          valign = "top";
        }
      ];
    };
  };
}
