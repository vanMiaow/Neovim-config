
-- module
local module = {}

-- trim
function module.trim(from, to)
    local count = 0
    return require("script.util").process_lines(function(lines)
        -- remove trail
        local modified = false
        for i, line in ipairs(lines) do
            lines[i] = line:gsub("%s+$", function()
                count = count + 1
                modified = true
                return ""
            end)
        end
        -- result
        if (count == 0) then
            return "no trail.", modified
        elseif (count == 1) then
            return "1 line trimmed.", modified
        else
            return count .. " lines trimmed.", modified
        end
    end, from, to)
end

-- trim line
function module.trim_line()
    vim.notify(module.trim(vim.fn.line(".")))
    return
end

-- trim all or visual
function module.trim_mode()
    if (vim.api.nvim_get_mode().mode == "n") then
        -- all
        vim.notify(module.trim())
    else
        -- visual
        vim.notify(module.trim(vim.fn.line("v"), vim.fn.line(".")))
        vim.api.nvim_input("<esc>")
    end
    return
end

-- return
return module

