
local filetypes = {
    -- user-defined filetypes
    melcor = { "mel", "mpp", "melinp_v2-0" },
    -- built-in filetypes, do not set filetype
    markdown = { "md" }
}

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = "filetypedetect",
    callback = function(args)
        -- return if invalid buffer
        if (not vim.api.nvim_buf_is_valid(args.buf)) then
            return
        end
        -- get extension
        local extension = args.file:match("([^.]+)$"):lower()
        -- get filetype
        local filetype
        for ft, exts in pairs(filetypes) do
            for _, ext in ipairs(exts) do
                if (extension == ext) then
                    filetype = ft
                end
            end
        end
        -- setup
        if (filetype) then
            require("filetype." .. filetype).setup(args.buf)
        end
    end
})

