return {

    {
        "tpope/vim-fugitive",

        keys = {
            {
                "<localleader>gs",
                "<cmd>Git<CR>",
                desc = "Git status",
            },
        },
    },

    {
        "lewis6991/gitsigns.nvim",

        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signcolumn = "yes"
        },

        keys = {
            {
                "]c",
                function()
                    require("gitsigns").next_hunk()
                end,
                desc = "Next hunk",
            },

            {
                "[c",
                function()
                    require("gitsigns").prev_hunk()
                end,
                desc = "Previous hunk",
            },

            {
                "<localleader>gb",
                function()
                    require("gitsigns").blame_line()
                end,
                desc = "Blame line",
            },

            {
                "<localleader>gp",
                function()
                    require("gitsigns").preview_hunk()
                end,
                desc = "Preview hunk",
            },

            {
                "<localleader>gu",
                function()
                    require("gitsigns").undo_stage_hunk()
                end,
                desc = "Undo hunk",
            },

            {
                "<localleader>gr",
                function()
                    require("gitsigns").reset_hunk()
                end,
                desc = "Reset hunk",
            },
        },
    },

}
