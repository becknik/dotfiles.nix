{ withDefaultKeymapOptions, mapToModeAbbr, ... }:

{
  plugins.avante = {
    enable = true;

    settings = {
      provider = "copilot";
      auto_suggestions_provider = "copilot";
    };
  };

  keymaps = withDefaultKeymapOptions [];
}
