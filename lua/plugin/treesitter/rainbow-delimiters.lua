
return {
    "HiPhish/rainbow-delimiters.nvim",
    name = "rainbow-delimiters",
    version = false,
    cond = not vim.g.vscode,
    submodules = false,
    main = "rainbow-delimiters.setup",
    opts = {
        highlight = {
            "RainbowDelimiterRed",
            "RainbowDelimiterOrange",
            "RainbowDelimiterYellow",
            "RainbowDelimiterGreen",
            "RainbowDelimiterCyan",
            "RainbowDelimiterBlue",
            "RainbowDelimiterViolet"
        },
        query = {
            lua = "rainbow-blocks",
            latex = "rainbow-blocks"
        }
    },
    lazy = false
}

