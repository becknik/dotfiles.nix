{ withDefaultKeymapOptions, mapToModeAbbr, ... }:

{
  # vim.opt
  config = {
    #extraConfigLua = "filetype plugin indent on";
    opts = {
      encoding = "utf-8";
      termguicolors = true; # 24-bit terminal coloring support

      spell = true;
      spelllang = [
        "en_us"
        "en_gb"
        "de_20"
      ];

      # UI
      number = true;
      relativenumber = true;
      colorcolumn = [
        80
        120
      ];
      cursorline = true;
      wrap = true;
      scrolloff = 2; # always keep 8 lines above/below cursor unless at start/end of file
      cmdheight = 0; # more space in the neovim command line for displaying messages

      # Symbol Formatting
      list = true;
      # listchars = "tab:»\ ,extends:›,precedes:‹,trail:·,nbsp:·";

      # Cursor Movement
      matchpairs =
        "(:),{:},[:]" # default
        + ",<:>";
      mouse = "a"; # Enable mouse mode for modes: normal, visual, insert, command-line

      # Indentation
      tabstop = 2;
      smartindent = true;
      shiftwidth = 2;
      expandtab = true;

      # Indentation
      # shiftwidth = 2; # indent with 4 spaces
      # shiftround = true; # round indents of >,< to shiftwidth
      # smartindent = true; # enable smart indenting by using context of previous line
      # breakindent = true; # indent wrapped lines
      # source: https://stackoverflow.com/questions/1204149/smart-wrap-in-vim

      # Search
      hlsearch = true; # default
      incsearch = true; # default; show matchings as you type
      ignorecase = true;
      smartcase = true; # Don't ignore case when with capitals
      # grepprg = "rg --vimgrep";
      # grepformat = "%f:%l:%c:%m";

      # Better Window Splitting
      splitright = true;
      splitbelow = true;

      # Completion
      updatetime = 400; # faster completion (4000ms default)
      completeopt = [
        "fuzzy"
        "menuone"
        "noinsert"
      ]; # completion window; "preview" "popup"
    };

    keymaps =
      let
        m = builtins.toString 5;
      in
      withDefaultKeymapOptions [

        {
          key = "<C-w>=";
          action.__raw = ''
            function()
              local delta = vim.v.count1 * ${m}
              vim.cmd(("horizontal resize +%d"):format(delta))
            end
          '';
          options.desc = "resize horizontal +${m}";
          mode = mapToModeAbbr [
            "insert"
            "normal"
          ];
        }
        {
          key = "<C-w>-";
          action.__raw = ''
            function()
              local delta = vim.v.count1 * ${m}
              vim.cmd(("horizontal resize -%d"):format(delta))
            end
          '';
          options.desc = "resize horizontal -${m}";
          mode = mapToModeAbbr [
            "insert"
            "normal"
          ];
        }
        {
          key = "<C-w>,";
          action.__raw = ''
            function()
              local delta = vim.v.count1 * ${m}
              vim.cmd(("vertical resize +%d"):format(delta))
            end
          '';
          options.desc = "resize vertical +${m}";
          mode = mapToModeAbbr [
            "insert"
            "normal"
          ];
        }
        {
          key = "<C-w>.";
          action.__raw = ''
            function()
              local delta = vim.v.count1 * ${m}
              vim.cmd(("vertical resize -%d"):format(delta))
            end
          '';
          options.desc = "resize vertical -${m}";
          mode = mapToModeAbbr [
            "insert"
            "normal"
          ];
        }
      ];
  };
}
