# Copy this whole directory into a new project, then `direnv allow`:
#   cp -r python-devenv-template ~/projects/my-project && cd ~/projects/my-project && direnv allow
{ pkgs, ... }:

{
  languages.python = {
    enable = true;
    version = "3.12";
    venv = {
      enable = true;
      requirements = ./requirements.txt;
    };
  };
}
