return {
  "zbirenbaum/copilot.lua",
  event = "InsertEnter",
  enabled = false,
  opts = {
    panel = {
      enabled = true,
      auto_refresh = false,
      keymap = {
        jump_prev = "[[",
        jump_next = "]]",
        accept = "<CR>",
        refresh = "gr",
        open = "<M-CR>",
      },
      layout = {
        position = "bottom", -- | top | left | right | horizontal | vertical
        ratio = 0.4,
      },
    },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      hide_during_completion = true,
      debounce = 75,
      keymap = {
        accept = "<M-l>",
        accept_word = false,
        accept_line = false,
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },
    filetypes = {
      yaml = false,
      markdown = false,
      help = false,
      gitcommit = false,
      gitrebase = false,
      hgcommit = false,
      svn = false,
      cvs = false,
      ["."] = false,
    },
    copilot_node_command = "node", -- Node.js version must be > 18.x
    server_opts_overrides = {},
  },

  -- config = function()
  --   vim.g.copilot_assume_mapped = true
  --   -- local function SuggestOneCharacter()
  --   --   local suggestion = vim.fn["copilot#Accept"]("")
  --   --   local bar = vim.fn["copilot#TextQueuedForInsertion"]()
  --   --   return bar:sub(1, 1)
  --   -- end
  --
  --   local function SuggestOneWord()
  --     local suggestion = vim.fn["copilot#Accept"]("")
  --     local bar = vim.fn["copilot#TextQueuedForInsertion"]()
  --     return vim.fn.split(bar, [[[ .]\zs]])[1]
  --   end
  --
  --   -- map("i", "<C-l>", SuggestOneCharacter, { expr = true, remap = false })
  --   vim.keymap.set("i", "<C-l>", SuggestOneWord, { expr = true, remap = false })
  -- end,
}
