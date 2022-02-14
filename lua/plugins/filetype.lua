require("filetype").setup({
	overrides = {
		extensions = {
			dockerfile = "dockerfile",
		},
        complex = {
            ["*%.nginx"] = "nginx",
            [".*nginx.*%.conf"] = "nginx",
            [".*nginx/.*/conf.*"] = "nginx",
            [".*/nginx/.*%.conf"] = "nginx",
            ["/srv/nginx/conf%.d/locations/.*"] = "nginx",
        }
	},
})
