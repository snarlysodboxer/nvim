return {
  "neovim/nvim-lspconfig",
  config = function()
    -- load defaults i.e lua_lsp
    require("nvchad.configs.lspconfig").defaults()

    -- Check if we're on NixOS by looking for nixd in system PATH
    local is_nixos = vim.fn.executable('nixd') == 1

    local mason_ensure_installed = {
      "black",
      "gofumpt",
      "goimports-reviser",
      "golangci-lint",
      "prettier",
      "shfmt",
      "stylua",
      "yamlfmt",
    }

    -- Only install nixd via Mason if not available system-wide
    if not is_nixos then
      table.insert(mason_ensure_installed, "nixd")
    end

    require("mason").setup({
      ensure_installed = mason_ensure_installed,
    })
    require("mason-lspconfig").setup({
      -- automatically install the LSPs setup in lspconfig
      automatic_installation = true,
    })

    local lspconfig = require("lspconfig")
    local nvlsp = require("nvchad.configs.lspconfig")

    -- lsps with default config
    local servers = {
      "bashls",
      "buf_ls",
      "cssls",
      "denols",
      "golangci_lint_ls",
      "html",
      "lua_ls",
      "pylsp",
      "rust_analyzer",
      "ts_ls",
    }
    for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup({
        on_attach = nvlsp.on_attach,
        on_init = nvlsp.on_init,
        capabilities = nvlsp.capabilities,
      })
    end

    -- setup dockerfile-language-server
    -- NOTE: this guy has issues with highlighting right now, see: https://github.com/nvim-treesitter/nvim-treesitter/issues/6530
    require("lspconfig").dockerls.setup({
      on_attach = nvlsp.on_attach,
      on_init = nvlsp.on_init,
      capabilities = nvlsp.capabilities,
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
    lspconfig.gopls.setup({
      on_attach = nvlsp.on_attach,
      capabilities = nvlsp.capabilities,
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

    -- setup yaml-language-server
    lspconfig.yamlls.setup({
      on_attach = nvlsp.on_attach,
      on_init = nvlsp.on_init,
      capabilities = nvlsp.capabilities,
      settings = {
        yaml = {
          -- don't use yaml-language-server's built-in formatter,
          -- as it insists on indented sequences.
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

    lspconfig.nixd.setup({
      cmd = { nixd_cmd },
      on_attach = nvlsp.on_attach,
      on_init = nvlsp.on_init,
      capabilities = nvlsp.capabilities,
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
  end,
}
