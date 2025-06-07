
return {
    -- requires pip pylatexenc
    "MeanderingProgrammer/render-markdown.nvim",
    name = "render-markdown",
    version = false,
    opts = {
        latex = {
            enabled = false
        },
        heading = {
            width = "block",
            min_width = 64
        },
        code = {
            position = "right",
            width = "block",
            min_width = 64,
            border = "thick",
            inline_pad = 1
        },
        dash = {
            width = 64
        },
        checkbox = {
            unchecked = {
                icon = "   󰄱 " -- nf-md-checkbox_blank_outline
            },
            checked = {
                icon = "   󰱒 " -- nf-md-checkbox_outline
            },
            custom = {
                todo = {
                    rendered = "   󰐋 " -- nf-md-play_box_outline
                }
            }
        },
        pipe_table = {
            preset = "round"
        },
        sign = {
            enabled = false
        }
    },
    lazy = true,
    ft = "markdown"
}

