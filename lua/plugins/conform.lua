return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- enable format on save
    opts = {
      formatters_by_ft = {
        bash = { "shfmt" },
        css = { "prettier" },
        go = { "gofmt" },
        html = { "prettier" },
        javascript = { "prettier" },
        json = { "prettier" },
        lua = { "stylua" },
        -- markdown = { "prettier" },
        nix = { "nixfmt" },
        proto = { "buf" },
        python = { "black" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
        shell = { "shfmt" },
        toml = { "prettier" },
        -- yamlfmt reads config from the closest .yamlfmt.yaml file, else from
        -- the global config at ~/.config/yamlfmt/.yamlfmt.yaml
        yaml = { "yamlfmt" },
      },

      formatters = {
        -- consider instead getting shfmt to use .editorconfig or similar
        -- for project-specific settings
        shfmt = {
          prepend_args = { "--case-indent", "--indent", "4" },
        },
        nixfmt = {
          command = "nixfmt",
        },
      },

      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 1000,
        lsp_fallback = true,
      },
    },
  },
}
