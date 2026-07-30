return {
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    -- update plugin's deps on every update
    build = function()
      -- gopher.nvim loads lazily on `ft = "go"`, so its user commands may not
      -- be registered when this build hook runs. Load the plugin first, then
      -- pcall so a failure here doesn't mark the whole update as failed.
      pcall(function()
        require("lazy").load({ plugins = { "gopher.nvim" } })
        vim.cmd.GoInstallDeps()
      end)
    end,
    -- ---@type gopher.Config
    opts = {},
  },
}
