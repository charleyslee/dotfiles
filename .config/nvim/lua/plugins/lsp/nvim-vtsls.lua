return {
  "yioneko/nvim-vtsls",
  config = function()
    local vtsls = require("vtsls")

    vim.keymap.set("n", "<leader>to", vtsls.commands.sort_imports)
    vim.keymap.set("n", "<leader>tu", vtsls.commands.remove_unused_imports)

    vim.keymap.set("n", "<leader>ti", vtsls.commands.add_missing_imports)

    vim.keymap.set("n", "<leader>td", ":TSToolsGoToSourceDefinition<CR>")

    vim.keymap.set("n", "<leader>tr", ":TSToolsRenameFile<CR>")

    vim.keymap.set("n", "<leader>tf", ":TSToolsFileReferences<CR>")

    vim.keymap.set("n", "<leader>tx", ":TSToolsFixAll<CR>")
  end,
}
