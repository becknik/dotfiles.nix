{ pkgs, withDefaultKeymapOptions, ... }:

let
  snippetPath = "~/devel/own/dotfiles.nix/nixvim/snippets";
in
{
  plugins.luasnip = {
    enable = true;

    settings = {
      enable_autosnippets = true;
    };

    fromLua = [
      { paths = snippetPath; }
    ];
    fromVscode = [
      {
        lazyLoad = true;
        paths = [ "${pkgs.vimPlugins.friendly-snippets}" ];
        exclude = [
          "javascript"
          "javascriptreact"
          "typescript"
          "typescriptreact"
        ];
      }
    ];
  };

  plugins.telescope.luaConfig.post = ''
    wk.add {
      { "<leader>S", icon = "󰑓  " },
    }
  '';
  keymaps = withDefaultKeymapOptions [
    {
      key = "<Tab>";
      action.__raw = ''
        function()
          -- using this to extend the default (hacky) binding from store_selection_keys = "<Tab>";
          vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "x", true)
          require"luasnip.util.select".pre_yank"z"
          vim.cmd { cmd = "normal", bang = true, args = { 'gv"zs' } }
          require"luasnip.util.select".post_yank"z"

          vim.cmd 'startinsert'

          vim.schedule(function()
            require'blink-cmp'.show {
              providers = { 'snippets' },
              callback = function()
                vim.schedule(function()
                  require'blink-cmp'.show_documentation()
                end)
              end
            }
          end)
        end
      '';
      mode = [ "x" ];
      options.desc = "LuaSnip: Yank Selection and Show Snippet Completions";
    }
    {
      key = "<leader>S";
      action.__raw = ''
        function()
            require'luasnip.loaders.from_lua'.load { paths = "${snippetPath}" }

            vim.notify(
              "Reloaded Local LuaSnip Snippets",
              vim.log.levels.INFO,
              { title = "LuaSnip", render = "compact" }
            )
        end
      '';
      options.desc = "Reload Local LuaSnip Snippets";
    }
  ];
}
