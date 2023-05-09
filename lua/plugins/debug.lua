local is_not_mini = require("custom.funcs").is_not_mini
local M = {}
M.python_attach = function(options)
    local dap = require("dap")
    options = {
        host = options.host or "0.0.0.0",
        port = options.port or 5678,
        remote_root = options.remote_root or "/app",
    }
    local host = options.host -- This should be configured for remote debugging if your SSH tunnel is setup.
    -- You can even make nvim responsible for starting the debugpy server/adapter:
    --  vim.fn.system({"${some_script_that_starts_debugpy_in_your_container}", ${script_args}})
    local pythonAttachAdapter = {
        type = "server",
        host = host,
        port = options.port,
    }
    local pythonAttachConfig = {
        type = "python",
        request = "attach",
        connect = {
            port = options.port,
            host = host,
        },
        mode = "remote",
        name = "Remote Attached Debugger",
        cwd = vim.fn.getcwd(),
        pathMappings = {
            {
                localRoot = vim.fn.getcwd(), -- Wherever your Python code lives locally.
                remoteRoot = options.remote_root, -- Wherever your Python code lives in the container.
            },
        },
    }
    local session = dap.attach(pythonAttachAdapter, pythonAttachConfig)
    if session == nil then
        io.write("Error launching adapter")
    end
    require("dapui").open()
end

M.keymaps = function()
    vim.api.nvim_create_user_command("PythonAttach", function(opts)
        M.python_attach({ remote_root = opts.fargs[1] or vim.fn.getcwd() })
    end, {
        nargs = "*",
        complete = "file_in_path",
    })

    vim.keymap.set("n", "<leader>dc", function()
        require("dapui").close()
    end, { desc = "DapUIClose" })

    vim.keymap.set("n", "<leader>do", function()
        require("dapui").open()
    end, { desc = "DapUIOpen" })

    vim.keymap.set("n", "<leader>dd", function()
        require("dapui").toggle()
    end, { desc = "DapUIToggle" })

    vim.keymap.set("n", "<F5>", function()
        require("dap").continue()
    end)
    vim.keymap.set("n", "<F10>", function()
        require("dap").step_over()
    end)
    vim.keymap.set("n", "<F11>", function()
        require("dap").step_into()
    end)
    vim.keymap.set("n", "<F12>", function()
        require("dap").step_out()
    end)
    vim.keymap.set("n", "<Leader>db", function()
        require("dap").toggle_breakpoint()
    end, {
        desc = "ToggleBreakpoint",
    })
    vim.keymap.set("n", "<Leader>dB", function()
        require("dap").set_breakpoint()
    end, {
        desc = "SetBreakpoint",
    })
    vim.keymap.set("n", "<Leader>dlp", function()
        require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
    end)
    vim.keymap.set("n", "<Leader>dr", function()
        require("dap").repl.open()
    end, {
        desc = "Repl",
    })
    vim.keymap.set("n", "<Leader>dl", function()
        require("dap").run_last()
    end)
    vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
        require("dap.ui.widgets").hover()
    end, {
        desc = "DapHover",
    })
    vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
        require("dap.ui.widgets").preview()
    end, {
        desc = "DapPreview",
    })
    vim.keymap.set("n", "<Leader>df", function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.frames)
    end, { desc = "DapFrames" })
    vim.keymap.set("n", "<Leader>ds", function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.scopes)
    end, { desc = "DapScopes" })

    vim.keymap.set("n", "<Leader>de", function()
        require("dapui").float_element()
    end, { desc = "DapUIFloatElement" })

    vim.keymap.set("v", "<C-e>", require("dapui").eval, { desc = "DapEval" })

    vim.keymap.set("n", "]d", require("goto-breakpoints").next, {})
    vim.keymap.set("n", "[d", require("goto-breakpoints").prev, {})
    vim.keymap.set("n", "]S", require("goto-breakpoints").stopped, {})
end

M.plugin = {
    "rcarriga/nvim-dap-ui",
    cond = is_not_mini,
    dependencies = {
        {
            "mfussenegger/nvim-dap",
        },
        {
            "theHamsta/nvim-dap-virtual-text",
            opts = {},
            dependencies = "nvim-treesitter",
        },
        "ofirgall/goto-breakpoints.nvim",
        {
            "LiadOz/nvim-dap-repl-highlights",
            dependencies = "nvim-treesitter",
        },
    },
    keys = "<leader>d",
    cmd = { "PythonAttach" },
    config = function()
        M.keymaps()
        local dap, dapui = require("dap"), require("dapui")
        dapui.setup()
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end

        require("nvim-dap-repl-highlights").setup()
    end,
}

return M
