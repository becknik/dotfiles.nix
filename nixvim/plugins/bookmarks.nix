{ pkgs, withDefaultKeymapOptions, ... }:

{
  # https://github.com/LintaoAmons/bookmarks.nvim?tab=readme-ov-file#install-and-config
  extraPlugins = with pkgs.vimPlugins; [
    (pkgs.vimUtils.buildVimPlugin {
      name = "bookmarks-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "LintaoAmons";
        repo = "bookmarks.nvim";
        rev = "df3ff61bd1feb978a14e0591b53a126d5360a011";
        hash = "sha256-kO/n8JABYSq/tV0o82Sk+EivsVMe3oC8hGcvS8y2U2s=";
      };
      dependencies = with pkgs.vimPlugins; [
        sqlite-lua
        plenary-nvim
        telescope-nvim
      ];
    })
  ];

  extraConfigLua = ''
    -- https://github.com/LintaoAmons/bookmarks.nvim/blob/main/lua/bookmarks/default-config.lua
    local bookmark_opts = {
      backup = {
        enabled = false,
      },

      treeview = {
        window_split_dimension = 50,

        keymap = {
          ["D"] = nil,
          ["d"] = {
            action = "delete",
            desc = "Delete current node"
          },
          ["."] = nil,
          ["/"] = {
            action = "set_root",
            desc = "Set current list as root of the tree view, also set as active list"
          },
          ["c"] = nil,
          ["y"] = {
            action = "copy",
            desc = "Copy node"
          },
          ["i"] = nil,
          ["K"] = {
            action = "show_info",
            desc = "Show node info"
          },
          ["t"] = {
            action = "reverse",
            desc = "Reverse the order of nodes in the tree view"
          },
          ["P"] = {
            action = "preview",
            desc = "Preview bookmark content"
          },

          ["+"] = nil,
          ["="] = nil,
          ["-"] = nil,
        },
      }
    }

    require('bookmarks').setup(bookmark_opts)

    -- Is executed in auto-session hooks - don't like this kind of coupling...
    vim.api.nvim_create_user_command(
      "BookmarksInitGlobConfig",
      function()
        vim.g.bookmarks_config = vim.tbl_deep_extend('force', vim.g.bookmarks_config or require'bookmarks.default-config', bookmark_opts)
        vim.notify("Bookmarks global config initialized", vim.log.levels.INFO, { title = "Bookmarks", render = "compact" })
      end,
      {}
    )

    local bookmark_list_map = {}

    local find_or_create_project_bookmark_group = function()
      local project_name = string.gsub(vim.fn.getcwd(), "^" .. vim.fn.getenv("HOME") .. "/", "")
      local Service = require("bookmarks.domain.service")
      local Repo = require("bookmarks.domain.repo")
      local bookmark_list = nil

      for _, bl in ipairs(Repo.find_lists()) do
        if bl.name == project_name then
          bookmark_list = bl
          break
        end
      end

      if not bookmark_list then
        bookmark_list = Service.create_list(project_name)
      end
      Service.set_active_list(bookmark_list.id)
      require("bookmarks.sign").safe_refresh_signs()
    end

    vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter" }, {
      group = vim.api.nvim_create_augroup("BookmarksGroup", {}),
      pattern = { "*" },
      callback = find_or_create_project_bookmark_group,
    })

    wk.add {
      { "<leader>o", icon = "󰃁" },
      { "<leader>of", icon = "󰃁  " },
    }
  '';

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>oo";
      action = "BookmarksMark";
      options.cmd = true;
      options.desc = "Bookmark current line";
    }
    {
      key = "<leader>of";
      action = "BookmarksGoto";
      options.cmd = true;
      options.desc = "Find Bookmark";
    }
    {
      key = "<leader>ot";
      action = "BookmarksTree";
      options.cmd = true;
      options.desc = "Find Bookmark";
    }
  ];
}
