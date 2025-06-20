{ withDefaultKeymapOptions, ... }:

{
  plugins.harpoon = {
    # https://github.com/ThePrimeagen/harpoon/tree/harpoon2
    enable = true;

    luaConfig.post = ''
      wk.add {
        { "<leader>1", icon = "󰀱 1", desc = "Harpoon 1" },
        { "<leader>2", icon = "󰀱 2", desc = "Harpoon 2" },
        { "<leader>3", icon = "󰀱 3", desc = "Harpoon 3" },
        { "<leader>4", icon = "󰀱 4", desc = "Harpoon 4" },
        { "<leader>5", icon = "󰀱 5", desc = "Harpoon 5" },
        { "<leader>6", icon = "󰀱 6", desc = "Harpoon 6" },

        { "<leader>j", icon = "󰀱  " },
        { "<leader>a", icon = "󰀱 ", desc = "Harpoon" },
        { "<leader>aa", icon = "󰀱  " },
        { "<leader>a1", icon = "󰀱 1 " },
        { "<leader>a2", icon = "󰀱 2 " },
        { "<leader>a3", icon = "󰀱 3 " },
        { "<leader>a4", icon = "󰀱 4 " },
        { "<leader>a5", icon = "󰀱 5 " },
        { "<leader>a6", icon = "󰀱 6 " },
      }
    '';
  };

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>j";
      action.__raw = "function() require'harpoon'.ui:toggle_quick_menu(require'harpoon':list()) end";
      options.desc = "Harpoon List";
    }
    {
      key = "<leader>aa";
      action.__raw = "function() require'harpoon':list():add() end";
      options.desc = "Add to Harpoon";
    }
    {
      key = "<leader>a1";
      action.__raw = "function() require'harpoon':list():replace_at(1) end";
      options.desc = "Replace Harpoon Item 1";
    }
    {
      key = "<leader>a2";
      action.__raw = "function() require'harpoon':list():replace_at(2) end";
      options.desc = "Replace Harpoon Item 2";
    }
    {
      key = "<leader>a3";
      action.__raw = "function() require'harpoon':list():replace_at(3) end";
      options.desc = "Replace Harpoon Item 3";
    }
    {
      key = "<leader>a4";
      action.__raw = "function() require'harpoon':list():replace_at(4) end";
      options.desc = "Replace Harpoon Item 4";
    }
    {
      key = "<leader>a5";
      action.__raw = "function() require'harpoon':list():replace_at(5) end";
      options.desc = "Replace Harpoon Item 5";
    }
    {
      key = "<leader>a6";
      action.__raw = "function() require'harpoon':list():replace_at(6) end";
      options.desc = "Replace Harpoon Item 6";
    }

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
