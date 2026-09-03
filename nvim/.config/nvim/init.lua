vim.opt.termguicolors = true

-- ═══════════════════════════════════════════════════════════════════════════
-- ¶ THEME
-- ═══════════════════════════════════════════════════════════════════════════

vim.pack.add({
	"https://github.com/navarasu/onedark.nvim",
	"https://github.com/ellisonleao/gruvbox.nvim",
})

require("onedark").setup({
	style = "darker",
})

vim.cmd.colorscheme("onedark")

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
vim.opt.showmatch = true
vim.opt.cmdheight = 1
vim.opt.completeopt = "menuone,noinsert,noselect"
vim.opt.showmode = false
vim.opt.laststatus = 2
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.opt.winblend = 0
vim.opt.conceallevel = 2
vim.opt.concealcursor = ""
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

-- TODO: ?
vim.keymap.set("n", "<leader>td", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

-- ── project tasks ──
-- run tasks, defined per project in .tasks.lua at the project root:
--   return { { label = "Flutter: Debug Local", cmd = { "flutter", "run", ... } }, ... }
-- local function load_project_tasks()
-- 	local start = vim.api.nvim_buf_get_name(0)
-- 	start = start ~= "" and vim.fs.dirname(start) or vim.fn.getcwd()
-- 	local file = vim.fs.find(".tasks.lua", { upward = true, path = start })[1]
-- 	if not file then
-- 		return nil
-- 	end
-- 	local ok, tasks = pcall(dofile, file)
-- 	if not ok or type(tasks) ~= "table" then
-- 		vim.notify(".tasks.lua: " .. tostring(tasks), vim.log.levels.ERROR)
-- 		return nil
-- 	end
-- 	return tasks, vim.fs.dirname(file)
-- end
--
-- local function run_task(task, dir)
-- 	if vim.env.TMUX then
-- 		local shell_cmd = table.concat(vim.tbl_map(vim.fn.shellescape, task.cmd), " ")
-- 		-- keep the window open after exit so startup errors stay readable
-- 		shell_cmd = shell_cmd .. '; echo "[exit $?]"; read -r _'
-- 		vim.system({ "tmux", "split-window", "-h", "-c", dir, shell_cmd })
-- 	else
-- 		vim.cmd.vsplit()
-- 		vim.fn.jobstart(task.cmd, { term = true, cwd = dir })
-- 		vim.cmd.startinsert()
-- 	end
-- end
--
-- vim.keymap.set("n", "<leader>rt", function()
-- 	local tasks, dir = load_project_tasks()
-- 	if not tasks or #tasks == 0 then
-- 		return vim.notify("no .tasks.lua found in project", vim.log.levels.WARN)
-- 	end
-- 	vim.ui.select(tasks, {
-- 		prompt = "Task: ",
-- 		format_item = function(t)
-- 			return t.label
-- 		end,
-- 	}, function(task)
-- 		if task then
-- 			run_task(task, dir)
-- 		end
-- 	end)
-- end, { desc = "Run project task" })

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

-- ── format on save ──
-- only real file buffers, only when the mapped client is attached, never in
-- diff mode. filetype → LSP client that formats it: efm for most languages,
-- dartls for dart (efm has no dart config; dartls runs `dart format`).
-- markdown/yaml/php stay manual — use <leader>oi
local format_on_save_ft = {
	lua = "efm",
	javascript = "efm",
	javascriptreact = "efm",
	typescript = "efm",
	typescriptreact = "efm",
	vue = "efm",
	css = "efm",
	scss = "efm",
	html = "efm",
	json = "efm",
	jsonc = "efm",
	sh = "efm",
	dart = "dartls",
}

vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	pattern = "*",
	callback = function(args)
		if vim.o.diff then -- don't reformat files in diff/mergetool sessions
			return
		end
		local client_name = format_on_save_ft[vim.bo[args.buf].filetype]
		if not client_name then
			return
		end
		-- avoid formatting non-file buffers (helps prevent weird write prompts)
		if vim.bo[args.buf].buftype ~= "" then
			return
		end
		if not vim.bo[args.buf].modifiable then
			return
		end
		if vim.api.nvim_buf_get_name(args.buf) == "" then
			return
		end

		if #vim.lsp.get_clients({ bufnr = args.buf, name = client_name }) == 0 then
			return
		end

		pcall(vim.lsp.buf.format, {
			bufnr = args.buf,
			timeout_ms = 2000,
			filter = function(c)
				return c.name == client_name
			end,
		})
	end,
})

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
	"https://www.github.com/echasnovski/mini.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://www.github.com/ibhagwan/fzf-lua",
	"https://www.github.com/nvim-tree/nvim-tree.lua",
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "main",
	},
	"https://github.com/sphamba/smear-cursor.nvim",
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
vim.keymap.set("n", "<leader>gs", function()
	require("fzf-lua").git_status()
end, { desc = "FZF Git Status" })

