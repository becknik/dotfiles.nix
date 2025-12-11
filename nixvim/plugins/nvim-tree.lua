-- on_attach function for nvim-tree
function(bufnr)
  local api = require "nvim-tree.api"
  local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"

  api.config.mappings.default_on_attach(bufnr)

  -- Auto open file when created
  api.events.subscribe(
    api.events.Event.FileCreated,
    function(file) vim.cmd("edit " .. vim.fn.fnameescape(file.fname)) end
  )

  local opts = function(desc) return { buffer = bufnr, noremap = true, silent = true, desc = desc } end

  vim.keymap.del("n", "]e", { buffer = bufnr })
  vim.keymap.del("n", "[e", { buffer = bufnr })
  local next_diag, prev_diag =
    ts_repeat_move.make_repeatable_move_pair(api.node.navigate.diagnostics.next, api.node.navigate.diagnostics.prev)
  vim.keymap.set("n", "]d", next_diag, opts "Next Diagnostic")
  vim.keymap.set("n", "[d", prev_diag, opts "Previous Diagnostic")

  vim.keymap.del("n", "]c", { buffer = bufnr })
  vim.keymap.del("n", "[c", { buffer = bufnr })
  local next_git, prev_git =
    ts_repeat_move.make_repeatable_move_pair(api.node.navigate.git.next, api.node.navigate.git.prev)
  vim.keymap.set("n", "]h", next_git, opts "Next Git")
  vim.keymap.set("n", "[h", prev_git, opts "Previous Git")

  vim.keymap.del("n", "F", { buffer = bufnr })
  vim.keymap.set("n", "f", api.tree.search_node, opts "Find")
  vim.keymap.set("n", "q", api.tree.close, opts "Close")
  vim.keymap.set("n", "gn", api.fs.rename, opts "Rename")

  local function reset()
    local api = require "nvim-tree.api"
    local global_cwd = vim.fn.getcwd(-1, -1)
    api.tree.change_root(global_cwd)

    api.tree.collapse_all()
  end

  vim.keymap.set("n", "R", reset, opts "Reset")
  vim.keymap.set("n", "<C-r>", api.tree.reload, opts "Refresh")

  vim.keymap.set("n", "h", api.node.navigate.parent, opts "Up")
  vim.keymap.set("n", "H", api.node.navigate.parent_close, opts "Close")
  vim.keymap.set("n", "H", api.tree.collapse_all, opts "Collapse All")

  local function edit_or_open()
    local node = api.tree.get_node_under_cursor()

    if node.nodes ~= nil then
      api.node.open.edit()
    else
      api.node.open.edit()
      api.tree.close()
    end
  end

  vim.keymap.set("n", "l", edit_or_open, opts "Edit or Open")
  vim.keymap.set("n", "L", api.tree.expand_all, opts "Expand All")

  local function open_dir_in_oil()
    local node = api.tree.get_node_under_cursor()

    if node.nodes ~= nil then
      require("oil").open(node.absolute_path)
    else
      api.node.open.edit()
    end
  end

  vim.keymap.set("n", "<CR>", open_dir_in_oil, opts "Open")

  local function git_add()
    local node = api.tree.get_node_under_cursor()
    local gs = node.git_status.file

    -- If the current node is a directory get children status
    if gs == nil then
      gs = (node.git_status.dir.direct ~= nil and node.git_status.dir.direct[1])
        or (node.git_status.dir.indirect ~= nil and node.git_status.dir.indirect[1])
    end

    -- If the file is untracked, unstaged or partially staged, we stage it
    if gs == "??" or gs == "MM" or gs == "AM" or gs == " M" then
      vim.cmd("silent !git add " .. node.absolute_path)

    -- If the file is staged, we unstage
    elseif gs == "M " or gs == "A " then
      vim.cmd("silent !git restore --staged " .. node.absolute_path)
    end
    api.tree.reload()
  end

  vim.keymap.set("n", "<leader>hs", git_add, opts "Git Stage")
end
