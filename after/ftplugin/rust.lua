-- Neovim's Rust ftplugin runs `rustfmt --help` and `--version` synchronously on the first save,
-- freezing the editor. conform.nvim already runs rustfmt asynchronously, so remove that hook.
pcall(vim.api.nvim_clear_autocmds, { group = "rust.vim.PreWrite" })
