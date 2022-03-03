require("filetype").setup({
	overrides = {
		extensions = {
			dockerfile = "dockerfile",
            lvimrc = "lua"
		},
		complex = {
			["*%.nginx"] = "nginx",
			[".*nginx.*%.conf"] = "nginx",
			[".*nginx/.*/conf.*"] = "nginx",
			[".*/nginx/.*%.conf"] = "nginx",
			["/srv/nginx/conf%.d/locations/.*"] = "nginx",
		},
	},
})
