
-- module
local module = {}

-- replace
function module.replace(from, to)
    -- get arguments
    local pattern, init, diff, float = require("script.util").get_inputs("Replace: ", "#")
    -- return if canceled
    if (not pattern) then
        return "Canceled."
    end
    -- otherwise
    -- default
    init = tonumber(init) or 1
    diff = tonumber(diff) or 1
    -- 1st pass
    local count = 0
    require("script.util").process_lines(function(lines)
        -- count pattern
        for _, line in ipairs(lines) do
            line:gsub(pattern, function()
                count = count + 1
                return
            end)
        end
        -- result not used
        return "", false
    end, from, to)
    -- get format
    local format
    local last = init + (count - 1) * diff
    if (float) then
        -- width of integer part with sign
        local width = math.max(#("%d"):format(init), #("%d"):format(last))
        -- width of fractional part
        local digit = 1
        for _, value in ipairs({ init, diff }) do
            local match = tostring(value):match("%.(%d+)")
            if (match) then
                digit = math.max(digit, #match)
            end
        end
        -- float format
        format = "%" .. (width + 1 + digit) .. "." .. digit .. "f"
    else
        -- width without sign
        local width = math.max(#("%d"):format(math.abs(init)), #("%d"):format(math.abs(last)))
        -- integer format
        if (init < 0 or last < 0) then
            format = "% 0" .. (width + 1) .. "d"
        else
            format = "%0" .. width .. "d"
        end
    end
    -- 2nd pass
    count = 0
    local modified = false
    return require("script.util").process_lines(function(lines)
        -- replace pattern
        for i, line in ipairs(lines) do
            lines[i] = line:gsub(pattern, function()
                count = count + 1
                modified = true
                return format:format(init + (count - 1) * diff)
            end)
        end
        -- result
        return count .. " " .. pattern .. " replaced.", modified
    end, from, to)
end

-- replace all or visual
function module.replace_mode()
    if (vim.api.nvim_get_mode().mode == "n") then
        -- all
        print(module.replace())
    else
        -- visual
        print(module.replace(vim.fn.line("v"), vim.fn.line(".")))
        vim.api.nvim_input("<esc>")
    end
    return
end

-- return
return module

