
return {
    -- requires npm tree-sitter-cli
    "nvim-treesitter/nvim-treesitter",
    name = "nvim-treesitter",
    branch = "master", -- switch to main when nvim 0.12 available on winget
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
            "melcor",
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
        -- custom parser
        local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
        parser_configs.melcor = {
            install_info = {
                url = "https://github.com/vanMiaow/tree-sitter-melcor",
                files = { "src/parser.c" }
            }
        }
        -- todo custom highlight
        -- currently using Neovim/queries/melcor/highlights.scm
        -- install from tree-sitter-melcor after switching to main
        -- setup
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

