return {
    'echasnovski/mini.nvim',
    version = false,
    config = function ()
        -- pairs
        require('mini.pairs').setup()
        -- highlight word under cursor
        require('mini.cursorword').setup()
        -- comment
        require('mini.comment').setup()
    end
}
