local config_dir = vim.fn.stdpath("config")

-- These two have no public parser, so they build from grammars kept in this repo.
local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
for _, lang in ipairs({ "psu", "splunk" }) do
  parser_configs[lang] = {
    install_info = {
      url = config_dir .. "/tree-sitter/" .. lang,
      files = { "src/parser.c" },
    },
    filetype = lang,
  }
end

-- Splunk dashboards are XML, with SPL injected by queries/xml/injections.scm.
vim.treesitter.language.register("xml", "splunkxml")
vim.treesitter.query.add_predicate("splunkxml?", function(_, _, source)
  return type(source) == "number" and vim.bo[source].filetype == "splunkxml"
end, { force = true })

require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash", "c", "c_sharp", "cpp", "css", "csv", "diff", "dockerfile",
    "git_config", "gitignore", "go", "graphql", "html", "ini", "java",
    "javascript", "jsdoc", "json", "jsonc", "kotlin", "lua", "luadoc", "make",
    "markdown", "markdown_inline", "powershell", "psu", "python", "query",
    "razor", "regex", "rust", "scss", "splunk", "sql", "svelte", "toml", "tsx",
    "typescript", "vim", "vimdoc", "vue", "xml", "yaml",
  },
  -- Anything not listed above installs the first time you open that filetype.
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})
