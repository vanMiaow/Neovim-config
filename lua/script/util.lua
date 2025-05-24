
-- module
local module = {}

-- trim
function module.trim(string)
    return string:match("^%s*(.-)%s*$")
end

-- to string in float format
function module.tofloat(number, digit)
    return (("%." .. (digit or 10) .. "f"):format(number):match("^(.-)0*$"):gsub("%.$", ".0"))
end

-- contains
function module.contains(list, var)
    for _, value in ipairs(list) do
        if (value == var) then
            return true
        end
    end
    return false
end

-- get inputs
function module.get_inputs(prompt, default, cancelreturn, delimeter)
    local inputs = vim.split(
        vim.fn.input({
            prompt = prompt or "",
            default = default or "",
            cancelreturn = cancelreturn or ""
        }),
        delimeter or " ",
        { trimempty = true }
    )
    return unpack(inputs)
end

-- process lines
-- do not add or delete lines
function module.process_lines(process, from, to)
    -- get line range
    if (not from) then
        from = 1
        to = vim.api.nvim_buf_line_count(0)
    elseif (not to) then
        to = from
    elseif (to < from) then
        local swap = from
        from = to
        to = swap
    end
    -- log line range
    local log = "Line " .. from
    if (to ~= from) then
        log = log .. " to " .. to
    end
    log = log .. ": "
    -- split chunks
    -- local MAX_SIZE = 1024
    local MAX_SIZE = 10
    local total = to - from + 1
    local chunks = math.ceil(total / MAX_SIZE)
    local size = math.ceil(total / chunks)
    -- for all chunks
    for chunk = 1, chunks do
        -- get chunk range
        local chunk_from = from + (chunk - 1) * size
        local chunk_to = from + chunk * size - 1
        local last = chunk_to >= to
        if (last) then
            chunk_to = to
        end
        -- get chunk lines
        local lines = vim.api.nvim_buf_get_lines(0, chunk_from - 1, chunk_to, true)
        -- process chunk lines
        result, modified = process(lines)
        -- set chunk lines
        if (modified) then
            vim.api.nvim_buf_set_lines(0, chunk_from - 1, chunk_to, true, lines)
        end
        -- log result
        if (last) then
            log = log .. result
        end
    end
    -- return log
    return log
end

-- require plugin
function module.require_plugin(name)
    local plugin = require("lazy.core.config").plugins[name]
    if (not plugin) then
        -- unspecified plugin
        vim.notify("Plugin unspecified: " .. name .. ".", vim.log.levels.ERROR)
    elseif (not plugin._.loaded) then
        -- load plugin manually
        require("lazy").load({ plugins = { name } })
    end
    return
end

-- return
return module

