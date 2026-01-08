local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local sn = ls.snippet_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta

---@class SnippetEntry
---@field trig string
---@field name string

---@class SnippetFunctionProps
---@field async? boolean
---@field last_index? number
---@field wrap_with_sn? boolean
---@alias SnippetFunction fun(params: SnippetFunctionProps): string[]

---@class SnippetTuple
---@field [1] SnippetEntry
---@field [2] SnippetFunction

---@alias SnippetTuples SnippetTuple[]

---@class SnippetUtils
local M = {}

---@param framework_files table<string, string[] | boolean>
function M.detect_frameworks(framework_files)
  for name, files in pairs(framework_files) do
    local root = vim.fs.root(0, files --[[ @as string[] ]])
    framework_files[name] = root ~= nil
  end
end

---@class Options
---@field async boolean?
---@field const_declaration boolean?

--- @param snippets LuaSnip.Snippet[] | string[]
--- @param snippet_tuples SnippetTuple[]
--- @param options Options
--- @return SnippetTuple[]
function M.insert_snippets(snippets, snippet_tuples, options)
  local snippet_tuples_extended = vim.deepcopy(snippet_tuples)

  local insert
  if type(snippets[1]) == "table" or snippets[1] == nil then
    insert = function(snippet) table.insert(snippets, snippet) end
  elseif type(snippets[1]) == "string" then
    insert = function(snippet)
      vim.iter(snippets):each(function(ft) ls.add_snippets(ft, { snippet }) end)
    end
  else
    error "First argument is neither filetype list nor snippet list..."
  end

  for _, snip in pairs(snippet_tuples) do
    insert(s(snip[1], snip[2] { async = false }))

    if options.async then
      local snip_context = {
        trig = (snip[1].trig .. "a"),
        name = (snip[1].name .. " (async)"),
      }
      local snip_async = function() return snip[2] { async = true } end

      insert(s(snip_context, snip_async()))
      table.insert(snippet_tuples_extended, { snip_context, snip_async })
    end

    if options.const_declaration then
      local snip_context =
        { trig = ("c" .. snip[1].trig), name = ("declaration with" .. snip[1].name) }
      local snip_const = function()
        return fmta("const <> = <>;", {
          i(1, "name"),
          d(2, function() return snip[2] { wrap_with_sn = true } end),
        })
      end

      insert(s(snip_context, snip_const()))
      table.insert(snippet_tuples_extended, { snip_context, snip_const })
    end
  end

  return snippet_tuples_extended
end

--- @param snippet_tuples SnippetTuple[]
--- @param selection string[]
--- @param start LuaSnip.SnippetNode[]?
--- @return LuaSnip.SnippetNode
function M.select_snippets(snippet_tuples, selection, start)
  local selected_snippet_nodes = start and vim.deepcopy(start) or {}

  for _, snippet in ipairs(snippet_tuples) do
    if vim.tbl_contains(selection, snippet[1].trig) then
      table.insert(selected_snippet_nodes, sn(nil, snippet[2] {}))
    end
  end

  return selected_snippet_nodes
end

-- @param snip: string[]
-- @param callback? fun(): any
-- @param to_props: boolean
function M.typescript_function_params_to_type_props(content, callback, from_props)
  local index = 1
  local params = {}

  for parameter, type in
    string.gmatch(
      table.concat(content, "\n"),
      '([%l_][%w_]*)%s*:%s*([%w_%[%]{}<>|,?" ]+)' .. (not from_props and "," or ";")
    )
  do
    if not from_props then
      table.insert(params, i(index * 2 - 1, parameter))
      table.insert(params, t ": ")
      table.insert(params, i(index * 2, type))
      table.insert(params, t "; ")
    else
      table.insert(params, t(parameter))
      table.insert(params, t ", ")
    end

    index = index + 1
  end

  if callback then
    table.insert(
      params,
      d(not from_props and (index * 2 - 1) or 1, callback, {}, {
        user_args = { 2 },
      })
    )
  end

  return params
end

return M
