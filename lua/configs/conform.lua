local options = {
  formatters_by_ft = {
    css = { "prettier" },
    go = { "gofumpt", "goimports-revisor" },
    html = { "prettier" },
    javascript = { "prettier" },
    json = { "prettier" },
    lua = { "stylua" },
    markdown = { "prettier" },
    protobuf = { "buf" },
    python = { "black" },
    rust = { "rustfmt" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    shell = { "shfmt" },
    toml = { "prettier" },
    yaml = { "prettier" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
