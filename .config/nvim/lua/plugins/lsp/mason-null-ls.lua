return {
  "jay-babu/mason-null-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "nvimtools/none-ls.nvim",
  },
  config = function()
    -- require("your.null-ls.config") -- require your null-ls config here (example below)
    require("mason-null-ls").setup({
      ensure_installed = nil,
      automatic_installation = true,
    })
  end,
}
