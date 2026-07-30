-- Highlight, edit, and navigate code.
--
-- Migrated to the nvim-treesitter `main` branch, which is a full rewrite
-- required by Neovim 0.12+. The old `master` branch (config.setup with
-- ensure_installed/highlight/incremental_selection/textobjects opts) is locked
-- and only targets Neovim 0.11; on 0.12 it crashes in the injected-langtree
-- API ("attempt to call method 'range' (a nil value)").
--
-- On `main`:
--   * parsers are installed via require('nvim-treesitter').install(...)
--   * highlight/folds/indent are enabled per-filetype in a FileType autocmd
--     (vim.treesitter.start(), foldexpr, indentexpr) — there is no `highlight`
--     opt anymore
--   * incremental_selection and textobjects are no longer in core; we
--     reimplement incremental selection locally and use the textobjects
--     plugin's own `main` branch for movement.

-- Languages we install parsers for and enable treesitter features on.
local ENSURE_INSTALLED = {
  "arduino",
  "bash",
  "crystal",
  "css",
  "csv",
  "diff",
  "dockerfile",
  "go",
  "gomod",
  "gosum",
  "gotmpl",
  "gowork",
  "haskell",
  "haskell_persistent",
  "helm",
  "html",
  "javascript",
  "json",
  "json5",
  "just",
  "kotlin",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "nginx",
  "nix",
  "nu",
  "promql",
  "proto",
  "python",
  "query",
  "regex",
  "ruby",
  "rust",
  "sql",
  "terraform",
  "tmux",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

--- Self-contained incremental selection, since the `master` module was removed
--- on `main`. `<cr>` starts/expands the selection to the parent node; `<bs>`
--- shrinks back to the previous node.
local ts_selection = {}

local incremental = {}

do
  local selections = {} -- per-buffer stack of nodes

  -- Visually select a node's range.
  local function select_node(node)
    local srow, scol, erow, ecol = node:range()
    -- range() end col is exclusive; convert to an inclusive charwise selection
    vim.fn.setpos("'<", { 0, srow + 1, scol + 1, 0 })
    if ecol == 0 then
      erow = erow - 1
      ecol = vim.fn.col({ erow + 1, "$" }) - 1
    end
    vim.fn.setpos("'>", { 0, erow + 1, ecol, 0 })
    vim.cmd("normal! gv")
  end

  function incremental.init()
    local buf = vim.api.nvim_get_current_buf()
    local node = vim.treesitter.get_node()
    if not node then
      return
    end
    selections[buf] = { node }
    select_node(node)
  end

  function incremental.node_incremental()
    local buf = vim.api.nvim_get_current_buf()
    local stack = selections[buf]
    if not stack then
      incremental.init()
      return
    end
    local node = stack[#stack]
    local parent = node:parent()
    -- climb until the parent covers a strictly larger range
    while parent do
      local ps, pc, pe, pec = parent:range()
      local ns, nc, ne, nec = node:range()
      if ps ~= ns or pc ~= nc or pe ~= ne or pec ~= nec then
        break
      end
      parent = parent:parent()
    end
    if parent then
      table.insert(stack, parent)
      select_node(parent)
    else
      select_node(node)
    end
  end

  function incremental.node_decremental()
    local buf = vim.api.nvim_get_current_buf()
    local stack = selections[buf]
    if not stack or #stack < 2 then
      return
    end
    table.remove(stack)
    select_node(stack[#stack])
  end
end

ts_selection.incremental = incremental

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    -- Override NvChad's master-oriented spec. lazy.nvim MERGES `opts` and `cmd`
    -- across specs for the same plugin but REPLACES other keys. NvChad's spec
    -- sets `opts` to a function returning a master-only ensure_installed table;
    -- returning our own table from a function *replaces* theirs (a table would
    -- merge). `build` is replaced, so our ":TSUpdate" wins over their
    -- master-only ":TSUpdate | TSInstallAll". We don't use these opts (our
    -- `config` drives everything), so an empty table is fine.
    opts = function()
      return {}
    end,
    version = false,
    event = { "BufReadPost", "BufNewFile" },
    -- `main` uses :TSUpdate to update parsers; the master-only
    -- ":TSUpdate | TSInstallAll" and TSBufEnable/TSModuleInfo commands are gone.
    build = ":TSUpdate",
    cmd = { "TSInstall", "TSUpdate", "TSUninstall", "TSLog" },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
      },
      {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
          -- Avoid the sticky context from growing a lot.
          max_lines = 5,
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
    keys = {
      { "<cr>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup({})

      -- Register the Crystal parser (not upstreamed to nvim-treesitter). On
      -- `main`, custom parsers are registered in a `User TSUpdate` autocmd.
      vim.api.nvim_create_autocmd("User", {
        pattern = "TSUpdate",
        callback = function()
          require("nvim-treesitter.parsers").crystal = {
            install_info = {
              url = "https://github.com/crystal-lang-tools/tree-sitter-crystal",
              branch = "main",
              -- files default is fine, but be explicit to match the old config
              files = { "src/parser.c", "src/scanner.c" },
            },
          }
        end,
      })

      -- Install parsers we care about (async, no-op if already installed).
      ts.install(ENSURE_INSTALLED)

      -- Textobjects (main branch) — movement setup.
      require("nvim-treesitter-textobjects").setup({
        move = { set_jumps = true },
      })

      -- Enable treesitter features per-filetype. We map our installed parser
      -- names to the filetypes that should turn on highlight/folds/indent.
      local ft_group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = ft_group,
        callback = function(args)
          local buf = args.buf
          local ft = vim.bo[buf].filetype
          local lang = vim.treesitter.language.get_lang(ft) or ft

          -- Only enable treesitter for languages whose parser actually loads.
          -- `language.add` returns `true` when a real parser is available and
          -- `nil, err` when there is none (e.g. lazy.nvim's own `lazy` /
          -- `lazy_backdrop` filetypes). get_parser can't be used to probe here:
          -- it lazily succeeds for those buffers and then vim.treesitter.start()
          -- asserts. `add` may throw only on an invalid lang name, so pcall it
          -- and require a truthy return value.
          local ok, has_parser = pcall(vim.treesitter.language.add, lang)
          if not ok or not has_parser then
            return
          end

          -- syntax highlighting (provided by Neovim core); guard start() too,
          -- since some filetypes report a lang with no usable parser.
          if not pcall(vim.treesitter.start, buf, lang) then
            return
          end
          -- folds — but NOT in diff mode: `nvim -d` relies on
          -- foldmethod=diff to fold the identical regions symmetrically on both
          -- sides. Forcing treesitter (syntax-structure) folds here overrides
          -- that and makes the two windows fold differently.
          if not vim.wo.diff then
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.wo.foldmethod = "expr"
          end
          -- indentation (provided by nvim-treesitter), except for filetypes
          -- whose treesitter indent over-indents. yaml's indent module adds an
          -- extra level under `key:` before `- item`; we want lists flush by
          -- default, so leave yaml on Vim's built-in indent.
          local no_ts_indent = { yaml = true }
          if not no_ts_indent[lang] then
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      -- Fold defaults: don't fold everything closed on open.
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99

      -- Swap fold methods when a window enters/leaves diff mode. When diff is
      -- turned on, hand folding back to foldmethod=diff (symmetric folds on both
      -- sides); when turned off, restore treesitter folds if the buffer has a
      -- parser running.
      vim.api.nvim_create_autocmd("OptionSet", {
        group = ft_group,
        pattern = "diff",
        callback = function()
          if vim.v.option_new == "1" or vim.v.option_new == true then
            -- entering diff mode: let Vim manage diff folds
            vim.wo.foldmethod = "diff"
          else
            -- leaving diff mode: restore treesitter folds if highlighting is on
            local buf = vim.api.nvim_get_current_buf()
            if vim.treesitter.highlighter.active[buf] then
              vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
              vim.wo.foldmethod = "expr"
            else
              vim.wo.foldmethod = "manual"
            end
          end
        end,
      })

      -- Incremental selection keymaps (reimplemented; the core module was
      -- removed on the `main` branch).
      local incr = ts_selection.incremental
      vim.keymap.set("n", "<cr>", incr.init, { desc = "Init selection" })
      vim.keymap.set("x", "<cr>", incr.node_incremental, { desc = "Increment selection" })
      vim.keymap.set("x", "<bs>", incr.node_decremental, { desc = "Decrement selection" })

      -- Textobjects movement: ]f / [f to next/previous function start.
      local move = require("nvim-treesitter-textobjects.move")
      vim.keymap.set({ "n", "x", "o" }, "]f", function()
        move.goto_next_start("@function.outer", "textobjects")
      end, { desc = "Next function start" })
      vim.keymap.set({ "n", "x", "o" }, "[f", function()
        move.goto_previous_start("@function.outer", "textobjects")
      end, { desc = "Previous function start" })
    end,
  },
}
