
return {
    "folke/which-key.nvim",
    name = "which-key",
    cond = not vim.g.vscode,
    opts = {
        preset = "helix",
        delay = 1000,
        expand = 2
    },
    lazy = true,
    event = { "VeryLazy" }
}

