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

-- NOTE: snippets start here

-- @param call_number number
-- @param start_index number?
-- @return LuaSnip.SnippetNode
local snippet_rec_ternary
snippet_rec_ternary = function(_, _, _, call_number)
  return sn(
    nil,
    c(1, {
      fmta("<><>", {
        t " ",
        i(1, "false"),
      }),
      fmta("\n\n<><> ? <> :<>", {
        f(function() return string.rep(" ", 2 * call_number) end),
        i(1, "condition"),
        i(2, "true"),
        d(3, snippet_rec_ternary, {}, { user_args = { call_number + 1 } }),
      }),
    })
  )
end

local function maybe_wrap_with_sn(params, snip)
  if params.wrap_with_sn then
    return sn(nil, snip)
  else
    return snip
  end
end

local snippets_calls = utils.insert_snippets(snippets, {
  {
    { trig = "new", name = "new statement" },
    function(params)
      return maybe_wrap_with_sn(
        params,
        fmta("new <>(<>)", {
          i(1, "Type"),
          i(2, "arguments"),
        })
      )
    end,
  },
  {
    { trig = "t", name = "ternary" },
    function(params)
      return maybe_wrap_with_sn(
        params,
        fmta("<> ? <> :<>", {
          i(1, "condition"),
          i(2, "true"),
          d(3, snippet_rec_ternary, {}, { user_args = { 1 } }),
        })
      )
    end,
  },

  {
    { trig = "st", name = "setTimeout" },
    function(params)
      return maybe_wrap_with_sn(
        params,
        fmta("setTimeout(<>, <>)", {
          c(2, utils.select_snippets(globals.functions, { "fn", "fni" })),
          i(1, "1000"),
        })
      )
    end,
  },
  {
    { trig = "ok", name = "Object.keys" },
    function(params)
      return maybe_wrap_with_sn(
        params,
        fmta("Object.keys(<>)", {
          i(1, "object"),
        })
      )
    end,

  },
  {
    { trig = "ov", name = "Object.values" },
    function(params)
      return maybe_wrap_with_sn(
        params,
        fmta("Object.values(<>)", {
          i(1, "object"),
        })
      )
    end,
  },
  {
    { trig = "oe", name = "Object.entries" },
    function(params)
      return maybe_wrap_with_sn(
        params,
        fmta("Object.entries(<>)", {
          i(1, "object"),
        })
      )
    end,
  },

  {
    { trig = "js", name = "JSON.stringify" },
    function(params)
      return maybe_wrap_with_sn(
        params,
        fmta("JSON.stringify(<>)", {
          i(1, "value"),
        })
      )
    end,
  },
  {
    { trig = "jp", name = "JSON.parse" },
    function(params)
      return maybe_wrap_with_sn(
        params,
        fmta("JSON.parse(<>)", {
          i(1, "value"),
        })
      )
    end,
  },

}, { const_declaration = true })

local snippet_rec_params
-- @return LuaSnip.SnippetNode
snippet_rec_params = function(_, _, _, call_number)
  return sn(
    nil,
    c(1, {
      t "",
      fmta(", <><>", {
        d(1, ts_utils.nearest_var_declaration(call_number)),
        d(2, snippet_rec_params, {}, { user_args = { call_number + 1 } }),
      }),
    })
  )
end

