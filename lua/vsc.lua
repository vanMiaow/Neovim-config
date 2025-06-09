
-- [option]

-- case
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- [keymap]

-- no leader
-- hlsearch
vim.keymap.set("n", "<esc>", function() vim.opt.hlsearch = false return "<esc>" end, { expr = true, desc = "Suspend highlight search" })
vim.keymap.set({ "n", "x", "o" }, "/", function() vim.opt.hlsearch = true return "/" end, { expr = true, desc = "Search forward" })
vim.keymap.set({ "n", "x", "o" }, "?", function() vim.opt.hlsearch = true return "?" end, { expr = true, desc = "Search backward" })
vim.keymap.set({ "n", "x", "o" }, "n", function() vim.opt.hlsearch = true return "n" end, { expr = true, desc = "Next match" })
vim.keymap.set({ "n", "x", "o" }, "N", function() vim.opt.hlsearch = true return "N" end, { expr = true, desc = "Previous match" })

-- leader
vim.g.mapleader = " "
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

-- [lazy-config]

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- import your plugins
        { import = "plugin.completion" },
        { import = "plugin.editor" },
        { import = "plugin.explorer" },
        { import = "plugin.git" },
        { import = "plugin.markdown" },
        { import = "plugin.misc" },
        { import = "plugin.treesitter" },
        { import = "plugin.ui" },
        { import = "plugin.util" },
    },
    -- lockfile path
    lockfile = vim.fn.stdpath("config") .. "/lua/plugin/lazy-lock.json",
    -- disable rocks
    rocks = { enabled = false },
    -- disable change detection
    change_detection = { enabled = false }
})

-- bufferline
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Write buffer" })

-- [filetype]

require("filetype")

-- [end]

vim.notify("vscode-neovim")

