{
  internal.homeModules.laptop =
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
            monitor = "";
            path = "$HOME/.config/background";
            blur_passes = 0;
            color = "$base";
          };

          input-field = {
            monitor = "";
            size = "384, 78";
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
            position = "0,-60";
            halign = "center";
            valign = "center";
          };

          image = {
            monitor = "";
            path = "$HOME/.face";
            size = 140;
            border_color = "$accent";
            position = "0,108";
            halign = "center";
            valign = "center";
          };

          label = [
            # TIME
            {
              monitor = "";
              text = "$TIME";
              color = "$text";
              font_size = 116;
              font_family = "$font";
              position = "-40, 0";
              halign = "right";
              valign = "top";
            }
            # DATE
            {
              monitor = "";
              text = "cmd[update:43200000] date +\"%A, %d %B %Y\"";
              color = "$text";
              font_size = 33;
              font_family = "$font";
              position = "-40, -192";
              halign = "right";
              valign = "top";
            }
          ];
        };
      };
    };
}
