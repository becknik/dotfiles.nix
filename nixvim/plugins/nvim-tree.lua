function(bufnr)
  local api = require("nvim-tree.api")
  local opts =  {buffer = bufnr, noremap = true, silent = true, nowait = true }
  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set('n', 'g?', api.tree.toggle_help, opts)
  vim.keymap.set("n", "h", api.node.navigate.parent_close, opts)
  vim.keymap.set("n", "H", api.tree.collapse_all, opts)
  vim.keymap.set("n", "<esc>", api.tree.close, opts)

  local function edit_or_open()
    local node = api.tree.get_node_under_cursor()

    if node.nodes ~= nil then
      api.node.open.edit() -- expand or collapse folder
    else
      api.node.open.edit() -- open file
      api.tree.close() -- Close the tree if file was opened
    end
  end
  vim.keymap.set("n", "l", edit_or_open, opts)

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
  vim.keymap.set('n', 'ga', git_add, opts)

  -- TODO write recursive function to expand all subdirs
--[[   local function expand_all_subdirs()
    local node = api.tree.get_node_under_cursor()

    if node and node.children then
      -- Expands all children recursively
      for child in node.children do
        if child.children and not child.open then
          lib.expand_or_collapse(child)
        end
      end
    end
  end
  vim.keymap.set('n', 'gl', expand_all_subdirs, opts) ]]

end
