
local function toggle_tree()
    local execute = require("neo-tree.command").execute
    if (vim.bo.filetype == "neo-tree") then
        execute({ action = "close" })
    else
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            if (vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "neo-tree") then
                vim.api.nvim_set_current_win(win)
                return
            end
        end
        execute({ action = "focus", source = "last" })
    end
    return
end

return {
    "nvim-neo-tree/neo-tree.nvim",
    name = "neo-tree",
    version = false,
    init = function()
        -- disable netrw
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        return
    end,
    opts = {
        close_if_last_window = true,
        enable_cursor_hijack = true,
        source_selector = {
            winbar = true,
            sources = {
                { source = "filesystem" },
                { source = "git_status" }
            },
            content_layout = "center"
        },
        default_component_configs = {
            modified = {
                symbol = "●"
            },
            git_status = {
                symbols = {
                    -- -- nerd font
                    -- added = "", -- nf-oct-diff_added
                    -- deleted = "", -- nf-oct-diff_removed
                    -- modified = "", -- nf-oct-diff_modified
                    -- renamed = "", -- nf-oct-diff_renamed
                    -- untracked = "", -- nf-cod-question
                    -- ignored = "", -- nf-oct-diff_ignored
                    -- unstaged = "󰄱", -- nf-md-checkbox_blank_outline
                    -- staged = "", -- nf-oct-checkbox
                    -- conflict = "", -- nf-cod-warning
                    -- unocide
                    added = "+",
                    deleted = "-",
                    modified = "~",
                    renamed = "→",
                    untracked = "?",
                    ignored = "·",
                    unstaged = "×",
                    staged = "○",
                    conflict = "!"
                }
            }
        },
        window = {
            mappings = {
                ["<space>"] = false,
                ["<2-LeftMouse>"] = false,
                ["<2-leftMouse>"] = "open",
                ["o"] = "open",
                ["P"] = false,
                ["<tab>"] = { "toggle_preview", config = { use_float = true } },
                ["<C-f>"] = false,
                ["<c-f>"] = { "scroll_preview", config = { direction = -10 } },
                ["<C-b>"] = false,
                ["<c-b>"] = { "scroll_preview", config = { direction = 10 } },
                ["l"] = false,
                ["S"] = false,
                ["t"] = false,
                ["w"] = false,
                ["C"] = false,
                ["z"] = false,
                ["A"] = false,
                ["e"] = false
            }
        },
        filesystem = {
            window = {
                mappings = {
                    ["H"] = false,
                    ["/"] = false,
                    ["D"] = false,
                    ["#"] = false,
                    ["f"] = "filter_as_you_type",
                    ["<C-x>"] = false,
                    ["<c-x>"] = "clear_filter",
                    ["[g"] = false,
                    ["]g"] = false,
                    ["oc"] = false,
                    ["od"] = false,
                    ["og"] = false,
                    ["om"] = false,
                    ["on"] = false,
                    ["os"] = false,
                    ["ot"] = false
                }
            },
            filtered_items = {
                visible = true
            }
        },
        git_status = {
            window = {
                mappings = {
                    ["A"] = false,
                    ["gA"] = "git_add_all",
                    ["gU"] = false,
                    ["gp"] = false,
                    ["gg"] = false,
                    ["oc"] = false,
                    ["od"] = false,
                    ["om"] = false,
                    ["on"] = false,
                    ["os"] = false,
                    ["ot"] = false
                }
            }
        }
    },
    lazy = true,
    -- not "nui" here to avoid duplication with MunifTanjim/noice.nvim/lazy.lua
    dependencies = { { "MunifTanjim/nui.nvim", name = "nui" }, "plenary" },
    keys = {
        { "<leader>e", toggle_tree, mode = "n", desc = "Explorer" }
    }
}

