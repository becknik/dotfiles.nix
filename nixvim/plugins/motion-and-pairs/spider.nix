{ withDefaultKeymapOptions, ... }:

{
  plugins.spider = {
    # https://github.com/chrisgrieser/nvim-spider
    enable = true;
  };

  # NOTE: configured in textobjects.lua
  keymaps = withDefaultKeymapOptions [
    {
      key = "w";
      action.__raw = "function() require'spider'.motion'w' end";
      options.desc = "Spider Word";
      mode = [
        "n"
        "x"
        "o"
      ];
    }
    {
      key = "e";
      action.__raw = "function() require'spider'.motion'e' end";
      options.desc = "Spider End";
      mode = [
        "n"
        "x"
        "o"
      ];
    }
    {
      key = "b";
      action.__raw = "function() require'spider'.motion'b' end";
      options.desc = "Spider Back";
      mode = [
        "n"
        "x"
        "o"
      ];
    }

    {
      key = "<C-f>";
      action.__raw = "function() require'spider'.motion'w' end";
      options.desc = "Spider Word";
      mode = [ "i" ];
    }
    {
      key = "<C-b>";
      action.__raw = "function() require'spider'.motion'b' end";
      options.desc = "Spider Back";
      mode = [ "i" ];
    }
  ];
}
