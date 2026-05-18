vim.env.PATH = vim.env.PATH .. ";C:\\Users\\Andre\\.bun\\bin"
vim.g.wakatime_enabled = true -- comment this line out to disable all wakatime functionality

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvimrc")
if vim.g.wakatime_enabled then require("nvimrc.wakatime").setup() end
require("nvimrc.plugins")
