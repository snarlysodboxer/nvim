return {
  "neovim/nvim-lspconfig",
  config = function()
    -- load defaults i.e lua_lsp
    -- NvChad's defaults() now uses the vim.lsp.config / vim.lsp.enable API
    -- (Neovim 0.11+) and installs a global LspAttach autocmd that sets up
    -- on_attach keymaps, so per-server on_attach is no longer needed.
    require("nvchad.configs.lspconfig").defaults()

    -- Check if we're on NixOS by looking for nixd in system PATH
    local is_nixos = vim.fn.executable('nixd') == 1

    -- Tools always installed via Mason (not currently provided by Nix).
    local mason_ensure_installed = {
      "black",
      "gofumpt",
      "goimports-reviser",
      "prettier",
      "stylua",
    }

    -- Tools provided by Nix on NixOS; install them via Mason only elsewhere so
    -- the config stays portable to non-Nix machines. Mirrors the nixd pattern:
    -- on NixOS these come from the system PATH (broken if pulled from Mason).
    if not is_nixos then
      vim.list_extend(mason_ensure_installed, {
        "nixd",
        "golangci-lint",
        "shfmt",
        "yamlfmt",
      })
    end

    require("mason").setup({
      ensure_installed = mason_ensure_installed,
    })
    require("mason-lspconfig").setup({
      -- automatically install the LSPs setup in lspconfig
      automatic_installation = true,
    })

    local nvlsp = require("nvchad.configs.lspconfig")

    -- lsps with default config (capabilities/on_init come from the "*" config
    -- set by NvChad's defaults(); on_attach is handled by its LspAttach autocmd)
    local servers = {
      "bashls",
      "buf_ls",
      "crystalline",
      "cssls",
      "denols",
      "golangci_lint_ls",
      "html",
      "lua_ls",
      "nushell",
      "pylsp",
      "rust_analyzer",
      "ts_ls",
    }

    -- setup dockerfile-language-server
    -- NOTE: this guy has issues with highlighting right now, see: https://github.com/nvim-treesitter/nvim-treesitter/issues/6530
    vim.lsp.config("dockerls", {
      settings = {
        docker = {
          languageserver = {
            diagnostics = {
              -- string values must be equal to "ignore", "warning", or "error"
              -- deprecatedMaintainer = "error",
              -- directiveCasing = "error",
              -- emptyContinuationLine = "error",
              -- instructionCasing = "error",
              -- instructionCmdMultiple = "error",
              -- instructionEntrypointMultiple = "error",
              -- instructionHealthcheckMultiple = "error",
              -- instructionJSONInSingleQuotes = "error",
            },
            formatter = {
              ignoreMultilineInstructions = false,
            },
          },
        },
      },
    })

    -- setup gopls
    vim.lsp.config("gopls", {
      settings = {
        gopls = {
          -- gofumpt = true, turns `0755` into `0o755` for some reason
          completeUnimported = true,
          usePlaceholders = true,
          analyses = {
            unusedvariable = true,
            unusedparams = false,
            shadow = false,
          },
          staticcheck = true,
        },
      },
    })

    -- Override gd for gopls to jump directly to the first definition without
    -- opening quickfix. NvChad sets a global `gd` in its LspAttach autocmd, so
    -- register ours in a gopls-filtered LspAttach that runs after it.
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or client.name ~= "gopls" then
          return
        end
        vim.keymap.set("n", "gd", function()
          vim.lsp.buf.definition({
            reuse_win = true,
            on_list = function(opts)
              if opts and opts.items and #opts.items > 0 then
                local item = opts.items[1]
                vim.cmd("edit " .. vim.fn.fnameescape(item.filename))
                vim.api.nvim_win_set_cursor(0, { item.lnum, item.col - 1 })
              end
            end,
          })
        end, { buffer = args.buf, desc = "Go to definition (first result)" })
      end,
    })

    -- setup yaml-language-server
    vim.lsp.config("yamlls", {
      settings = {
        yaml = {
          -- don't use yaml-language-server's built-in formatter,
          -- as it insists on indented sequences. It defaults to on and gets
          -- invoked on save via conform's lsp_fallback, so disable it here.
          format = {
            enable = false,
          },
          validate = true,
          hover = true,
          completion = true,
          schemaStore = {
            enable = false,
          },
          -- schemas = { -- not working
          --   ["kubernetes"] = "{appProject,clusterRole,clusterRole,clusterRoleBinding,configMap,configMap,customResourceDefinition,daemonSet,deployment,deployment,externalSecret,iamPolicyMember,ingress,ingressClass,job,kustomization,labelTransformer,namespace,namespace,persistentVolume,persistentVolumeClaim,priorityClass,role,role,role,roleBinding,roleBinding,roleBinding,secret,service,service,serviceAccount,serviceAccount,statefulSet,validatingWebhookConfiguration}*\\.yaml",
          -- },
        },
      },
    })

    -- setup nixd (Nix language server)
    local nixd_cmd = is_nixos and "nixd" or vim.fn.stdpath('data') .. '/mason/bin/nixd'

    vim.lsp.config("nixd", {
      cmd = { nixd_cmd },
      settings = {
        nixd = {
          nixpkgs = {
            expr = "import <nixpkgs> { }",
          },
          formatting = {
            command = { "nixfmt" },
          },
        },
      },
    })

    -- enable all configured servers
    vim.lsp.enable(servers)
    vim.lsp.enable("dockerls")
    vim.lsp.enable("gopls")
    vim.lsp.enable("yamlls")
    vim.lsp.enable("nixd")
  end,
}
