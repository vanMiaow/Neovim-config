
return {
    "echasnovski/mini.surround",
    name = "mini-surround",
    version = false,
    main = "mini.surround",
    opts = {
        mappings = {
            add = "<leader>sa", -- Add surrounding in Normal and Visual modes
            delete = "<leader>sd", -- Delete surrounding
            find = "<leader>sf", -- Find surrounding (to the right)
            find_left = "<leader>sb", -- Find surrounding (to the left)
            highlight = "<leader>sh", -- Highlight surrounding
            replace = "<leader>sr", -- Replace surrounding
            update_n_lines = "<leader>sn", -- Update `n_lines`
            suffix_last = "N", -- Suffix to search with "prev" method
            suffix_next = "n" -- Suffix to search with "next" method
        }
    },
    lazy = true,
    keys = {
        { "<leader>s", mode = { "n", "v" }, desc = "Mini surround" }
    }
}

