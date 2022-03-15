local cmd = vim.cmd

local present, packer = pcall(require, "packer")

local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if not present then
	print("Cloning packer..")
	-- remove the dir before cloning
	-- vim.fn.delete(packer_path, "r")
	vim.fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		packer_path,
	})

	cmd("packadd packer.nvim")
	present, packer = pcall(require, "packer")

	if present then
		print("Packer cloned successfully.")
	else
		error("Couldn't clone packer !\nPacker path: " .. packer_path .. "\n" .. packer)
	end
end

packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "single" })
		end,
		prompt_border = "single",
	},
	git = {
		clone_timeout = 600, -- Timeout, in seconds, for git clones
	},
	auto_clean = false,
	compile_on_sync = true,
	auto_reload_compiled = true,
})

return packer
