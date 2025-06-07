
return {
    "folke/flash.nvim",
    name = "flash",
    version = false,
    opts = {
        modes = {
            search = {
                enabled = true,
                highlight = { backdrop = true },
                jump = { nohlsearch = false }
            },
            char = {
                enabled = false
            }
        }
    },
    lazy = true,
    keys = {
        { "/", function() vim.opt.hlsearch = true return "/" end, mode = { "n", "x", "o" }, expr = true, desc = "Search forward" },
        { "?", function() vim.opt.hlsearch = true return "?" end, mode = { "n", "x", "o" }, expr = true, desc = "Search backward" },
        { "f", function() require("flash").jump() end, mode = { "n", "x", "o" }, desc = "Flash" },
        { "r", function() require("flash").remote() end, mode = "o", desc = "Remote Flash" }
    }
}

