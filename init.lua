-- ═══════════════════════════════════════════════════════════════════════════
--
--   init.lua · a single-file Neovim config (0.12+, native-first)
--
--   vim.pack for plugins · vim.lsp for servers · treesitter for syntax
--   efm for linting & formatting · per-server configs in after/lsp/
--
--   ¶ Theme      colorschemes + :Theme picker
--   ¶ Options    editor behavior
--   ¶ Keymaps    global mappings (leader = space)
--   ¶ Autocmds   format-on-save, yank highlight, cursor restore
--   ¶ Plugins    vim.pack + per-plugin setup
--   ¶ LSP        diagnostics, formatting, completion, servers
--
--   jump to any section by searching for "¶"
--
-- ═══════════════════════════════════════════════════════════════════════════

vim.opt.termguicolors = true

-- ═══════════════════════════════════════════════════════════════════════════
-- ¶ THEME · colorschemes + :Theme picker, choice persisted across sessions
-- ═══════════════════════════════════════════════════════════════════════════

local themes = {
	evergarden = {
		spec = { src = "https://github.com/evergardentheme/nvim", name = "evergarden" },
		setup = function()
			require("evergarden").setup({
				theme = {
					variant = "fall",
					accent = "green",
				},
				editor = {
					transparent_background = false,
					sign = { color = "none" },
					float = { color = "mantle", solid_border = false },
					completion = { color = "surface0" },
				},
			})
		end,
	},
	onedark = {
		spec = { src = "https://github.com/navarasu/onedark.nvim" },
		setup = function()
			require("onedark").setup({ style = "darker" })
		end,
	},
}

-- install theme
vim.pack.add(vim.tbl_map(function(t)
	return t.spec
end, vim.tbl_values(themes)))

-- theme switching
local theme_file = vim.fn.stdpath("data") .. "/theme.txt"
local done = {}

local function apply(name, save)
	local t = themes[name]
	if t and not done[name] then
		done[name] = true
		t.setup()
	end
	local ok, err = pcall(vim.cmd.colorscheme, name)
	if not ok then
		return vim.notify(err, vim.log.levels.ERROR)
	end
	if save then
		vim.fn.writefile({ name }, theme_file)
	end
end

local function names()
	local n = vim.tbl_keys(themes)
	table.sort(n)
	return n
end

vim.api.nvim_create_user_command("Theme", function(o)
	if o.args ~= "" then
		return apply(o.args, true)
	end
	vim.ui.select(names(), { prompt = "Theme: " }, function(c)
		if c then
			apply(c, true)
		end
	end)
end, { nargs = "?", complete = names })

local saved_theme = vim.fn.filereadable(theme_file) == 1 and vim.fn.readfile(theme_file)[1] or nil
apply(saved_theme ~= nil and saved_theme ~= "" and saved_theme or "evergarden", false)

-- ═══════════════════════════════════════════════════════════════════════════
-- ¶ OPTIONS · editor behavior
-- ═══════════════════════════════════════════════════════════════════════════

-- ── lines & scrolling ──
vim.opt.number = true -- line number
vim.opt.relativenumber = true -- relative line numbers
vim.opt.cursorline = true -- highlight current line
vim.opt.wrap = false -- do not wrap lines by default
vim.opt.scrolloff = 10 -- keep 10 lines above/below cursor
vim.opt.sidescrolloff = 10 -- keep 10 lines to left/right of cursor

-- ── indentation ──
vim.opt.tabstop = 2 -- tabwidth
vim.opt.shiftwidth = 2 -- indent width
vim.opt.softtabstop = 2 -- soft tab stop not tabs on tab/backspace
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.smartindent = true -- smart auto-indent
vim.opt.autoindent = true -- copy indent from current line

-- ── search ──
vim.opt.ignorecase = true -- case insensitive search
vim.opt.smartcase = true -- case sensitive if uppercase in string
vim.opt.hlsearch = true -- highlight search matches
vim.opt.incsearch = true -- show matches as you type

