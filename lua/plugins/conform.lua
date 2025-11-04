-- Helper function to detect if we're in a work repo that needs alejandra
local function get_nix_formatter(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  local home = vim.fn.expand("~")

  -- Work repos that should use nixfmt (opt-in list for future migrations)
  local nixfmt_work_repos = {
    -- Add work repo names here when they migrate to nixfmt
    -- e.g., "repo-name",
  }

  -- Check if we're in ~/work/ directory
  if path:find("^" .. home .. "/work/") then
    -- Get the git root to find repo name
    local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(vim.fn.fnamemodify(path, ":h")) .. " rev-parse --show-toplevel 2>/dev/null")[1]

    if git_root and git_root ~= "" then
      local repo_name = vim.fn.fnamemodify(git_root, ":t")

      -- Check if this specific work repo has opted into nixfmt
      for _, allowed_repo in ipairs(nixfmt_work_repos) do
        if repo_name == allowed_repo then
          return { "nixfmt" }
        end
      end
    end

    -- All other work repos use alejandra
    return { "alejandra" }
  end

  -- Default to nixfmt for personal repos
  return { "nixfmt" }
end

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
        nix = get_nix_formatter,
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
        alejandra = {
          command = "alejandra",
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
