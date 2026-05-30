
if (vim.g.vscode) then
    require("vs-code")
else
    require("option")
    require("keymap")
    require("filetype")
    require("lazy-config")
end

-- todo
-- xmake?

-- vim.o
-- vim.api
-- vim.opt
-- vim.fn
-- vim.cmd

-- mini?
-- edit
-- code?
-- > session
-- > layout
-- > term
-- > lsp
-- > lint
-- > diag
-- > debug
-- > ...

