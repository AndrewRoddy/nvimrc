-- Match buffer indentation to whatever Prettier will format the file with.
-- Asks the project's own prettier (from node_modules) to resolve its config for
-- the file, so every config format and per-file override is honored.

local M = {}

M.filetypes = {
  "javascript", "javascriptreact", "typescript", "typescriptreact",
  "json", "jsonc", "css", "scss", "less", "html", "vue", "svelte",
  "yaml", "markdown", "graphql",
}

-- Filetypes where we always want spaces, whatever the project config says.
-- Keep in sync with the prettier prepend_args in plugins.lua.
M.force_spaces = { svelte = true }

local script = [[
const file = process.argv[1];
let prettier;
try {
  prettier = require(require.resolve("prettier", { paths: [require("path").dirname(file)] }));
} catch (e) {
  process.exit(0);
}
Promise.resolve(prettier.resolveConfig(file, { editorconfig: true })).then((c) => {
  if (c) console.log(JSON.stringify({ tabWidth: c.tabWidth ?? 2, useTabs: c.useTabs ?? false }));
});
]]

local function apply(buf)
  local file = vim.api.nvim_buf_get_name(buf)
  if file == "" or vim.fn.executable("node") == 0 then
    return
  end
  vim.system({ "node", "-e", script, file }, { text = true }, function(res)
    if res.code ~= 0 or not res.stdout or res.stdout == "" then
      return
    end
    local ok, cfg = pcall(vim.json.decode, res.stdout)
    if not ok then
      return
    end
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(buf) then
        return
      end
      local bo = vim.bo[buf]
      bo.expandtab = M.force_spaces[bo.filetype] or not cfg.useTabs
      bo.shiftwidth = cfg.tabWidth
      bo.tabstop = cfg.tabWidth
      bo.softtabstop = cfg.tabWidth
    end)
  end)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = M.filetypes,
  callback = function(args)
    apply(args.buf)
  end,
})

return M
