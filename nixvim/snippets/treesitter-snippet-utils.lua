local ls = require "luasnip"
local sn = ls.snippet_node
local i = ls.insert_node

-- prepare treesitter

for _, lang in ipairs { "typescript", "tsx", "javascript", "jsx" } do
  vim.treesitter.query.set(
    lang,
    "LuaSnip_JS_var-declaration-in-function",
    [[
      ; query
      (lexical_declaration
        (variable_declarator
          name: [
            (identifier) @declaration_identifier
            (array_pattern (identifier) @declaration_identifier)
            (object_pattern (shorthand_property_identifier_pattern) @declaration_identifier)
          ]
        )
      )
    ]]
  )
end

---@class TreesitterUtils
local M = {}

--- @param call_number number
function M.nearest_var_declaration(call_number)

  --- @return LuaSnip.SnippetNode
  return function()
    local parser = vim.treesitter.get_parser(0)
    parser:parse(true)

    local cursor_row = unpack(vim.api.nvim_win_get_cursor(0))
    cursor_row = cursor_row - 1

    local node = vim.treesitter.get_node()
    while node ~= nil do
      if node:type() == "statement_block" then
        break
      end

      node = node:parent()
    end

    if not node then
      vim.print "no statement block"
      return sn(nil, i(1, '"variable"'))
    end

    local query = vim.treesitter.query.get(parser:lang(), "LuaSnip_JS_var-declaration-in-function")

    local nodes_before_cursor = {}
    for _, captured_node in query:iter_captures(node, 0) do
      local node_end_row = captured_node:end_()

      if cursor_row > node_end_row then
        table.insert(nodes_before_cursor, captured_node)
      else
        break
      end
    end

    if #nodes_before_cursor == 0 then
      return sn(nil, i(1, '"variable"'))
    else
      local selection_index = #nodes_before_cursor - (call_number - 1)
      local selected_node
      if selection_index >= 1 then
        selected_node = nodes_before_cursor[#nodes_before_cursor - (call_number - 1)]
      else
        selected_node = nodes_before_cursor[1]
      end

      local declaration_name = vim.treesitter.get_node_text(selected_node, 0)
      return sn(nil, i(1, declaration_name))
    end
  end
end

--- @return LuaSnip.SnippetNode
function M.last_var_declaration_in_function(args)
  if args[1][1] == "body" then
    return sn(nil, i(1, "variable"))
  end

  local parser = vim.treesitter.get_parser(0)
  parser:parse(true)

  -- @type TSNode?
  local node = vim.treesitter.get_node()
  while node ~= nil do
    if node:type() == "statement_block" then
      break
    end

    node = node:parent()
  end

  if not node then
    return sn(nil, i(1, "variable"))
  end

  local query = vim.treesitter.query.get(parser:lang(), "LuaSnip_JS_var-declaration-in-function")

  local last_captured_node = nil
  for _, captured_node in query:iter_captures(node, 0) do
    last_captured_node = captured_node
  end

  if last_captured_node then
    local declaration_name = vim.treesitter.get_node_text(last_captured_node, 0)
    return sn(nil, i(1, declaration_name))
  else
    return sn(nil, i(1, "variable"))
  end
end

return M
