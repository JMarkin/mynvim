function post_hook(buf, win)
    print(buf)
    print(win)
end

require("goto-preview").setup({
    default_mappings = true,
    -- debug = true,
    -- post_open_hook = post_hook,
})
