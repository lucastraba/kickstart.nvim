return {
  -- Auto-close and auto-rename HTML/Vue tags
  {
    'windwp/nvim-ts-autotag',
    event = 'InsertEnter',
    opts = {},
  },

  -- Better diagnostics list
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>xs', '<cmd>Trouble symbols toggle<cr>', desc = 'Symbols (Trouble)' },
    },
    opts = {},
  },

  -- =====================================================================
  -- Josean-inspired plugins
  -- =====================================================================

  -- Lualine: Rich statusline (replaces mini.statusline)
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local lualine = require('lualine')
      local lazy_status = require('lazy.status')

      local color_palettes = {
        blue = {
          blue = '#65D1FF',
          green = '#3EFFDC',
          violet = '#FF61EF',
          yellow = '#FFDA7B',
          red = '#FF4A4A',
          fg = '#c3ccdc',
          bg = '#112638',
          inactive_bg = '#2c3043',
        },
        purple = {
          blue = '#B065FF',
          green = '#3EFFDC',
          violet = '#FF61EF',
          yellow = '#FFDA7B',
          red = '#FF4A4A',
          fg = '#D4C8F0',
          bg = '#1A0E38',
          inactive_bg = '#2c2043',
        },
      }

      local variant = vim.g.tokyonight_variant or 'purple'
      local colors = color_palettes[variant] or color_palettes.purple

      local my_lualine_theme = {
        normal = {
          a = { bg = colors.blue, fg = colors.bg, gui = 'bold' },
          b = { bg = colors.bg, fg = colors.fg },
          c = { bg = colors.bg, fg = colors.fg },
        },
        insert = {
          a = { bg = colors.green, fg = colors.bg, gui = 'bold' },
          b = { bg = colors.bg, fg = colors.fg },
          c = { bg = colors.bg, fg = colors.fg },
        },
        visual = {
          a = { bg = colors.violet, fg = colors.bg, gui = 'bold' },
          b = { bg = colors.bg, fg = colors.fg },
          c = { bg = colors.bg, fg = colors.fg },
        },
        command = {
          a = { bg = colors.yellow, fg = colors.bg, gui = 'bold' },
          b = { bg = colors.bg, fg = colors.fg },
          c = { bg = colors.bg, fg = colors.fg },
        },
        replace = {
          a = { bg = colors.red, fg = colors.bg, gui = 'bold' },
          b = { bg = colors.bg, fg = colors.fg },
          c = { bg = colors.bg, fg = colors.fg },
        },
        inactive = {
          a = { bg = colors.inactive_bg, fg = colors.fg, gui = 'bold' },
          b = { bg = colors.inactive_bg, fg = colors.fg },
          c = { bg = colors.inactive_bg, fg = colors.fg },
        },
      }

      lualine.setup({
        options = {
          theme = my_lualine_theme,
        },
        sections = {
          lualine_x = {
            {
              lazy_status.updates,
              cond = lazy_status.has_updates,
              color = { fg = '#ff9e64' },
            },
            { 'encoding' },
            { 'fileformat' },
            { 'filetype' },
          },
        },
      })
    end,
  },

  -- Bufferline: Visual tab bar
  {
    'akinsho/bufferline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    version = '*',
    opts = {
      options = {
        mode = 'tabs',
      },
    },
  },

  -- Alpha: Dashboard/greeter on startup
  {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    config = function()
      local alpha = require('alpha')
      local dashboard = require('alpha.themes.dashboard')

      dashboard.section.header.val = {
        '                                                     ',
        '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
        '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
        '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
        '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
        '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
        '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
        '                                                     ',
      }

      dashboard.section.buttons.val = {
        dashboard.button('e', '  > New File', '<cmd>ene<CR>'),
        dashboard.button('\\', '  > Toggle file explorer', '<cmd>Neotree reveal<CR>'),
        dashboard.button('SPC sf', '󰱼 > Find File', '<cmd>Telescope find_files<CR>'),
        dashboard.button('SPC sg', '  > Find Word', '<cmd>Telescope live_grep<CR>'),
        dashboard.button('SPC wr', '󰁯  > Restore Session', '<cmd>lua require("persistence").load()<CR>'),
        dashboard.button('q', ' > Quit NVIM', '<cmd>qa<CR>'),
      }

      alpha.setup(dashboard.opts)

      vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
    end,
  },

  -- Persistence: Save/restore sessions automatically per project directory
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {
      pre_save = function() pcall(vim.cmd, 'Neotree close') end,
    },
    keys = {
      { '<leader>wr', function() require('persistence').load() end,              desc = '[R]estore session for cwd' },
      { '<leader>ws', function() require('persistence').select() end,            desc = '[S]elect session' },
      { '<leader>wl', function() require('persistence').load({ last = true }) end, desc = 'Restore [L]ast session' },
      { '<leader>wd', function() require('persistence').stop() end,              desc = "[D]on't save session on exit" },
    },
  },

  -- LazyGit: Open lazygit directly in Neovim
  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = {
      { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'Open LazyGit' },
    },
  },

  -- Dressing: Improved UI for vim.ui.select and vim.ui.input
  {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
  },

  -- Vim-maximizer: Toggle split maximization
  {
    'szw/vim-maximizer',
    keys = {
      { '<leader>sm', '<cmd>MaximizerToggle<CR>', desc = 'Maximize/minimize a split' },
    },
  },

  -- Seamless Ctrl-hjkl navigation across nvim splits and tmux panes
  { 'christoomey/vim-tmux-navigator' },
}
