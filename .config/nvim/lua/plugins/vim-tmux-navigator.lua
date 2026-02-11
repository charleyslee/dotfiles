vim.g.tmux_navigator_no_mappings = 1

---@type LazySpec
return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    -- "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<c-h>", "<cmd>TmuxNavigateLeft<cr>", mode = { "n", "i" } },
    { "<c-j>", "<cmd>TmuxNavigateDown<cr>", mode = { "n", "i" } },
    { "<c-k>", "<cmd>TmuxNavigateUp<cr>", mode = { "n", "i" } },
    { "<c-l>", "<cmd>TmuxNavigateRight<cr>", mode = { "n", "i" } },
    -- { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
  },
}
