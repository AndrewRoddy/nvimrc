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
    "folke/lazy.nvim",
    commit = "306a05526ada86a7b30af95c5cc81ffba93fef97",
  },
  {
    -- master is the branch for Neovim 0.11. main needs 0.12 and a full rewrite of this setup.
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    commit = "cf12346a3414fa1b06af75c79faebe7f76df080a",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvimrc.treesitter")
    end,
  },
  {
    "mason-org/mason.nvim",
    commit = "2a6940af80375532e5e9e7c1f2fc6319a1b7a69d", -- v2.3.1
    lazy = false,
    build = ":MasonUpdate",
    config = function()
      require("nvimrc.lsp").setup_mason()
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    commit = "a5671269a1ddfa7790cdf97c14e600e269da550f", -- v2.3.0
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      automatic_enable = false,
    },
  },
  {
    "neovim/nvim-lspconfig",
    commit = "4d363f93c3581b9212a24f7a830d7590b3f050af", -- v2.12.0
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvimrc.lsp").setup_servers()
    end,
  },
  {
    "numToStr/Comment.nvim",
    commit = "e30b7f2008e52442154b66f7c519bfd2f1e32acb",
    event = "VeryLazy",
    opts = {},
  },
  {
    "alvan/vim-closetag",
    commit = "d0a562f8bdb107a50595aefe53b1a690460c3822",
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
    commit = "0fcc83805ad11cf714a949c98c605ed717e0b83e",
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
          vim.keymap.set("n", "<Esc>", function() require("oil").close() end, { buffer = args.buf, desc = "Close oil" })
        end,
      })
    end,
  },
  {
    "AndrewRoddy/splunk-syntax.nvim",
    commit = "cdbe88008dbd3b8ad356a7e34c365db57f88caea",
    ft = { "splunk", "splunkxml" },
  },
  {
    -- Uses the local checkout on machines that have one, otherwise clones from GitHub.
    "AndrewRoddy/vimquire",
    dir = (vim.uv or vim.loop).fs_stat("C:/Coding/vimquire") and "C:/Coding/vimquire" or nil,
    cmd = { "Search", "SearchOpen", "SearchSources", "SearchAdd", "SearchRemove" },
    init = function()
      -- User commands must start with a capital, so expand a typed :search into :Search.
      vim.cmd([[cnoreabbrev <expr> search getcmdtype() ==# ':' && getcmdline() ==# 'search' ? 'Search' : 'search']])
    end,
    opts = {},
  },
  {
    "stevearc/conform.nvim",
    commit = "18aeab3d63d350dcf44d64c462cc489a3412af40",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      format_after_save = {
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json =       { "prettier" },
        jsonc =      { "prettier" },
        css =        { "prettier" },
        scss =       { "prettier" },
        less =       { "prettier" },
        html =       { "prettier" },
        vue =        { "prettier" },
        svelte =     { "prettier" },
        yaml =       { "prettier" },
        markdown =   { "prettier" },
        graphql =    { "prettier" },
        python =     { "black" },
        rust =       { "rustfmt" },
        sql =        { "sqlfluff" },
      },
      formatters = {
        -- Only runs when the project has a .sqlfluff/pyproject.toml/setup.cfg/tox.ini
        -- "format" only fixes layout, so leftover lint errors don't block it
        -- Exits 1 when something it can't fix remains (e.g. a long comment),
        -- but still prints the formatted file, so accept that too.
        sqlfluff = {
          args = { "format", "-" },
          exit_codes = { 0, 1 },
        },
        -- Runs Prettier everywhere, with or without a project Prettier config.
        -- Uses the project's node_modules Prettier when there is one (so its plugins load),
        -- otherwise Mason's. Mason puts its bin folder first on PATH, so black and sqlfluff
        -- also come from Mason.
        prettier = {
          -- Wrap at 60 columns, overriding the project config.
          -- Svelte always uses spaces, even if the project config says tabs.
          prepend_args = function(_, ctx)
            local args = { "--print-width=60" }
            if vim.bo[ctx.buf].filetype == "svelte" then
              table.insert(args, "--use-tabs=false")
            end
            return args
          end,
        },
      },
    },
  },
  {
    -- v4.1.2: v5 needs Neovim 0.12+
    "eero-lehtinen/oklch-color-picker.nvim",
    commit = "9b5db80d5f6af8fbc31bad29f69ad76f63154944",
    event = "VeryLazy",
    keys = {
      {
        "<leader>v",
        function() require("oklch-color-picker").pick_under_cursor() end,
        desc = "Color pick under cursor",
      },
    },
    opts = {},
  },
  {
    "folke/noice.nvim",
    commit = "7bfd942445fb63089b59f97ca487d605e715f155",
    event = "VeryLazy",
    dependencies = {
      { "MunifTanjim/nui.nvim", commit = "de740991c12411b663994b2860f1a4fd0937c130" },
    },
    opts = {
      routes = {
        { filter = { event = "msg_showmode", find = "TERMINAL" }, opts = { skip = true } },
        { view = "mini", filter = { event = "msg_showmode" } },
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
