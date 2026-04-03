-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Leader key (must be set before lazy)
vim.g.mapleader = " "

-- Options
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.scrolloff = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.cursorline = true
vim.opt.list = true
vim.opt.listchars = { tab = "> ", trail = "-", extends = ">", precedes = "<", nbsp = "+" }
vim.opt.updatetime = 100
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true

-- Filetype-specific indentation
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "html", "php", "javascript", "css" },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.shiftwidth = 2
  end,
})

-- Disable auto-comment on new lines
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "o" })
    vim.opt_local.formatoptions:append("j")
  end,
})

-- Highlight trailing whitespace
vim.api.nvim_create_autocmd({ "BufWinEnter", "InsertLeave" }, {
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "" then
      vim.fn.matchadd("ExtraWhitespace", [[\s\+$]])
    end
  end,
})
vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  callback = function()
    vim.fn.clearmatches()
  end,
})
vim.api.nvim_set_hl(0, "ExtraWhitespace", { bg = "red" })

-- CoQ settings (must be set before loading)
vim.g.coq_settings = { auto_start = "shut-up" }

-- Load plugins
require("lazy").setup("plugins")

-- Load commands and keybindings
require("commands")
require("keybindings")
