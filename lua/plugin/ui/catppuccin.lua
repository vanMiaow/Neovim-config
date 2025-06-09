
return {
    "catppuccin/nvim",
    name = "catppuccin",
    version = false,
    cond = not vim.g.vscode,
    opts = {
        dim_inactive = {
            enabled = true
        },
        color_overrides = {
            mocha = {
                base = "#1e1e23",
                mantle = "#18181c",
                crust = "#121215"
            }
        },
        integrations = {
            blink_cmp = true,
            flash = true,
            gitgraph = true,
            gitsigns = true,
            indent_blankline = { enabled = true },
            mini = { enabled = true },
            neotree = true,
            noice = true,
            notify = true,
            rainbow_delimiters = true,
            render_markdown = true,
            telescope = { enabled = true },
            treesitter = true,
            which_key = true
        }
    },
    config = function(_, opts)
        require("catppuccin").setup(opts)
        -- colorscheme
        vim.cmd.colorscheme("catppuccin")
        vim.api.nvim_set_hl(0, "CursorColumn", { link = "CursorLine" })
        return
    end,
    lazy = false,
    priority = 99
}

-- Catppuccin Mocaccino (based on Mocha) for Windows Terminal
-- by user: { base, mantle, crust }
-- from Latte: { blue, cyan, green, purple, red, yellow }
-- {
--     "background": "#1E1E23",
--     "black": "#45475A",
--     "blue": "#1E66F5",
--     "brightBlack": "#585B70",
--     "brightBlue": "#89B4FA",
--     "brightCyan": "#94E2D5",
--     "brightGreen": "#A6E3A1",
--     "brightPurple": "#F5C2E7",
--     "brightRed": "#F38BA8",
--     "brightWhite": "#A6ADC8",
--     "brightYellow": "#F9E2AF",
--     "cursorColor": "#F5E0DC",
--     "cyan": "#179299",
--     "foreground": "#CDD6F4",
--     "green": "#40A02B",
--     "name": "Catppuccin Mocaccino",
--     "purple": "#EA76CB",
--     "red": "#D20F39",
--     "selectionBackground": "#585B70",
--     "white": "#BAC2DE",
--     "yellow": "#DF8E1D"
-- },
-- {
--     "name": "Catppuccin Mocaccino",
--     "tab":
--     {
--         "background": "#1E1E23FF",
--         "iconStyle": "default",
--         "showCloseButton": "always",
--         "unfocusedBackground": null
--     },
--     "tabRow":
--     {
--         "background": "#18181CFF",
--         "unfocusedBackground": "#121215FF"
--     },
--     "window":
--     {
--         "applicationTheme": "dark",
--         "experimental.rainbowFrame": false,
--         "frame": null,
--         "unfocusedFrame": null,
--         "useMica": false
--     }
-- },

