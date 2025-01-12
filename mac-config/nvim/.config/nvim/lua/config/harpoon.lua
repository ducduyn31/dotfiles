local harpoon = require("harpoon")

-- Setup Harpoon
harpoon:setup()

-- Setup Keybinds for Harpoon
vim.keymap.set("n", "<leader>ha", function()
	harpoon:list():add()
end, { desc = "[A]dd file to [H]arpoon buffer" })
vim.keymap.set("n", "<leader>m", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Show buffer [M]enu" })

vim.keymap.set("n", "<leader>1", function()
	harpoon:list():select(1)
end, { desc = "Switch to buffer slot 1" })
vim.keymap.set("n", "<leader>2", function()
	harpoon:list():select(2)
end, { desc = "Switch to buffer slot 2" })
vim.keymap.set("n", "<leader>3", function()
	harpoon:list():select(3)
end, { desc = "Switch to buffer slot 3" })
vim.keymap.set("n", "<leader>4", function()
	harpoon:list():select(4)
end, { desc = "Switch to buffer slot 4" })
