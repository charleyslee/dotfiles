return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.3",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<C-p>", "<cmd>Telescope git_files<cr>", desc = "Git files" },
    { "<leader>fl", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    {
      "<leader>fs",
      "<cmd>Telescope grep_string<cr>",
      desc = "Grep string",
    },
    {
      "<leader>fh",
      "<cmd>Telescope help_tags<cr>",
      desc = "Help tags",
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "truncate" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
          },
        },
      },
      pickers = {
        find_files = {
          find_command = {
            "rg",
            "-uu",
            "--files",
            "--hidden",
            "-g",
            "!.git/",
            "-g",
            "!node_modules",
            "-g",
            "!tmp/",
            "-g",
            "!build/",
            "-g",
            "!.next/",
            "-g",
            "!.turbo/",
          },
        },
      },
    })

    telescope.load_extension("fzf")
  end,
}
