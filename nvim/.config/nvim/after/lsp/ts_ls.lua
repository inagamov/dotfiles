-- Vue / Nuxt / TS — hybrid mode: vue_ls handles .vue, ts_ls does the TS work
local vue_plugin = vim.fn.expand("$MASON/packages/vue-language-server/node_modules/@vue/language-server")

-- inlay hints are off until requested per category. "literals" only names
-- parameters for literal arguments (f(1, true)), the case where it helps most
local inlay_hints = {
	includeInlayParameterNameHints = "literals",
	includeInlayVariableTypeHints = true,
	includeInlayPropertyDeclarationTypeHints = true,
	includeInlayFunctionLikeReturnTypeHints = true,
	includeInlayEnumMemberValueHints = true,
}

return {
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
	},
	init_options = {
		plugins = {
			{
				name = "@vue/typescript-plugin",
				location = vue_plugin,
				languages = { "vue" },
			},
		},
	},
	settings = {
		typescript = { inlayHints = inlay_hints },
		javascript = { inlayHints = inlay_hints },
	},
}
