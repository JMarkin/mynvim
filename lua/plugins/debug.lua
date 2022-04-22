local M = {}
M.attach_python_debugger = function(options)
    local dap = require("dap")
    options = options or {
        host = "0.0.0.0",
        port = 5678,
        remote_root = "/app",
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

return M
