-- vimquire renders pages with markdown-style "#" headings but turns folding
-- off, so fold them the same way as markdown files.
vim.opt_local.foldenable = true
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.require'nvimrc.markdown_fold'.foldexpr()"

vim.api.nvim_create_autocmd({ "BufUnload", "BufDelete" }, {
  buffer = vim.api.nvim_get_current_buf(),
  callback = function(args)
    require("nvimrc.markdown_fold").forget(args.buf)
  end,
})
