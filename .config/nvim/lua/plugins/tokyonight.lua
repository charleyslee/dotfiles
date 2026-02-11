return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  ---@class tokyonight.Config
  opts = {
    style = "moon",
    transparent = true,
    styles = {
      -- Style to be applied to different syntax groups
      -- Value is any valid attr-list value for `:help nvim_set_hl`
      -- comments = { italic = true },
      keywords = { italic = false },
      functions = {},
      variables = {},
      -- Background styles. Can be "dark", "transparent" or "normal"
      sidebars = "transparent", -- style for sidebars, see below
      floats = "transparent", -- style for floating windows
    },
    day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
    dim_inactive = false, -- dims inactive windows
    lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

    --- You can override specific color groups to use other groups or a hex color
    --- function will be called with a ColorScheme table
    ---@param colors ColorScheme
    on_colors = function(colors) end,

    --- You can override specific highlights to use other groups or a hex color
    --- function will be called with a Highlights and ColorScheme table
    ---@param highlights tokyonight.Highlights
    ---@param colors ColorScheme
    on_highlights = function(highlights, colors) end,

    cache = true, -- When set to true, the theme will be cached for better performance

    ---@type table<string, boolean|{enabled:boolean}>
    plugins = {
      -- enable all plugins when not using lazy.nvim
      -- set to false to manually enable/disable plugins
      all = package.loaded.lazy == nil,
      -- uses your plugin manager to automatically enable needed plugins
      -- currently only lazy.nvim is supported
      auto = true,
      -- add any plugins here that you want to enable
      -- for all possible plugins, see:
      --   * https://github.com/folke/tokyonight.nvim/tree/main/lua/tokyonight/groups
      -- telescope = true,
    },
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)

    vim.cmd.colorscheme("tokyonight")

    local colors = require("tokyonight.colors").setup()
    local toggleterm = require("toggleterm")

    toggleterm.setup({
      shade_terminals = false,
      highlights = {
        Normal = {
          guibg = colors.bg_dark,
        },
      },
    })
  end,
}
