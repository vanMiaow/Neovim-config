
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
    -- disable treesitter highlight
    module.toggle_highlight()
    vim.keymap.set("n", "<localleader>h", module.toggle_highlight, { buffer = buf, desc = "Toggle highlight" })
    -- align table
    vim.keymap.set("n", "<localleader>a", module.align_table, { buffer = buf, expr = true, remap = true, desc = "Align table" })
    return
end

-- align table
function module.align_table()
    -- require mini-align
    require("script.util").require_plugin("mini-align")
    -- align
    return "<plug>(vm-align)ip|"
end

-- toggle highlight
function module.toggle_highlight()
    if (vim.bo.syntax == "off") then
        -- enable
        vim.cmd("TSBufEnable highlight")
        vim.bo.syntax = "markdown"
    else
        -- disable
        vim.cmd("TSBufDisable highlight")
        vim.bo.syntax = "off"
    end
    return
end

-- return
return module

