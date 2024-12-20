return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "buf",
        "lua-language-server",
        "stylua",
        "shellcheck",
        "rust-analyzer",
        "python-lsp-server",
        "dockerfile-language-server",
        "bash-language-server",
        "black",
        "css-lsp",
        "deno",
        "gofumpt",
        "goimports-reviser",
        "gopls",
        "html-lsp",
        "prettier",
        "shfmt",
      },
    },
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- enable format on save
    opts = require("configs.conform"),
  },

  {
    "NvChad/nvterm",
    enabled = false,
  },

  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
  },

  {
    "windwp/nvim-autopairs",
    -- disable automatically adding the opposite versions of `{`, `(`, `[`, etc
    enabled = false,
  },

  {
    "justinmk/vim-sneak",
    lazy = false,
  },

  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup()
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },
}
