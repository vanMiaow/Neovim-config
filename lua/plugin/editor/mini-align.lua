
return {
    "echasnovski/mini.align",
    name = "mini-align",
    version = false,
    -- cond = not vim.g.vscode,
    main = "mini.align",
    opts = {
        mappings = {
            start = "<plug>(vm-align)",
            start_with_preview = "<leader>a"
        }
    },
    lazy = true,
    keys = {
        { "<leader>a", mode = { "n", "x" }, desc = "Mini align" }
    }
}

