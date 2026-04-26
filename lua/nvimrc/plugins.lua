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
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        view_options = { show_hidden = true },
        skip_confirm_for_simple_edits = true,
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "oil",
        callback = function(args)
          vim.cmd([[cnoreabbrev <buffer> <expr> q getcmdtype() == ':' && getcmdline() == 'q' ? 'lua require("oil").close()' : 'q']])
        end,
      })
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      routes = {
        { filter = { event = "notify", find = "WakaTime" }, opts = { skip = true } },
        { filter = { event = "msg_show", find = "WakaTime" }, opts = { skip = true } },
        { filter = { event = "msg_showmode", find = "WakaTime" }, opts = { skip = true } },
        { filter = { error = true, find = "WakaTime" }, opts = { skip = true } },
        { filter = { warning = true, find = "WakaTime" }, opts = { skip = true } },
      },
      messages = { enabled = true, view = "mini", view_error = "mini", view_warn = "mini" },
      notify = { enabled = true, view = "mini" },
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
      format = {
        level = {
          icons = {
            error = "E",
            warn = "!",
            info = "i",
          },
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
