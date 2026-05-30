
return {
    "folke/which-key.nvim",
    name = "which-key",
    cond = not vim.g.vscode,
    opts = {
        preset = "helix",
        delay = 1000,
        expand = 2,
        keys = {
            scroll_down = "<c-j>",
            scroll_up = "<c-k>"
        }
    },
    lazy = true,
    event = { "VeryLazy" }
}

