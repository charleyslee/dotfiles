return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    -- enable mason and configure icons
    mason.setup()

    mason_lspconfig.setup({
      -- ensure_installed is handled by mason-tool-installer
      automatic_installation = true,
    })
  end,
}
