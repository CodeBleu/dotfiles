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

    {
        "Exafunction/windsurf.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "hrsh7th/nvim-cmp",
        },
        config = function()
          require("codeium").setup({
            -- Turn off the cmp popup source since virtual text replaces it
            enable_cmp_source = false,
            virtual_text = {
              enabled = true,
              manual = false, -- false = show automatically, not just on-demand
              default_filetype_enabled = true,
              idle_delay = 75, -- ms after you stop typing before it suggests
              key_bindings = {
                accept = "<Tab>",
                accept_word = false,
                accept_line = false,
                clear = false,
                next = "<M-]>",
                prev = "<M-[>",
              },
            },
          })
        end,
      }
}
