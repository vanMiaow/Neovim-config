
-- no leader
-- hlsearch
vim.keymap.set("n", "<esc>", function() vim.opt.hlsearch = false return "<esc>" end, { expr = true, desc = "Suspend highlight search" })
-- vim.keymap.set({ "n", "x", "o" }, "/", function() vim.opt.hlsearch = true return "/" end, { expr = true, desc = "Search forward" }) -- handled by flash now
-- vim.keymap.set({ "n", "x", "o" }, "?", function() vim.opt.hlsearch = true return "?" end, { expr = true, desc = "Search backward" }) -- handled by flash now
vim.keymap.set({ "n", "x", "o" }, "n", function() vim.opt.hlsearch = true return "n" end, { expr = true, desc = "Next match" })
vim.keymap.set({ "n", "x", "o" }, "N", function() vim.opt.hlsearch = true return "N" end, { expr = true, desc = "Previous match" })
-- term
vim.keymap.set("t", "<c-e>", "<c-\\><c-n>", { desc = "Exit terminal mode" })

-- leader
vim.g.mapleader = " "
-- term
vim.keymap.set("n", "<leader>p", "<cmd>vert term pwsh<cr>", { desc = "Open powershell" })
-- trim
vim.keymap.set("n", "<leader>t.", require("script.trim").trim_line, { desc = "Trim line" })
vim.keymap.set({ "n", "x" }, "<leader>tr", require("script.trim").trim_mode, { desc = "Trim" })
-- count
vim.keymap.set({ "n", "x" }, "<leader>ct", require("script.count").count_mode, { desc = "Count" })
-- replace
vim.keymap.set({ "n", "x" }, "<leader>rp", require("script.replace").replace_mode, { desc = "Replace" })

-- local leader
-- for filetype keymap only
vim.g.maplocalleader = ","

