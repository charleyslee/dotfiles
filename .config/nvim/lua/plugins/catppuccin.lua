return {
  "catppuccin/nvim",
  name = "catppuccin",
  enabled = false,
  priority = 1000,
  opts = {
    flavour = "macchiato",
    transparent_background = true,
    integrations = {
      harpoon = true,
    },
    custom_highlights = function(colors)
      return {
        LineNr = { fg = "#8b87a8" },
      }
    end,
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    -- vim.cmd.colorscheme("catppuccin")
  end,
}
