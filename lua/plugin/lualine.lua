
return {
    "nvim-lualine/lualine.nvim",
    name = "lualine",
    version = false,
    init = function()
        -- mode
        vim.opt.showmode = false
        return
    end,
    opts = {
        options = {
            theme = "catppuccin",
            section_separators = { left = "", right = "" }, -- nf-ple-left_half_circle_thick, nf-ple-right_half_circle_thick
            component_separators = { left = "", right = "" },
            ignore_focus = { "NvimTree" },
            globalstatus = true
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff", "diagnostics" },
            lualine_c = { "filename" },
            lualine_x = { "fileformat", { "encoding", show_bomb = true, padding = { left = 0, right = 1 } }, "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" }
        }
    },
    lazy = true,
    event = { "VeryLazy" }
}

