vim.opt.termguicolors = true

-- ═══════════════════════════════════════════════════════════════════════════
-- ¶ THEME
-- ═══════════════════════════════════════════════════════════════════════════

vim.pack.add({
	-- "https://github.com/navarasu/onedark.nvim",
	"https://github.com/ellisonleao/gruvbox.nvim",
})

-- require("onedark").setup({
-- 	style = "darker",
-- })

require("gruvbox").setup({ transparent_mode = true })

vim.cmd.colorscheme("gruvbox")

-- ═══════════════════════════════════════════════════════════════════════════
-- ¶ OPTIONS · editor behavior
-- ═══════════════════════════════════════════════════════════════════════════

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10

-- ── indentation ──
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- ── search ──
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = false

-- ── ui ──
vim.opt.signcolumn = "yes"
vim.opt.winborder = "rounded"
vim.opt.showmatch = true
vim.opt.cmdheight = 1
-- vim.opt.completeopt = "menuone,noinsert,noselect"
vim.opt.showmode = false
vim.opt.laststatus = 2
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.opt.winblend = 0
vim.opt.conceallevel = 0
vim.opt.synmaxcol = 300
vim.opt.fillchars = { eob = " " }

-- ── files, undo & timing ──
local undodir = vim.fn.expand("~/.vim/undodir")
if
	vim.fn.isdirectory(undodir) == 0 -- create undodir if nonexistent
then
	vim.fn.mkdir(undodir, "p")
end

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = undodir
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 50
vim.opt.autoread = true
vim.opt.autowrite = false

-- ── behavior ──
vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.backspace = "indent,eol,start"
vim.opt.autochdir = false
vim.opt.iskeyword:append("-")
vim.opt.path:append("**")
vim.opt.selection = "inclusive"
vim.opt.mouse = "a"
vim.opt.clipboard:append("unnamedplus")
vim.opt.modifiable = true

-- ── cursor ──
vim.opt.guicursor =
	"n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175" -- cursor blinking and settings

-- ── folding ──
-- expr folding via treesitter; foldlevel 99 keeps everything open on entry
vim.opt.foldmethod = "expr" -- use expression for folding
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- use treesitter for folding
vim.opt.foldlevel = 99 -- start with all folds open

-- ── splits ──
vim.opt.splitbelow = true
vim.opt.splitright = true

-- ── cmdline & performance ──
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.diffopt:append("linematch:60")
vim.opt.redrawtime = 10000
vim.opt.maxmempattern = 20000

-- ═══════════════════════════════════════════════════════════════════════════
-- ¶ KEYMAPS · leader = space
-- ═══════════════════════════════════════════════════════════════════════════

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ── movement & search ──
-- better movement in wrapped text
vim.keymap.set("n", "j", function()
	return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (wrap-aware)" })
vim.keymap.set("n", "k", function()
	return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (wrap-aware)" })

vim.keymap.set("n", "<leader>c", ":nohlsearch<CR>", { desc = "Clear search highlights" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
vim.keymap.set("n", "G", "Gzz", { desc = "Bottom of the file (centered)" })

-- ── clipboard ──
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>x", '"_d', { desc = "Delete without yanking" })

-- ── buffers, windows & tmux ──
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

vim.g.tmux_navigator_no_mappings = 1
vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "Move to left window/pane" })
vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "Move to bottom window/pane" })
vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "Move to top window/pane" })
vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "Move to right window/pane" })

vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })

-- ── editing ──
-- FIXME:
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- ── utility ──
vim.keymap.set("n", "<leader>pa", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file:", path)
end, { desc = "Copy full file path" })

-- ── project tasks ──
-- run tasks, defined per project in .tasks.lua at the project root:
--   return { { label = "Flutter: Debug Local", cmd = { "flutter", "run", ... } }, ... }
vim.keymap.set("n", "<leader>rt", function()
	local dir = vim.fs.root(0, ".tasks.lua")
	local ok, tasks = pcall(dofile, dir and vim.fs.joinpath(dir, ".tasks.lua") or "")
	if not ok or type(tasks) ~= "table" or #tasks == 0 then
		return vim.notify("no valid .tasks.lua in project", vim.log.levels.WARN)
	end
	vim.ui.select(tasks, {
		prompt = "Task: ",
		format_item = function(t)
			return t.label
		end,
	}, function(t)
		if not t then
			return
		end
		if vim.env.TMUX then
			local cmd = table.concat(vim.tbl_map(vim.fn.shellescape, t.cmd), " ")
			vim.system({ "tmux", "split-window", "-h", "-c", dir, cmd .. '; echo "[exit $?]"; read -r _' })
		else
			vim.cmd.vsplit()
			vim.fn.jobstart(t.cmd, { term = true, cwd = dir })
			vim.cmd.startinsert()
		end
	end)
end, { desc = "Run project task" })

