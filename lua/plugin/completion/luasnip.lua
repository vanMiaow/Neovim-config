
local function expand_or_jump()
    if (require("luasnip").expand_or_locally_jumpable()) then
        return "<plug>(vm-snip-expand-or-jump)"
    else
        return "<tab>"
    end
end

local function jump_prev()
    if (require("luasnip").locally_jumpable(-1)) then
        return "<plug>(vm-snip-jump-prev)"
    else
        return "<s-tab>"
    end
end

local function next_choice()
    if (require("luasnip").choice_active()) then
        return "<plug>(vm-snip-next-choice)"
    else
        return "<c-j>"
    end
end

local function prev_choice()
    if (require("luasnip").choice_active()) then
        return "<plug>(vm-snip-prev-choice)"
    else
        return "<c-k>"
    end
end

local function select_choice()
    if (require("luasnip").choice_active()) then
        return "<plug>(vm-snip-select-choice)"
    else
        return "<c-s>"
    end
end

return {
    "L3MON4D3/LuaSnip",
    name = "luasnip",
    version = false,
    cond = not vim.g.vscode,
    opts = {},
    config = function(_,opts)
        require("luasnip").setup(opts)
        -- load html and tex for markdown
        require("luasnip").filetype_extend("markdown", { "html", "tex" })
        -- load from friendly-snippets
        require("luasnip.loaders.from_vscode").lazy_load()
        -- load from user-defined
        require("luasnip.loaders.from_lua").lazy_load({ paths = vim.fn.stdpath("config") .. "/lua/snippet" })
        return
    end,
    lazy = true,
    dependencies = { "friendly-snippets" },
    keys = {
        { "<plug>(vm-snip-expand-or-jump)", function() return require("luasnip").expand_or_jump() end, mode = { "i", "s" }, desc = "Snippet expand or jump" },
        { "<plug>(vm-snip-jump-prev)", function() return require("luasnip").jump(-1) end, mode = { "i", "s" }, desc = "Snippet jump previous" },
        { "<plug>(vm-snip-next-choice)", function() require("luasnip").change_choice(1) return end, mode = { "i", "s" }, desc = "Snippet next choice" },
        { "<plug>(vm-snip-prev-choice)", function() require("luasnip").change_choice(-1) return end, mode = { "i", "s" }, desc = "Snippet previous choice" },
        { "<plug>(vm-snip-select-choice)", function() require("luasnip.extras.select_choice")() return end, mode = { "i", "s" }, desc = "Snippet select choice" },
        { "<tab>", expand_or_jump, mode = { "i", "s" }, expr = true, desc = "Snippet expand or jump" },
        { "<s-tab>", jump_prev, mode = { "i", "s" }, expr = true, desc = "Snippet jump previous" },
        { "<c-j>", next_choice, mode = { "i", "s" }, expr = true, desc = "Snippet next choice" },
        { "<c-k>", prev_choice, mode = { "i", "s" }, expr = true, desc = "Snippet previous choice" },
        { "<c-s>", select_choice, mode = { "i", "s" }, expr = true, desc = "Snippet select choice" }
    }
}

