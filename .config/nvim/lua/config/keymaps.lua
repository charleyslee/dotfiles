vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("i", "kj", "<esc>")

vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Move line(s) up/down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")

-- Don't copy the replaced text after pasting
vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set("n", "[b", ":bprev<CR>")
vim.keymap.set("n", "]b", ":bnext<CR>")

vim.keymap.set("n", "<leader>gds", ":Gvdiffsplit!<CR> <C-k> :q<CR>")
