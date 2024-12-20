-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "nightfox", -- "chocolate", "nightfox", "material-darker", "nightfox", "nightowl", "oceanic-next", "penumbra_dark", "tokyonight", "vscode_dark"

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

M.ui = {
  statusline = {
    theme = "default",
    separator_style = "default",
    order = { "customfile", "%=", "lsp_msg", "%=", "diagnostics", "lsp" },
    modules = {
      customfile = function()
        local file = require("nvchad.stl.utils").file()
        -- return "%#St_file# " .. file[1] .. " " .. "%<%f (%{&ft}) %m" .. "%#St_file_sep#"
        return "%#St_file# " .. file[1] .. " " .. "%<%f %m" .. "%#St_file_sep#"
      end,
    },
  },

  -- disable tabs
  tabufline = {
    enabled = false,
  },

  nvdash = {
    enabled = false,
  },
}

return M
