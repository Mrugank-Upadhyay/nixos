{ inputs, pkgs, ... }:

{
  imports = [ inputs.nvf.homeManagerModules.default ];

  programs.nvf = {
    enable = true;
    defaultEditor = true;
    settings.vim = {
      viAlias = true;
      vimAlias = true;

      clipboard = {
        enable = true;
        registers = "unnamedplus";
        providers.wl-copy.enable = true;
      };

      lsp.enable = true;
      languages = {
        enableTreesitter = true;
        enableFormat = true;

        nix.enable = true;
        lua.enable = true;
        python.enable = true;
        bash.enable = true;
        markdown.enable = true;
        typescript.enable = true;
        tsx.enable = true;
        json.enable = true;
        sql.enable = true;
      };

      autocomplete.nvim-cmp.enable = true;
      telescope = {
        enable = true;
        extensions = [
          {
            name = "file_browser";
            packages = [ pkgs.vimPlugins.telescope-file-browser-nvim ];
          }
        ];
      };
      filetree.nvimTree.enable = true;
      statusline.lualine.enable = true;
      git.enable = true;
      autopairs.nvim-autopairs.enable = true;
      comments.comment-nvim.enable = true;
      binds.whichKey.enable = true;
      visuals.indent-blankline.enable = true;

      theme = {
        enable = true;
        name = "catppuccin";
        style = "mocha";
      };

      keymaps = [
        {
          key = "<leader>fB";
          mode = "n";
          action = ":Telescope file_browser<CR>";
          desc = "File browser [Telescope]";
        }
      ];
    };
  };
}
