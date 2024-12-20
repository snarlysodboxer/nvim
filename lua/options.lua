require("nvchad.options")

local o = vim.o

o.shell = "/usr/local/bin/bash"

o.backspace = "indent,eol,start"

o.fileignorecase = false

-- use separate neovim and system clipboards
o.clipboard = ""
