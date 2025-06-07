
return {
    "iamcco/markdown-preview.nvim",
    name = "markdown-preview",
    version = false,
    build = "cd app && npm install && git restore yarn.lock",
    lazy = true,
    ft = "markdown",
    keys = {
        { "<localleader>v", "<cmd>call mkdp#util#toggle_preview()<cr>", ft = "markdown", mode = "n", desc = "Makrdown preview" }
    }
}