-- ═══════════════════════════════════════════════════════════════════════════
-- ¶ AUTOCMDS
-- ═══════════════════════════════════════════════════════════════════════════

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- ── highlight on yank ──
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.hl.on_yank()
	end,
})

-- ── restore last cursor position ──
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	desc = "Restore last cursor position",
	callback = function()
		if vim.o.diff then -- except in diff mode
			return
		end

		local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
		local last_line = vim.api.nvim_buf_line_count(0)

		local row = last_pos[1]
		if row < 1 or row > last_line then
			return
		end

		pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
	end,
})

-- ── prose filetypes: wrap, linebreak, spellcheck ──
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = true
	end,
})

-- ═══════════════════════════════════════════════════════════════════════════
-- ¶ PLUGINS · vim.pack + per-plugin setup
-- ═══════════════════════════════════════════════════════════════════════════

vim.pack.add({
	"https://www.github.com/echasnovski/mini.icons",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://www.github.com/ibhagwan/fzf-lua",
	"https://www.github.com/nvim-tree/nvim-tree.lua",
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "main",
	},
	"https://github.com/sphamba/smear-cursor.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/tpope/vim-fugitive",
	-- Language Server Protocols
	"https://www.github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/creativenull/efmls-configs-nvim",
	{
		-- NOTE: blink.cmp v2 is now the actively developed branch (breaking
		-- changes vs v1). Staying pinned to v1 here deliberately for stability.
		-- Revisit this pin when ready to migrate — v2 requires installing
		-- blink.lib as a native dependency outside vim.pack.
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},
	"https://github.com/christoomey/vim-tmux-navigator",
})

-- ── nvim-treesitter ──
require("nvim-treesitter").setup()

require("nvim-treesitter").install({
	-- config & data formats you'll hit constantly
	"json",
	"yaml",
	"toml",
	"ini",
	"csv",

	-- web layer (Laravel frontend, Inertia/Vue/Blade)
	"html",
	"css",
	"scss",
	"javascript",
	"typescript",
	"tsx",
	"vue",

	-- infra / tooling
	"bash",
	"dockerfile",
	"make",
	"nginx",
	"ssh_config",
	"git_config",
	"git_rebase",
	"gitcommit",
	"gitattributes",
	"diff",

	-- rust
	"rust",

	-- docs & notes
	"markdown",
	"markdown_inline",
	"comment",
})

-- enable highlighting + treesitter indent per filetype
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	callback = function(args)
		local ft = vim.bo[args.buf].filetype
		local lang = vim.treesitter.language.get_lang(ft)
		if lang and vim.treesitter.language.add(lang) then
			vim.treesitter.start(args.buf, lang)
			vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})

-- keep parsers in sync when nvim-treesitter itself updates
vim.api.nvim_create_autocmd("PackChanged", {
	group = augroup,
	callback = function(ev)
		if ev.data.spec.name == "nvim-treesitter" and ev.data.kind ~= "delete" then
			require("nvim-treesitter").update()
		end
	end,
})

-- ── mini.icons ──
local mini_icons = require("mini.icons")
mini_icons.setup({})
mini_icons.mock_nvim_web_devicons()

-- ── nvim-tree ──
require("nvim-tree").setup({
	view = {
		width = 35,
	},
	filters = {
		dotfiles = false,
	},
	renderer = {
		group_empty = true,
	},
})
vim.keymap.set("n", "<leader>e", function()
	require("nvim-tree.api").tree.toggle()
end, { desc = "Toggle NvimTree" })

-- ── fzf-lua ──
require("fzf-lua").setup({
	grep = {
		rg_opts = "--fixed-strings --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
	},
})

vim.keymap.set("n", "<leader>ff", function()
	require("fzf-lua").files()
end, { desc = "FZF Files" })
vim.keymap.set("n", "<leader>fg", function()
	require("fzf-lua").live_grep()
end, { desc = "FZF Live Grep" })
vim.keymap.set("n", "<leader>fb", function()
	require("fzf-lua").buffers()
end, { desc = "FZF Buffers" })
vim.keymap.set("n", "<leader>fh", function()
	require("fzf-lua").help_tags()
end, { desc = "FZF Help Tags" })
vim.keymap.set("n", "<leader>fx", function()
	require("fzf-lua").diagnostics_document()
end, { desc = "FZF Diagnostics Document" })
vim.keymap.set("n", "<leader>fX", function()
	require("fzf-lua").diagnostics_workspace()
end, { desc = "FZF Diagnostics Workspace" })

