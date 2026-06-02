-- ================================
-- Neovim Keymaps
-- ================================

local map = vim.keymap.set

-- Reload config
map("n", "<localleader>ev", "<cmd>edit $MYVIMRC<CR>")
map("n", "<localleader>sv", "<cmd>source $MYVIMRC<CR>")

-- Easier window commands
map("n", "<localleader>w", "<C-w>")

-- Window splits
map("n", "<localleader>w-", "<cmd>split<CR>")
map("n", "<localleader>w\\", "<cmd>vsplit<CR>")

-- Buffer navigation
map("n", "bn", "<cmd>bnext<CR>")
map("n", "bp", "<cmd>bprevious<CR>")

-- Quickfix navigation
map("n", "cn", "<cmd>cnext<CR>")
map("n", "cp", "<cmd>cprevious<CR>")

-- Toggle search highlight
map("n", "<localleader>hl", function()
    vim.o.hlsearch = not vim.o.hlsearch
end)

-- Toggle listchars
map("n", "<localleader>l", function()
    vim.o.list = not vim.o.list
end)

-- Better gf behavior
map("n", "gf", "<C-w>f")
map("v", "gf", "<C-w>f")

-- Disable arrows
map("n", "<Left>", "<Nop>")
map("n", "<Right>", "<Nop>")
map("n", "<Up>", "<Nop>")
map("n", "<Down>", "<Nop>")

-- Better escape
map("i", "kj", "<Esc>")

-- Save
map("n", "<leader>w", "<cmd>w<CR>")

-- Quit
map("n", "<leader>q", "<cmd>q<CR>")

-- Toggle relative number
map("n", "<F3>", function()
    vim.o.relativenumber = not vim.o.relativenumber
end)

-- Scratch buffer
map("n", "<localleader>sb", function()
    vim.cmd("split")
    vim.cmd("resize 10")
    vim.cmd("enew")

    vim.bo.buftype = "nofile"
    vim.bo.bufhidden = "hide"
    vim.bo.swapfile = false
end)

-- Toggle colorcolumn
map("n", "<localleader>cc", function()
    if vim.o.colorcolumn == "" then
        vim.o.colorcolumn = "80"
    else
        vim.o.colorcolumn = ""
    end
end)

