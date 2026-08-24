-- Laravel / PHP
return {
	filetypes = { "php", "blade" },
	settings = {
		intelephense = {
			files = { maxSize = 5000000 },
			stubs = {
				"apache",
				"bcmath",
				"core",
				"curl",
				"date",
				"dom",
				"fileinfo",
				"filter",
				"gd",
				"hash",
				"json",
				"mbstring",
				"mysqli",
				"pcre",
				"pdo",
				"pdo_mysql",
				"redis",
				"session",
				"standard",
				"tokenizer",
				"xml",
				"zip",
			},
		},
	},
}
