return {

    -- Commenting
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    },

    -- Surround text objects
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end,
    },

    -- Auto pairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    },

    -- Better file explorer
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup({
                show_hidden = false,
                keymaps = {
                    ["<S-H>"] = "actions.toggle_hidden",
                    ["<CR>"]  = "actions.select",
                    ["-"]     = "actions.parent",
                },
            })

            vim.keymap.set("n", "-", "<cmd>Oil<CR>",
                { desc = "Open parent directory" })
        end,
    },

}

