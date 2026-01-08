local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local ai = require "luasnip.nodes.absolute_indexer"
local events = require "luasnip.util.events"
-- local opt = require("luasnip.nodes.optional_arg")
local extras = require "luasnip.extras"
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require "luasnip.extras.expand_conditions"
local postfix = require("luasnip.extras.postfix").postfix
local types = require "luasnip.util.types"
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

package.path = debug.getinfo(1, "S").source:match "@(.*/)" .. "?.lua;" .. package.path

---@class SnippetUtils
local utils = require ".snippet-utils"
---@class TreesitterUtils
local ts_utils = require ".treesitter-snippet-utils"
---@class GlobalsJS
-- local globals_js = require "..javascript.globals"

local snippets = {}

local frameworks = {
  TODO = { "relay.config.json" },
}
utils.detect_frameworks(frameworks)

-- NOTE: framework-specific snippets start here

--[[
if frameworks["TODO"] then
  vim.list_extend(snippets, {
    s("todo_snippet", {
      t "This is a TODO snippet from the snippet template.",
      i(1, "Insert your code here"),
      t { "", "Done!" },
    }),
  })
end
--]]

-- NOTE: snippets start here

-- ls.filetype_extend("typescriptreact", { "javascript", "typescript" })

return snippets
