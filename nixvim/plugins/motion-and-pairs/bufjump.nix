{ pkgs, ... }:

{
  extraConfigLua = ''
    local function jump_in_buffer(direction)
      local jumplist, current_pos = unpack(vim.fn.getjumplist())
      local current_bufnr = vim.api.nvim_get_current_buf()

      local step = direction == "back" and -1 or 1
      local i = current_pos + 1 + step -- convert to 1-indexed and move one step

      local count = 0
      while i >= 1 and i <= #jumplist do
        count = count + 1
        local entry = jumplist[i]
        if entry and entry.bufnr == current_bufnr then
          local key = direction == "back" and "<C-o>" or "<C-i>"
          vim.cmd.normal({ count .. vim.keycode(key), bang = true })
          return
        end
        i = i + step
      end
    end

    vim.keymap.set("n", "<M-o>", function()
      jump_in_buffer("back")
    end, { desc = "Jump back (current buffer only)" })

    vim.keymap.set("n", "<M-i>", function()
      jump_in_buffer("forward")
    end, { desc = "Jump forward (current buffer only)" })
  '';
}
