{ ... }:

{
  # Neovim TODO https://mipmip.github.io/home-manager-option-search/?query=neovim
  programs = {
    nixvim = {
      enable = true;

      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      clipboard.providers.wl-copy.enable = true;
      colorschemes.oxocarbon.enable = true;

      # Sources:
      # https://gist.github.com/Nazerbayev/641ad1367cdc3044a0f3b3866e52e1b6
      # https://medium.com/geekculture/neovim-configuration-for-beginners-b2116dbbde84

      plugins = {
        nvim-cmp = {
          enable = true;

          performance.fetchingTimeout = 200;
          experimental = { ghost_text = true; };

          autoEnableSources = true;
          snippet = { expand = "luasnip"; };
          formatting = { fields = [ "kind" "abbr" "menu" ]; };
          sources = [
            { name = "nvim_lsp"; }
            { name = "emoji"; }
            {
              name = "buffer"; # text within current buffer
              option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
              keywordLength = 3;
            }
            {
              name = "path"; # file system paths
              keywordLength = 3;
            }
            {
              name = "luasnip"; # snippets
              keywordLength = 3;
            }
          ];

          window = {
            completion = {
              border = "rounded";
              winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None";
            };
            documentation = { border = "rounded"; };
          };

          mapping = {
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<C-j>" = "cmp.mapping.select_next_item()";
            "<C-k>" = "cmp.mapping.select_prev_item()";
            "<C-e>" = "cmp.mapping.abort()";
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
          };
        };

        lsp.servers = { lua-ls.enable = true; };
        cmp-emoji.enable = true;
        cmp-nvim-lsp.enable = true;
        cmp-buffer.enable = true;
        cmp-path.enable = true; # file system paths
        cmp_luasnip.enable = true;
        cmp-cmdline.enable = false; # autocomplete for cmdline

        treesitter = {
          enable = true;
          indent = true;
          folding = true;
          nixvimInjections = true;
        };
        treesitter-context.enable = true;
        treesitter-textobjects.enable = false; # TODO

        luasnip.enable = true;

        nix.enable = true;
        nix-develop.enable = true;

        telescope.enable = false; # TODO
        todo-comments.enable = true;
        gitsigns.enable = true;

        lualine.enable = true;
        # transparent.enable = false; # TODO first need terminal support for this

        # obsidian.enable = false; # TODO
      };

      options = {
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
    };
  };
  #set history=1000
  #" default: backup current file, deleted afterwards
  #set backup	" delete old backup, backup current file
  #set backupdir=~/.cache/nvim/backup//	"seems to not work properly...
  #set noswapfile
  #set shada='100,<1000,s100
  #set shadafile=~/.cache/nvim/session.shada

  #" Keybinding setup
  #" _nnoremap maps keys in normal mode
  #" :inoremap maps keys in insertion mode
  #" :vnoremap maps keys in visual mode
  #" <C> represents control key
  #" <A> represents control key

  #" move line or visually selected block - alt+j/k
  #inoremap <A-j> <Esc>:move .+1<CR>==gi
  #inoremap <A-k> <Esc>:move .-2<CR>==gi
  #vnoremap <A-j> :move '>+1<CR>gv=gv
  #vnoremap <A-k> :move '<-2<CR>gv=gv

  #" move split panes to left/bottom/top/right
  #nnoremap <A-h> <C-W>H
  #nnoremap <A-j> <C-W>J
  #nnoremap <A-k> <C-W>K
  #nnoremap <A-l> <C-W>L

  #" move between panes to left/bottom/top/right
  #nnoremap <C-h> <C-w>h
  #nnoremap <C-j> <C-w>j
  #nnoremap <C-k> <C-w>k
  #nnoremap <C-l> <C-w>l

  #" modify windows sizes with <C->> & <C-<>
  #nnoremap <C-w>+ :res +10<CR>
  #nnoremap <C-w>- :res -10<CR>
  #" I give it up...
  #"nnoremap <C-w>> :resize vertical +10<CR>
  #"nnoremap <C-w>< :resize vertical -10<CR>

  #" Press i to enter insert mode, and ii etc. to exit insert mode.
  #:inoremap ii <Esc>
  #:inoremap hh <Esc>
  #:inoremap jj <Esc>
  #:inoremap kk <Esc>
  #":inoremap jk <Esc>
  #" Maybe not so good idea?

  #nnoremap <C-n>oh :noh<CR>

  #" Prevents clipboard hijacking of <C-R+>
  #:inoremap <C-R>+ <C-R><C-R>+

  #""" VIM gutter - jump between 'hunks'

  #nmap ]h <Plug>(GitGutterNextHunk)
  #nmap [h <Plug>(GitGutterPrevHunk)

  #""" NERDCommenter config

  #let g:NERDCreateDefaultMappings = 1
  #let g:NERDSpaceDelims = 1
  #let g:NERDCompactSexyComs = 1
  #let g:NERDTrimTrailingWhitespace = 1

  #nnoremap <C-n> :NvimTreeFocus<CR>
  #nnoremap <C-t> :NvimTreeToggle<CR>
  #nnoremap <C-n>f :NERDTreeFind<CR>

  #" Start NERDTree and put the cursor back in the other window.
  #"autocmd VimEnter * NERDTree | wincmd p
  #" Close the tab if NERDTree is the only window remaining in it.
  #"autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
  #" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
  #"autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
  #"	\ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

  #"set statusline+=%#warningmsg#
  #"set statusline+=%{SyntasticStatuslineFlag()}
  #"set statusline+=%*

  #"let g:syntastic_always_populate_loc_list = 1
  #"let g:syntastic_auto_loc_list = 1
  #"let g:syntastic_check_on_open = 1
  #"let g:syntastic_check_on_wq = 0
}

# Plugins

#-- This file can be loaded by calling `lua require('plugins')` from your init.vim
#
#local vscode = vim.g.vscode == 1
#
#return require('packer').startup(function(use)
#	use {'tpope/vim-fugitive', disable = vscode}
#	use 'tpope/vim-surround'
#	--use 'tpope/vim-obsession'
#	--use {'scrooloose/nerdtree', disable = vscode}
#	use {'nvim-tree/nvim-tree.lua'}
#	use {'ryanoasis/vim-devicons', disable = vscode}
#	--use 'PhilRunninger/nerdtree-buffer-ops' -- Leads to cursor movement lags
#	--use 'Xuyuanp/nerdtree-git-plugin'
#	--use 'tiagofumo/vim-nerdtree-syntax-highlight'
#	--use {'airblade/vim-gitgutter', disable = vscode}
#	use 'preservim/nerdcommenter'
#	use 'tpope/vim-repeat'
#	--use 'valloric/youcompleteme'
#	--use 'SirVer/ultisnips'
#
#	--use 'scrooloose/syntastic'
#	use {'honza/vim-snippets', disable = vscode}
#	use {'hrsh7th/nvim-cmp', disable = vscode}
#	use {'hrsh7th/cmp-buffer', disable = vscode}
#	use {'hrsh7th/cmp-cmdline', disable = vscode}
#	use {'hrsh7th/cmp-path', disable = vscode}
#	use {'hrsh7th/cmp-vsnip', disable = vscode}
#	use {'hrsh7th/vim-vsnip', disable = vscode}
#	use {'rstacruz/vim-closer', disable = vscode}
#	use {'mhinz/vim-startify', disable = vscode}
#
#	use {'ofirgall/ofirkai.nvim', disable = vscode}
#	use {'kajamite/vim-monokai2', disable = vscode}
#	use {'ingram1107/moneokai', disable = vscode}
#	--use {'dracula/vim', disable = vscode}
#	--use {'nanotech/jellybeans.vim', disable = vscode} -- Best so far!
#	--use {'EdenEast/nightfox.nvim', disable = vscode} -- Okay...
#	--use {'cocopon/iceberg.vim', disable = vscode} -- Nice!
#	--use {'tomasr/molokai', disable = vscode}
#	--use {'joshdick/onedark.vim', disable = vscode}
#	--use {
#	--	'neoclide/coc.nvim', branch = 'release',
#	--	disable = vscode
#	--}
#end)
#
#-- You must run this or `PackerSync` whenever you make changes to your plugin configuration
#-- Regenerate compiled loader file
#--:PackerCompile
#
#
#-- Remove any disabled or unused plugins
#--:PackerClean
#
#-- Clean, then install missing plugins
#--:PackerInstall
#
#-- Clean, then update and install plugins
#-- supports the `--preview` flag as an optional first argument to preview updates
#--:PackerUpdate
#
#-- Perform `PackerUpdate` and then `PackerCompile`
#-- supports the `--preview` flag as an optional first argument to preview updates
#--:PackerSync
#
#-- Show list of installed plugins
#--:PackerStatus
#
#-- Loads opt plugin immediately
#--:PackerLoad completion-nvim ale