-- ── mini.nvim (clue · diff · git) ──
require("mini.clue").setup({
	triggers = {
		{ mode = "n", keys = "<Leader>" },
		{ mode = "x", keys = "<Leader>" },
		{ mode = "n", keys = "g" },
		{ mode = "n", keys = "[" },
		{ mode = "n", keys = "]" },
	},
	clues = {
		require("mini.clue").gen_clues.builtin_completion(),
	},
})

require("mini.diff").setup({
	view = {
		style = "sign",
		signs = { add = "▎", change = "▎", delete = "▎" },
	},
})

require("mini.git").setup({})

local MiniDiff = require("mini.diff")

vim.keymap.set("n", "]h", function()
	MiniDiff.goto_hunk("next")
end, { desc = "Next git hunk" })

vim.keymap.set("n", "[h", function()
	MiniDiff.goto_hunk("prev")
end, { desc = "Prev git hunk" })

vim.keymap.set("n", "<leader>hp", function()
	MiniDiff.toggle_overlay()
end, { desc = "Preview diff overlay" })

vim.keymap.set("n", "<leader>hb", function()
	require("mini.git").show_at_cursor()
end, { desc = "Git blame/show" })

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
local function setup_lualine()
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
end

setup_lualine()
vim.api.nvim_create_autocmd("ColorScheme", { callback = setup_lualine })

-- ── mason ──
require("mason").setup({})

-- ═══════════════════════════════════════════════════════════════════════════
-- ¶ LSP · diagnostics, formatting, completion, servers
-- ═══════════════════════════════════════════════════════════════════════════

local lsp_augroup = vim.api.nvim_create_augroup("UserLsp", { clear = true })

vim.o.winborder = "rounded" -- replaces the open_floating_preview patch

-- blade files aren't detected by default
vim.filetype.add({ pattern = { [".*%.blade%.php"] = "blade" } })

-- ── diagnostics ──
local diagnostic_signs = {
	Error = "\u{f057} ",
	Warn = "\u{f071} ",
	Hint = "\u{ea61} ",
	Info = "\u{f05a} ",
}

