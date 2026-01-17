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

package.path = debug.getinfo(1, "S").source:match "@(.*/)"
  .. "?.lua;"
  .. package.path

---@class SnippetUtils
local utils = require ".snippet-utils"
---@class GlobalsJS
local globals_js = require "..javascript.globals"

local snippets = {}

-- NOTE: snippets start here

local snippet_rec_props
-- TODO: keep in sync with one from ./typescript.lua
snippet_rec_props = function(_, _, _, start_index)
  local recursive_snip = fmta("\n\n\t<>: <>;<>", {
    i(1, "prop" .. (start_index or "")),
    c(2, {
      i(nil, "string"),
      fmta("(<>) =>> <>", {
        i(1, "args"),
        i(2, "void"),
      }),
    }),
    d(3, snippet_rec_props, {}, {
      user_args = { (start_index or 1) + 1 },
    }),
  })

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

vim.list_extend(snippets, {
  s(
    { trig = "rfc", name = "react functional component " },
    fmta(
      [[
        <>type Props = {<>
        };

        const <>: React.FC<<Props>> = (<>) =>> {
          <>

          return <<>><</>>;
        }

        export default <>;
      ]],
      {
        c(1, {
          t "",
          fmta("import classes from '<>';\n\n\n", {
            l(l.TM_FILENAME:gsub("%.tsx", ".module.css")),
          }),
        }),
        d(2, snippet_rec_props, {}, {
          user_args = { 1 },
        }),
        dl(3, l.TM_FILENAME:gsub("%.tsx", "")),
        d(4, function(args)
          local params =
            utils.typescript_function_params_to_type_props(args[1], nil, true)
          return sn(nil, params)
        end, { 2 }, {
          user_args = { 2 },
        }),
        i(0, "body"),
        f(function(args) return args[1][1] end, 3),
      }
    )
  ),

  s({ trig = "fr", name = "react fragment wrapper" }, {
    t { "<>", "" },
    l(l.TM_SELECTED_TEXT),
    t { "", "</>" },
  }),
  s({ trig = "w&", name = "react && wrapper" }, {
    t { "{" },
    i(1, "condition"),
    t { " && (" },
    l(l.TM_SELECTED_TEXT),
    t { "", ")}" },
  }),

  s(
    { trig = "sty", name = "react style property" },
    fmta(
      [[
        style={<>}
      ]],
      { i(1, "{}") }
    )
  ),

  -- hooks

  s(
    { trig = "ucb", name = "react useCallback " },
    fmta(
      [[
        const <> = useCallback(<>, [<>]);
      ]],
      {
        i(1, "handleSomething"),
        c(
          2,
          utils.select_snippets(
            globals_js.functions,
            { "fn", "fnr", "fna", "fnra" }
          )
        ),
        i(3),
      }
    )
  ),
  s(
    { trig = "ue", name = "react useEffect" },
    fmta(
      [[
        useEffect(() =>> {
          <><>
        }, [<>]);
      ]],
      {
        i(1),
        c(2, {
          t "",
          fmta(
            [[

              return () =>> {
                <>
              };
            ]],
            {
              i(1, ""),
            }
          ),
        }),
        i(3),
      }
    )
  ),
  s(
    { trig = "uea", name = "react useEffect async" },
    fmta(
      [[
        useEffect(() =>> {
          <>(<>)

          async function <> (<>) {
            <>
          }
        }, [<>]);
      ]],
      {
        l(l._1, 1),
        i(3),
        i(1, "fetchData"),
        i(2),
        i(4),
        i(5),
      }
    )
  ),
  s(
    { trig = "uee", name = "react useEffectEvent" },
    fmta(
      [[
        const <> = useEffectEvent(() =>> {
          <>
        });
      ]],
      {
        i(1, "effectEvent"),
        i(2),
      }
    )
  ),
  s(
    { trig = "um", name = "react useMemo" },
    fmta(
      [[
        const {<>} = useMemo(() =>> {
          <>
        })
      ]],
      {
        i(2, ""),
        i(1, ""),
      }
    )
  ),
  s(
    { trig = "ust", name = "react useSate" },
    fmta("const [<>, <>] = useState<>(<>);", {
      i(1, ""),
      f(function(args)
        local name = args[1][1]
        if not name or name == "" then return "" end
        return "set" .. string.upper(name:sub(0, 1)) .. name:sub(2)
      end, 1),
      c(3, {
        t "",
        fmt("<{}>", { i(1, "null") }),
      }),
      i(2, ""),
    })
  ),
  s(
    { trig = "ur", name = "react useRef" },
    fmta("const <> = useRef<>(<>);", {
      i(1, "ref"),
      c(3, {
        t "",
        fmt("<{}>", { i(1, "| null") }),
      }),
      i(2, "null"),
    })
  ),
  s(
    { trig = "uct", name = "react useContext" },
    fmta("const {<>} = useContext(<>);", {
      i(1, ""),
      i(2, "/* context */"),
    })
  ),
  s(
    { trig = "ut", name = "react useTransition" },
    t "const [isPending, startTransition] = useTransition();"
  ),

  -- calls

  s(
    { trig = "rst", name = "react startTransition" },
    fmta(
      [[
        startTransition(<>() =>> {
          <>
        });
      ]],
      { c(1, {
        t "",
        t "async ",
      }), i(2, "// actions") }
    )
  ),

  -- components

  s(
    { trig = "sus", name = "react Suspense component" },
    fmt(
      [[
        <Suspense fallback={{{}}}>
          {}
        </Suspense>
      ]],
      {
        i(2, "<div>Loading...</div>"),
        d(1, function(_, snip)
          if
            #snip.env.TM_SELECTED_TEXT == 0
            or snip.env.TM_SELECTED_TEXT == "$TM_SELECTED_TEXT"
          then
            return sn(nil, i(1, "{/* content */}"))
          else
            return sn(nil, i(1, snip.env.TM_SELECTED_TEXT))
          end
        end),
      }
    )
  ),
  s(
    { trig = "ac", name = "react Activity component" },
    fmt(
      [[
        <Activity mode={{{}}}>
          {}
        </Activity>
      ]],
      {
        i(2, "isVisible ? 'visible' : 'hidden'"),
        d(1, function(_, snip)
          if
            #snip.env.TM_SELECTED_TEXT == 0
            or snip.env.TM_SELECTED_TEXT == "$TM_SELECTED_TEXT"
          then
            return sn(nil, i(1, "{/* content */}"))
          else
            return sn(nil, i(1, snip.env.TM_SELECTED_TEXT))
          end
        end),
      }
    )
  ),
})

ls.filetype_extend("typescriptreact", { "javascript", "typescript" })

return snippets
