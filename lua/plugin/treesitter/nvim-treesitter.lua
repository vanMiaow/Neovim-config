
return {
    -- requires npm tree-sitter-cli
    "nvim-treesitter/nvim-treesitter",
    name = "nvim-treesitter",
    version = false,
    -- cond = not vim.g.vscode,
    build = ":TSUpdate",
    opts = {
        ensure_installed = {
            "c",
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
            "markdown_inline",
            "powershell",
            "toml",
            "xml",
            "yaml"
        },
        highlight = {
            enable = true
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<cr>",
                node_incremental = "<cr>",
                node_decremental = "<bs>",
                scope_incremental = "`"
            }
        },
        indent = {
            enable = true
        }
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
        -- fold
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.opt.foldlevel = 99
        return
    end,
    lazy = false,
    priority = 99
}

