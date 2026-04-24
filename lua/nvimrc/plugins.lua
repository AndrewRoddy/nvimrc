local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("vscode").setup({ style = "dark" })
      vim.cmd.colorscheme("vscode")
    end,
  },
  {
    "wakatime/vim-wakatime",
    lazy = false,
  },
  {
    "alvan/vim-closetag",
    ft = { "html", "xhtml", "xml", "jsx", "tsx", "javascriptreact", "typescriptreact", "vue", "svelte", "php" },
    init = function()
      vim.g.closetag_filenames = "*.html,*.xhtml,*.xml,*.jsx,*.tsx,*.vue,*.svelte,*.php"
      vim.g.closetag_filetypes = "html,xhtml,xml,jsx,tsx,javascriptreact,typescriptreact,vue,svelte,php"
      vim.g.closetag_shortcut = ">"
      vim.g.closetag_close_shortcut = "<leader>>"
    end,
  },
  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
      },
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      messages = { enabled = false },
      notify = { enabled = false },
      lsp = {
        progress = { enabled = false },
        hover = { enabled = false },
        signature = { enabled = false },
        message = { enabled = false },
      },
      cmdline = {
        format = {
          cmdline = { pattern = "^:", icon = ":", lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = "/", lang = "regex" },
          search_up = { kind = "search", pattern = "^%?", icon = "?", lang = "regex" },
          lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "lua", lang = "lua" },
          help = { pattern = "^:%s*he?l?p?%s+", icon = "?" },
        },
      },
      views = {
        cmdline_popup = {
          position = { row = "50%", col = "50%" },
          size = { width = 60, height = "auto" },
          border = { style = "rounded" },
        },
      },
    },
  },
})
