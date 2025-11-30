{ withDefaultKeymapOptions, ... }:

{

  # alternative: https://github.com/catgoose/nvim-colorizer.lua
  plugins.ccc = {
    enable = true;
    settings.lsp = true;

    settings = {
      inputs = [
        "ccc.input.oklch"
        "ccc.input.hsl"
        "ccc.input.rgb"
      ];
      outputs = [
        "ccc.output.css_oklch"
        "ccc.output.css_hsl"
        "ccc.output.css_rgb"
        "ccc.output.hex"
        "ccc.output.hex_short"
      ];
      convert = [
        [
          "ccc.picker.hex"
          "ccc.output.css_oklch"
        ]
        [
          "ccc.picker.css_oklch"
          "ccc.output.css_hsl"
        ]
        [
          "ccc.picker.css_hsl"
          "ccc.output.hex"
        ]
      ];

      highlighter = {
        auto_enable = true;
        excludes = [ ];
        lsp = true;
      };
    };
  };

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>cp";
      action = "CccPick";
      options.desc = "Color Picker";
      options.cmd = true;
    }
    {
      key = "<leader>cc";
      action = "CccConvert";
      options.desc = "Color Converter";
      options.cmd = true;
    }
  ];
}
