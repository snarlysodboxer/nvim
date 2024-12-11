local opt = vim.opt

-- use statusline in each split
opt.laststatus = 2

-- normal file browsing instead of awful cmp-path
opt.wildmode = { "longest", "list" }
