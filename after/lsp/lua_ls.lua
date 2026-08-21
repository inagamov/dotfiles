return {
	-- nvim-lspconfig's default markers end with ".git", which makes a stray
	-- .lua file inside a big non-Lua repo index the entire repo. Only root on
	-- real Lua-project markers; otherwise lua_ls runs in single-file mode.
	root_markers = {
		{ ".emmyrc.json", ".luarc.json", ".luarc.jsonc" },
		{ ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml" },
	},
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			telemetry = { enable = false },
		},
	},
}
