-- sources:
--  https://github.com/fenuks/dotfiles/blob/9306cf7c7d7b79c93881da87daf61f314a9d96b4/.config/nvim/lua/init.lua#L256
-- https://github.com/nvimdev/lspsaga.nvim/blob/a4d442896a9ff1f83ee3db965d81b659ebc977d5/lua/lspsaga/lspkind.lua#L29
-- TODO look at https://github.com/onsails/lspkind.nvim/issues/12 for more symbols

local symbols = {
  Array = '󰅨 ',
  -- Array = '',
  -- Array = '[]',
  Boolean = '⊨',
  Class = ' ',
  -- Class = '𝓒'
  -- Class = '🅒',
  Color = " ",
  -- Color = '☀',
  -- Color = '⛭',
  Constant = '𝜋',
  -- Constant = 'π',
  Constructor = '⌬',
  -- Constructor, ' ',
  -- Constructor = '⬡',
  -- Constructor = '⎔',
  -- Constructor = '⚙',
  -- Constructor = 'ᲃ',
  -- Enum = '',
  Enum = ' ',
  -- Enum = 'ℰ',
  EnumMember = ' ',
  Event = '',
  Field = "󰄶 ",
  -- Field, ' ',
  -- Field = '→',
  -- Field = '🠶',
  File = ' ',
  Folder = ' ',
  Function, '󰡱 ',
  -- Function = 'ƒ',
  -- Function = 'λ',
  Interface = ' ',
  Key = '🗝',
  Keyword = "󰌆 ",
  Macro, ' ',
  Method = '𝘮',
  -- Method = 'λ',
  Module = '󰏗 ',
  Namespace = 'ns',
  -- Namespace, ' ',
  Null, '󰟢 ',
  Number, '󰎠 ',
  Object, ' ',
  -- Object = '⦿',
  Operator = '±',
  -- Operator = '≠',
  Package, ' ',
  -- Package = '⚙',
  Property = '∴',
  -- Property = '::',
  -- Property = '∷',
  -- Property, ' '
  Reference = '⊷',
  -- Reference = '⊶',
  -- Reference = '⊸',
  Snippet, ' ',
  -- Snippet = '{}',
  -- Snippet = '',
  -- Snippet = '↲',
  -- Snippet = '♢',
  -- Snippet = '<>',
  StaticMethod, ' ',
  String, '󰅳 ',
  Struct = ' ',
  -- Struct = '',
  -- Struct = "𝓢",
  Text, '󰭷 ',
  -- Text = ' ',
  -- Text = '𝓐',
  -- Text = '♯',
  -- Text = 'ⅵ',
  -- Text = "¶",
  -- Text = "𝒯",
  -- Text = "𝓣",
  -- Text = "𐄗",
  TypeAlias, ' ',
  TypeParameter, ' ',
  -- TypeParameter = '𝜏',
  -- TypeParameter = '×',
  -- TypeParameter = "𝙏",
  -- TypeParameter = "Ŧ",
  -- TypeParameter = "T",
  Unit = '()',
  -- Unit, '󰊱 ',
  Value, ' ',
  -- Value = '󰎠 ',
  Variable = '𝛸',
  -- Variable, ' ',
  -- Variable = '𝛼',
  -- Variable = 'χ',
  -- Variable = '𝓧',
  -- Variable = 'α',
  -- Variable = '≔',

  Copilot = "",
}
-- ⊕ † ፨ ᯾ ⁂ ∎ ∹ ☖ ⚐ 🕮 🗈 🗉 🗈 🗉 ⬠  ⬡  ⮺  ⮻ ⯐  ⯒ ⟡ ✐  ✎ ꒾꙳ ꥟ ⤙ ⤚ ⤛ ⤜ 𐄂 𐄔 𐄘  𐄜 𐄝 𐄷 𐄕 𐄗  𐄎 𐅽  𐅼 𐆓 𐊌  𐊾 𐦖 𑁍
-- 🗩 🗛 🗗  🗁  🗀  🕸 ✗○◐●✓

local kinds = vim.lsp.protocol.CompletionItemKind
for i, kind in ipairs(kinds) do
  kinds[i] = symbols[kind] or kind
end

-- source: https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#completion-kinds
local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end