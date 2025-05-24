
local function prev_diff()
    if (vim.wo.diff) then
        return "[c"
    else
        require("gitsigns").nav_hunk("prev")
        return
    end
end

local function next_diff()
    if (vim.wo.diff) then
        return "]c"
    else
        require("gitsigns").nav_hunk("next")
        return
    end
end

return {
    "lewis6991/gitsigns.nvim",
    name = "gitsigns",
    version = false,
    opts = {
        update_debounce = 10,
        signs = {
            add = { show_count = true },
            change = { show_count = true },
            delete = { show_count = true },
            topdelete = { show_count = true },
            changedelete = { show_count = true },
            untracked = { show_count = true }
        },
        signs_staged = {
            add = { show_count = true },
            change = { show_count = true },
            delete = { show_count = true },
            topdelete = { show_count = true },
            changedelete = { show_count = true }
        },
        count_chars = {
            "₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉", ["+"] = "₊"
        },
        diff_opts = {
            algorithm = "histogram",
            vertical = true
        }
    },
    lazy = true,
    event = { "VeryLazy" },
    keys = {
        { "[c", prev_diff, mode = "n", expr = true, desc = "Previous diff" },
        { "]c", next_diff, mode = "n", expr = true, desc = "Next diff" },
        { "<leader>gs", function() require("gitsigns").stage_hunk() return end, mode = "n", desc = "Git stage" },
        { "<leader>ga", function() require("gitsigns").stage_buffer() return end, mode = "n", desc = "Git add" },
        { "<leader>gr", function() require("gitsigns").reset_buffer_index() return end, mode = "n", desc = "Git reset" },
        { "<leader>gd", function() require("gitsigns").diffthis() return end, mode = "n", desc = "Git diff" }
    }
}

