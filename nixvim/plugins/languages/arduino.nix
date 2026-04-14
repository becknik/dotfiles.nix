{ pkgs, config, ... }:

let
  arduinoCliConfig = pkgs.writeText "arduino-cli.yaml" /* yaml */ ''
    directories:
      data: /home/jnnk/.arduino15
      downloads: /home/jnnk/.arduino15/staging
      user: /home/jnnk/Arduino
  '';

  # Ensure clangd trusts Arduino cross-compiler drivers so it resolves the
  # correct toolchain headers instead of host system glibc include paths.
  clangdArduinoWrapper = pkgs.writeShellScript "clangd-arduino-wrapper" ''
    set -eu

    exec ${pkgs.clang-tools}/bin/clangd \
      "--query-driver=$HOME/.arduino15/packages/**/bin/*-gcc,$HOME/.arduino15/packages/**/bin/*-g++" \
      "$@"
  '';

  # https://github.com/arduino/arduino-language-server/issues/125
  arduinoLanguageServerWrapper = pkgs.writeShellScript "arduino-language-server-wrapper" ''
    set -eu

    fqbn=""

    find_arduino_config() {
      search_dir="$PWD"

      while [ "$search_dir" != "/" ]; do
        candidate="$search_dir/.arduino_config.lua"
        if [ -f "$candidate" ]; then
          printf '%s\n' "$candidate"
          return 0
        fi
        search_dir="$(dirname "$search_dir")"
      done

      return 1
    }

    extract_board_from_config() {
      config_file="$1"
      sed -nE "s/^[[:space:]]*board[[:space:]]*=[[:space:]]*['\"]([^'\"]+)['\"][[:space:]]*,?[[:space:]]*$/\1/p" "$config_file"
    }

    if config_file="$(find_arduino_config)"; then
      extracted_fqbn="$(extract_board_from_config "$config_file")"
      if [ -n "$extracted_fqbn" ]; then
        fqbn="$extracted_fqbn"
      fi
    fi

    if [ -z "$fqbn" ]; then
      fqbn="arduino:avr:uno"
    fi

    exec ${pkgs.arduino-language-server}/bin/arduino-language-server \
      -cli ${pkgs.arduino-cli}/bin/arduino-cli \
      -cli-config ${arduinoCliConfig} \
      -clangd ${clangdArduinoWrapper} \
      -fqbn "$fqbn"
  '';
in

{

  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "arduino-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "yuukiflow";
        repo = "arduino-nvim";
        rev = "60e7ed08ca2bcf0cd357efb0aa74ae3dd528a83a";
        hash = "sha256-pQk5bks0oBywnzZcMaime4J3mjpOaG/OUTBv0gVd/gU=";
      };

      patches = [
        ./arduino-nvim.patch
      ];
    })
  ];
  extraPackages = with pkgs; [
    arduino-cli
  ];

  lsp.servers.clangd.enable = true;
  lsp.servers.arduino_language_server = {
    enable = true;

    config = {
      textDocument.semanticTokens.__raw = "vim.NIL";
      workspace.semanticTokens.__raw = "vim.NIL";

      # The clangd LSP doesn't see HardwareSerial as inheriting from or convertible to Print. This is likely a clangd/clang indexing issue where the inheritance relationship isn't being recognized properly by the language server.
      handlers."textDocument/publishDiagnostics".__raw = ''
        function(err, result, ctx, conf)
          if result and result.diagnostics then
            result.diagnostics = vim.tbl_filter(function(diagnostic)
              return diagnostic.code ~= "ovl_no_viable_member_function_in_call"
            end, result.diagnostics)
          end

          return vim.lsp.handlers["textDocument/publishDiagnostics"](err, result, ctx, conf)
        end
      '';

      cmd = [
        "${arduinoLanguageServerWrapper}"
      ];
    };
  };

  autoCmd = [
    {
      event = "FileType";
      pattern = "arduino";
      desc = "Attach arduino-nvim";
      callback.__raw = ''
        function()
          require'Arduino-Nvim'
        end
      '';
    }
  ];
}
