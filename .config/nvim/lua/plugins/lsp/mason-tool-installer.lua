return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = {
    "williamboman/mason.nvim",
  },
  config = function()
    require("mason-tool-installer").setup({
      ensure_installed = {
        -- LSP servers
        "astro-language-server",
        "biome",
        "clangd",
        "css-lsp",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "elixir-ls",
        "emmet-ls",
        "eslint-lsp",
        "gopls",
        "graphql-language-service-cli",
        "html-lsp",
        "jdtls",
        "json-lsp",
        "lemminx",
        "lua-language-server",
        "prisma-language-server",
        "pyright",
        "rescript-language-server",
        "rust-analyzer",
        "tailwindcss-language-server",
        "taplo",
        "terraform-ls",
        "texlab",
        "tsgo",
        "ty",
        "typescript-language-server",
        "vtsls",
        "yaml-language-server",

        -- Formatters
        "black",
        "clang-format",
        "google-java-format",
        "isort",
        "kdlfmt",
        "latexindent",
        "prettier",
        "prettierd",
        "shfmt",
        "sql-formatter",
        "stylua",
        "xmlformatter",
        "yamlfmt",

        -- Linters
        "eslint_d",
        "pylint",
        "ruff",
      },
    })
  end,
}
