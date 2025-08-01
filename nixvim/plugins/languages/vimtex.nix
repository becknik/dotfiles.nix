{ pkgs-stable, ... }:

{
  # FileType Autocommands for "*": Vim(append):tree-sitter CLI not found: `tree-sitter` is not executable!
  # stack traceback:
  #         [C]: in function '_with'
  #         ...-neovim-unwrapped-0.11.2/share/nvim/runtime/filetype.lua:35: in function <...-neovim-unwrapped-0.11.2/share/nvim/runtime/filetype.lua:10>
  #         [C]: at 0x0063cb10
  #         [C]: in function 'pcall'
  #         ...-dir/pack/myNeovimPackages/opt/oil.nvim/lua/oil/init.lua:761: in function 'callback'
  #         ...myNeovimPackages/opt/oil.nvim/lua/oil/adapters/files.lua:270: in function ''
  dependencies.tree-sitter.enable = true;

  plugins.vimtex = {
    enable = true;
    # NOTE: sync with NixOS system texlive
    texlivePackage = pkgs-stable.tectonic;
    # texlivePackage = null;

    settings = {
      mappings_prefix = "<leader>l";
      view_method = "general";
      view_general_viewer = "okular";
      view_general_options = "--unique file:@pdf\#src:@line@tex";

      # compiler_method = "tectonic";
      compiler_tectonic.__raw = ''
        {
          options = {
            '-X',
            ' compile',
            '--keep-logs',
            '--synctex',
            -- '--keep-intermediates',
          },
        }
      '';

      # compiler_method = "generic";
      # compiler_generic.__raw = # vim
      #   ''
      #     {
      #     \ 'command': 'ls *.tex | entr -c ${pkgs-stable.tectonic} /_ --synctex --keep-logs',
      #     \}
      #   '';
    };
  };
}
