local capabilities = require'cmp_nvim_lsp'.default_capabilities()

local keymap = vim.keymap
local function config(_config)
    return vim.tbl_deep_extend("force", {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            -- keybind options
            local opts = {noremap = true, silent = true, buffer = bufnr}

            -- set keybinds
            keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
            keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- got to declaration
            keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
            keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>",
                       opts) -- go to implementation
            keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
            keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
            keymap.set("n", "<leader>d",
                       "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
            keymap.set("n", "<leader>d",
                       "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
            keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
            keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
            keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
            keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts) -- see outline on right hand side

            -- typescript specific keymaps (e.g. rename file and update imports)
            if client.name == "tsserver" then
                keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>") -- rename file and update imports
                keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>") -- organize imports (not in youtube nvim video)
                keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>") -- remove unused variables (not in youtube nvim video)
            end
        end
    }, _config or {})
end

local lsp = require 'lspconfig'
lsp.pyright.setup(config())
lsp.terraformls.setup(config())
lsp.tsserver.setup(config())
lsp.dockerls.setup(config())
lsp.yamlls.setup(config())
lsp["sumneko_lua"].setup({
    settings = { -- custom settings for lua
        Lua = {
            -- make the language server recognize "vim" global
            diagnostics = {globals = {"vim"}},
            workspace = {
                -- make language server aware of runtime files
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.stdpath("config") .. "/lua"] = true
                }
            }
        }
    }
})
local typescript_setup, typescript = pcall(require, "typescript")
if not typescript_setup then return end
-- configure typescript server with plugin
typescript.setup({server = config()})

local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
local cmp = require 'cmp'

local snippets_paths = function()
    local plugins = {"friendly-snippets"}
    local paths = {}
    local path
    local root_path = vim.env.HOME .. "/.vim/plugged/"
    for _, plug in ipairs(plugins) do
        path = root_path .. plug
        if vim.fn.isdirectory(path) ~= 0 then table.insert(paths, path) end
    end
    return paths
end

require("luasnip.loaders.from_vscode").lazy_load({
    paths = snippets_paths(),
    include = nil, -- Load all languages
    exclude = {}
})
vim.opt.completeopt = "menu,menuone,noselect"

local lspkind = require("lspkind")

cmp.setup {
    sources = cmp.config.sources({
        {name = 'nvim_lsp'}, {name = 'treesitter'}, {name = 'luasnip'},
        {name = 'spell'}, {name = 'buffer'}, {name = 'path'},
        {name = 'cmdline'}, {name = 'emoji'}
    }),
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({select = true}),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<Tab>"] = cmp.mapping(function(fallback)
            -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
            if cmp.visible() then
                local entry = cmp.get_selected_entry()
                if not entry then
                    cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
                else
                    cmp.confirm()
                end
            else
                fallback()
            end
        end, {"i", "s", "c"})
    }),
    snippet = {
        expand = function(args) require("luasnip").lsp_expand(args.body) end
    },
    formatting = {
        format = lspkind.cmp_format({maxwidth = 50, ellipsis_char = "..."})
    }
}

cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
