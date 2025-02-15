return {
  "nvimtools/none-ls.nvim", -- configure formatters & linters
  event = { "BufReadPre", "BufNewFile" },
  enabled = true,
  config = function()
    -- import null-ls plugin
    local null_ls = require("null-ls")

    local null_ls_utils = require("null-ls.utils")
    local cmd_resolver = require("null-ls.helpers.command_resolver")

    -- for conciseness
    local formatting = null_ls.builtins.formatting -- to setup formatters
    local diagnostics = null_ls.builtins.diagnostics -- to setup linters

    -- configure null_ls
    null_ls.setup({
      -- add package.json as identifier for root (for typescript monorepos)
      root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
      dynamic_command = cmd_resolver.from_node_modules(),

      -- setup formatters & linters
      sources = {
        formatting.black, -- python formatter
        formatting.isort, -- python import formatter
        -- diagnostics.eslint_d.with({ -- js/ts linter
        --   condition = function(utils)
        --     return utils.root_has_file({ ".eslintrc.js", ".eslintrc.cjs" }) -- only enable if root has .eslintrc.js or .eslintrc.cjs
        --   end,
        -- }),
        -- formatting.clang_format.with({
        --   extra_args = { "-style=file:/Users/charley/.config/nvim/.clang-format" }, -- use .clang-format file
        -- }), -- c/c++ formatter
        -- formatting.latexindent.with({
        --   extra_args = { "-m", "-l", "/Users/charley/.config/nvim/latexindent.yaml" }, -- use custom config
        -- }), -- latex formatter
        -- formatting.taplo, -- toml formatter
        --
        -- formatting.rustfmt,
        -- -- diagnostics.pylint,
        -- -- diagnostics.ruff,
        diagnostics.credo.with({
          extra_args = { "--strict" },
          condition = function(utils)
            return utils.root_has_file({ ".credo.exs" })
          end,
        }),
      },
    })
  end,
}