vim.list_extend(snippets, {

  -- Promises

  s(
    { trig = "apa", name = "await Promise.all" },
    fmta("await Promise.all(<>);", {
      i(1, "items"),
    })
  ),
  s(
    { trig = "apad", name = "await Promise.all (destructured)" },
    fmta("const [<>] = await Promise.all(<>);", {
      i(1, "items"),
      i(2, "vars"),
    })
  ),
  s(
    { trig = "apam", name = "await Promise.all (map)" },
    fmta("await Promise.all(<>.map(<>));", {
      i(1, "items"),
      c(2, utils.select_snippets(globals.functions, { "fni", "fnr" })),
    })
  ),
  s(
    { trig = "np", name = "new Promise" },
    fmta(
      [[
        new Promise((resolve, reject) =>> {
          <>
        })
      ]],
      {
        i(1, "body"),
      }
    )
  ),

  -- DOM Events

  s(
    { trig = "ael", name = "addEventListener" },
    fmta("<>.addEventListener(<>, <>);", {
      i(1, "document"),
      i(2, "event"),
      c(3, utils.select_snippets(globals.functions, { "fn", "fni" })),
    })
  ),
  s(
    { trig = "rel", name = "removeEventListener" },
    fmta("<>.removeEventListener(<>, <>);", {
      i(1, "document"),
      i(2, "event"),
      i(3, "listener"),
    })
  ),

  -- Assignments

  s(
    { trig = "c", name = "assignment" },
    fmta("<> <> = <>;", {
      c(1, {
        t "const",
        t "let",
      }),
      i(2, "name"),
      i(3, "value"),
    })
  ),
  s(
    { trig = "cd", name = "destructuring assignment" },
    fmta("<> <> = <>;", {
      c(1, {
        t "const",
        t "let",
      }),
      c(3, {
        sn(nil, fmta("{<>}", { i(1, "props") })),
        sn(nil, fmta("[<>]", { i(1, "props") })),
      }),
      i(2, "value"),
    })
  ),
  s(
    { trig = "co", name = "declaration (object / array)" },
    fmta(
      [[
        <> <> = <>;
      ]],
      {
        c(1, {
          t "const",
          t "let",
        }),
        i(2, "name"),
        c(3, {
          sn(nil, fmta("{\n  <>\n}", { i(1, "props") })),
          sn(nil, fmta("[<>]", { i(1, "props") })),
        }),
      }
    )
  ),
  s(
    { trig = "cfn", name = "function declaration inline" },
    fmta("const <> = <>;", {
      i(1, "name"),
      c(2, utils.select_snippets(globals.functions, { "fn", "fni", "fnr", "fna", "fnia", "fnra" })),
    })
  ),
  s(
    { trig = "cfun", name = "function declaration" },
    fmta(
      [[
        function <> (<>) {
          <>
        }
      ]],
      {
        i(1, "name"),
        i(2, "arguments"),
        i(0),
      }
    )
  ),

  s(
    { trig = "e", name = "export" },
    fmta("export <>;", {
      i(1, "member"),
    })
  ),
  s(
    { trig = "ed", name = "export default" },
    fmta("export default <>;", {
      i(1, "member"),
    })
  ),
  s(
    { trig = "ec", name = "export const" },
    fmta("export const <> = <>;", {
      i(2, "member"),
      i(1, "value"),
    })
  ),

  -- console

  s(
    { trig = "cl", name = "console.log" },
    fmta('console.log("<>", <><>)', {
      dl(2, l._1, 1),
      d(1, ts_utils.nearest_var_declaration(1)),
      c(3, {
        t "",
        d(1, snippet_rec_params, {}, {
          user_args = { 2 },
        }),
      }),
    })
  ),
  s(
    { trig = "ci", name = "console.info" },
    fmta('console.info("<>"<>)', {
      i(1, "info text"),
      c(2, {
        t "",
        d(1, snippet_rec_params, {}, {
          user_args = { 1 },
        }),
      }),
    })
  ),
  s(
    { trig = "cw", name = "console.warn" },
    fmta('console.warn("<>"<>)', {
      i(1, "text"),
      c(2, {
        t "",
        d(1, snippet_rec_params, {}, {
          user_args = { 1 },
        }),
      }),
    })
  ),
  s(
    { trig = "ce", name = "console.error" },
    fmta('console.error("<>"<>)', {
      i(1, "error text"),
      c(2, {
        t "",
        d(1, snippet_rec_params, {}, {
          user_args = { 1 },
        }),
      }),
    })
  ),

  -- method calls

  s(
    { trig = "af", name = "Array.from" },
    fmta("Array.from(<><>)", {
      c(1, {
        i(1, "iterable"),
        sn(
          nil,
          fmta("{ length: <> }", {
            i(1, "n"),
          })
        ),
      }),
      c(2, {
        t "",
        sn(
          nil,
          fmta(", <>", {
            c(1, utils.select_snippets(globals.functions, { "fn", "fni" })),
          })
        ),
      }),
    })
  ),

  -- Object

  s(
    { trig = "oa", name = "Object.assign" },
    fmta("Object.assign(<>, <>)", {
      i(1, "dest"),
      i(2, "source"),
    })
  ),
})

return snippets
