
# VSCodium

## [Custom Snippets](/home-manager/programs/vscodium/snippets.nix)

TypeScript/ React (subsets for TypeScript without React/ JS):

```nix
let
  snippets = outputs.nixosConfigurations.dnix.config.home-manager.users.jnnk.programs.vscode.profiles.default.languageSnippets.typescriptreact;
in
builtins.listToAttrs (
  map (snippetName: {
    name = (snippets.${snippetName}).prefix;
    value = snippetName;
  }) (builtins.attrNames snippets)
)
{
  afn = "Lambda Multi-Line";
  afnl = "Lambda";
  cc = "Console Count";
  ce = "Console Error";
  ci = "Console Info";
  cl = "Console Log";
  cld = "Console Log Debug";
  cn = "React classname Prop";
  cs = "CSS Selector";
  ct = "Console Time";
  cte = "Console Time End";
  ctl = "Console Time Log";
  cw = "Console Warn";
  desa = "Destructure Array";
  deso = "Destructure Object";
  fn = "Arrow Function";
  fnl = "Arrow Function Lambda";
  fnt = "Arrow Function Inline to Return";
  fntv = "Arrow Function Inline to Return with Variable";
  int = "Interface";
  jp = "JSON Parse";
  js = "JSON Stringify";
  op = "Object Property";
  opc = "Object Property Complex";
  pr = "Promise";
  rjsfc = "React FC";
  rjsfca = "React FC Async";
  rjsfcap = "React FC Async + Props";
  rjsfcp = "React PC + Props";
  rjsfr = "React Fragment";
  si = "Interval";
  st = "Timeout";
  sty = "React style Prop";
  stym = "React style Prop Multiline";
  sx = "MUI sx Prop";
  sxm = "MUI sx Prop Multiline";
  ti = "Type Inline";
  tpf = "Type Property Function";
  ty = "Type";
  typ = "Type Property";
  ucb = "React useCallback";
  uct = "React useContext";
  uef = "React useEffect";
  uefa = "React useEffect async";
  umm = "React useMemo";
  ure = "React useRef";
  ust = "React useState";
  ustn = "React useState nullable";
}


```
