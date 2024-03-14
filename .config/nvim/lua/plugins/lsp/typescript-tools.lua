return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  config = function()
    require("typescript-tools").setup({
      -- capabilities = capabilities,
      on_attach = function(client, bufnr)
        if client.server_capabilities.inlayHintProvider then
          vim.g.inlay_hints_visible = true
          vim.lsp.inlay_hint.enable(bufnr, true)
        else
          print("no inlay hints available")
        end
      end,

      settings = {
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeCompletionsForModuleExports = true,
          quotePreference = "auto",
        },
        tsserver_format_options = {
          allowIncompleteCompletions = false,
          allowRenameOfImportPath = true,
        },
      },
    })
  end,
}
