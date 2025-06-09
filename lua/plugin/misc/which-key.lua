
return {
    "folke/which-key.nvim",
    name = "which-key",
    version = false,
    cond = not vim.g.vscode,
    opts = {
        preset = "helix",
        delay = 1000,
        expand = 2
    },
    lazy = true,
    event = { "VeryLazy" }
}

