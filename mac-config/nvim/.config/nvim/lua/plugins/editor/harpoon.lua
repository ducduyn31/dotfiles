return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		opts = {
			settings = {
				save_on_toggle = true,
			},
		},
		keys = function()
			local keys = {
				{
					"<leader>ha",
					function()
						require("harpoon"):list():add()
					end,
					desc = "[H]arpoon [A]dd",
				},
				{
					"<leader>m",
					function()
						local harpoon = require("harpoon")
						harpoon.ui:toggle_quick_menu(harpoon:list())
					end,
					desc = "Toggole Harpoon [M]enu",
				},
			}

			for i = 1, 5 do
				table.insert(keys, {
					"<leader>" .. i,
					function()
						require("harpoon"):list():select(i)
					end,
					desc = "Harpoon to File " .. i,
				})
			end
			return keys
		end,
	},
}
