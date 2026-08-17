require("nvchad.options")

local o = vim.o

o.shell = "bash"

o.backspace = "indent,eol,start"

-- don't be absurd
o.fileignorecase = false

-- use separate neovim and system clipboards
o.clipboard = ""

-- disable mouse support completely so terminal can handle mouse selections
o.mouse = ""

-- Highlight trailing whitespace
vim.api.nvim_set_hl(0, "TrailingWhitespace", { bg = "#ff5555" })
vim.cmd([[match TrailingWhitespace /\s\+$/]])

-- Include hyphens in word boundaries by default (for * command)
vim.opt.iskeyword:append("-")

-- Recognize .nix-import files as nix (used in Cardano repos)
vim.filetype.add({
  extension = {
    ["nix-import"] = "nix",
  },
})

-- Don't inherit the jumplist from previous sessions (via shada), so <C-o>
-- only goes back as far as the current session. Cleared per-window since
-- session restores can open multiple windows before VimEnter.
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      vim.api.nvim_win_call(win, function()
        vim.cmd("clearjumps")
      end)
    end
  end,
})

-- Auto-remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})
