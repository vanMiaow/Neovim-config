
-- module
local module = {}

-- count
function module.count(from, to)
    -- get pattern
    local pattern = require("script.util").get_inputs("Count: ", "#")
    -- return if canceled
    if (not pattern) then
        return "Canceled."
    end
    -- otherwise
    local count = 0
    return require("script.util").process_lines(function(lines)
        -- count pattern
        for _, line in ipairs(lines) do
            line:gsub(pattern, function()
                count = count + 1
                return
            end)
        end
        -- result
        return count .. " " .. pattern .. " counted.", false
    end, from, to)
end

-- count all or visual
function module.count_mode()
    if (vim.api.nvim_get_mode().mode == "n") then
        -- all
        print(module.count())
    else
        -- visual
        print(module.count(vim.fn.line("v"), vim.fn.line(".")))
        vim.api.nvim_input("<esc>")
    end
    return
end

-- return
return module

