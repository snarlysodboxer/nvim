require("nvchad.mappings")

local map = vim.keymap.set
local nomap = vim.keymap.del

map("i", "jk", "<ESC>")

-- open files relative to current file
nomap("n", "<leader>e") -- "nvimtree toggle window"
map("n", "<leader>e", function()
  local input = vim.fn.input(":edit ", vim.fn.expand("%:h") .. "/", "file")
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
nomap("n", "<M-i>") -- "terminal toggle floating term"
nomap("n", "<M-h>") -- "terminal toggleable horizontal term"
nomap("n", "<M-v>") -- "terminal toggleable vertical term"
nomap("i", "<C-b>") -- "move beginning of line"
nomap("i", "<C-e>") -- "move end of line"
nomap("i", "<C-h>") -- "move left"
nomap("i", "<C-l>") -- "move right"
nomap("i", "<C-j>") -- "move down"
nomap("i", "<C-k>") -- "move up"

-- clear search highlights
map("n", "<leader><CR>", ":nohlsearch<cr>", { desc = "Clear search highlights" })

-- base64 encode/decode selection
map("v", "<leader>64", "c<c-r>=system('base64', @\")<cr><esc>", { desc = "Base64 encode selection" })
map("v", "<leader>d64", "c<c-r>=system('base64 --decode', @\")<cr><esc>", { desc = "Base64 decode selection" })

-- move selected lines up and down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

-- keep cursor in place when half-page scrolling
map("n", "<C-u>", "<C-u>zz", { desc = "Half page scroll up" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half page scroll down" })

-- keep cursor in place when jumping to next/previous search result. open folds
map("n", "n", "nzzzv", { desc = "Jump to next search result, center cursor" })
map("n", "N", "Nzzzv", { desc = "Jump to previous search result, center cursor" })

-- paste without copying selection
map("x", "<leader>p", '"_dP', { desc = "Paste without copying selection" })

-- delete without copying selection
map({ "n", "x" }, "<leader>d", '"_d', { desc = "Delete without copying selection" })

-- yank to system clipboard
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank to system clipboard" })

-- "nvimtree toggle window"
map("n", "<leader>l", "<Cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })

-- open popup about error using same syntax as vim in vscode
map("n", "gh", "<cmd>lua vim.diagnostic.open_float()<CR>", { noremap = true, silent = true })
