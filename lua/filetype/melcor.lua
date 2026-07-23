
-- module
local module = {}

-- register
function module.register()
    vim.filetype.add({
        extension = {
            mel = "melcor",
            mpp = "melcor"
        },
        filename = {
            ["MELINP_v2-0"] = "melcor"
        }
    })
end

-- setup
function module.setup()
    -- pragma once
    if (vim.b.vm_filetype_set) then
        return
    else
        vim.b.vm_filetype_set = true
    end
    -- highlight
    vim.treesitter.start()
    -- comment string
    if (vim.fs.ext(vim.api.nvim_buf_get_name(0)) == "mel") then
        vim.bo.commentstring = "! %s"
    elseif (vim.fs.ext(vim.api.nvim_buf_get_name(0)) == "mpp") then
        vim.bo.commentstring = "// %s"
    else
        vim.bo.commentstring = "// %s"
    end
    -- align table
    vim.keymap.set({ "n", "x" }, "<localleader>a", module.align_table, { buffer = 0, expr = true, remap = true, desc = "Align table" })
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

