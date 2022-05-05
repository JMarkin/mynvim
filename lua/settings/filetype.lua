vim.filetype.add({
    extension = {
        dockerfile = "dockerfile",
        lvimrc = "lua",
    },
    pattern = {
        ["*%.nginx"] = "nginx",
        [".*nginx.*%.conf"] = "nginx",
        [".*nginx/.*/conf.*"] = "nginx",
        [".*/nginx/.*%.conf"] = "nginx",
        ["/srv/nginx/conf%.d/locations/.*"] = "nginx",
    },
})
