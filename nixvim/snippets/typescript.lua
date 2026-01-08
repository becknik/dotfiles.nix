-- https://github.com/L3MON4D3/LuaSnip
-- https://github.com/rafamadriz/friendly-snippets/blob/main/snippets/javascript/react-ts.json
-- https://github.com/rafamadriz/friendly-snippets/blob/main/snippets/javascript/javascript.json

package.path = debug.getinfo(1, "S").source:match "@(.*/)" .. "?.lua;" .. package.path

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

-- NOTE: snippets start here

local snippet_rec_props
-- TODO: keep in sync with one from ./typescriptreact.lua
snippet_rec_props = function(delimiter, omit_newline)
  return function(_, _, _, start_index)
    local recursive_snip = fmta(
      (not omit_newline and "\n\n" or "") .. "\t<>: <>" .. delimiter .. "<>",
      {
        i(1, "prop" .. (start_index or "")),
        c(2, {
          i(nil, delimiter == ";" and "string" or "null"),
          fmta("(<>) =>> <>", {
            i(1, "args"),
            i(2, "void"),
          }),
        }),
        d(3, snippet_rec_props(delimiter), {}, {
          user_args = { (start_index or 1) + 1 },
        }),
      }
    )

    if start_index ~= 1 and start_index ~= nil then
      return sn(
        nil,
        c(1, {
          t "",
          recursive_snip,
        })
      )
    else
      return sn(2, recursive_snip)
    end
  end
end

-- @type SnippetTuple[]
local tuples_property = {
  {
    { trig = "n", name = "nested " },
    function(delimiter)
      return fmta(
        [[
        <>: {<>
        }<>
      ]],
        {
          i(1, "objectProp"),
          d(2, function(_, snip)
            if
              #snip.env.TM_SELECTED_TEXT == 0
              or snip.env.TM_SELECTED_TEXT == "$TM_SELECTED_TEXT"
            then
              return snippet_rec_props(delimiter)()
            else
              return sn(nil, i(1, snip.env.TM_SELECTED_TEXT))
            end
          end, {}, {
            user_args = { 1 },
          }),
          t(delimiter),
        }
      )
    end,
  },
  {
    { trig = "i", name = "inline " },
    function(delimiter)
      return fmta(
        [[
        {<>
        }
      ]],
        {
          d(1, snippet_rec_props(delimiter), {}, {
            user_args = { 1 },
          }),
        }
      )
    end,
  },
  {
    { trig = "p", name = "property " },
    function(delimiter)
      return fmta("<>", {
        d(1, snippet_rec_props(delimiter), {}, {
          user_args = { 1 },
        }),
      })
    end,
  },
}

vim.iter(tuples_property):map(function(tuple)
  local context, snippet_function = tuple[1], tuple[2]

  table.insert(
    snippets,
    s({
      trig = "t" .. context.trig,
      name = context.name .. "type",
    }, snippet_function ";")
  )

  local object_snippet = s({
    trig = "o" .. context.trig,
    name = context.name,
  }, snippet_function ",")

  table.insert(snippets, object_snippet)
  ls.add_snippets("javascript", { object_snippet })
end)

vim.list_extend(snippets, {

  -- types

  s(
    { trig = "in", name = "interface" },
    fmta(
      [[
        interface <> {<>
        }
      ]],
      {
        i(1, "Interface"),
        d(2, snippet_rec_props ";", {}, {
          user_args = { 1 },
        }),
      }
    )
  ),
  s(
    { trig = "ty", name = "type" },
    fmta(
      [[
        type <> = <>
      ]],
      {
        i(1, "Type"),
        c(2, {
          i(nil, "type"),
          sn(
            nil,
            fmta(
              [[
            {<>
            }]],
              d(1, snippet_rec_props ";", {}, {
                user_args = { 1 },
              })
            )
          ),
        }),
      }
    )
  ),
  s(
    { trig = "tpo", name = "typed props/ parameter object" },
    fmta(
      [[
        {<>}: {<>}
      ]],
      {
        f(function(args)
          -- vim.print("args", args)
          local variables = {}
          for param in
            string.gmatch(table.concat(args[1], "\n"), "([%w_]+)%s*:")
          do
            table.insert(variables, param)
          end
          -- vim.print("variables", variables)

          local params = ""
          for index, variable in ipairs(variables) do
            params = params .. variable .. ", "
            -- table.insert(nodes, i(index, variable))
            -- table.insert(nodes, t ", ")
          end

          -- return sn(2, nodes)
          return params
        end, { 1 }),

        d(1, function(_, snip)
          if
            #snip.env.TM_SELECTED_TEXT == 0
            or snip.env.TM_SELECTED_TEXT == "$TM_SELECTED_TEXT"
          then
            return snippet_rec_props ";"()
          else
            local params = utils.typescript_function_params_to_type_props(
              snip.env.TM_SELECTED_TEXT,
              snippet_rec_props(";", true)
            )
            return sn(nil, params)
          end
        end, {}, {
          user_args = { 2 },
        }),
      }
    )
  ),
})

ls.filetype_extend("typescript", { "javascript" })

return snippets
