return {
  -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/nvim-treesitter-context",
    "rescript-lang/tree-sitter-rescript",
  },
  build = ":TSUpdate",
  event = { "BufReadPre", "BufNewFile" },

  opts = function() -- this is needed so you won't override your default nvim-treesitter configuration
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.rescript = {
      install_info = {
        url = "https://github.com/rescript-lang/tree-sitter-rescript",
        branch = "main",
        files = { "src/parser.c", "src/scanner.c" },
        generate_requires_npm = false,
        requires_generate_from_grammar = true,
        use_makefile = true, -- macOS specific instruction
      },
    }
  end,

  config = function()
    require("nvim-treesitter.configs").setup({
      -- A list of parser names, or "all" (the five listed parsers should always be installed)
      ensure_installed = {
        "elixir",
        "javascript",
        "typescript",
        "tsx",
        "python",
        "lua",
        "vim",
        "vimdoc",
        "query",
      },

      ignore_install = { "latex" }, -- VimTex handles syntax highlighting for LaTeX

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = true,

      highlight = {
        enable = true,

        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        -- disable = function(lang, buf)
        --   local max_filesize = 1000 * 1024 -- 1 MB
        --   local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        --   if ok and stats and stats.size > max_filesize then
        --     return true
        --   end
        -- end,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
      },

      indent = {
        enable = true,
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<A-space>",
          node_incremental = "<A-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },

      modules = {},
    })

    vim.treesitter.language.register("markdown", "mdx")
  end,
}
