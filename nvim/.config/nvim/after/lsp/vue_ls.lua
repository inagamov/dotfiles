-- Vue — template-side inlay hints (script-side hints come from ts_ls)
return {
	settings = {
		vue = {
			inlayHints = {
				missingProps = true,
				destructuredProps = true,
				vBindShorthand = true,
			},
		},
	},
}
