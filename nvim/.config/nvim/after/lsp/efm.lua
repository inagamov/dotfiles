-- efm — linters & formatters
local luacheck = require("efmls-configs.linters.luacheck")
local stylua = require("efmls-configs.formatters.stylua")
local prettier_d = require("efmls-configs.formatters.prettier_d")
local fixjson = require("efmls-configs.formatters.fixjson")
local shellcheck = require("efmls-configs.linters.shellcheck")
local shfmt = require("efmls-configs.formatters.shfmt")
local php_cs_fixer = require("efmls-configs.formatters.php_cs_fixer")
local phpstan = require("efmls-configs.linters.phpstan")

-- eslint_d only in projects that actually have an eslint config (the bundled
-- linter also roots on package.json, which would fire in every node project).
-- The fixer is chained AFTER prettier_d so project eslint style rules
-- (e.g. vue/* formatting rules) win over prettier defaults.
local eslint_markers = {
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
}
local function eslint_d(kind)
	return vim.tbl_extend("force", require("efmls-configs." .. kind .. ".eslint_d"), {
		rootMarkers = eslint_markers,
		requireMarker = true,
	})
end
local js = { eslint_d("linters"), prettier_d, eslint_d("formatters") }

local languages = {
	css = { prettier_d },
	html = { prettier_d },
	javascript = js,
	javascriptreact = js,
	json = { fixjson },
	jsonc = { prettier_d }, -- fixjson strips comments; prettier keeps them
	lua = { luacheck, stylua },
	markdown = { prettier_d },
	php = { php_cs_fixer, phpstan },
	scss = { prettier_d },
	sh = { shellcheck, shfmt },
	typescript = js,
	typescriptreact = js,
	vue = js,
	yaml = { prettier_d },
}

return {
	filetypes = vim.tbl_keys(languages),
	init_options = { documentFormatting = true },
	settings = { languages = languages },
}
