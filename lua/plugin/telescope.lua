
return {
    -- requires winget ripgrep
    "nvim-telescope/telescope.nvim",
    name = "telescope",
    version = false,
    opts = function()
        local actions = require("telescope.actions")
        return {
            defaults = {
                sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        prompt_position = "top"
                    }
                },
                path_display = { "filename_first" },
                dynamic_preview_title = true,
                default_mappings = {
                    i = {
                        ["<leftMouse>"] = {
                            actions.mouse_click,
                            type = "action",
                            opts = { expr = true },
                        },
                        ["<2-leftMouse>"] = {
                            actions.double_mouse_click,
                            type = "action",
                            opts = { expr = true },
                        },
                        ["<up>"] = actions.cycle_history_prev,
                        ["<down>"] = actions.cycle_history_next,
                        ["<c-j>"] = actions.move_selection_next,
                        ["<c-k>"] = actions.move_selection_previous,
                        ["<cr>"] = actions.select_default,
                        ["<esc>"] = actions.close
                    }
                }
            },
            pickers = {
                git_status = {
                    git_icons = {
                        -- -- nerd font
                        -- added = "", -- nf-oct-diff_added
                        -- deleted = "", -- nf-oct-diff_removed
                        -- changed = "", -- nf-oct-diff_modified
                        -- renamed = "", -- nf-oct-diff_renamed
                        -- untracked = "", -- nf-cod-question
                        -- unmerged = "", -- nf-oct-git_merge
                        -- copied = "", -- nf-oct-copy
                        -- unicode
                        added = "+",
                        deleted = "-",
                        changed = "~",
                        renamed = "→",
                        untracked = "?",
                        unmerged = "ᚶ",
                        copied = ">"
                    }
                }
            }
        }
    end,
    lazy = true,
    dependencies = { "plenary" },
    keys = {
        { "<leader>tf", "<cmd>Telescope find_files<cr>", mode = "n", desc = "Telescope find files" },
        { "<leader>tg", "<cmd>Telescope git_status<cr>", mode = "n", desc = "Telescope git status" },
        { "<leader>tl", "<cmd>Telescope live_grep<cr>", mode = "n", desc = "Telescope live grep" },
        { "<leader>tn", "<cmd>Telescope noice<cr>", mode = "n", desc = "Telescope noice" }
    }
}

