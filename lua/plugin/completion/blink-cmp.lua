
return {
    "saghen/blink.cmp",
    name = "blink-cmp",
    version = "*", -- to use prebuilt binary
    cond = not vim.g.vscode,
    opts = {
        completion = {
            list = {
                selection = {
                    auto_insert = false
                }
            },
            ghost_text = {
                enabled = true
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 50
            }
        },
        sources = {
            default = function()
                if (vim.bo.filetype == "markdown") then
                    return { "snippets", "path" }
                else
                    return { "buffer", "snippets", "path" }
                end
            end
        },
        snippets = {
            preset = "luasnip"
        },
        keymap = {
            preset = "none",
            ["<c-j>"] = { "select_next", "fallback" },
            ["<c-k>"] = { "select_prev", "fallback" },
            ["<c-h>"] = { "hide", "fallback" },
            ["<c-l>"] = { "accept", "fallback" }
        },
        cmdline = {
            enabled = true,
            keymap = {
                preset = "inherit",
                ["<tab>"] = { "show_and_insert", "select_next", "fallback" },
                ["<c-h>"] = { "cancel", "fallback" }
            }
        },
        term = {
            enabled = false
        },
        fuzzy = {
            prebuilt_binaries = {
                proxy = {
                    url = "http://127.0.0.1:7899/"
                }
            }
        }
    },
    lazy = true,
    dependencies = { "luasnip" },
    event = { "InsertEnter", "CmdlineEnter" }
}

