-- Rust — install via `rustup component add rust-analyzer`, not Mason, so the
-- server matches the active toolchain
return {
	settings = {
		["rust-analyzer"] = {
			-- clippy lints instead of plain `cargo check` on save; allTargets
			-- includes tests so items used only under #[cfg(test)] aren't dead
			check = { command = "clippy", allTargets = true },
		},
	},
}
