-- ================================
-- Neovim Autocommands
-- ================================

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Restore cursor position
local restore_group = augroup("restore_cursor", { clear = true })

autocmd("BufReadPost", {
    group = restore_group,
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local line_count = vim.api.nvim_buf_line_count(0)

        if mark[1] > 0 and mark[1] <= line_count then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Spellcheck
local spell_group = augroup("spellcheck", { clear = true })

autocmd("FileType", {
    group = spell_group,
    pattern = { "markdown", "gitcommit" },
    callback = function()
        vim.opt_local.spell = true
    end,
})

-- Python settings
local python_group = augroup("python_settings", { clear = true })

autocmd("FileType", {
    group = python_group,
    pattern = "python",
    callback = function()
        vim.opt_local.colorcolumn = "120"
        vim.opt_local.wrap = false
    end,
})

-- YAML settings
local yaml_group = augroup("yaml_settings", { clear = true })

autocmd("FileType", {
    group = yaml_group,
    pattern = "yaml",
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
    end,
})

-- Jenkinsfile
local jenkins_group = augroup("jenkinsfile", { clear = true })

autocmd({ "BufRead", "BufNewFile" }, {
    group = jenkins_group,
    pattern = "Jenkinsfile",
    callback = function()
        vim.bo.filetype = "groovy"
    end,
})

-- Highlight trailing whitespace
local whitespace_group = augroup("trailing_whitespace", { clear = true })

autocmd({ "BufEnter", "InsertLeave" }, {
    group = whitespace_group,
    callback = function()
        vim.cmd([[match ErrorMsg /\s\+$/]])
    end,
})

autocmd("InsertEnter", {
    group = whitespace_group,
    callback = function()
        vim.cmd([[match ErrorMsg /\s\+\%#\@<!$/]])
    end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#61AFEF", bold = true })
    vim.api.nvim_set_hl(0, "LineNr", { fg = "#555555" })
  end,
})
