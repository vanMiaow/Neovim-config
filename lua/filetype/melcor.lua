
-- module
local module = {}

-- setup
function module.setup(buf)
    -- pragma once
    if (vim.b[buf].filetype_set) then
        return
    else
        vim.b[buf].filetype_set = true
    end
    -- set filetype
    vim.bo[buf].filetype = "melcor"
    -- align table
    vim.keymap.set({ "n", "v" }, "<localleader>a", module.align_table, { buffer = buf, expr = true, remap = true, desc = "Align table" })
    return
end

-- align table
function module.align_table()
    -- require mini-align
    require("script.util").require_plugin("mini-align")
    -- backup config
    local backup = vim.b.minialign_config
    -- config
    vim.b.minialign_config = {
        options = {
            split_pattern = "%s+%S+",
            merge_delimiter = "  "
        },
        steps = {
            pre_justify = { MiniAlign.gen_step.trim() },
            -- restore config
            pre_split = { MiniAlign.new_step("restore", function() vim.b.minialign_config = backup return end) }
        }
    }
    -- align
    return "<plug>(vm-align)"
end

-- return
return module

