local M = {}

-- Language servers are installed by hand with :Mason. pyrefly is the exception: Mason tries to
-- compile it from source on this machine and fails, so use `uv tool install pyrefly` instead.
local function on_attach(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { silent = true, buffer = bufnr, desc = desc })
  end

  map("n", "K", vim.lsp.buf.hover, "Show hover documentation")
  map("n", "<C-k>", vim.lsp.buf.signature_help, "Show function signature")
  map("n", "gd", vim.lsp.buf.definition, "Go to definition")
  map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  map("n", "grt", vim.lsp.buf.type_definition, "Go to type definition")
  map("n", "gri", vim.lsp.buf.implementation, "Go to implementation")
  map("n", "grn", vim.lsp.buf.rename, "Rename symbol")
  map({ "n", "v" }, "gra", vim.lsp.buf.code_action, "Show code actions")
  map("n", "grr", vim.lsp.buf.references, "Show references")
  map("n", "gO", vim.lsp.buf.document_symbol, "Show document symbols")
  -- Insert <C-s> saves in this config, so signature help uses <C-k> here too.
  map("i", "<C-k>", vim.lsp.buf.signature_help, "Show signature help (Insert)")
  map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Go to previous diagnostic")
  map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Go to next diagnostic")
end

local servers = {
  rust_analyzer = {},
  pyrefly = {},
  clangd = {},
  lua_ls = {},
  ts_ls = {},
  gopls = {
    settings = {
      gofumpt = true,
      codelenses = {
        gc_details = false,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      analyses = {
        fieldalignment = true,
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      usePlaceholders = true,
      completeUnimported = true,
      staticcheck = true,
      directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
      semanticTokens = true,
    },
  },
  emmet_language_server = {
    filetypes = { "eruby", "html", "javascript", "less", "sass", "scss", "pug" },
    init_options = {
      includeLanguages = {},
      excludeLanguages = { "tsx", "jsx" },
      showAbbreviationSuggestions = true,
      showExpandedAbbreviation = "always",
      showSuggestionsAsSnippets = false,
    },
  },
}

function M.setup_mason()
  require("mason").setup()

  -- Start a newly installed server in the current buffer without a restart.
  require("mason-registry"):on("package:install:success", function()
    vim.defer_fn(function()
      require("lazy.core.handler.event").trigger({
        event = "FileType",
        buf = vim.api.nvim_get_current_buf(),
      })
    end, 100)
  end)
end

-- Keep only errors, throwing away warnings, info and hints as they arrive from a server. Servers
-- have no general setting to stop sending them: rustc's come from the same check as its errors.
local function errors_only(method, list_key)
  local handler = vim.lsp.handlers[method]
  vim.lsp.handlers[method] = function(err, result, ctx, config)
    if result and result[list_key] then
      result[list_key] = vim.tbl_filter(function(diagnostic)
        return diagnostic.severity == nil
          or diagnostic.severity == vim.lsp.protocol.DiagnosticSeverity.Error
      end, result[list_key])
    end
    return handler(err, result, ctx, config)
  end
end

function M.setup_servers()
  errors_only("textDocument/publishDiagnostics", "diagnostics")
  errors_only("textDocument/diagnostic", "items")
  -- Don't mark errors in the buffer. They're still reachable with ]d, [d and <C-w>d.
  vim.diagnostic.config({ underline = false })

  for name, opts in pairs(servers) do
    opts.on_attach = on_attach
    vim.lsp.config(name, opts)
  end
  vim.lsp.enable(vim.tbl_keys(servers))
end

return M
