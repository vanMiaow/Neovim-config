
return {
    -- requires npm tree-sitter-cli
    "nvim-treesitter/nvim-treesitter",
    name = "nvim-treesitter",
    -- cond = not vim.g.vscode,
    build = ":TSUpdate",
    opts = {},
    config = function(_, opts)
        require("nvim-treesitter").setup(opts)
        -- custom parser
        vim.api.nvim_create_autocmd('User', { pattern = 'TSUpdate', callback = function()
            require("nvim-treesitter.parsers").melcor = {
                install_info = {
                    url = "https://github.com/vanMiaow/tree-sitter-melcor",
                    branch = "master",
                    queries = "queries/"
                }
            }
        end })
        -- ensure installed
        require("nvim-treesitter").install({
            "cmake",
            "cpp",
            "fortran",
            "gitignore",
            "html",
            "javascript",
            "json",
            "latex",
            "lua",
            "markdown",
            "melcor",
            "powershell",
            "toml",
            "xml",
            "yaml"
        })
        return
    end,
    lazy = false,
    priority = 99
}

