
local function toggle_tree()
    local tree = require("nvim-tree.api").tree
    if (vim.bo.filetype == "NvimTree") then
        tree.close()
    else
        tree.open()
    end
    return
end

return {
    "nvim-tree/nvim-tree.lua",
    name = "nvim-tree",
    version = false,
    init = function()
        -- disable netrw
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        return
    end,
    opts = {
        renderer = {
            indent_markers = {
                enable = true
            },
            icons = {
                show = {
                    folder_arrow = false
                },
                glyphs = {
                    git = {
                        unstaged = "", -- nf-oct-diff_modified
                        staged = "", -- nf-oct-checkbox
                        unmerged = "", -- nf-oct-git_merge
                        renamed = "", -- nf-oct-diff_renamed
                        untracked = "", -- nf-oct-diff_added
                        deleted = "", -- nf-oct-diff_removed
                        ignored = "" -- nf-oct-diff_ignored
                    }
                }
            }
        },
        filters = {
            git_ignored = false
        },
        live_filter = {
            prefix = "<filter> "
        }
    },
    lazy = true,
    keys = {
        { "<leader>e", toggle_tree, mode = "n", desc = "Explorer" }
    }
}

