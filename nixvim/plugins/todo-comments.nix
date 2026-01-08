{
  config,
  lib,
  pkgs,
  withDefaultKeymapOptions,
  ...
}:

{
  plugins.todo-comments = {
    enable = true;
    settings = {
      kebwords = {
        FIX.alt = [
          "ISSUE"
          "FIXME"
          "FixMe"
          "FIXIT"
          "FixIt"
          "BUG"
        ];
        TODO.alt = [
          "TODO"
          "ToDo"
        ];
      };

      sign_priority = 8;
      highlight.multiline_pattern = "^%s+.";
      highlight.after = "";
      search.cmd = "${lib.getExe config.dependencies.ripgrep.package}";
      # TODO: KEYWORDS aren't extended by `alt`
      search.pattern = "(KEYWORDS):?";
    };
  };

  plugins.todo-comments.luaConfig.post = ''
    wk.add {
      { "<leader>dx", icon = " " },
      { "<leader>dX", icon = " " },
      { "<leader>fX", icon = "  " },
    }
  '';

  keymaps = withDefaultKeymapOptions [
    {
      key = "<leader>dx";
      action = "Trouble todo filter.buf = 0";
      options.cmd = true;
      options.desc = "TODOs";
    }
    {
      key = "<leader>dX";
      action = "Trouble todo win.position = right";
      options.cmd = true;
      options.desc = "Global TODOs";
    }
    {
      key = "<leader>fX";
      action = "TodoTelescope";
      options.cmd = true;
      options.desc = "Global TODOs";
    }

    {
      key = "gco";
      action.__raw = ''
        function()
          return "o.<esc>" .. require("vim._comment").operator() .. "_$s"
        end'';
      options.expr = true;
      options.desc = "Toggle Comment Below";
    }
    {
      key = "gcOO";
      action.__raw = ''
        function()
          return "O.<esc>" .. require("vim._comment").operator() .. "_$s"
        end'';
      options.expr = true;
      options.desc = "Toggle Comment Above";
    }

    {
      key = "gcOt";
      action.__raw = ''
        function()
          return "OTODO: <esc>" .. require("vim._comment").operator() .. "_A"
        end'';
      options.expr = true;
      options.desc = "Toggle TODO Comment Above";
    }
    {
      key = "gcOf";
      action.__raw = ''
        function()
          return "OFIXME: <esc>" .. require("vim._comment").operator() .. "_A"
        end'';
      options.expr = true;
      options.desc = "Toggle FIXME Comment Above";
    }
    {
      key = "gcOh";
      action.__raw = ''
        function()
          return "OHACK: <esc>" .. require("vim._comment").operator() .. "_A"
        end'';
      options.expr = true;
      options.desc = "Toggle HACK Comment Above";
    }
    {
      key = "gcOw";
      action.__raw = ''
        function()
          return "OWARN: <esc>" .. require("vim._comment").operator() .. "_A"
        end'';
      options.expr = true;
      options.desc = "Toggle WARN Comment Above";
    }
    {
      key = "gcOn";
      action.__raw = ''
        function()
          return "ONOTE: <esc>" .. require("vim._comment").operator() .. "_A"
        end'';
      options.expr = true;
      options.desc = "Toggle NOTE Comment Above";
    }
  ];
}
