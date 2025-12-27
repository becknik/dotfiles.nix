{ ... }:

{
  autoCmd = [
    {
      event = "FileType";
      pattern = [
        "javascriptreact"
        "typescriptreact"
        "css"
      ];
      desc = "Toggle between React component and CSS module";

      callback.__raw = ''
        function(args)
          local bufnr = args.buf

          local current_file = vim.api.nvim_buf_get_name(bufnr)
          local current_ext = vim.fn.expand("%:e")
          local current_base = vim.fn.expand("%:t");

          if current_ext == "css" and current_base:match("%.module%.css$") then
            vim.keymap.set("n", "<leader>lc", function()
              local base_name = vim.fn.expand("%:r:r")
              local target_file = base_name .. ".jsx"

              if vim.fn.filereadable(target_file) == 0 then
                target_file = base_name .. ".tsx"
              end

              if vim.fn.filereadable(target_file) == 0 then
                vim.notify("Couldn't find component: " .. target_file, vim.log.levels.WARN)
              else
                vim.cmd("edit " .. vim.fn.fnameescape(target_file))
              end
            end, { buffer = bufnr, silent = true, desc = "Switch to component" })
          else
            vim.keymap.set("n", "<leader>lc", function()
              local base_name = vim.fn.expand("%:r")
              local target_file = base_name .. ".module.css"
              vim.cmd("edit " .. vim.fn.fnameescape(target_file))
            end, { buffer = bufnr, silent = true, desc = "Switch to CSS module" })
          end
        end
      '';
    }
  ];
}
