return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "jfpedroza/neotest-elixir",
  },
  config = function()
    local neotest = require("neotest")

    neotest.setup({
      adapters = {
        require("neotest-elixir"),
      },
    })

    vim.keymap.set("n", "<leader>tn", neotest.run.run)

    vim.keymap.set("n", "<leader>tf", function()
      neotest.run.run(vim.fn.expand("%"))
    end)

    vim.keymap.set("n", "<leader>ta", neotest.run.attach)

    vim.keymap.set("n", "<leader>ts", neotest.run.stop)
  end,
}
