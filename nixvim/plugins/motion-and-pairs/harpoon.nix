{ withDefaultKeymapOptions, ... }:

{
  plugins.harpoon = {
    # https://github.com/ThePrimeagen/harpoon/tree/harpoon2
    enable = true;

    luaConfig.post = ''
      local harpoon = require("harpoon")
      local extensions = require("harpoon.extensions")
      local HarpoonList = require("harpoon.list")

      harpoon:extend(extensions.builtins.highlight_current_file())
      -- harpoon:extend(extensions.builtins.navigate_with_number());

      function HarpoonList:swap(i, j)
        if i < 1 or j < 1 or i > self._length or j > self._length then
          vim.notify(
            string.format("Harpoon swap: invalid indices %d with %d", i, j),
            vim.log.levels.ERROR,
            { title = "Harpoon", render = "compact" }
          )
          return
        end

        self.items[i], self.items[j] = self.items[j], self.items[i]

        -- fire the REORDER event so any UI/pickers update
        harpoon._extensions:emit(
          extensions.event_names.REORDER,
          { list = self, idx1 = i, idx2 = j }
        )
      end

      wk.add {
        { "<leader>1", icon = "󰀱 1", desc = "Harpoon 1" },
        { "<leader>2", icon = "󰀱 2", desc = "Harpoon 2" },
        { "<leader>3", icon = "󰀱 3", desc = "Harpoon 3" },
        { "<leader>4", icon = "󰀱 4", desc = "Harpoon 4" },
        { "<leader>5", icon = "󰀱 5", desc = "Harpoon 5" },
        { "<leader>6", icon = "󰀱 6", desc = "Harpoon 6" },

        { "<leader>A", icon = "󰀱  " },
        { "<leader>j", icon = "󰀱 ", desc = "Harpoon" },
        { "<leader>jj", icon = "󰀱  " },
        -- { "<leader>js", icon = "󰀱 " },
      }
    '';
  };

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>A";
      action.__raw = "function() require'harpoon':list():add() end";
      options.desc = "Add to Harpoon";
    }
    {
      key = "<leader>jj";
      action.__raw = ''
        function()
          local harpoon = require"harpoon"
          local harpoon_files = harpoon:list()
          local file_paths = {}
          -- TODO also display the index in telescope
          for _, item in ipairs(harpoon_files.items) do
            table.insert(file_paths, item.value)
          end

          require("telescope.pickers").new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
              results = file_paths,
            }),
            previewer = require"telescope.config".values.file_previewer({}),
            sorter = require"telescope.config".values.generic_sorter({}),
          }):find()
        end
      '';
      options.desc = "Toggle Harpoon List";
    }
    # TODO
    # {
    #   key = "<leader>js";
    #   action.__raw = ''
    #     function()
    #       local harpoon = require"harpoon"
    #       local lst = harpoon:list()
    #       lst:swap(i, j)
    #       harpoon:sync()
    #       harpoon.ui:refresh()
    #       vim.notify(string.format("Harpoon: swapped %d ↔ %d", i, j))
    #     end
    #   '';
    #   options.desc = "Switch Harpoon";
    # }

    # {
    #   key = "<C-n>";
    #   action.__raw = "function() require'harpoon':list():next() end";
    #   options.desc = "Next Harpoon";
    # }
    # {
    #   key = "<C-p>";
    #   action.__raw = "function() require'harpoon':list():prev() end";
    #   options.desc = "Previous Harpoon";
    # }

    {
      key = "<leader>1";
      action.__raw = "function() require'harpoon':list():select(1) end";
      options.desc = "Harpoon 1";
    }
    {
      key = "<leader>2";
      action.__raw = "function() require'harpoon':list():select(2) end";
      options.desc = "Harpoon 2";
    }
    {
      key = "<leader>3";
      action.__raw = "function() require'harpoon':list():select(3) end";
      options.desc = "Harpoon 3";
    }
    {
      key = "<leader>4";
      action.__raw = "function() require'harpoon':list():select(4) end";
      options.desc = "Harpoon 4";
    }
    {
      key = "<leader>5";
      action.__raw = "function() require'harpoon':list():select(5) end";
      options.desc = "Harpoon 5";
    }
    {
      key = "<leader>6";
      action.__raw = "function() require'harpoon':list():select(6) end";
      options.desc = "Harpoon 6";
    }
  ];
}
