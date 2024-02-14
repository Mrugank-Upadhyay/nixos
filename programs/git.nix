{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;

    userName = "mrugank";
    userEmail = "mrugank2@gmail.com";

    extraConfig = {
      color.ui = "auto";
      diff.tool = "nvim -d";
    };

    delta.enable = true;
  };
}
