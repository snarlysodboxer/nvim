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
    "NvChad/nvterm",
     enabled = false
  },

  {
    "nvim-tree/nvim-tree.lua",
     enabled = false
  },

  {
    "windwp/nvim-autopairs",
    -- disable automatically adding the opposite versions of `{`, `(`, `[`, etc
    enabled = false,
  },
}
