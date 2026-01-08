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

package.path = debug.getinfo(1, "S").source:match "@(..*/)" .. "?.lua;" .. package.path

---@class SnippetUtils
local utils = require "..snippet-utils"
---@class TreesitterUtils
local ts_utils = require "..treesitter-snippet-utils"
---@class GlobalsJS
local globals = require ".globals"

local snippets = {}

local snippet_rec_elseif
-- @param start_index number?
-- @return LuaSnip.SnippetNode
snippet_rec_elseif = function(start_index)
  local choices = {
    -- Order is important, sn(...) first would cause infinite loop of expansion.
    fmta(
      [[
            else {
              <>
            }
          ]],
      { i(1) }
    ),
    fmta(
      [[
        else if (<>) {
          <>
        } <>
      ]],
      {
        i(1, "condition"),
        i(2),
        d(3, snippet_rec_elseif, {}),
      }
    ),
  }
  if start_index ~= 1 then
    table.insert(choices, 1, t "")
  end

  return sn(start_index, c(1, choices))
end

vim.list_extend(snippets, {
  s(
    { trig = "r", name = "return" },
    fmta("return <>", {
      c(
        1,
        utils.select_snippets(
          globals.functions,
          { "fn", "fni", "fnr", "fna", "fnia", "fnra" },
          { i(1, "value") }
        )
      ),
    })
  ),

  s(
    { trig = "if", name = "if" },
    fmta(
      [[
        if (<>) {
          <>
        } <>
      ]],
      {
        i(1, "condition"),
        i(2),
        snippet_rec_elseif(3),
      }
    )
  ),
  s({ trig = "else", name = "else (if)" }, {
    snippet_rec_elseif(1),
  }),

  s(
    { trig = "try", name = "try-catch" },
    fmta(
      [[
        try {
          <>
        } catch (error) {
          <>
        } <>
      ]],
      {
        i(1, "condition"),
        i(2),
        c(3, {
          t "",
          fmta(
            [[
              finally {
                <>
              }
            ]],
            { i(1) }
          ),
        }),
      }
    )
  ),
  s(
    { trig = "te", name = "throw new Error" },
    fmta('throw new <>("<>")', {
      i(1, "Error"),
      i(2, "message"),
    })
  ),

  s(
    { trig = "io", name = "instanceof" },
    fmta("<> instanceof <>", {
      i(1, "value"),
      i(2, "class"),
    })
  ),
  s(
    { trig = "to", name = "typeof" },
    fmta("typeof <> === <>", {
      i(1, "value"),
      i(2, "type"),
    })
  ),

  s(
    { trig = "fori", name = "for loop" },
    fmta(
      [[
        for (let <> = 0; <> << <>; <>) {
          const <> = <>[<>];
          <>
        }
      ]],
      {
        i(1, "i"),
        l(l._1, 1),
        i(2, "array.length"),
        l(l._1 .. "++", 1),
        i(3, "element"),
        dl(4, l._1:match "^(.*)%.", 2),
        l(l._1, 1),
        i(5),
      }
    )
  ),
  s(
    { trig = "fof", name = "for of loop" },
    fmta(
      [[
        for (<> <> of <>) {
          <>
        }
      ]],
      {
        c(1, {
          i(nil, "const"),
          i(nil, "let"),
        }),
        i(2, "key"),
        d(3, ts_utils.nearest_var_declaration(1)),
        i(4),
      }
    )
  ),
  s(
    { trig = "while", name = "while loop" },
    fmta(
      [[
        while (<>) {
          <>
        }
      ]],
      {
        i(1, "condition"),
        i(2),
      }
    )
  ),
  s(
    { trig = "dowhile", name = "while loop" },
    fmta(
      [[
        do {
          <>
        } while (<>);
      ]],
      {
        i(2),
        i(1, "condition"),
      }
    )
  ),
})

return snippets
