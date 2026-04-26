do
  local orig_notify = vim.notify
  vim.notify = function(msg, level, opts)
    if type(msg) == "string" and msg:find("WakaTime", 1, true) then return end
    return orig_notify(msg, level, opts)
  end
  local orig_echo = vim.api.nvim_echo
  vim.api.nvim_echo = function(chunks, history, o)
    if type(chunks) == "table" then
      for _, c in ipairs(chunks) do
        if type(c) == "table" and type(c[1]) == "string" and c[1]:find("WakaTime", 1, true) then return end
      end
    end
    return orig_echo(chunks, history, o)
  end
end

local opt = vim.opt

opt.number = true
opt.relativenumber = false
opt.signcolumn = "no"
opt.fillchars:append({ eob = " " })
opt.shortmess:append("I")
opt.cursorline = false
opt.spell = false
opt.termguicolors = true
opt.scrolloff = 8
opt.wrap = true
opt.linebreak = true
opt.breakindent = true

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

opt.splitright = true
opt.splitbelow = true

opt.laststatus = 3

opt.undofile = true
opt.swapfile = false
opt.backup = false

opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.updatetime = 250
opt.timeoutlen = 300

if vim.fn.has("win32") == 1 then
  opt.shell = "pwsh.exe"
  opt.shellcmdflag = "-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  opt.shellredir = '2>&1 | %{ "$_" } | Out-File %s; exit $LastExitCode'
  opt.shellpipe = '2>&1 | %{ "$_" } | tee %s; exit $LastExitCode'
  opt.shellquote = ""
  opt.shellxquote = ""
end

local function set_default_colors()
  vim.api.nvim_set_hl(0, "Normal", { fg = "#EBDBB2", bg = "#282820" })
  vim.api.nvim_set_hl(0, "NormalNC", { fg = "#EBDBB2", bg = "#282820" })
  vim.api.nvim_set_hl(0, "StatusLine", { fg = "#EBDBB2", bg = "#282820" })
  vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#EBDBB2", bg = "#282820" })
  vim.api.nvim_set_hl(0, "MsgArea", { fg = "#EBDBB2", bg = "#282820" })
  vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#504945", bg = "#282820" })
  vim.api.nvim_set_hl(0, "WinSeparatorActive", { fg = "#ff922f", bg = "#282820", bold = true })
  vim.api.nvim_set_hl(0, "LineNr", { fg = "#EBDBB2", bg = "#282820" })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#EBDBB2", bg = "#282820" })
  vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#EBDBB2", bg = "#282820" })
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#504945", bg = "#282820" })
  vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { fg = "#ff922f", bg = "#282820" })
  vim.api.nvim_set_hl(0, "NoiceCmdlineIconCmdline", { fg = "#ff922f", bg = "#282820" })
  vim.api.nvim_set_hl(0, "NoiceCmdlineIconSearch", { fg = "#ff922f", bg = "#282820" })
  vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = "#ff922f", bg = "#282820" })
  vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderCmdline", { fg = "#ff922f", bg = "#282820" })
  vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderSearch", { fg = "#ff922f", bg = "#282820" })
  vim.api.nvim_set_hl(0, "NoiceCmdlinePopupTitle", { fg = "#ff922f", bg = "#282820" })
  vim.api.nvim_set_hl(0, "Directory", { fg = "#ff922f", bg = "#282820" })
  vim.api.nvim_set_hl(0, "OilDir", { fg = "#ff922f", bg = "#282820" })
  vim.api.nvim_set_hl(0, "OilDirIcon", { fg = "#ff922f", bg = "#282820" })
  vim.api.nvim_set_hl(0, "OilFile", { fg = "#EBDBB2", bg = "#282820" })
  vim.api.nvim_set_hl(0, "OilLink", { fg = "#EBDBB2", bg = "#282820" })
  vim.api.nvim_set_hl(0, "OilSocket", { fg = "#EBDBB2", bg = "#282820" })
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_default_colors })
set_default_colors()

local function update_active_window_separators()
  local current = vim.api.nvim_get_current_win()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    vim.wo[win].winhighlight = (win == current) and "WinSeparator:WinSeparatorActive" or ""
  end
end

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "VimEnter", "WinNew" }, {
  callback = update_active_window_separators,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
  callback = function() vim.wo.spell = false end,
})

local map = vim.keymap.set
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("v", "<", "<gv", { desc = "Indent left, keep selection" })
map("v", ">", ">gv", { desc = "Indent right, keep selection" })
map({ "i", "v", "n", "s", "x" }, "<A-a>", "<Esc>", { desc = "Enter normal mode" })
map("t", "<A-a>", [[<C-\><C-n>]], { desc = "Enter normal mode from terminal" })
map({ "n", "v", "s", "x" }, "<C-s>", "<cmd>w<cr>", { desc = "Save" })
map("i", "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save" })

vim.cmd([[cnoreabbrev <expr> f getcmdtype() == ':' && getcmdline() == 'f' ? 'Oil' : 'f']])
