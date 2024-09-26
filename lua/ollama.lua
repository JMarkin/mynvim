local n = require("nui-components")

local fn = require("funcs")
local gen = require("gen")

local OPTIONS = {
    CHAT = "chat",
    ISSUE = "issue",
    GRAMMAR = "gramamr",
    DOCSTRING = "docstring",
    REVIEW = "review",
    SIMPLIFY = "simplify",
    IMPROVE = "improve",
    TESTS = "tests",
    SQL = "sql",
}

local options = {
    n.option("chit-chat", { id = OPTIONS.CHAT }),
    n.option("issues", { id = OPTIONS.ISSUE }),
    n.separator("󰅪 code "),
    n.option("generate tests", { id = OPTIONS.TESTS }),
    n.option("generate docstring", { id = OPTIONS.DOCSTRING }),
    n.option("generate sql", { id = OPTIONS.SQL }),
    n.option("simplify the following code", { id = OPTIONS.SIMPLIFY }),
    n.option("improve the following code", { id = OPTIONS.IMPROVE }),
    n.option("review the following code and make concise suggestions", { id = OPTIONS.REVIEW }),
    n.separator("󰦨 text "),
    n.option("modify the following text to improve grammar and spelling", { id = OPTIONS.GRAMMAR }),
}

local get_prompt = function(state)
    return fn.switch(state.selected_option, {
        [OPTIONS.CHAT] = function()
            return state.chat
        end,
        [OPTIONS.GRAMMAR] = function()
            return "Modify the following text to improve grammar and spelling, just output the final text in English without additional quotes around it:\n"
                .. state.text
        end,
        [OPTIONS.ISSUE] = function()
            local content = table.concat(vim.api.nvim_buf_get_lines(vim.api.nvim_get_current_buf(), 0, -1, false), "\n")

            return "Provide more a simple and concise insight about the following issue, try to fix it\n"
                .. state.issue
                .. "\nin the following code\n```"
                .. vim.bo.filetype
                .. "\n"
                .. content
                .. "\n```"
        end,
        [OPTIONS.TESTS] = function()
            return "Write test on different cases, only output the result in format:\n```"
                .. vim.bo.filetype
                .. "\n"
                .. state.code
                .. "\n```"
        end,
        [OPTIONS.DOCSTRING] = function()
            return "Write docstring using google style, only output the result in format:\n```"
                .. vim.bo.filetype
                .. "\n"
                .. state.code
                .. "\n```"
        end,
        [OPTIONS.REVIEW] = function()
            return "Review the following code and make concise suggestions, only output the result in format:\n```"
                .. vim.bo.filetype
                .. "\n"
                .. state.code
                .. "\n```"
        end,
        [OPTIONS.SIMPLIFY] = function()
            return "Simplify the following code, only output the result in format:\n```"
                .. vim.bo.filetype
                .. "\n"
                .. state.code
                .. "\n```"
        end,
        [OPTIONS.IMPROVE] = function()
            return "Improve the following code, only output the result in format:\n```"
                .. vim.bo.filetype
                .. "\n"
                .. state.code
                .. "\n```"
        end,
        [OPTIONS.SQL] = function()
            return "Generate correct sql query by following text, only output result in format:\n```sql```"
                .. state.text
        end,
    })
end

local M = {}

M.toggle = function()
    if M.renderer then
        M.renderer:focus()
    end

    local register = vim.fn.getreg('"')
    if fn.in_visual_mode() then
        register = fn.get_visual()
        fn.exit_visual()
    end
    local diags = vim.diagnostic.get()
    vim.print(diags)

    local default_signal_value = {
        selected_option = "chat",
        select_size = 8,
        chat = "",
        question = "",
        text = register,
        code = register,
        diags = diags,
        issue = table.concat(
            fn.ireduce(diags, function(acc, diag)
                local range = string.format("%s-%s", diag.range["start"].line, diag.range["end"].line)
                table.insert(acc, string.format("%s on line range %s", diag.message, range))
                return acc
            end, {}),
            "\n"
        ),
    }
    local default_size = {
        width = 80,
        height = 40,
    }

    if M.last_signal_value then
        M.last_signal_value.text = default_signal_value.text
        M.last_signal_value.code = default_signal_value.code
        M.last_signal_value.diags = default_signal_value.diags
        M.last_signal_value.issue = default_signal_value.issue
    end

    local renderer = n.create_renderer(M.last_renderer_size or default_size)

    local signal = n.create_signal(M.last_signal_value or default_signal_value)

    local function close()
        renderer:close()
        M.renderer = nil
    end

    renderer:add_mappings({
        {
            mode = { "n" },
            key = "q",
            handler = close,
        },
        {
            mode = { "n", "i" },
            key = "<c-p>",
            handler = function()
                local state = signal:get_value()

                local prompt = get_prompt(state)
                gen.exec({ prompt = prompt })
                close()
            end,
        },
    })

    local body = n.rows(
        { flex = 1 },
        n.select({
            id = "type",
            size = signal.select_size,
            autofocus = true,
            border_label = "Hey, Ollama, I'd like to…",
            data = options,
            selected = signal.selected_option,
            on_select = function(node)
                signal.selected_option = node.id
            end,
            on_blur = function()
                signal.select_size = 1
            end,
            on_focus = function()
                signal.select_size = 8
            end,
        }),
        n.text_input({
            flex = 1,
            border_label = {
                text = "Issue",
                icon = "",
            },
            wrap = true,
            value = signal.issue,
            on_change = function(value)
                signal.issue = value
            end,
            hidden = signal.selected_option:map(function(value)
                return #diags == 0 or not (value == OPTIONS.ISSUE)
            end),
        }),
        n.text_input({
            flex = 1,
            id = "chat",
            border_label = {
                text = "Chat",
                icon = "󰭻",
            },
            value = signal.chat,
            on_change = function(value)
                signal.chat = value
            end,
            wrap = true,
            hidden = signal.selected_option:map(function(value)
                return not (value == OPTIONS.CHAT)
            end),
        }),
        n.text_input({
            flex = 2,
            id = "text",
            border_label = {
                text = "Text",
                icon = "󰦨",
            },
            value = signal.text,
            on_change = function(value)
                signal.text = value
            end,
            wrap = true,
            hidden = signal.selected_option:map(function(value)
                return not fn.isome({
                    OPTIONS.GRAMMAR,
                }, function(key)
                    return key == value
                end)
            end),
        }),
        n.text_input({
            flex = 1,
            id = "code",
            border_label = {
                text = "Code",
                icon = "",
            },
            value = signal.code,
            on_change = function(value)
                signal.code = value
            end,
            filetype = vim.bo.filetype,
            hidden = signal.selected_option:map(function(value)
                return not fn.isome({
                    OPTIONS.TESTS,
                    OPTIONS.DOCSTRING,
                    OPTIONS.REVIEW,
                    OPTIONS.IMPROVE,
                    OPTIONS.SIMPLIFY,
                    OPTIONS.SQL,
                }, function(key)
                    return key == value
                end)
            end),
        })
    )

    M.renderer = renderer
    renderer:render(body)
end

return M
