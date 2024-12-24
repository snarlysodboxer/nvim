return {
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
