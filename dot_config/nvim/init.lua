-- vim.opt.number = true
-- vim.opt.relativenumber = true
-- vim.opt.scrolloff = 8
-- vim.opt.tabstop = 4
-- vim.opt.softtabstop = 4
-- vim.opt.shiftwidth = 4
-- vim.opt.expandtab = true
-- vim.opt.smartindent = true
-- vim.opt.wrap = false
-- vim.opt.swapfile = false
-- vim.opt.backup = false
-- vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
-- vim.opt.undofile = true
-- vim.opt.hlsearch = false
-- vim.opt.incsearch = true
-- vim.opt.termguicolors = true
-- vim.opt.signcolumn = "yes"
-- --vim.opt.colorcolumn = "80"
--
--
-- vim.g.maplocalleader = " "
-- vim.g.mapleader = ","
-- vim.api.nvim_set_keymap('n', '<leader>ev', ':vsplit $MYVIMRC<cr>', {noremap = true})
-- vim.api.nvim_set_keymap('n', '<leader>sv', ':source $MYVIMRC<cr>', {noremap = true})
--
--
--
--
require("plugins")

vim.g.vimwiki_global_ext = 0
vim.g.vimwiki_ext2syntax = { ['.md'] = 'markdown' }

-- Optional: Extra aggressive fix
vim.cmd([[
  augroup vimwiki_override
    autocmd!
    autocmd BufRead,BufNewFile *.md set filetype=markdown
  augroup END
]])

vim.g.maplocalleader = ","
vim.g.mapleader = " "
vim.api.nvim_set_keymap('n', '<localleader>c', ':call codeium#Chat()<CR>', { noremap = true, silent = true })

vim.cmd([[
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
]])

vim.opt.mouse = ""
vim.api.nvim_set_keymap('i', '<esc>', '<nop>', {noremap = true})
vim.treesitter.start = function() end

vim.cmd([[
  augroup jenkinsfile
    autocmd!
    autocmd BufRead,BufNewFile Jenkinsfile set filetype=groovy
  augroup END
]])
