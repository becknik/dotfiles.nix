{ lib, ... }:

{
  # TODO draw inspo from
  # https://marketplace.visualstudio.com/items?itemName=NicholasHsiang.vscode-javascript-snippet
  # https://marketplace.visualstudio.com/items?itemName=burkeholland.simple-react-snippets
  # (https://github.com/r5n-labs/vscode-react-javascript-snippets/blob/master/docs/Snippets.md)

  # Reference:
  # https://code.visualstudio.com/docs/editor/userdefinedsnippets#_snippet-syntax
  programs.vscode.languageSnippets =
    let
      debugEmojis = {
        debug = { emoji = "🔍"; log = [ "log" "info" ]; };
        bug = { emoji = "🐞"; log = [ "log" ]; };
        worm = { emoji = "🐛"; log = [ "log" ]; };
        slow = { emoji = "🐢"; log = [ "log" ]; };
        fast = { emoji = "⚡"; log = [ "log" ]; };

        "oh god" = { emoji = "🤦"; log = [ "log" ]; };
        "why" = { emoji = "🤷"; log = [ "log" ]; };
        "stop it" = { emoji = "🙅"; log = [ "log" ]; };
        alien = { emoji = "👾️"; log = [ "log" ]; };
        popcorn = { emoji = "🍿"; log = [ "log" ]; };
        robot = { emoji = "🤖"; log = [ "log" ]; };
        "brain.exe" = { emoji = "🧠"; log = [ "log" ]; };
        monkey = { emoji = "🐒"; log = [ "log" ]; };

        input = { emoji = "🎛️"; log = [ "log" "info" ]; };
        init = { emoji = "🚀"; log = [ "log" "info" ]; };

        success = { emoji = "✅"; log = [ "info" ]; };
        info = { emoji = "ℹ️"; log = [ "info" ]; };
        config = { emoji = "⚙️"; log = [ "info" ]; };

        warning = { emoji = "⚠️"; log = [ "log" "warn" ]; };
        caution = { emoji = "🔶"; log = [ "warn" ]; };

        error = { emoji = "❌"; log = [ "error" ]; };
        explosion = { emoji = "💥"; log = [ "error" "log" ]; };
        alarm = { emoji = "🚨"; log = [ "error" "log" ]; };
      };
      debugEmojiList = lib.attrsets.mapAttrsToList (name: value: { name = name; } // value) debugEmojis;
      debugEmojiListLog = builtins.foldl'
        (acc1: emoji: acc1 ++ (
          builtins.foldl'
            (acc2: logl: acc2 ++ [{
              name = logl;
              value = {
                name = emoji.name;
                emoji = emoji.emoji;
              };
            }]) [ ]
            emoji.log
        )) [ ]
        debugEmojiList;

      debugEmojiGroupedByLog = builtins.foldl'
        (
          acc: e:
            if (builtins.hasAttr e.name acc) then
              acc // { "${e.name}" = (builtins.getAttr e.name acc) ++ [ e.value ]; }
            else acc // { "${e.name}" = [ e.value ]; }
        )
        { }
        debugEmojiListLog;

      debugEmojiStringsByLog = builtins.mapAttrs
        (name: emojis: (
          builtins.foldl'
            (acc: emoji: acc + ",${emoji.emoji} ${emoji.name} ") " "
            emojis
        ))
        debugEmojiGroupedByLog;

      jsArrayFunctions = "map,filter,some,every,reduce,forEach,find,findIndex,sort";
      js = {
        # Console
        "Console Log" = {
          prefix = "cl";
          body = [ "console.log('\${2|${debugEmojiStringsByLog.log}|}', $1)" ];
        };
        "Console Log Debug" = {
          prefix = "cld";
          body = [ "console.log('\${2|${debugEmojiStringsByLog.log}|}' + \${1/(.*)/'$1:'/}, $1)" ];
        };
        "Console Info" = {
          prefix = "ci";
          body = [ " console.info('\${2|${debugEmojiStringsByLog.info}|}$0', $1)" ];
        };
        "Console Warn" = {
          prefix = "cw";
          body = [ "console.warn('\${2|${debugEmojiStringsByLog.warn}|}'$0, $1)" ];
        };
        "Console Error" = {
          prefix = "ce";
          body = [ "console.error('\${2|${debugEmojiStringsByLog.error}|}$0', $1)" ];
        };
        "Console Count" = {
          prefix = "cc";
          body = [ "console.count($1)" ];
        };
        "Console Time" = {
          prefix = "ct";
          body = [ "console.time($1)" ];
        };
        "Console Time Log" = {
          prefix = "ctl";
          body = [ "console.timeLog($1)" ];
        };
        "Console Time End" = {
          prefix = "cte";
          body = [ "console.timeEnd($1)" ];
        };

        # Destructuring
        "Destructure Object" = {
          prefix = "deso";
          body = [ "const { $2 } = $1;" ];
        };
        "Destructure Array" = {
          prefix = "desa";
          body = [ "const [ $2 ] = $1;" ];
        };

        # CSS
        "CSS Selector" = {
          prefix = "cs";
          body = [
            ''
              "''\${1:&}''${2| > , , + , ~ |}''${3:div}": {
                $0
              },''
          ];
        };

        # Object properties
        "Object Property" = {
          prefix = "op";
          body = [ ''$1: "$2",'' ];
        };
        "Object Property Complex" = {
          prefix = "opc";
          body = [ "$1: { $0 }," ];
        };

        # Functions
        "Arrow Function Lambda" = {
          prefix = "fnl";
          body = [ "(\${1:items}) => $2" ];
        };
        "Arrow Function" = {
          prefix = "fn";
          body = [
            ''
              (''${1:items}) => {
                $0
              }''
          ];
        };
        "Arrow Function Inline to Return" = {
          prefix = "fnt";
          body = [
            ''
              {
                $TM_SELECTED_TEXT
                return $0;
              }''
          ];
        };
        "Arrow Function Inline to Return with Variable" = {
          prefix = "fntv";
          body = [
            ''
              {
                const ''${1:tmp} = $1
                $TM_SELECTED_TEXT
                return ''${1};
              }''
          ];
        };
        # Function for Arrays
        "Lambda" = {
          prefix = "afnl";
          body = [ "\${1|${jsArrayFunctions}|}((\${2:item}, i) => $3)" ];
        };
        "Lambda Multi-Line" = {
          prefix = "afn";
          body = [
            ''
              ''${1|${jsArrayFunctions}|}((''${2:item}, i) => {
                $0
              })''
          ];
        };
        # Promises
        "Promise" = {
          prefix = "pr";
          body = [
            ''
              new Promise((resolve, reject) => {
                $0
              })''
          ];
        };

        # JSON
        "JSON Parse" = {
          prefix = "jp";
          body = [ "JSON.parse(\${1:obj});" ];
        };
        "JSON Stringify" = {
          prefix = "js";
          body = [ "JSON.stringify(\${1:obj});" ];
        };

        # Interval / Timeout
        "Interval" = {
          prefix = "si";
          body = [
            ''
              setInterval(() => {
                $0
              }, ''${1:1000});''
          ];
        };
        "Timeout" = {
          prefix = "st";
          body = [
            ''
              setTimeout(() => {
                $0
              }, ''${1:5000});''
          ];
        };
      };

      ts = js // {
        "Interface" = {
          prefix = "int";
          body = [
            ''
              interface $1 {
                $2
              }''
          ];
        };
        "Type Inline" = {
          prefix = "ti";
          body = [ "type \$1 = $2;" ];
        };
        "Type" = {
          prefix = "ty";
          body = [
            ''
              type $1 = {
                $2
              };''
          ];
        };
        "Type Property" = {
          prefix = "typ";
          body = [
            "\${1:prop}: \${2:type};"
          ];
        };
        "Type Property Function" = {
          prefix = "tpf";
          body = [
            "\${1:func}: (\${2:args}) => \${3:void};"
          ];
        };
      };

      reactHooks = {
        "React useState" = {
          prefix = "ust";
          # Source: https://dev.to/arkfuldodger/transforming-vs-code-snippets-4jcc
          body = [ "const [$1, set\${1/(.*)/\${1:/capitalize}/}] = useState<\${2:unknown}>($3);" ];
        };
        "React useState nullable" = {
          prefix = "ustn";
          body = [ "const [$1, set\${1/(.*)/\${1:/capitalize}/}] = useState<\${2:unknown} | null>(\${3:null});" ];
        };
        "React useRef" = {
          prefix = "ure";
          # TODO add conditional <> to useRef snippet
          body = [ ''const ''${1:ref} = useRef(''${2:null});'' ];
        };
        "React useEffect" = {
          prefix = "uef";
          body = [
            ''
              useEffect(() => {
                $1
              }, [$2]);''
          ];
        };
        "React useEffect async" = {
          prefix = "uefa";
          body = [
            ''
              useEffect(() => {
                ''${1:fetchSomething}($2);

                async function $1($2) {
                  $3
                }
              }, [$4]);''
          ];
        };
        "React useCallback" = {
          prefix = "ucb";
          body = [
            ''
              const ''${1:callback} = useCallback(($2) => {
                $3
              }, [$4]);''
          ];
        };
        "React useMemo" = {
          prefix = "umm";
          body = [
            ''
              const ''${1:memo} = useMemo(() => {
                $2
              }, [$3]);''
          ];
        };
        "React useContext" = {
          prefix = "uct";
          body = [ "const \${1:context} = useContext($2);" ];
        };
      };

      # React Function Components
      reactFC = {
        "React FC" = {
          prefix = "rjsfc";
          body = [
            ''
              const ''${1:$TM_FILENAME_BASE} = ({$2}) => {
                return $0;
              };

              export default $1;
            ''
          ];
        };
        "React FC Async" = {
          prefix = "rjsfca";
          body = [
            ''
              const ''${1:$TM_FILENAME_BASE} = async () => {
                return $0;
              };

              export default $1;
            ''
          ];
        };
      };
      propRemovalRegex = "\${1/:.*$(\n\s*)?/, /gm}";
      reactFCTs = reactFC // {
        "React FC Async + Props" = {
          prefix = "rjsfcap";
          body = [
            ''
              interface Props {
                $1
              }

              const ''${2:$TM_FILENAME_BASE} = async ({ ${propRemovalRegex} }: Props) => {
                return $0;
              };

              export default $2;
            ''
          ];
        };
        "React PC + Props" = {
          prefix = "rjsfcp";
          body = [
            ''
              interface Props {
                $1
              }

              const ''${2:$TM_FILENAME_BASE} = ({ ${propRemovalRegex} }: Props) => {
                return $0;
              };

              export default $2;
            ''
          ];
        };
      };

      # React Props and Stuff
      reactEtc = {
        "React Fragment" = {
          prefix = "rjsfr";
          body = [
            ''
              <>
                $TM_SELECTED_TEXT
              </>
            ''
          ];
        };
        "React classname Prop" = {
          prefix = "cn";
          body = [ "className=\"$1\"" ];
        };
        "React style Prop" = {
          prefix = "sty";
          body = [ "style={{ $1 }}" ];
        };
        "React style Prop Multiline" = {
          prefix = "stym";
          body = [
            ''
              style={{
                $1
              }}''
          ];
        };
        "MUI sx Prop" = {
          prefix = "sx";
          body = [ "sx={{ $1 }}" ];
        };
        "MUI sx Prop Multiline" = {
          prefix = "sxm";
          body = [
            ''
              sx={{
                $1
              }}''
          ];
        };
      };
    in
    {
      javascript = js;
      typescript = ts;
      javascriptreact = js // reactHooks // reactFC // reactEtc;
      typescriptreact = ts // reactHooks // reactFCTs // reactEtc;
    };
}
