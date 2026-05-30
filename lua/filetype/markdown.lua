
-- module
local module = {}

-- setup
function module.setup()
    -- pragma once
    if (vim.b.vm_filetype_set) then
        return
    else
        vim.b.vm_filetype_set = true
    end
    -- toggle highlight
    -- module.toggle_highlight()
    vim.keymap.set("n", "<localleader>h", module.toggle_highlight, { buffer = 0, desc = "Toggle highlight" })
    -- align table
    vim.keymap.set("n", "<localleader>a", module.align_table, { buffer = 0, expr = true, remap = true, desc = "Align table" })
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
    if (vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()]) then
        -- disable
        vim.treesitter.stop()
        vim.bo.syntax = ""
    else
        -- enable
        vim.treesitter.start()
    end
    return
end

-- return
return module

