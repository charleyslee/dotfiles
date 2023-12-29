return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    {
      "<C-\\>",
      "<cmd>ToggleTerm<CR>",
      -- function ()
      --   vim.opt
      -- end
    },
  },
  opts = {
    open_mapping = [[<c-\>]],
    direction = "float",
  },
}
