local augroup = vim.api.nvim_create_augroup
local ssedrickGroup = augroup('ssedrick', {})

require("ssedrick.set")
require("ssedrick.packer")
require("ssedrick.neovide")

local autocmd = vim.api.nvim_create_autocmd

autocmd("BufWritePre",
        {group = ssedrickGroup, pattern = "*", command = "%s/\\s\\+$//e"})

local packerGroup = augroup('packer_user_config', {})

autocmd("BufWritePost", {
    group = packerGroup,
    pattern = "packer.lua",
    command = "source <afile> | PackerSync"
})

autocmd("BufWritePre", {
    group = ssedrickGroup,
    pattern = "*",
    command = "undojoin | Neoformat"
})

autocmd("BufWritePost", {
    group = ssedrickGroup,
    pattern = "<buffer>",
    command = "lua require('lint').try_lint()"
})

-- require("ssedrick.bugs")
