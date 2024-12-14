return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "gopls",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
   "NvChad/nvterm",
    enabled = false
  },

  {
   "nvim-tree/nvim-tree.lua",
    enabled = false
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css", "go",
      },
    },
  },

  {
    "windwp/nvim-autopairs",
    -- disable automatically adding the opposite versions of `{`, `(`, `[`, etc
    enabled = false,
  },

  {
    "olexsmir/gopher.nvim",
    ft = "go",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    -- update plugin's deps on every update
    build = function()
      vim.cmd.GoInstallDeps()
    end,
    -- ---@type gopher.Config
    opts = {},
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        -- suggestion = {
        --   enabled = false,
        --   auto_trigger = true,
        -- },
        -- panel = { enabled = false },
        -- -- filetypes = {
        -- --   yaml = true,
        -- --   markdown = true,
        -- -- },
      })
    end,
  },

  {
    "zbirenbaum/copilot-cmp",
    lazy = false,
    config = function ()
      require("copilot_cmp").setup()
    end,
    -- dependencies = {
    --   "zbirenbaum/copilot.lua",
    --   cmd = "Copilot",
    --   config = function()
    --     require("copilot").setup({
    --       suggestion = {
    --         enabled = false,
    --         auto_trigger = true,
    --       },
    --       panel = { enabled = false },
    --       -- filetypes = {
    --       --   yaml = true,
    --       --   markdown = true,
    --       -- },
    --     })
    --   end,
    -- },
  },
}
