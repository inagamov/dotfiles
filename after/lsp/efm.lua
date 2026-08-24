-- efm — linters & formatters
local luacheck = require("efmls-configs.linters.luacheck")
local stylua = require("efmls-configs.formatters.stylua")

local prettier_d = require("efmls-configs.formatters.prettier_d")
local eslint_d = require("efmls-configs.linters.eslint_d")

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
			javascript = { eslint_d, prettier_d },
			javascriptreact = { eslint_d, prettier_d },
			json = { fixjson },
			-- fixjson strips // and /* */ comments; prettier keeps them
			jsonc = { prettier_d },
			lua = { luacheck, stylua },
			markdown = { prettier_d },
			php = { php_cs_fixer, phpstan },
			scss = { prettier_d },
			sh = { shellcheck, shfmt },
			typescript = { eslint_d, prettier_d },
			typescriptreact = { eslint_d, prettier_d },
			vue = { eslint_d, prettier_d },
			yaml = { prettier_d },
		},
	},
}
