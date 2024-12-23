return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "bash-language-server",
        "black",
        "buf",
        "css-lsp",
        "deno",
        "dockerfile-language-server",
        "gofumpt",
        "goimports-reviser",
        "gopls",
        "html-lsp",
        "lua-language-server",
        "prettier",
        "protols",
        "python-lsp-server",
        "rust-analyzer",
        "shellcheck",
        "shfmt",
        "stylua",
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
