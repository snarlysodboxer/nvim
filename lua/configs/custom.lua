local opt = vim.opt

-- use statusline in each split
opt.laststatus = 2

-- normal file browsing instead of awful cmp-path
opt.wildmode = { "longest", "list" }

-- do not undo past last opening of a file
opt.undofile = false

-- enable spell checking
opt.spelllang = "en_us"
opt.spell = true
