return {
    "nvim-treesitter/nvim-treesitter",
    config = function ()
        require'nvim-treesitter.configs'.setup {
            ensure_installed = { "javascript", "typescript", "c", "lua", "vim", "html", "css" },
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
        }
    end
}
