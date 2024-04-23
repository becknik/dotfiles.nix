{ helpers, ... }:

{
  plugins.comment = {
    enable = true;

    settings = {
      extra = {
        above = "<leader>/O";
        below = "<leader>/o";
        eol = "<leader>/A";
      };
      opleader = {
        line = "g/";
        block = "g*";
      };
      toggler = {
        block = "<leader>/*";
        line = "<leader>//";
        # line = helpers.mkRaw ''{ "<leader>//", "<c-/>" }'';
      };
    };
  };
}
