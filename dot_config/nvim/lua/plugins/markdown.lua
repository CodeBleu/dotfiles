return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    name = "render-markdown",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    config = function()
      require("render-markdown").setup({
        heading = {
          enabled = true,
          icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
          width = "block",
        },
        code = {
          enabled = true,
          sign = false,
          width = "block",
          right_pad = 1,
        },
        checkbox = {
          enabled = true,
          unchecked = {
            icon = "󰄱 ",
            highlight = "RenderMarkdownUnchecked",
          },
          checked = {
            icon = "󰱒 ",
            highlight = "RenderMarkdownChecked",
          },
        },
        pipe_table = {
          style = "full",
          cell = "overlay",
          padding = 1,
        },
        html = { enabled = false },
        latex = { enabled = false },
      })
    end,
  },

  {
    "brianhuster/live-preview.nvim",
    dependencies = {
      -- optional: pick one if you want a nice file picker
      -- "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("livepreview.config").set({
      })
    end,
  },
}
