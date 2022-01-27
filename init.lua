local present, impatient = pcall(require, "impatient")
if not present then
   print("Impations not install run :PackerInstall")
end
require('settings')
require('plugins')
