-- ================================
-- Neovim Options
-- ================================

local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.splitright = true
opt.splitbelow = true

opt.ignorecase = true
opt.smartcase = true

opt.incsearch = true
opt.hlsearch = true

opt.scrolloff = 8

opt.wrap = false

opt.cursorline = true

opt.hidden = true

opt.list = true
opt.listchars = {
    tab = "»-",
    trail = "·",
    eol = "↴",
}

opt.termguicolors = true

opt.updatetime = 300

opt.signcolumn = "yes"

opt.swapfile = false

opt.backspace = "indent,eol,start"

opt.foldmethod = "marker"
opt.foldenable = false

vim.g.mapleader = " "
vim.g.maplocalleader = ","

