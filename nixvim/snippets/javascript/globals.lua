local ls = require "luasnip"
local sn = ls.snippet_node
local i = ls.insert_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta

package.path = debug.getinfo(1, "S").source:match "@(..*/)" .. "?.lua;" .. package.path

---@class SnippetUtils
local utils = require "..snippet-utils"
---@class TreesitterUtils
local ts_utils = require "..treesitter-snippet-utils"

--- @class GlobalsJS
local M = {}

-- @param params SnippetFunctionProps
local function get_last_node(params)
  return function()
    return d(2, function(_, snip)
      -- for nested snippets: access the parent snippet env
      local env = snip.env or snip.snippet.env

      if not env or #env.TM_SELECTED_TEXT == 0 or env.TM_SELECTED_TEXT == "$TM_SELECTED_TEXT" then
        -- 0 sadly isn't possible any more
        return sn(nil, i(params.last_index or 1, "body"))
      else
        return sn(nil, i(1, env.TM_SELECTED_TEXT))
      end
    end, { 1 })
  end
end

---@type SnippetTuples
M.functions = utils.insert_snippets({ "javascript" }, {
  {
    { trig = "fn", name = "function inline {}" },
    function(params)
      local last_node = get_last_node(params)

      return fmta((params.async and "async " or "") .. [[
(<>) =>> {
  <>
}
]], { i(1, "params"), last_node() })
    end,
  },
  {
    { trig = "fun", name = "function {}" },
    function(params)
      local last_node = get_last_node(params)

      return fmta((params.async and "async " or "") .. [[
function (<>) {
  <>
}
]], { i(1, "params"), last_node() })
    end,
  },
  {
    { trig = "fni", name = "function inline" },
    function(params)
      local last_node = get_last_node(params)

      return fmta(
        (params.async and "async " or "") .. "(<>) =>> <>",
        { i(1, "params"), last_node() }
      )
    end,
  },
  {
    { trig = "fnr", name = "function with return" },
    function(params)
      params.last_index = 2
      local second_node = get_last_node(params)

      return fmta((params.async and "async " or "") .. [[
(<>) =>> {
  <>

  return <>;
}
]], {
        i(1, "params"),
        second_node(),
        d(3, ts_utils.last_var_declaration_in_function, { 2 }),
      })
    end,
  },
}, { async = true })

return M
