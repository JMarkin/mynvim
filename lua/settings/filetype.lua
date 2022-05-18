vim.filetype.add({
    extension = {
        dockerfile = "dockerfile",
    },
    pattern = {
        ["*%.nginx"] = "nginx",
        [".*nginx.*%.conf"] = "nginx",
        [".*nginx/.*/conf.*"] = "nginx",
        [".*/nginx/.*%.conf"] = "nginx",
        ["/srv/nginx/conf%.d/locations/.*"] = "nginx",
    },
})
