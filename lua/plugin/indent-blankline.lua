
return {
    "lukas-reineke/indent-blankline.nvim",
    name = "indent-blankline",
    version = false,
    opts = {
        debounce = 10,
        indent = {
            char = "▏",
            highlight = {
                "RainbowDelimiterRed",
                "RainbowDelimiterOrange",
                "RainbowDelimiterYellow",
                "RainbowDelimiterGreen",
                "RainbowDelimiterCyan",
                "RainbowDelimiterBlue",
                "RainbowDelimiterViolet"
            }
        },
        scope = {
            char = "▎",
            highlight = {
                "RainbowDelimiterRed",
                "RainbowDelimiterOrange",
                "RainbowDelimiterYellow",
                "RainbowDelimiterGreen",
                "RainbowDelimiterCyan",
                "RainbowDelimiterBlue",
                "RainbowDelimiterViolet"
            }
        }
    },
    config = function(_, opts)
        require("ibl").setup(opts)
        -- register hook
        local hooks = require("ibl.hooks")
        hooks.register(
            hooks.type.SCOPE_HIGHLIGHT,
            hooks.builtin.scope_highlight_from_extmark
        )
    end,
    lazy = false
}

