
return {
    "echasnovski/mini.pairs",
    name = "mini-pairs",
    cond = not vim.g.vscode,
    main = "mini.pairs",
    opts = {
        modes = { insert = true, command = true, terminal = true },
        mappings = {
            [" "] = { action = "open", pair = "  ", neigh_pattern = "[<([{$]." }
        }
    },
    lazy = true,
    event = { "InsertEnter", "CmdlineEnter", "TermEnter" }
}

