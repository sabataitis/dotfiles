return {
    "VonHeikemen/lsp-zero.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        {
            'hrsh7th/nvim-cmp',
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                'L3MON4D3/LuaSnip'
            },
        },
    },
    config = function()
        local lsp_zero = require('lsp-zero');

        lsp_zero.on_attach(function(_, bufnr)
            lsp_zero.default_keymaps({ buffer = bufnr })
        end);
        vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)

        require('mason').setup {}
        require('mason-lspconfig').setup()

        local lspconfig = require('lspconfig');

        lspconfig.tsserver.setup{}
        lspconfig.eslint.setup{}
        lspconfig.clangd.setup{}

        lspconfig.kotlin_language_server.setup{}

        lspconfig.sqls.setup{
            settings = {
                sqls = {
                    connections = {
                        {
                            driver = 'postgresql',
                            dataSourceName = 'host=127.0.0.1 port=5432 user=postgres dbname=localdb sslmode=disable',
                        },
                    },
                },
            },

        }

        local cmp = require('cmp')
        local cmp_action = require('lsp-zero').cmp_action();

        cmp.setup {
            mapping = cmp.mapping.preset.insert({
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<Tab>'] = cmp_action.luasnip_supertab(),
                ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
            }),
        }
    end,
}
