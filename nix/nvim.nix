{ config, pkgs, inputs, ... }:

let
  unstable = import inputs.pkgs-unstable { inherit (pkgs.stdenv.targetPlatform) system; };
in
{
  programs.neovim = {
    package = unstable.neovim-unwrapped;
    enable = true;
    vimAlias = true;
    withPython3 = true;
    withRuby = false;

    extraPackages = with pkgs; [
      fzf
      silver-searcher
      rnix-lsp
      rls
      ripgrep
      nodePackages.pyright
      clang-tools
    ];

    plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-lspconfig;
#        type = "lua";
        config = ''
          lua <<EOF
          local lsp = require'lspconfig'
          lsp.rls.setup{}
          lsp.rnix.setup{}
          lsp.pyright.setup{}
          lsp.clangd.setup{}
          EOF
        '';
      }
      lsp_extensions-nvim
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-emoji
      cmp-cmdline
      {
        plugin = nvim-cmp;
#        type = "lua";
        config = ''
          lua <<EOF
          local cmp = require'cmp'
          cmp.setup{
            sources = {
              { name = 'spell' },
              { name = 'buffer' },
              { name = 'nvim_lsp' },
              { name = 'path' },
              { name = 'cmdline' },
              { name = 'emoji' },
            },
            mapping = {
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }),
            },
          }
          EOF
          '';
      }
      {
        plugin = nvim-autopairs;
#        type = "lua";
        config = ''
          lua <<EOF
          require'nvim-autopairs'.setup{}
          EOF
          '';
      }
      vim-commentary

      rust-vim vim-fish vim-nix

      {
        plugin = telescope-nvim;
#        type = "lua";
        config = ''
          lua <<EOF
          local telescope = require'telescope'
          telescope.setup{}
          telescope.load_extension('fzf')

          local opts = { noremap = true }
          vim.api.nvim_set_keymap("n","<C-p>", ":Telescope find_files<CR>", opts)
          vim.api.nvim_set_keymap("n","<C-t>", ":Telescope<CR>", opts)
          vim.api.nvim_set_keymap("n","<C-g>", ":Telescope live_grep<CR>", opts)
          vim.api.nvim_set_keymap("n","<leader>t", ":Telescope help_tags<CR>", opts)
          EOF
        '';
      }
      popup-nvim plenary-nvim telescope-nvim nvim-treesitter
      telescope-fzf-native-nvim playground 
      vim-tmux-navigator

      {
        plugin = harpoon;
#        type = "lua";
        config = ''
          lua <<EOF
          local silent = { noremap = true, silent = true }
          local noremap = { noremap = true }
          vim.api.nvim_set_keymap("n","<leader>m", ":lua require('harpoon.mark').add_file()<CR>", silent)
          vim.api.nvim_set_keymap("n","<C-h>", ":lua require('harpoon.ui').toggle_quick_menu()<CR>", noremap)
          vim.api.nvim_set_keymap("n","<leader>h", ":lua require('harpoon.ui').toggle_quick_menu()<CR>", noremap)
          vim.api.nvim_set_keymap("n","<C-j>", ":lua require('harpoon.ui').nav_file(1)<CR>", silent)
          vim.api.nvim_set_keymap("n","<C-k>", ":lua require('harpoon.ui').nav_file(2)<CR>", silent)
          vim.api.nvim_set_keymap("n","<C-l>", ":lua require('harpoon.ui').nav_file(3)<CR>", silent)
          vim.api.nvim_set_keymap("n","<C-;>", ":lua require('harpoon.ui').nav_file(4)<CR>", silent)
          vim.cmd([[
            command Mark :lua require('harpoon.mark').add_file()
            command ViewMark :lua require('harpoon.ui').toggle_quick_menu()
          ]])
          EOF
        '';
      }

      {
        plugin = nvim-tree-lua;
#        type = "lua";
        config = ''
          lua <<EOF
          vim.api.nvim_set_keymap("n","<C-n>", ":NvimTreeToggle<CR>", { noremap = true })
          require'nvim-tree'.setup {}
          EOF
          '';
      }

      nord-nvim nightfox-nvim

      vim-devicons
    ];

    extraConfig = ''
      set expandtab
      set tabstop=2
      set softtabstop=2
      set shiftwidth=2
      set number
      set list
      set noswapfile
      set encoding=UTF-8

      colorscheme nightfox

      let mapleader=" "
    '';
  };
}
