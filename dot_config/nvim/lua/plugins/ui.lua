return {

    -- Icons
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },

    -- Colorscheme
    {
        "NLKNguyen/papercolor-theme",
        priority = 1000,
        config = function()
            vim.o.background = "dark"

            vim.g.PaperColor_Theme_Options = {
                theme = {
                    ["default.dark"] = {
                        override = {
                            folded_fg = { "#83a598", "74" },
                            folded_bg = { "#282c34", "16" },
                        }
                    }
                }
            }

            vim.cmd.colorscheme("PaperColor")
        end,
    },

    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",
                    globalstatus = true,
                    section_separators = { left = "", right = "" },
                    component_separators = { left = "│", right = "│" },
                },
            })
        end,
    },

    -- Git signs
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end,
    },

    -- Better vim.ui interfaces
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        opts = {},
    },

    -- Better notifications
    {
        "rcarriga/nvim-notify",
        config = function()
            vim.notify = require("notify")
        end,
    },

    -- Show colors in files
    {
      "catgoose/nvim-colorizer.lua",
      event = "FileType *", -- CRITICAL: Load on ANY filetype detection
      opts = {
        filetypes = { "*" }, -- Highlight ALL filetypes
        user_default_options = {
          RGB = true,
          RRGGBB = true,
          names = true,
          RRGGBBAA = true,
          rgb_fn = true,
          hsl_fn = true,
          css = true,
          css_fn = true,
          mode = "background",
          always_update = false,
        },
      },
    }
}

