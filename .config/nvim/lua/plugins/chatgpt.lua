return {
  "jackMort/ChatGPT.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "folke/trouble.nvim",
    "nvim-telescope/telescope.nvim",
  },
  event = "VeryLazy",
  cond = function()
    return vim.fn.executable("op") == 1
  end,
  opts = {
    popup_input = {
      submit = "<CR>",
    },
    api_key_cmd = "gpg --decrypt /Users/charley/.s/openai.gpg",
    openai_params = {
      model = "gpt-4-0125-preview",
      frequency_penalty = 0,
      presence_penalty = 0,
      temperature = 0,
      top_p = 1,
      n = 1,
    },
  },
}