-- ── gitsigns (hunk signs · hunk actions · inline blame) ──
require("gitsigns").setup({
	current_line_blame = true,
	on_attach = function(bufnr)
		local gs = require("gitsigns")
		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
		end

		map("n", "<leader>j", function()
			gs.nav_hunk("next")
		end, "Next git hunk")
		map("n", "<leader>k", function()
			gs.nav_hunk("prev")
		end, "Prev git hunk")

		map("n", "<leader>h", function()
			gs.preview_hunk_inline()
		end, "Preview hunk inline")
	end,
})

-- ── smear-cursor ──
require("smear_cursor").setup({
	cursor_color = "#d3cdc3",
	stiffness = 0.8,
	trailing_stiffness = 0.6,
	stiffness_insert_mode = 0.7,
	trailing_stiffness_insert_mode = 0.7,
	damping = 0.95,
	damping_insert_mode = 0.95,
	distance_stop_animating = 0.5,
})

-- ── lualine ──
require("lualine").setup({
	options = {
		component_separators = "",
		section_separators = { left = "\u{e0b4}", right = "\u{e0b6}" },
		globalstatus = false,
	},
	sections = {
		lualine_a = { { "mode", separator = { left = "\u{e0b6}" }, right_padding = 2 } },
		lualine_b = { { "branch", icon = "\u{e725}" }, { "filename", path = 1 } },
		lualine_c = {
			"%=",
		},
		lualine_x = {},
		lualine_y = { "filesize", "filetype", "progress" },
		lualine_z = {
			{ "location", separator = { right = "\u{e0b4}" }, left_padding = 2 },
		},
	},
	inactive_sections = {
		lualine_a = { { "filename", path = 1 } },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = { "location" },
	},
	tabline = {},
	extensions = {},
})

-- ── mason ──
require("mason").setup({})

-- ═══════════════════════════════════════════════════════════════════════════
-- ¶ LSP · diagnostics, formatting, completion, servers
-- ═══════════════════════════════════════════════════════════════════════════

-- ── diagnostics ──
vim.diagnostic.config({
	virtual_text = { prefix = "●", spacing = 4 },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "\u{f057} ",
			[vim.diagnostic.severity.WARN] = "\u{f071} ",
			[vim.diagnostic.severity.INFO] = "\u{f05a} ",
			[vim.diagnostic.severity.HINT] = "\u{ea61} ",
		},
	},
	severity_sort = true,
	float = { source = true, header = "", prefix = "", focusable = false },
})

vim.keymap.set("n", "<leader>ih", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, { desc = "Toggle inlay hints" })

-- ── formatting ──
-- efm formats everything it's configured for (after/lsp/efm.lua); dartls and
-- rust_analyzer format their own language. markdown/yaml/php are never
-- formatted on save
local formatters = { efm = true, dartls = true, rust_analyzer = true }
local manual_format_ft = { markdown = true, yaml = true, php = true }

-- ── on attach: buffer-local keymaps & format on save ──
vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
		local bufnr = ev.buf
		local fzf = require("fzf-lua")
		local function map(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
		end

		map("gd", function()
			fzf.lsp_definitions({ jump1 = true })
		end, "Go to definition (fzf)")
		map("grr", function()
			fzf.lsp_references({ jump1 = true })
		end, "References (fzf)")

		if formatters[client.name] and not manual_format_ft[vim.bo[bufnr].filetype] then
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					if vim.o.diff or not vim.lsp.buf_is_attached(bufnr, client.id) then
						return
					end
					vim.lsp.buf.format({ bufnr = bufnr, id = client.id, timeout_ms = 2000 })
				end,
			})
		end
	end,
})

-- ── completion (blink.cmp) ──
require("blink.cmp").setup({
	keymap = {
		preset = "none",
		["<C-Space>"] = { "show", "hide" },
		["<CR>"] = { "accept", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<C-k>"] = { "select_prev", "fallback" },
		["<Tab>"] = { "snippet_forward", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "fallback" },
	},
	completion = {
		menu = {
			auto_show = function()
				return vim.bo.filetype ~= "markdown"
			end,
		},
	},
	signature = { enabled = true },
	fuzzy = { implementation = "prefer_rust" },
})

-- ── servers ──
-- per-server configs live in after/lsp/<name>.lua and override the defaults
-- shipped by nvim-lspconfig (:h lsp-config-merge)
vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

vim.lsp.enable({
	"lua_ls",
	"ts_ls",
	"vue_ls",
	"intelephense",
	"dartls",
	"rust_analyzer",
	"jsonls",
	"tailwindcss",
	"efm",
})
