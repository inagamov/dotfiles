-- Rust — install via `rustup component add rust-analyzer`, not Mason, so the
-- server matches the active toolchain
return {
	settings = {
		["rust-analyzer"] = {
			check = { command = "clippy" }, -- clippy lints instead of plain `cargo check` on save
		},
	},
}
