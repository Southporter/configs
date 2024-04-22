local mason = require 'mason'
local lsp_config = require 'mason-lspconfig'

mason.setup()
lsp_config.setup({
    ensure_installed = {
        "lua_ls", "pyright", "yamlls"
    },
    automatic_installation = true
})
