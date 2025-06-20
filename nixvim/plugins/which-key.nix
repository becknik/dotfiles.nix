{ helpers, ... }:

{
  plugins.which-key = {
    enable = true;
    settings = {
      preset = "modern";
      triggers = [
        # (helpers.mkRaw ''{ "<auto>", mode = "nisotc" }'') # not "nixsotc"
      ];
      sort = [ "alphanum" ];
    };
  };
}
