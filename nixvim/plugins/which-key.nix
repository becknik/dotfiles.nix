{ ... }:

{
  plugins.which-key = {
    enable = true;
    settings = {
      preset = "modern";
      triggers = [
        # (__raw  = ''{ "<auto>", mode = "nisotc" }'') # not "nixsotc"
      ];
      sort = [ "alphanum" ];
    };
  };
}
