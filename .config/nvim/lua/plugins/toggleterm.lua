---@type LazySpec
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    local colors = require("tokyonight.colors").setup()
    local toggleterm = require("toggleterm")

    toggleterm.setup({
      open_mapping = [[<c-\>]],
      direction = "float",
      shade_terminals = false,
      highlights = {
        Normal = {
          guibg = colors.bg_dark,
        },
      },
    })
  end,
}
