return {
  -- 1. Vim Markdown (Syntax & Logic)
  {
    "plasticboy/vim-markdown",
    dependencies = { "godlygeek/tabular" },
    ft = "markdown",
    config = function()
      vim.g.vim_markdown_folding_disabled = 1
      vim.g.vim_markdown_toc_autofit = 1
      vim.g.vim_markdown_frontmatter = 1
      vim.g.vim_markdown_math = 1
      -- We enable conceal here so the renderer can hide symbols
      vim.g.vim_markdown_conceal = 1
      vim.g.vim_markdown_conceal_code_blocks = 0
    end,
  },

  -- 2. Render Markdown (The "Nice Look" in Terminal)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    name = "render-markdown", -- Explicit name to avoid conflicts
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    config = function()
      require("render-markdown").setup({
        -- Optional: Customize the look
        heading = {
          enabled = true,
          icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " }, -- Nice icons for headers
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
          unchecked = "󰄱 ",
          checked = "󰱒 ",
        },
      })
    end,
  },

  -- 3. Markdown Preview (Browser View)
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = "markdown",
    build = "cd app && npm install",
    config = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_theme = "dark"
    end,
  },
}
