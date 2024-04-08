return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            'williamboman/mason.nvim', -- Automatically install LSPs to stdpath for neovim
            'williamboman/mason-lspconfig.nvim', -- ibid
            {
                "hrsh7th/nvim-cmp",
                dependencies = {
                    'hrsh7th/cmp-nvim-lsp',
                    'L3MON4D3/LuaSnip',
                    'saadparwaiz1/cmp_luasnip'
                }
            },
        },
        config = function()
            require('mason').setup {}
            require('mason-lspconfig').setup()


            vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
            vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

            local on_attach = function(_, bufnr)
                local opts = { silent = true, buffer = bufnr }

                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<space>f", function()
                    vim.lsp.buf.format({ async = true })
                end, opts)
            end

            local lspconfig = require("lspconfig")
            local capapabilities = require('cmp_nvim_lsp').default_capabilities()

            lspconfig['lua_ls'].setup{
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }
                        }
                    }
                },
                on_attach = on_attach,
                capabilities = capapabilities
            }

            lspconfig['tsserver'].setup{
                on_attach = on_attach,
                capabilities = capapabilities,
                root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json")
            }

            lspconfig['angularls'].setup{
                on_attach = on_attach,
                capabilities = capapabilities,
                root_dir = lspconfig.util.root_pattern("angular.json")
            }

            lspconfig['eslint'].setup{
                on_attach = on_attach,
                capabilities = capapabilities,
                root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json")
            }

            for _, lsp in ipairs({ "html", "cssls", "tailwindcss" }) do
                lspconfig[lsp].setup {
                    on_attach = on_attach,
                    capabilities = capapabilities,
                }
            end

            -- cmp setup
            local cmp = require('cmp')
            local luasnip = require('luasnip')

            local cmp_mappings = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end
                    )
                })

            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp_mappings,
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }
                }
            }
        end,
    },
}
