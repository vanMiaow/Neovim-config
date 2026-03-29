
return {
    "rcarriga/nvim-notify",
    name = "nvim-notify",
    cond = not vim.g.vscode,
    opts = {
        render = "minimal",
        stages = "static",
        timeout = 10000,
        top_down = false
    },
    lazy = true
}

