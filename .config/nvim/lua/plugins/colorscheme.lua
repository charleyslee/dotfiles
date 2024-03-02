return {
  "catppuccin/nvim",
  name = "catppuccin",
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
        -- LineNrAbove = { fg = "#000000" },
        -- LineNrBelow = { fg = "#000000" },
      }
    end,
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
    -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  end,
}
