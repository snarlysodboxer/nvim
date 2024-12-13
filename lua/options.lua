require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt='both'
o.shell="/usr/local/bin/bash"
o.shiftwidth=4
o.softtabstop=4
o.expandtab=false -- indent with tabs instead of spaces
o.tabstop=4

o.backspace="indent,eol,start"

o.fileignorecase=false
