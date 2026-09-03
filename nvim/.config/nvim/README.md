# nvim

A single-file, native-first Neovim config for **Neovim 0.12+** — no plugin
manager, no LSP wrapper layers:

- **`vim.pack`** for plugins (built-in package manager)
- **`vim.lsp.config` / `vim.lsp.enable`** for servers, with per-server
  configs in `after/lsp/<name>.lua` (`:h lsp-config`)
- **treesitter** (main branch) for highlighting, indent, and folds
- **efm** + [efmls-configs] for linting and formatting

```
init.lua             everything: theme · options · keymaps · autocmds · plugins · LSP
after/lsp/           per-server LSP configs (override nvim-lspconfig defaults)
.luacheckrc          luacheck config for this repo
nvim-pack-lock.json  plugin lockfile
```

`init.lua` is organized into six sections marked with `¶` — search for `/¶`
to jump between them.

## Install

```sh
git clone <this repo> ~/.config/nvim
nvim   # vim.pack fetches plugins on first launch
```

Then install language tooling:

```vim
:MasonInstall lua-language-server stylua efm-langserver bash-language-server
  typescript-language-server vue-language-server vscode-json-language-server
  tailwindcss-language-server intelephense prettierd eslint_d fixjson
  php-cs-fixer phpstan shellcheck shfmt
```

External requirements: a [Nerd Font], `git`, `fzf` + `ripgrep` (fzf-lua),
`luacheck` (via `brew install luacheck` — the Mason package needs luarocks),
and `tmux` with [vim-tmux-navigator]'s tmux-side bindings for seamless pane
navigation. Dart/Flutter tooling provides `dartls` itself.

## Plugins

| Plugin | Role |
| --- | --- |
| [mini.nvim] (clue · diff · git) | keymap hints, git signs/hunks, blame |
| [lualine] | statusline (per-window, theme-aware) |
| [fzf-lua] | files, grep, buffers, LSP pickers |
| [nvim-tree] | file explorer |
| [nvim-treesitter] (main) | syntax, indent, folds |
| [nvim-lspconfig] + [mason] | LSP defaults + tool installer |
| [efmls-configs] | linter/formatter definitions for efm |
| [blink.cmp] (pinned to v1) | completion |
| [vim-tmux-navigator] | `<C-h/j/k/l>` across vim/tmux |

## Themes

`:Theme` opens a picker (evergarden · onedark); `:Theme <name>` switches
directly. The choice persists across sessions in `stdpath("data")/theme.txt`.

## Format on save

Saving formats the buffer via **efm only**, and only for filetypes in the
`format_on_save_ft` allowlist in `init.lua`: lua, js/jsx, ts/tsx, vue,
css/scss, html, json/jsonc, sh. **markdown, yaml, and php are deliberately
excluded** — they lint on save but format only on demand (`<leader>oi`), so
notes, workflow YAML, and Laravel files never get whole-file rewrites from a
plain `:w`. Formatting is skipped entirely in diff/mergetool sessions.

## Languages

| Language | LSP | Lint / Format (efm) |
| --- | --- | --- |
| Lua | lua_ls | luacheck · stylua |
| JS / TS / Vue | ts_ls + vue_ls (hybrid) | eslint_d · prettierd |
| PHP / Laravel (blade) | intelephense | phpstan · php-cs-fixer |
| Dart / Flutter | dartls | (dartls formats) |
| JSON / JSONC | jsonls | fixjson / prettierd |
| CSS / SCSS / HTML | tailwindcss | prettierd |
| Shell | bashls | shellcheck · shfmt |
| Markdown / YAML | — | prettierd (manual) |

## Keymaps

Leader = `Space`. mini.clue pops up hints after the leader key.

### General

| Key | Action |
| --- | --- |
| `<leader>e` | toggle file explorer |
| `<leader>c` | clear search highlight |
| `<leader>pa` | copy full file path |
| `<leader>td` | toggle diagnostics |
| `<leader>q` | diagnostics → location list |

### Movement & windows

| Key | Action |
| --- | --- |
| `j` / `k` | wrap-aware (gj/gk without a count) |
| `n` / `N` / `<C-d>` / `<C-u>` / `G` | centered after the jump |
| `<C-h/j/k/l>` | move across vim windows *and* tmux panes |
| `<leader>sv` / `<leader>sh` | vertical / horizontal split |
| `<C-arrows>` | resize window |
| `<leader>bn` / `<leader>bp` | next / previous buffer |

### Editing

| Key | Action |
| --- | --- |
| `<A-j>` / `<A-k>` | move line / selection down / up |
| `<` / `>` (visual) | indent and keep selection |
| `J` | join lines, keep cursor position |
| `<leader>p` (visual) | paste without yanking |
| `<leader>x` | delete without yanking |

### Find (fzf-lua)

| Key | Action |
| --- | --- |
| `<leader>ff` / `<leader>fg` | files / live grep |
| `<leader>fb` / `<leader>fh` | buffers / help tags |
| `<leader>fx` / `<leader>fX` | diagnostics: document / workspace |

### Git (mini.diff / mini.git)

| Key | Action |
| --- | --- |
| `]h` / `[h` | next / previous hunk |
| `<leader>hp` | toggle diff overlay |
| `<leader>hb` | blame / show at cursor |

### LSP (buffer-local, when a server attaches)

Native defaults (`K`, `grn`, `gra`, `grr`, `gri`) are kept, plus:

| Key | Action |
| --- | --- |
| `<leader>gd` / `<leader>gD` / `<leader>gS` | definition: fzf / direct / in vsplit |
| `<leader>d` / `<leader>nd` / `<leader>pd` | line diagnostics / next / previous |
| `<leader>fr` / `<leader>ft` / `<leader>fi` | references / type defs / implementations |
| `<leader>fs` / `<leader>fw` | document / workspace symbols |
| `<leader>oi` | organize imports, then format |

### Completion (insert mode, blink.cmp)

| Key | Action |
| --- | --- |
| `<C-Space>` | show / hide menu |
| `<CR>` | accept |
| `<C-j>` / `<C-k>` | next / previous item |
| `<Tab>` / `<S-Tab>` | snippet jump forward / back |

[efmls-configs]: https://github.com/creativenull/efmls-configs-nvim
[Nerd Font]: https://www.nerdfonts.com
[mini.nvim]: https://github.com/echasnovski/mini.nvim
[lualine]: https://github.com/nvim-lualine/lualine.nvim
[fzf-lua]: https://github.com/ibhagwan/fzf-lua
[nvim-tree]: https://github.com/nvim-tree/nvim-tree.lua
[nvim-treesitter]: https://github.com/nvim-treesitter/nvim-treesitter
[nvim-lspconfig]: https://github.com/neovim/nvim-lspconfig
[mason]: https://github.com/mason-org/mason.nvim
[blink.cmp]: https://github.com/saghen/blink.cmp
[vim-tmux-navigator]: https://github.com/christoomey/vim-tmux-navigator