vim.diagnostic.config({
	virtual_text = { prefix = "●", spacing = 4 },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
			[vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
			[vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
			[vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		source = true,
		header = "",
		prefix = "",
		focusable = false,
		style = "minimal",
	},
})

-- ── organize imports & format (<leader>oi) ──
-- synchronous on purpose: the code action must land before formatting runs
local function organize_then_format(bufnr)
	local params = vim.lsp.util.make_range_params(0, "utf-16")
	params.context = { only = { "source.organizeImports" }, diagnostics = {} }

	local results = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 2000)
	for client_id, res in pairs(results or {}) do
		local client = vim.lsp.get_client_by_id(client_id)
		for _, action in pairs(res.result or {}) do
			if action.edit and client then
				vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
			elseif action.command and client then
				client:exec_cmd(action.command, { bufnr = bufnr })
			end
		end
	end

	-- prefer efm (matches format-on-save); fall back to any client (e.g. dartls)
	local has_efm = #vim.lsp.get_clients({ bufnr = bufnr, name = "efm" }) > 0
	vim.lsp.buf.format({
		bufnr = bufnr,
		timeout_ms = 2000,
		filter = function(c)
			return not has_efm or c.name == "efm"
		end,
	})
end

-- ── buffer-local keymaps, registered on attach ──
local function lsp_on_attach(ev)
	local client = vim.lsp.get_client_by_id(ev.data.client_id)
	if not client then
		return
	end

	local bufnr = ev.buf
	local function map(lhs, rhs, desc)
		vim.keymap.set("n", lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
	end

	-- K, grn, gra, grr, gri are Neovim defaults — not remapped here
	map("gd", function()
		require("fzf-lua").lsp_definitions({ jump1 = true })
	end, "Go to definition (fzf)")
	map("<leader>gd", function()
		require("fzf-lua").lsp_definitions({ jump1 = true })
	end, "Go to definition (fzf)")
	map("<leader>gD", vim.lsp.buf.definition, "Go to definition")
	map("<leader>gS", function()
		vim.cmd("vsplit")
		vim.lsp.buf.definition()
	end, "Go to definition (vsplit)")

	map("<leader>d", function()
		vim.diagnostic.open_float({ scope = "line" })
	end, "Line diagnostics")
	map("<leader>nd", function()
		vim.diagnostic.jump({ count = 1, float = true })
	end, "Next diagnostic")
	map("<leader>pd", function()
		vim.diagnostic.jump({ count = -1, float = true })
	end, "Previous diagnostic")

	map("<leader>fr", function()
		require("fzf-lua").lsp_references()
	end, "FZF LSP references")
	map("<leader>ft", function()
		require("fzf-lua").lsp_typedefs()
	end, "FZF LSP type definitions")
	map("<leader>fs", function()
		require("fzf-lua").lsp_document_symbols()
	end, "FZF document symbols")
	map("<leader>fw", function()
		require("fzf-lua").lsp_workspace_symbols()
	end, "FZF workspace symbols")
	map("<leader>fi", function()
		require("fzf-lua").lsp_implementations()
	end, "FZF LSP implementations")

	if client:supports_method("textDocument/inlayHint", bufnr) then
		map("<leader>ih", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
		end, "Toggle inlay hints")
	end

	if client:supports_method("textDocument/codeAction", bufnr) then
		map("<leader>oi", function()
			organize_then_format(bufnr)
		end, "Organize imports & format")
	end
end

vim.api.nvim_create_autocmd("LspAttach", { group = lsp_augroup, callback = lsp_on_attach })

vim.keymap.set("n", "<leader>q", function()
	vim.diagnostic.setloclist({ open = true })
end, { desc = "Open diagnostic list" })

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
	appearance = { nerd_font_variant = "mono" },
	completion = {
		menu = {
			auto_show = function()
				return vim.bo.filetype ~= "markdown"
			end,
		},
	},
	signature = { enabled = true },
	sources = { default = { "lsp", "path", "buffer", "snippets" } },
	fuzzy = {
		implementation = "prefer_rust",
		prebuilt_binaries = { download = true },
	},
})

vim.lsp.config["*"] = {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
}

-- ── servers ──
-- per-server configs live in after/lsp/<name>.lua (:h lsp-config) — "after"
-- so they win over nvim-lspconfig's bundled lsp/ files, which come later in
-- 'runtimepath' and would otherwise take precedence on conflicting keys like
-- filetypes. Servers without a file there run on nvim-lspconfig defaults.
vim.lsp.enable({
	"lua_ls",
	"vue_ls",
	"ts_ls",
	"intelephense",
	"dartls",
	"bashls",
	"jsonls",
	"tailwindcss",
	"efm",
})
