-- Seamless ctrl+h/j/k/l navigation between neovim splits and herdr panes
-- (vim-tmux-navigator, but for herdr). Neovim tries a normal split move first;
-- at a split edge it asks herdr to focus the neighboring pane instead.
--
-- Paired with the herdr-side plugin, registered declaratively in my nix config
-- at /etc/nixos/home/shared/herdr.nix (writes ~/.config/herdr/plugins.json +
-- binds ctrl+h/j/k/l -> local.vim-navigator.* with focus_pane_* blanked).
--
-- SAFE OUTSIDE HERDR: `cond` gates loading on $HERDR_PANE_ID, so this plugin
-- does NOT load in a normal terminal. There, NvChad's default <C-h/j/k/l>
-- (<C-w>h/l/j/k) window navigation is completely untouched.
--
-- PRECEDENCE (NvChad): NvChad sets <C-h/j/k/l> via `vim.schedule(require
-- "mappings")` at the end of init.lua. This spec uses event="VeryLazy" +
-- vim.schedule() so its keymaps apply AFTER NvChad's and win. Verify inside
-- herdr with:
--   :lua print(vim.inspect(vim.fn.maparg("<C-l>", "n", false, true)))
-- Expect desc = "Herdr navigate right". If it still shows <C-w>l, the plugin
-- lost the race and we need to move its setup into a later autocmd.
return {
  {
    "bojackduy/nvim-herdr-navigation",
    -- Don't clone the repo's dev-only reference submodules (herdr,
    -- nvim-tmux-navigation); the neovim plugin doesn't need them.
    submodules = false,
    -- Only load inside a herdr pane. Outside herdr this spec is inert and
    -- NvChad's native window-nav keeps working exactly as before.
    cond = function()
      return vim.env.HERDR_PANE_ID ~= nil
    end,
    event = "VeryLazy",
    -- The neovim plugin lives in a subdir of the repo; add it to runtimepath.
    init = function(plugin)
      vim.opt.rtp:prepend(plugin.dir .. "/nvim-herdr-navigation")
    end,
    config = function()
      vim.schedule(function()
        require("herdr-navigation").setup({
          keybindings = {
            left = "<C-h>",
            down = "<C-j>",
            up = "<C-k>",
            right = "<C-l>",
          },
        })
      end)
    end,
  },
}
