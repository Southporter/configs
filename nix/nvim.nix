{ config, pkgs, inputs, ... }:

let 
  unstable = import inputs.pkgs-unstable { inherit (pkgs.stdenv.targetPlatform) system; };
in
{
  programs.neovim = {
    # package = unstable.neovim-unwrapped;
    enable = true;
    vimAlias = true;
    withPython3 = true;
    withRuby = false;

    extraPackages = with pkgs; [
      fzf
      silver-searcher
      rnix-lsp
      terraform-ls
      ripgrep
      nodePackages.pyright
      clang-tools
      elmPackages.elm-language-server
      gopls
    ];

    plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-lspconfig;
#        type = "lua";
        config = ''
          lua <<EOF
          local lsp = require'lspconfig'
          lsp.rnix.setup{}
          lsp.pyright.setup{}
          lsp.clangd.setup{}
          lsp.terraformls.setup{}
          lsp.elmls.setup{}
          lsp.gopls.setup{}
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
      lsp_extensions-nvim
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-emoji
      cmp-cmdline
      cmp-conjure
      {
        plugin = nvim-cmp;
#        type = "lua";
        config = ''
          lua <<EOF
          local cmp_autopairs = require'nvim-autopairs.completion.cmp'
          local cmp = require'cmp'
          cmp.setup{
            sources = {
              { name = 'spell' },
              { name = 'buffer' },
              { name = 'nvim_lsp' },
              { name = 'treesitter'},
              { name = 'conjure'},
              { name = 'path' },
              { name = 'cmdline' },
              { name = 'emoji' },
            },
            mapping = {
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }),
              ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
              ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
              ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  local entry = cmp.get_selected_entry()
                  if not entry then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                  else
                    cmp.confirm()
                  end
                else
                  fallback()
                end
              end, {"i", "s", "c"}),
             },
             snippet = {
               expand = function(args)
                 require'luasnip'.lsp_expand(args.body)
               end,
             }
          }
          cmp.event:on(
            'confirm_done',
            cmp_autopairs.on_confirm_done()
            )
          EOF
          '';
      }
      vim-commentary

      vim-fish vim-nix vim-terraform vim-terraform-completion 
      vim-polyglot elm-vim

      {
        plugin = dart-vim-plugin;
        config = ''
          lua <<EOF
          require'lspconfig'.dartls.setup{}
          EOF
          '';
      }

      {
        plugin = zig-vim;
        config = ''
          lua <<EOF
          require'lspconfig'.zls.setup{}
          EOF
        '';
      }

      rust-vim 
      {
        plugin = rust-tools-nvim;
        config = ''
          lua <<EOF
          local nvim_lsp = require'lspconfig'

          local opts = {
              tools = { -- rust-tools options
                  autoSetHints = true,
                  inlay_hints = {
                      show_parameter_hints = false,
                      parameter_hints_prefix = "",
                      other_hints_prefix = "",
                  },
              },

              -- all the opts to send to nvim-lspconfig
              -- these override the defaults set by rust-tools.nvim
              -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
              server = {
                  -- on_attach is a callback called when the language server attachs to the buffer
                  on_attach = function(_, bufnr)
                                -- Hover actions
                                vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
                                -- Code action groups
                                vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
                              end,
                  settings = {
                      -- to enable rust-analyzer settings visit:
                      -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
                      ["rust-analyzer"] = {
                          -- enable clippy on save
                          checkOnSave = {
                              command = "clippy"
                          },
                      }
                  }
              },
          }

          require('rust-tools').setup(opts)
          EOF
        '';
      }

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
      popup-nvim plenary-nvim telescope-nvim
      {
        plugin = nvim-treesitter;
        type = "lua";
        config = ''
          require "nvim-treesitter.configs".setup {
            playground = {
              enable = true,
              disable = {},
              updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
              persist_queries = false, -- Whether the query persists across vim sessions
              keybindings = {
                toggle_query_editor = 'o',
                toggle_hl_groups = 'i',
                toggle_injected_languages = 't',
                toggle_anonymous_nodes = 'a',
                toggle_language_display = 'I',
                focus_language = 'f',
                unfocus_language = 'F',
                update = 'R',
                goto_node = '<cr>',
                show_help = '?',
              },
            },
            query_linter = {
              enable = true,
              use_virtual_text = true,
              lint_events = {"BufWrite", "CursorHold"},
            },
          }
        '';
      }
      telescope-fzf-native-nvim playground 
      vim-tmux-navigator

      {
        plugin = harpoon;
        type = "lua";
        config = ''
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
        '';
      }

      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
          vim.api.nvim_set_keymap("n","<C-n>", ":NvimTreeToggle<CR>", { noremap = true })
          require'nvim-tree'.setup {}
          '';
      }

      nord-nvim nightfox-nvim

      vim-devicons

      {
        plugin = conjure;
        config = ''
          lua <<EOF
          require'lspconfig'.clojure_lsp.setup{}
          EOF
        '';
      }

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
    '';
  };
}