-- ── ui ──
vim.opt.signcolumn = "yes" -- always show a sign column
vim.opt.showmatch = true -- highlights matching brackets
vim.opt.cmdheight = 1 -- single line command line
vim.opt.completeopt = "menuone,noinsert,noselect" -- completion options
vim.opt.showmode = false -- do not show the mode, instead have it in statusline
vim.opt.laststatus = 2 -- per-window statusline (pairs with lualine's globalstatus = false)
vim.opt.pumheight = 10 -- popup menu height
vim.opt.pumblend = 10 -- popup menu transparency
vim.opt.winblend = 0 -- floating window transparency
vim.opt.conceallevel = 2 -- obsidian requirement
vim.opt.concealcursor = "" -- do not hide cursorline in markup
vim.opt.synmaxcol = 300 -- syntax highlighting limit
vim.opt.fillchars = { eob = " " } -- hide "~" on empty lines

-- ── files, undo & timing ──
local undodir = vim.fn.expand("~/.vim/undodir")
if
	vim.fn.isdirectory(undodir) == 0 -- create undodir if nonexistent
then
	vim.fn.mkdir(undodir, "p")
end

vim.opt.backup = false -- do not create a backup file
vim.opt.writebackup = false -- do not write to a backup file
vim.opt.swapfile = false -- do not create a swapfile
vim.opt.undofile = true -- do create an undo file
vim.opt.undodir = undodir -- set the undo directory
vim.opt.updatetime = 300 -- faster completion
vim.opt.timeoutlen = 500 -- timeout duration
vim.opt.ttimeoutlen = 50 -- key code timeout
vim.opt.autoread = true -- auto-reload changes if outside of neovim
vim.opt.autowrite = false -- do not auto-save

-- ── behavior ──
vim.opt.hidden = true -- allow hidden buffers
vim.opt.errorbells = false -- no error sounds
vim.opt.backspace = "indent,eol,start" -- better backspace behaviour
vim.opt.autochdir = false -- do not autochange directories
vim.opt.iskeyword:append("-") -- include - in words
vim.opt.path:append("**") -- include subdirs in search
vim.opt.selection = "inclusive" -- include last char in selection
vim.opt.mouse = "a" -- enable mouse support
vim.opt.clipboard:append("unnamedplus") -- use system clipboard
vim.opt.modifiable = true -- allow buffer modifications

-- ── cursor ──
vim.opt.guicursor =
	"n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175" -- cursor blinking and settings

-- ── folding ──
-- expr folding via treesitter; foldlevel 99 keeps everything open on entry
vim.opt.foldmethod = "expr" -- use expression for folding
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- use treesitter for folding
vim.opt.foldlevel = 99 -- start with all folds open

-- ── splits ──
vim.opt.splitbelow = true -- horizontal splits go below
vim.opt.splitright = true -- vertical splits go right

-- ── cmdline & performance ──
vim.opt.wildmenu = true -- tab completion
vim.opt.wildmode = "longest:full,full" -- complete longest common match, full completion list, cycle through with Tab
vim.opt.diffopt:append("linematch:60") -- improve diff display
vim.opt.redrawtime = 10000 -- increase neovim redraw tolerance
vim.opt.maxmempattern = 20000 -- increase max memory

-- ═══════════════════════════════════════════════════════════════════════════
-- ¶ KEYMAPS · leader = space
-- ═══════════════════════════════════════════════════════════════════════════

vim.g.mapleader = " " -- space for leader
vim.g.maplocalleader = " " -- space for localleader

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

vim.g.tmux_navigator_no_mappings = 1 -- we define our own <C-h/j/k/l> below
vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "Move to left window/pane" })
vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "Move to bottom window/pane" })
vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "Move to top window/pane" })
vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "Move to right window/pane" })

vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- ── editing ──
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- ── utility ──
vim.keymap.set("n", "<leader>pa", function() -- show file path
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file:", path)
end, { desc = "Copy full file path" })

