
if (vim.g.vscode) then
    require("vsc")
else
    require("option")
    require("keymap")
    require("lazy-config")
    require("filetype")
end

-- todo
-- melcor treesitter
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

