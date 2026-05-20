return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- enable format on save
    opts = function()
      -- Only format YAML if repo has .yamlfmt config
      local function get_yaml_formatter(bufnr)
        local root = vim.fs.root(bufnr, { ".yamlfmt" })
        if root then
          return { "yamlfmt" }
        end
        return {}
      end

      -- Custom function to determine which Nix formatter to use
      local function get_nix_formatter(bufnr)
        -- First try treefmt if treefmt.toml exists
        local root = vim.fs.root(bufnr, { "treefmt.toml" })
        if root then
          return { "treefmt" }
        end

        -- Check git remote to determine formatter
        -- Get the buffer's file path and use git to find the root (works for both regular repos and worktrees)
        local buffer_path = vim.api.nvim_buf_get_name(bufnr)
        if buffer_path ~= "" then
          local dir = vim.fn.fnamemodify(buffer_path, ":h")
          local remote_url = vim.fn.system({ "git", "-C", dir, "config", "--get", "remote.origin.url" })
          if vim.v.shell_error == 0 then
            -- Normalize the remote URL by removing newlines and converting to lowercase
            remote_url = remote_url:gsub("%s+", ""):lower()

            -- Check if remote is from work orgs (input-output-hk or IntersectMBO)
            -- Matches both SSH (git@github.com:IntersectMBO/...) and HTTPS formats
            if remote_url:find("input%-output%-hk") or remote_url:find("intersectmbo") then
              return { "alejandra" }
            end
          end
        end

        -- Default to nixfmt for everything else
        return { "nixfmt" }
      end

      return {
        formatters_by_ft = {
          bash = { "shfmt" },
          css = { "prettier" },
          go = { "gofmt" },
          html = { "prettier" },
          javascript = { "prettier" },
          json = { "prettier" },
          lua = { "stylua" },
          markdown = { "injected" },
          -- Custom function determines which formatter based on context
          nix = get_nix_formatter,
          proto = { "buf" },
          python = { "black" },
          rust = { "rustfmt" },
          sh = { "shfmt" },
          shell = { "shfmt" },
          toml = { "prettier" },
          yaml = get_yaml_formatter,
        },

        formatters = {
          shfmt = {
            prepend_args = { "--case-indent", "--indent", "4", "--space-redirects" },
          },
          nixfmt = {
            command = "nixfmt",
          },
          alejandra = {
            command = "alejandra",
          },
        },

        format_on_save = {
          timeout_ms = 1000,
          lsp_fallback = true,
        },
      }
    end,
  },
}
