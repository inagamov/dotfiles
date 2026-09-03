-- efm — linters & formatters
local luacheck = require("efmls-configs.linters.luacheck")
local stylua = require("efmls-configs.formatters.stylua")

local prettier_d = require("efmls-configs.formatters.prettier_d")
local eslint_d = require("efmls-configs.linters.eslint_d")

-- eslint --fix as a formatter, chained AFTER prettier_d so project eslint
-- style rules (e.g. vue/* formatting rules) win over prettier defaults.
-- requireMarker: only runs in projects that actually have an eslint config.
local eslint_d_fix = vim.tbl_extend("force", require("efmls-configs.formatters.eslint_d"), {
	rootMarkers = {
		".eslintrc",
		".eslintrc.js",
		".eslintrc.cjs",
		".eslintrc.json",
		".eslintrc.yaml",
		".eslintrc.yml",
		"eslint.config.js",
		"eslint.config.mjs",
		"eslint.config.cjs",
		"eslint.config.ts",
	},
	requireMarker = true,
})

local fixjson = require("efmls-configs.formatters.fixjson")

local shellcheck = require("efmls-configs.linters.shellcheck")
local shfmt = require("efmls-configs.formatters.shfmt")

local php_cs_fixer = require("efmls-configs.formatters.php_cs_fixer")
local phpstan = require("efmls-configs.linters.phpstan")

return {
	filetypes = {
		"css",
		"html",
		"javascript",
		"javascriptreact",
		"json",
		"jsonc",
		"lua",
		"markdown",
		"php",
		"scss",
		"sh",
		"typescript",
		"typescriptreact",
		"vue",
		"yaml",
	},
	init_options = { documentFormatting = true },
	settings = {
		languages = {
			css = { prettier_d },
			html = { prettier_d },
			javascript = { eslint_d, prettier_d, eslint_d_fix },
			javascriptreact = { eslint_d, prettier_d, eslint_d_fix },
			json = { fixjson },
			-- fixjson strips // and /* */ comments; prettier keeps them
			jsonc = { prettier_d },
			lua = { luacheck, stylua },
			markdown = { prettier_d },
			php = { php_cs_fixer, phpstan },
			scss = { prettier_d },
			sh = { shellcheck, shfmt },
			typescript = { eslint_d, prettier_d, eslint_d_fix },
			typescriptreact = { eslint_d, prettier_d, eslint_d_fix },
			vue = { eslint_d, prettier_d, eslint_d_fix },
			yaml = { prettier_d },
		},
	},
}
