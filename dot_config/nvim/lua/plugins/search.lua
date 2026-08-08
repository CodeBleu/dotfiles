return {
    {
        "nvim-telescope/telescope.nvim",

        dependencies = {
            "nvim-lua/plenary.nvim",
        },

        keys = {
            {
                "<C-p>",
                function()
                    require("telescope.builtin").find_files()
                end,
                desc = "Find files",
            },

            {
                "<localleader>f",
                function()
                    require("telescope.builtin").live_grep()
                end,
                desc = "Live grep",
            },

            {
                "<localleader>b",
                function()
                    require("telescope.builtin").buffers()
                end,
                desc = "Buffers",
            },

            {
                "<localleader>/",
                function()
                    require("telescope.builtin").current_buffer_fuzzy_find()
                end,
                desc = "Search current buffer",
            },
            {
                "<localleader>dd",
                function()
                    local builtin = require("telescope.builtin")
                    local diagnostic = vim.diagnostic

                    -- 1. Explicitly send current buffer diagnostics to the Quick Fix list
                    diagnostic.setqflist({ bufnr = 0, open = false })

                    -- 2. Open Telescope's 'quickfix' picker
                    builtin.quickfix({ prompt_title = "Diagnostics (Current Buffer)" })
                end,
                desc = "Diagnostics (Current Buffer)",
            },
        },

        config = function()
            local actions = require("telescope.actions")
            require("telescope").setup({
                defaults = {
                    -- Disable treesitter in previews (fixes the ft_to_lang crash)
                    preview = {
                      treesitter = false,
                    },
                    mappings = {
                        i = {
                            ["<C-d>"] = actions.preview_scrolling_down,
                            ["<C-u>"] = actions.preview_scrolling_up,
                            ["<C-f>"] = actions.preview_scrolling_down,
                            ["<C-b>"] = actions.preview_scrolling_up,
                        },
                        n = {
                            ["q"] = actions.close,
                            ["<C-d>"] = actions.preview_scrolling_down,
                            ["<C-u>"] = actions.preview_scrolling_up,
                            ["dd"] = actions.delete_buffer,
                        },
                    },
                    layout_strategy = "horizontal",
                    sorting_strategy = "ascending",
                },
            })
        end,
    },
}
