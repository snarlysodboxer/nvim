-- Highlight, edit, and navigate code.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
          -- Avoid the sticky context from growing a lot.
          max_lines = 3,
          -- Match the context lines to the source code.
          multiline_threshold = 1,
        },
        keys = {
          {
            "[c",
            function()
              require("treesitter-context").go_to_context()
            end,
            desc = "Jump to upper context",
          },
        },
      },
    },
    version = false,
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    keys = {
      { "<cr>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    opts = {
      ensure_installed = {
        "bash",
        "css",
        "go",
        "html",
        "javascript",
        "json",
        "json5",
        "jsonc",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
      },
      highlight = {
        enable = true,
        disable = function(lang, buf)
          -- Looking at you checker.ts
          return lang == "typescript" and vim.api.nvim_buf_line_count(buf) > 10000
        end,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<cr>",
          node_incremental = "<cr>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer" },
          goto_previous_start = { ["[f"] = "@function.outer" },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
