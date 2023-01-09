return require("packer").startup(function(use)
    use("wbthomason/packer.nvim")

    use("neovim/nvim-lspconfig")
    use("nvim-lua/lsp_extensions.nvim")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-emoji")
    use("hrsh7th/cmp-cmdline")
    use("f3fora/cmp-spell")
    use("ray-x/cmp-treesitter")
    use("hrsh7th/nvim-cmp")

    use("L3MON4D3/LuaSnip")
    use("saadparwaiz1/cmp_luasnip") -- for autocompletion
    use("rafamadriz/friendly-snippets") -- useful snippets
    use("williamboman/mason.nvim")
    use("williamboman/mason-lspconfig.nvim")

    use("windwp/nvim-autopairs")
    use("tpope/vim-commentary")

    -- Visualize lsp progress
    use({"j-hui/fidget.nvim", config = function() require("fidget").setup() end})

    use("simrat39/rust-tools.nvim")
    use {"dag/vim-fish", ft = {"fish"}}
    use {"hashivim/vim-terraform", ft = {"terraform"}}
    use {"juliosueiras/vim-terraform-completion", ft = {"terraform"}}
    use {"ekalinin/dockerfile.vim", ft = {"Dockerfile", "yaml.docker-compose"}}
    use("jose-elias-alvarez/typescript.nvim")
    use("mfussenegger/nvim-lint")

    use("sbdchd/neoformat")
    use("nvim-lua/popup.nvim")
    use("nvim-lua/plenary.nvim")
    use("nvim-telescope/telescope.nvim")
        use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }
    use 'nvim-treesitter/nvim-treesitter-context'
    use {"nvim-telescope/telescope-fzf-native.nvim", run = "make"}
    use("nvim-treesitter/playground")
    use("kyazdani42/nvim-tree.lua")
    use("christoomey/vim-tmux-navigator")
    use({"glepnir/lspsaga.nvim", branch = "main"})
    use("onsails/lspkind.nvim")
    use("gpanders/editorconfig.nvim")
    --
    -- use("mfussenegger/nvim-dap")
    -- use("rcarriga/nvim-dap-ui")
    -- use("theHamsta/nvim-dap-virtual-text")
    -- use {
    --   'glacambre/firenvim',
    --   run = function() vim.fn['firenvim#install'](0) end
    -- }

    use("ThePrimeagen/harpoon")

    use("edeneast/nightfox.nvim")
    use {
        'nvim-lualine/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }
end)
