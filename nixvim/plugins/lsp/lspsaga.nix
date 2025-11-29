{ ... }:

{
  # https://nix-community.github.io/nixvim/plugins/lspsaga/index.html
  # https://nvimdev.github.io/lspsaga/
  plugins.lspsaga = {
    enable = true;

    settings = {
      code_action = {
        only_in_cursor = false;
        show_server_name = true;
        extend_git_signs = false; # this is noise
      };

      outline = {
        # TODO en- and disabling this changes nothing
        detail = true;
        win_width = 50;
      };

      # what is this?
      symbol_in_winbar.enable = false;

      ui.code_action = "󰌶";
      lightbulb.sign = false;
      lightbulb.debounce = 200;

      autoCmd = [
        {
          # quit the lspsaga rename window ONLY when not in insert mode (wtf...)
          event = [ "FileType" ];
          pattern = "sagarename";
          callback.__raw = ''
            function(ctx)
              vim.keymap.set('n', 'q',
                function() require('lspsaga.rename'):close_rename_win() end,
                { buffer = ctx.buf, desc = 'Quit Lspsaga rename' }
              )
            end
          '';
        }
      ];
    };
  };
}
