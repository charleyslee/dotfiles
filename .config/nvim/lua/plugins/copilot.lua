return {
  "github/copilot.vim",
  enabled = false,
  event = "InsertEnter",
  config = function()
    vim.g.copilot_assume_mapped = true
    -- local function SuggestOneCharacter()
    --   local suggestion = vim.fn["copilot#Accept"]("")
    --   local bar = vim.fn["copilot#TextQueuedForInsertion"]()
    --   return bar:sub(1, 1)
    -- end

    local function SuggestOneWord()
      local suggestion = vim.fn["copilot#Accept"]("")
      local bar = vim.fn["copilot#TextQueuedForInsertion"]()
      return vim.fn.split(bar, [[[ .]\zs]])[1]
    end

    -- map("i", "<C-l>", SuggestOneCharacter, { expr = true, remap = false })
    vim.keymap.set("i", "<C-l>", SuggestOneWord, { expr = true, remap = false })
  end,
}
