
local last = 0

local function toggle_graph()
    if (vim.bo.filetype == "gitgraph") then
        local graph = vim.api.nvim_get_current_buf()
        vim.api.nvim_set_current_buf(last)
        vim.api.nvim_buf_delete(graph, {})
    else
        last = vim.api.nvim_get_current_buf()
        require("gitgraph").draw({ pretty = false }, { all = true, max_count = 100 })
    end
    return
end

return {
    "isakbm/gitgraph.nvim",
    name = "gitgraph",
    version = false,
    opts = {
        symbols = {
            merge_commit = "", -- nf-cod-circle_filled
            commit = "", -- nf-cod-circle
            merge_commit_end = "",
            commit_end = ""
        },
    },
    lazy = true,
    keys = {
        { "<leader>gg", toggle_graph, mode = "n", desc = "Git graph" }
    }
}

