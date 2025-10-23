{ withDefaultKeymapOptions, mapToModeAbbr, ... }:

{
  # https://github.com/olimorris/dotfiles/blob/main/.config/nvim/lua/plugins/coding.lua
  plugins.codecompanion = {
    enable = true;
    luaConfig.post = ''
      vim.cmd([[cab cc CodeCompanion]])
    '';

    settings = {
      display = {
        action_palette = {
          provider = "telescope";
          opts = {
            show_default_actions = true;
            show_default_prompt_library = true;
          };
        };
      };
      opts = {
        # log_level = "TRACE";
      };

      strategies = {
        chat = {
          adapter = {
            name = "copilot";
            model = "claude-sonnet-4.5";
          };
          roles.user = "becknik";
          opts.completion_provider = "blink";

          keymaps = { };
          slash_commands.__raw = ''
            {
              ["buffer"] = { keymaps = { modes = { i = "<C-b>" } } },
              ["file"] = { keymaps = { modes = { i = "<C-f>" } } }
            }
          '';
        };

        inline.adapter = {
          name = "copilot";
          model = "gpt-4.1";
        };

        cmd.adapter = {
          name = "copilot";
          model = "gpt-4.1";
        };
      };

      # Models Available:
      # https://codecompanion.olimorris.dev/usage/chat-buffer/agents#compatibility
      # Adapters Docs:
      # https://github.com/olimorris/codecompanion.nvim/blob/main/doc/configuration/adapters.md
      adapters = { };

      # https://codecompanion.olimorris.dev/configuration/prompt-library
      prompt_library = { };
    };
  };

  keymaps = withDefaultKeymapOptions [
    {
      key = "<C-g>";
      action = "CodeCompanionActions";
      mode = mapToModeAbbr [
        "normal"
        "insert"
        "visual_select"
      ];
      options.cmd = true;
      options.desc = "Code Companion Actions Palette";
    }

    {
      key = "<leader>cc";
      mode = mapToModeAbbr [
        "normal"
        "visual_select"
      ];
      action = "CodeCompanionChat Toggle";
      options.cmd = true;
      options.desc = "Code Companion Chat";
    }
    {
      key = "ga";
      mode = mapToModeAbbr [
        "normal"
        "visual_select"
      ];
      action = "CodeCompanionChat Add";
      options.cmd = true;
      options.desc = "Code Companion Inline";
    }
  ];
}
