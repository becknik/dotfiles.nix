{ ... }:

{
  config.opts = {
    encoding = "utf-8";
    spell = true;
    spelllang = [ "en" "de" ];

    termguicolors = true; # 24-bit terminal coloring support

    # Enable persistent undo history
    swapfile = false;
    backup = false;
    undofile = true;

    # UI
    number = true;
    relativenumber = true;
    colorcolumn = [ 80 120 ];
    wrap = true;
    # Always keep 8 lines above/below cursor unless at start/end of file
    scrolloff = 8;
    # More space in the neovim command line for displaying messages
    cmdheight = 0;

    # Tab stops
    tabstop = 2;
    softtabstop = 2;
    expandtab = true;

    # Enable auto indenting and set it to spaces
    smartindent = true;
    shiftwidth = 2;
    breakindent = true; # Enable smart indenting
    # source: https://stackoverflow.com/questions/1204149/smart-wrap-in-vim
    #shiftround = true;

    # Special symbol formatting
    list = true;
    listchars = "tab:»\ ,extends:›,precedes:‹,trail:·,nbsp:·";

    # Search
    incsearch = true;
    hlsearch = true;
    ignorecase = true;
    smartcase = true; #	Don't ignore case when with capitals
    grepprg = "rg --vimgrep";
    grepformat = "%f:%l:%c:%m";

    # Better splitting
    splitright = true;
    splitbelow = true;

    # Cursor movement
    matchpairs = "(:),{:},[:],<:>,=:;"; # first three are default ones
    mouse = "a"; # Enable mouse mode

    # Completion
    updatetime = 50; # faster completion (4000ms default)
    # Set completeopt to have a better completion experience
    completeopt = [ "menuone" "noselect" "noinsert" ];

  };
}
