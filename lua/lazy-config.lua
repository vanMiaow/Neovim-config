
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- import your plugins
        { import = "plugin" },
    },
    -- lockfile path
    lockfile = vim.fn.stdpath("config") .. "/lua/plugin/lazy-lock.json",
    -- disable rocks
    rocks = { enabled = false },
    -- automatically check for plugin updates
    checker = { enabled = true },
    -- disable change detection
    change_detection = { enabled = false }
})

-- plugin template
-- return {
--     url
--     name
--     version
--     pin?
--     submodules?
--     cond?
--     main?
--     build?
--     init?
--     opts
--     config?
--     lazy
--     priority?
--     dependencies?
--     event?
--     ft?
--     keys?
-- }