vim.keymap.set("n", "<leader>td", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

-- ── project tasks ──
-- Zed-style run tasks, defined per project in .tasks.lua at the project root:
--   return { { label = "Flutter: Debug Local", cmd = { "flutter", "run", ... } }, ... }
-- <leader>rt picks a task and runs it in a tmux pane beside the current one
-- (cwd = wherever .tasks.lua lives); outside tmux it falls back to a
-- :terminal in a split
local function load_project_tasks()
	local start = vim.api.nvim_buf_get_name(0)
	start = start ~= "" and vim.fs.dirname(start) or vim.fn.getcwd()
	local file = vim.fs.find(".tasks.lua", { upward = true, path = start })[1]
	if not file then
		return nil
	end
	local ok, tasks = pcall(dofile, file)
	if not ok or type(tasks) ~= "table" then
		vim.notify(".tasks.lua: " .. tostring(tasks), vim.log.levels.ERROR)
		return nil
	end
	return tasks, vim.fs.dirname(file)
end

local function run_task(task, dir)
	if vim.env.TMUX then
		local shell_cmd = table.concat(vim.tbl_map(vim.fn.shellescape, task.cmd), " ")
		-- keep the window open after exit so startup errors stay readable
		shell_cmd = shell_cmd .. '; echo "[exit $?]"; read -r _'
		vim.system({ "tmux", "split-window", "-h", "-c", dir, shell_cmd })
	else
		vim.cmd.vsplit()
		vim.fn.jobstart(task.cmd, { term = true, cwd = dir })
		vim.cmd.startinsert()
	end
end

vim.keymap.set("n", "<leader>rt", function()
	local tasks, dir = load_project_tasks()
	if not tasks or #tasks == 0 then
		return vim.notify("no .tasks.lua found in project", vim.log.levels.WARN)
	end
	vim.ui.select(tasks, {
		prompt = "Task: ",
		format_item = function(t)
			return t.label
		end,
	}, function(task)
		if task then
			run_task(task, dir)
		end
	end)
end, { desc = "Run project task" })

-- ═══════════════════════════════════════════════════════════════════════════
-- ¶ AUTOCMDS
-- ═══════════════════════════════════════════════════════════════════════════

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- ── format on save ──
-- only real file buffers, only when efm is attached, never in diff mode.
-- efm's languages table says what efm CAN format; this list says what
-- auto-formats on save (markdown/yaml/php stay manual — use <leader>oi)
local format_on_save_ft = {
	lua = true,
	javascript = true,
	javascriptreact = true,
	typescript = true,
	typescriptreact = true,
	vue = true,
	css = true,
	scss = true,
	html = true,
	json = true,
	jsonc = true,
	sh = true,
}

vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	pattern = "*",
	callback = function(args)
		if vim.o.diff then -- don't reformat files in diff/mergetool sessions
			return
		end
		if not format_on_save_ft[vim.bo[args.buf].filetype] then
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

		if #vim.lsp.get_clients({ bufnr = args.buf, name = "efm" }) == 0 then
			return
		end

		pcall(vim.lsp.buf.format, {
			bufnr = args.buf,
			timeout_ms = 2000,
			filter = function(c)
				return c.name == "efm"
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
require("fzf-lua").setup({})

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

-- ── lualine ──
-- setup re-runs on ColorScheme so the statusline follows :Theme switches
local function setup_lualine()
	require("lualine").setup({
		options = {
			theme = "auto",
			icons_enabled = true,
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			globalstatus = false, -- keep per-window active/inactive styling
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { { "branch", icon = "\u{e725}" } }, -- nf-dev-git_branch
			lualine_c = { { "filename", path = 0 } },
			lualine_x = {
				function()
					local size = vim.fn.getfsize(vim.fn.expand("%"))
					if size < 0 then
						return ""
					elseif size < 1024 then
						return size .. "B"
					elseif size < 1024 * 1024 then
						return string.format("%.1fK", size / 1024)
					else
						return string.format("%.1fM", size / 1024 / 1024)
					end
				end,
				{ "filetype", icon_only = false },
			},
			lualine_y = { "location" }, -- %l:%c equivalent
			lualine_z = { "progress" }, -- %P equivalent
		},
		inactive_sections = {
			lualine_c = { { "filename", path = 0 } },
			lualine_x = { "filetype" },
		},
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
	map("<leader>gd", function()
		require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
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
