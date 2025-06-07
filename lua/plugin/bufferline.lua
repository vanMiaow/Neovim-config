
local function delete_buffer(id)
    -- get current buffer
    local cur = vim.api.nvim_get_current_buf()
    -- default id
    id = id or cur
    -- get listed buffers
    local bufs = {}
    for i, e in ipairs(require("bufferline").get_elements().elements) do
        bufs[i] = e.id
    end
    -- return if unlisted
    if (not vim.tbl_contains(bufs, id)) then
        vim.notify("Buffer unlisted.", vim.log.levels.ERROR)
        return
    end
    -- return if modified
    if (vim.bo[id].modified) then
        vim.notify("Buffer modified.", vim.log.levels.ERROR)
        return
    end
    -- show next buffer if deleting current buffer
    if (id == cur) then
        local next = 0
        for i, v in ipairs(bufs) do
            if (v == id) then
                if (i < #bufs) then
                    next = bufs[i + 1]
                elseif (i > 1) then
                    next = bufs[i - 1]
                end
                break
            end
        end
        vim.api.nvim_set_current_buf(next)
    end
    -- delete buffer
    vim.api.nvim_buf_delete(id, {})
    return
end

return {
    "akinsho/bufferline.nvim",
    name = "bufferline",
    version = false,
    init = function()
        -- hover
        vim.opt.mousemoveevent = true
        return
    end,
    opts = function()
        return {
            options = {
                move_wraps_at_ends = true,
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "Explorer",
                        highlight = "Directory",
                        separator = " ",
                    }
                },
                separator_style = "slant",
                hover = {
                    enabled = true,
                    delay = 0,
                    reveal = { "close" }
                },
                close_command = delete_buffer,
                right_mouse_command = "buffer %d | BufferLineTogglePin",
                groups = {
                    items = {
                        require("bufferline.groups").builtin.pinned:with({ icon = "󰐃" })
                    }
                }
            },
            highlights = require("catppuccin.groups.integrations.bufferline").get()
        }
    end,
    lazy = false,
    keys = {
        { "<leader>w", "<cmd>w<cr>", mode = "n", desc = "Write buffer" },
        { "<leader>bd", delete_buffer, mode = "n", desc = "Delete buffer" },
        { "<c-h>", function() require("bufferline").cycle(-vim.v.count1) return end, mode = "n", desc = "Previous buffer" },
        { "<c-l>", function() require("bufferline").cycle(vim.v.count1) return end, mode = "n", desc = "Next buffer" },
        { "<leader>bh", function() require("bufferline").move(-vim.v.count1) return end, mode = "n", desc = "Move buffer previous" },
        { "<leader>bl", function() require("bufferline").move(vim.v.count1) return end, mode = "n", desc = "Move buffer next" },
        { "<leader>bp", function() require("bufferline").groups.toggle_pin() return end, mode = "n", desc = "Pin buffer" }
    }
}

