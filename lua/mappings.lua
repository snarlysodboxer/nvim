require "nvchad.mappings"

local map = vim.keymap.set
local nomap = vim.keymap.del

-- map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- open files relative to current file
nomap("n", "<leader>e")
map("n", "<leader>e", function()
  local input = vim.fn.input(":edit ", vim.fn.expand("%:h") .. "/", "file")
  -- vim.api.nvim_echo( {{"Input was: " .. input}}, true, {} )
  vim.api.nvim_exec2(":edit " .. input, {})
end, { desc = "Open relative to current file" })

-- remove various mappings from nvchad
nomap("n", "<C-c>") -- "general copy whole file"
nomap("n", "<C-s>") -- "general save file"
nomap("n", "<leader>b") -- "buffer new"
nomap("n", "<tab>") -- "buffer goto next"
nomap("n", "<S-tab>") -- "buffer goto prev"
nomap("n", "<leader>x") -- "buffer close"
nomap("n", "<leader>n") -- "toggle line number"
nomap("n", "<leader>rn") -- "toggle relative number"
nomap("n", "<C-n>") -- "nvimtree toggle window"
nomap("n", "<leader>h") -- "terminal new horizontal term"
nomap("n", "<leader>v") -- "terminal new vertical term"

-- stop highlighting search when hitting return
map("n", "<CR>", ":nohlsearch<cr>")

-- base64 encode/decode
map("v", "<leader>64", "c<c-r>=system('base64', @\")<cr><esc>")
map("v", "<leader>d64", "c<c-r>=system('base64 --decode', @\")<cr><esc>")
