
return {
    "HiPhish/rainbow-delimiters.nvim",
    name = "rainbow-delimiters",
    version = false,
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

