require("config")

vim.g.python3_host_prog = "/opt/homebrew/bin/python3.11"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  install = {
    colorscheme = { "catppuccin" },
  },
  checker = {
    enabled = false,
  },
  change_detection = {
    notify = false,
  },
})
