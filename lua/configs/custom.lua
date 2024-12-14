local opt = vim.opt

-- use statusline in each split
opt.laststatus = 2

-- normal file browsing instead of awful cmp-path
opt.wildmode = { "longest", "list" }

-- do not undo past last opening of a file
opt.undofile = false

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end

-- setup cmp sources to include copilot
cmp = require("cmp")
cmp.setup({
  sources = {
    { name = "copilot", group_index = 2 },
    { name = "nvim_lsp", group_index = 2 },
    { name = "luasnip", group_index = 2 },
  },
  experimental = {
    ghost_text = true,
  },
  mapping = {
    ["<Tab>"] = vim.schedule_wrap(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end),
  },
})

require("copilot").setup({
  suggestion = {
    enabled = false,
    auto_trigger = true,
    hide_during_completion = true,
  },
  panel = { enabled = false },
  -- filetypes = {
  --   yaml = true,
  --   markdown = true,
  -- },
})
