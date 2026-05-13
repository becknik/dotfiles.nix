-- https://github.com/L3MON4D3/LuaSnip
-- https://github.com/rafamadriz/friendly-snippets/blob/main/snippets/javascript/react-ts.json
-- https://github.com/rafamadriz/friendly-snippets/blob/main/snippets/javascript/javascript.json

package.path = debug.getinfo(1, "S").source:match "@(.*/)"
  .. "?.lua;"
  .. package.path

---@class SnippetUtils
local utils = require ".snippet-utils"
---@class TreesitterUtils
local ts_utils = require ".treesitter-snippet-utils"

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

local snippets = {}

local function selection_or(text, transformation_callback)
  return function(_, snip)
    local snippets_text = text

    if
      #snip.env.TM_SELECTED_TEXT ~= 0
      and snip.env.TM_SELECTED_TEXT ~= "$TM_SELECTED_TEXT"
    then
      snippets_text = snip.env.TM_SELECTED_TEXT
    end

    snippets_text = transformation_callback
        and transformation_callback(snippets_text)
      or snippets_text

    return not snippets_text and sn(nil, i(1, snippets_text))
      or sn(nil, { t(snippets_text), i(1) })
  end
end

-- NOTE: snippets start here

vim.list_extend(snippets, {

  -- syntax

  s(
    { trig = "c", name = "comment inline" },
    fmta("/* <> */", {
      d(1, selection_or "comment"),
    })
  ),

  -- abbreviations

  s(
    { trig = "em", name = "emph" },
    fmta("#emph[<>]", {
      d(1, selection_or()),
    })
  ),
  s(
    { trig = "it", name = "emph (alias)" },
    fmta("#emph[<>]", {
      d(1, selection_or()),
    })
  ),
  s(
    { trig = "quote", name = "quote" },
    fmta("#quote[<>]", {
      d(1, selection_or()),
    })
  ),
  s(
    { trig = "enquote", name = "quote (alias)" },
    fmta("#quote[<>]", {
      d(1, selection_or()),
    })
  ),
  s(
    { trig = "cite", name = "cite" },
    fmta("#cite(<>)", {
      d(
        1,
        selection_or(nil, function(text)
          if not text or not text[1] or text[1]:len() <= 2 then return "" end

          local minus_at = text[1]:sub(2, text[1]:len())
          return "<" .. minus_at .. ">"
        end)
      ),
    })
  ),
})

return snippets
