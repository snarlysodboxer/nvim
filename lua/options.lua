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
