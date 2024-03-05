return {
  "jose-elias-alvarez/null-ls.nvim", -- configure formatters & linters
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    -- import null-ls plugin
    local null_ls = require("null-ls")

    local null_ls_utils = require("null-ls.utils")

    -- for conciseness
    local formatting = null_ls.builtins.formatting -- to setup formatters
    local diagnostics = null_ls.builtins.diagnostics -- to setup linters

    -- to setup format on save
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    -- configure null_ls
    null_ls.setup({
      -- add package.json as identifier for root (for typescript monorepos)
      root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
      -- setup formatters & linters
      sources = {
        --  to disable file types use
        --  "formatting.prettier.with({disabled_filetypes: {}})" (see null-ls docs)
        formatting.prettierd, -- js/ts formatter
        formatting.black, -- python formatter
        formatting.stylua, -- lua formatter
        formatting.isort, -- python import formatter
        -- diagnostics.eslint_d.with({ -- js/ts linter
        --   condition = function(utils)
        --     return utils.root_has_file({ ".eslintrc.js", ".eslintrc.cjs" }) -- only enable if root has .eslintrc.js or .eslintrc.cjs
        --   end,
        -- }),
        formatting.clang_format.with({
          extra_args = { "-style=file:/Users/charley/.config/nvim/.clang-format" }, -- use .clang-format file
        }), -- c/c++ formatter
        formatting.latexindent.with({
          extra_args = { "-m", "-l", "/Users/charley/.config/nvim/latexindent.yaml" }, -- use custom config
        }), -- latex formatter
        formatting.taplo, -- toml formatter

        formatting.rustfmt,
      },
      -- configure format on save
      on_attach = function(current_client, bufnr)
        if current_client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                filter = function(client)
                  --  only use null-ls for formatting instead of lsp server
                  return client.name == "null-ls"
                end,
                bufnr = bufnr,
              })
            end,
          })
        end
      end,
    })
  end,
}
