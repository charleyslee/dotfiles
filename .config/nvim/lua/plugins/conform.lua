return {
  "stevearc/conform.nvim",
  opts = {
    notify_on_error = true,

    formatters_by_ft = {
      -- Use a sub-list to run only the first available formatter
      javascript = { { "prettierd", "prettier" }, "injected" },
      typescript = { { "prettierd", "prettier" }, "injected" },
      javascriptreact = { { "prettierd", "prettier" }, "injected" },
      typescriptreact = { { "prettierd", "prettier" }, "injected" },
      sql = { "sql_formatter" },
    },

    format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 500,
      lsp_fallback = true,
    },

    formatters = {
      injected = {
        ignore_errors = true,
      },
      -- sql_formatter = {
      --   args = function()
      --     local config = {
      --       language = "mysql",
      --     }
      --     return { "--config", vim.fn.json_encode(config) }
      --   end,
      -- },
    },
  },
}
