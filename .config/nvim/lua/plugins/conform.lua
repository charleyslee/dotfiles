return {
  "stevearc/conform.nvim",
  enabled = true,
  opts = {
    notify_on_error = true,

    formatters_by_ft = {
      -- Use a sub-list to run only the first available formatter
      javascript = { "biome-check", "injected" },
      typescript = { "biome-check", "injected" },
      javascriptreact = { "prettierd", "biome-check" },
      typescriptreact = { "prettierd", "biome-check" },
      css = { "biome-check" },
      json = { "biome-check" },
      mdx = { "prettierd", "injected" },
      markdown = { "prettierd", "injected" },
      graphql = { "biome" },
      rescript = { "injected", lsp_format = "first" },
      elixir = { lsp_format = "first" },
      heex = { "mix" },
      lua = { "stylua" },
      python = { "black" },
      cpp = { "clang_format" },
      dockerfile = { lsp_format = "first" },
      bash = { "shfmt" },
      sh = { "shfmt" },
      go = { "gofmt" },
      terraform = { lsp_format = "first" },
      java = { "google-java-format" },
      -- xml = { "xmlformat" },
      -- sql = { "sql_formatter" },
    },

    -- format_on_save = {
    -- These options will be passed to conform.format()
    -- timeout_ms = 500,
    -- },

    formatters = {
      injected = {
        ignore_errors = false,
      },

      -- biome-check = {
      --   prepend_args = { "--organize-imports-enabled=true" },
      -- },

      -- eslint_d = {
      --   condition = function (self, ctx)
      --     print(ctx)
      --     -- if .eslintrc.js is present, use it
      --
      --   end
      -- }

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

  config = function(_, opts)
    require("conform").setup(opts)
    vim.keymap.set("n", "<leader>f", function()
      require("conform").format({ bufnr = 0, timeout_ms = 3000 })
    end, { desc = "Format with Conform" })
  end,
}
