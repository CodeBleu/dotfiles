-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'klen/python-mode',
--  'davidhalter/jedi-vim',
  'vim-scripts/tComment',
  'vim-scripts/Solarized',
  -- 'vimwiki/vimwiki',
  'NLKNguyen/papercolor-theme',
  {
    'rrethy/vim-hexokinase',
    build = 'make hexokinase',
  },
  'jremmen/vim-ripgrep',
  { 'hashivim/vim-terraform', ft = 'terraform' },
  { 'hashivim/vim-packer',    ft = 'packer' },
--  if vim.fn.v:version >= 800 then
--     'dense-analysis/ale'
--     { 'puremourning/vimspector', ft = {'python', 'sh'} }
--  else
--     'scrooloose/syntastic'
--  end
  'dense-analysis/ale',
  { 'puremourning/vimspector', ft = {'python', 'sh'} },
  { 'artur-shaik/vim-javacomplete2', ft = 'java' },
  'Raimondi/delimitMate',
  'tpope/vim-surround',
  'pearofducks/ansible-vim',
  { 'junegunn/vader.vim', ft = 'vim' },
  'tpope/vim-fugitive',
  'vim-airline/vim-airline',
  'vim-airline/vim-airline-themes',
  'airblade/vim-gitgutter',
  'vim-test/vim-test',
  'embear/vim-localvimrc',
  'ryanoasis/vim-devicons',
  { 'junegunn/fzf', build = ':call fzf#install()' },
  'junegunn/fzf.vim',
  { 'fatih/vim-go', build = ':GoUpdateBinaries' },
  'rodjek/vim-puppet',
  'vim-ruby/vim-ruby',
  'godlygeek/tabular',
--  { 'Exafunction/codeium.vim', branch = 'main' },
  { 'Exafunction/windsurf.vim', branch = 'main' },

  -- Required plugins
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = 'VeryLazy',
    config = function()
      local ok, configs = pcall(require, 'nvim-treesitter.configs')
      if not ok then return end
      configs.setup({
        ensure_installed = { 'lua' },
        highlight = { enable = false },
      })
    end,
  },
  'stevearc/dressing.nvim',
  'nvim-lua/plenary.nvim',
  'MunifTanjim/nui.nvim',
  'MeanderingProgrammer/render-markdown.nvim',

  -- Optional dependencies
  'hrsh7th/nvim-cmp',
  'nvim-tree/nvim-web-devicons',
  'HakonHarnes/img-clip.nvim',
  'zbirenbaum/copilot.lua',

  -- Markdown related
  {
    "brianhuster/live-preview.nvim",
    lazy = false,
    config = function()
      require('livepreview.config').set({
        port = 5500,
        browser = "default",
        sync_scroll = true,
      })

      vim.keymap.set("n", ",mp", function()
        vim.cmd("LivePreview close")  -- close first to avoid the bug
        vim.defer_fn(function()
          vim.cmd("LivePreview start")
        end, 100)
      end, { desc = "Live Preview: Start", silent = true })

      vim.keymap.set("n", ",ms", "<cmd>LivePreview close<cr>",
        { desc = "Live Preview: Stop", silent = true })
    end,
  },
  -- Avante.nvim with build process
  {
    'yetone/avante.nvim',
    branch = 'main',
    build = 'make',
    config = function()
      require('avante').setup()
    end,
  },
})

-- Auto-recompile on save
vim.cmd [[
  augroup lazy_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile>
  augroup end
]]
