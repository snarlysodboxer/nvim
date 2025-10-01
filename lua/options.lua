require("nvchad.options")

local o = vim.o

o.shell = "/usr/local/bin/bash"

o.backspace = "indent,eol,start"

-- don't be absurd
o.fileignorecase = false

-- use separate neovim and system clipboards
o.clipboard = ""

-- TODO figure out highlighting TODOs
vim.api.nvim_set_hl(0, "@text.note", { link = "Search" })

-- Highlight trailing whitespace
vim.api.nvim_set_hl(0, "TrailingWhitespace", { bg = "#ff5555" })
vim.cmd([[match TrailingWhitespace /\s\+$/]])

-- Auto-remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})
