{
  internal.homeModules.desktop = _: {
    programs.google-chrome = {
      enable = true;

      commandLineArgs = [
        "--enable-features=MiddleClickAutoscroll"
      ];
    };
  };
}
