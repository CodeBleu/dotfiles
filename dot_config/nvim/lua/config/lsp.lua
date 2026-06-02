vim.lsp.config("lua_ls", {})
vim.lsp.enable("lua_ls")

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    end,
})
