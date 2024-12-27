return {
  "neovim/nvim-lspconfig",
  config = function()
    -- load defaults i.e lua_lsp
    require("nvchad.configs.lspconfig").defaults()

    require("mason").setup({
      ensure_installed = {
        "black",
        "gofumpt",
        "goimports-reviser",
        "prettier",
        "shfmt",
        "stylua",
        "yamlfmt",
      },
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
          gofumpt = true,
          completeUnimported = true,
          usePlaceholders = true,
          analyses = {
            unusedvariable = true,
            unusedparams = true,
            shadow = true,
          },
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
  end,
}
