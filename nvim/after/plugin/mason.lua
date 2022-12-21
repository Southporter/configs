local mason = require 'mason'
local lsp_config = require 'mason-lspconfig'

mason.setup()
lsp_config.setup({
    ensure_installed = {
        "dockerls", "jsonls", "sumneko_lua", "tsserver", "pyright",
        "rust_analyzer", "terraformls", "tflint", "yamlls"
    },
    automatic_installation = true
})
