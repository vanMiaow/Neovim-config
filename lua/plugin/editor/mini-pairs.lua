
return {
    "echasnovski/mini.pairs",
    name = "mini-pairs",
    version = false,
    main = "mini.pairs",
    opts = {
        modes = { insert = true, command = true, terminal = true },
        mappings = {
            [" "] = { action = "open", pair = "  ", neigh_pattern = "[([{].", register = { bs = false, cr = false } }
        }
    },
    lazy = true,
    event = { "InsertEnter", "CmdlineEnter", "TermEnter" }
}

