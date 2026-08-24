-- Vue / Nuxt / TS — hybrid mode: vue_ls handles .vue, ts_ls does the TS work
local vue_plugin = vim.fn.expand("$MASON/packages/vue-language-server/node_modules/@vue/language-server")

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
}
