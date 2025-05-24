
return {
    "nvim-telescope/telescope.nvim",
    name = "telescope",
    version = false,
    opts = function()
        local actions = require("telescope.actions")
        return {
            defaults = {
                sorting_strategy = "ascending",
                scroll_strategy = "limit",
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
                        ["<LeftMouse>"] = {
                            actions.mouse_click,
                            type = "action",
                            opts = { expr = true },
                        },
                        ["<2-LeftMouse>"] = {
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
            }
        }
    end,
    lazy = true,
    dependencies = { "plenary" },
    keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>", mode = "n", desc = "Telescope find files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", mode = "n", desc = "Telescope live grep" }
    }
}

