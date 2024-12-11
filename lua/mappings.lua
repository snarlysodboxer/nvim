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
