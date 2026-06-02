return {
    {
        "sindrets/diffview.nvim",

        dependencies = {
            "nvim-lua/plenary.nvim",
        },

        opts = {},

        keys = {
            {
                "<localleader>gd",
                "<cmd>DiffviewOpen<CR>",
                desc = "Open diff view",
            },

            {
                "<localleader>gh",
                "<cmd>DiffviewFileHistory %<CR>",
                desc = "File history",
            },

            {
                "<localleader>gD",
                "<cmd>DiffviewClose<CR>",
                desc = "Close diff view",
            },
        },
    },
}
