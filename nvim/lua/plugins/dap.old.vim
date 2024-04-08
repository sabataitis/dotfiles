return {
    "mfussenegger/nvim-dap",

    dependencies = {

        -- fancy UI for the debugger
        {
            "rcarriga/nvim-dap-ui",
            -- stylua: ignore
            keys = {
                { "<leader>du", function() require("dapui").toggle({}) end,  desc = "Dap UI" },
                { "<leader>de", function() require("dapui").eval() end,      desc = "Eval",  mode = { "n", "v" } },
            },
            opts = {},
            config = function(_, opts)
                -- setup dap config by VsCode launch.json file
                -- require("dap.ext.vscode").load_launchjs()
                local dap = require("dap")
                local dapui = require("dapui")
                dapui.setup(opts)
                dap.listeners.after.event_initialized["dapui_config"] = function()
                    dapui.open({})
                end
                dap.listeners.before.event_terminated["dapui_config"] = function()
                    dapui.close({})
                end
                dap.listeners.before.event_exited["dapui_config"] = function()
                    dapui.close({})
                end
            end,
        },

        -- virtual text for the debugger
        {
            "theHamsta/nvim-dap-virtual-text",
            opts = {},
        },

        -- mason.nvim integration
        {
            "jay-babu/mason-nvim-dap.nvim",
            dependencies = "mason.nvim",
            cmd = { "DapInstall", "DapUninstall" },
            opts = {
                automatic_installation = false,
                handlers = {},
                ensure_installed = {
                    "node2",
                    "codellbb",
                },
            },
        },
    },

    -- stylua: ignore
    keys = {
        { "<leader>db", function() require("dap").toggle_breakpoint() end,                                    desc = "Toggle Breakpoint" },
        { "<leader>dc", function() require("dap").continue() end,                                             desc = "Continue" },
        { "<leader>di", function() require("dap").step_into() end,                                            desc = "Step Into" },
        { "<leader>do", function() require("dap").step_out() end,                                             desc = "Step Out" },
        { "<leader>dt", function() require("dap").terminate() end,                                            desc = "Terminate" },
        { "<leader>dw", function() require("dap.ui.widgets").hover() end,                                     desc = "Widgets" },
        { "<leader>dq", function() require("dap").clear_breakpoints() end,                                    desc = "Clear breakpoints" },
    },

    config = function()
        local dap = require("dap")

        -- dap.adapters.gdb = {
        --     type = "executable",
        --     command = "gdb",
        --     args = { "-i", "dap" }
        -- }
        --
        -- dap.configurations.c = {
        --     {
        --         name = 'Launch',
        --         type = "gdb",
        --         request = 'launch',
        --         args = function()
        --             local args_string = vim.fn.input('args: ')
        --             return vim.split(args_string, " +")
        --         end,
        --         program = function()
        --             return vim.fn.input('path: ', vim.fn.getcwd() .. '/', 'file')
        --         end,
        --         cwd = '${workspaceFolder}',
        --         stopOnEntry = false,
        --     },
        -- }

        dap.configurations.javascript = {
            {
                type = "node2",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                cwd = "${workspaceFolder}",
            }

        }
    end
}
