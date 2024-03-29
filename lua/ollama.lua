local Form = require("nui-form")

local fn = require("funcs")

local M = {}

M.toggle = function()
    local form = Form:new({
        on_close = function() end,
        on_submit = function(state)
            local gen = require("gen")
            local id = state.type[1].id

            local prompt = fn.switch(id, {
                ["chat"] = function()
                    return state.chat
                end,
                ["ask"] = function()
                    return "Regarding the following text:\n" .. state.prompt .. "\n" .. state.question
                end,
                ["enhance-grammar"] = function()
                    return "Modify the following text to improve grammar and spelling, just output the final text in English without additional quotes around it:\n"
                        .. state.prompt
                end,
                ["enhance-wording"] = function()
                    return "Modify the following text to use better wording, just output the final text without additional quotes around it:\n"
                        .. state.prompt
                end,
                ["make-concise"] = function()
                    return "Modify the following text to make it as simple and concise as possible, just output the final text without additional quotes around it:\n"
                        .. state.prompt
                end,
                ["generate-simple-description"] = function()
                    return "Provide a simple and concise description of the following code:\n" .. state.prompt
                end,
                ["generate-detailed-description"] = function()
                    return "Provide a detailed description of the following code:\n" .. state.prompt
                end,
                ["suggest-better-naming"] = function()
                    return "Take all variable and function names, and provide only a list with suggestions with improved naming:\n"
                        .. state.prompt
                end,
                ["review-code"] = function()
                    return "Review the following code and make concise suggestions, only output the result in format:\n```"
                        .. vim.bo.filetype
                        .. "\n"
                        .. state.prompt
                        .. "\n```"
                end,
                ["simplify-code"] = function()
                    return "Simplify the following code, only output the result in format:\n```"
                        .. vim.bo.filetype
                        .. "\n"
                        .. state.prompt
                        .. "\n```"
                end,
                ["improve-code"] = function()
                    return "Improve the following code, only output the result in format:\n```"
                        .. vim.bo.filetype
                        .. "\n"
                        .. state.prompt
                        .. "\n```"
                end,
                ["tests"] = function()
                    return "Write test on different cases, only output the result in format:\n```"
                        .. vim.bo.filetype
                        .. "\n"
                        .. state.prompt
                        .. "\n```"
                end,
                ["docstring"] = function()
                    return "Write docstring using google style, only output the result in format:\n```"
                        .. vim.bo.filetype
                        .. "\n"
                        .. state.prompt
                        .. "\n```"
                end,
            })

            print(1, prompt)

            gen.exec({ prompt = prompt })
        end,
    })

    local register = vim.fn.getreg('"')

    if fn.in_visual_mode() then
        register = fn.get_visual()
        fn.exit_visual()
    end

    form:set_content(
        form.select({
            height = 10,
            focus = true,
            key = "type",
            label = "Hey, Ollama, I'd like to…",
            data = {
                { text = "chit-chat", id = "chat" },
                {
                    text = "ask regarding the following text",
                    id = "ask",
                },
                {
                    text = "modify the following text to improve grammar and spelling",
                    id = "enhance-grammar",
                },
                {
                    text = "modify the following text to use better wording",
                    id = "enhance-wording",
                },
                {
                    text = "modify the following text to make it as simple and concise as possible",
                    id = "make-concise",
                },
                {
                    text = "write test",
                    id = "tests",
                },
                {
                    text = "write docstring",
                    id = "docstring",
                },
                {
                    text = "generate a simple and concise description of the following code",
                    id = "generate-simple-description",
                },
                {
                    text = "generate a detailed description of the following code",
                    id = "generate-detailed-description",
                },
                {
                    text = "use better names for all provided variables and functions",
                    id = "suggest-better-naming",
                },
                {
                    text = "review the following code and make concise suggestions",
                    id = "review-code",
                },
                {
                    text = "simplify the following code",
                    id = "simplify-code",
                },
                {
                    text = "improve the following code",
                    id = "improve-code",
                },
            },
            default_value = { "chat" },
        }),
        form.text_input({
            height = 6,
            key = "chat",
            icon = "󰭻",
            label = "Chat",
            hidden = function(state)
                local id = state.type[1].id
                return not (id == "chat")
            end,
        }),
        form.text_input({
            height = 6,
            key = "question",
            icon = "",
            label = "Question",
            hidden = function(state)
                local id = state.type[1].id
                return not (id == "ask")
            end,
        }),
        form.text_input({
            height = 16,
            key = "prompt",
            icon = "",
            label = "Code/Text",
            default_value = register,
            filetype = vim.bo.filetype,
            hidden = function(state)
                local id = state.type[1].id
                return id == "chat"
            end,
        }),
        form.footer()
    )

    form:open()
end

return M
