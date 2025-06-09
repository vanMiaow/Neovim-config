
return {
    "folke/noice.nvim",
    -- name = "noice", -- disabled to avoid duplication with MunifTanjim/noice.nvim/lazy.lua
    version = false,
    cond = not vim.g.vscode,
    opts = {
        cmdline = {
            opts = {
                position = {
                    row = -2
                }
            }
        },
        messages = {
            view_search = false
        },
        commands = {
            all = {
                view = "popup",
                opts = { enter = true, format = "details" },
                filter = {},
                filter_opts = { reverse = true }
            }
        },
        views = {
            popup = {
                size = "auto"
            }
        }
    },
    lazy = true,
    -- not "nui" here to avoid duplication with MunifTanjim/noice.nvim/lazy.lua
    dependencies = { { "MunifTanjim/nui.nvim", name = "nui" }, "nvim-notify" },
    event = { "VeryLazy" },
    keys = {
        { "<leader>m", "<cmd>Noice all<cr>", mode = "n", desc = "Noice all" },
        { "<leader>n", "<cmd>Noice dismiss<cr>", mode = "n", desc = "Noice dismiss" }
    }
}

