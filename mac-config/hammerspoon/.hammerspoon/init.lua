require("hs.ipc") -- enables the `hs` CLI: hs -c "hs.reload()"

-- Autoclicker: toggle with cmd+alt+ctrl+C, clicks wherever the mouse currently is.
-- ponytail: fixed interval, no UI. Add a config/menubar if you need per-app rates.
local INTERVAL = 0.01 -- seconds between clicks
local timer = nil

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "C", function()
	if timer then
		timer:stop()
		timer = nil
		hs.alert.show("Autoclicker off")
	else
		timer = hs.timer.doEvery(INTERVAL, function()
			hs.eventtap.leftClick(hs.mouse.absolutePosition())
		end)
		hs.alert.show("Autoclicker on")
	end
end)

-- Auto-reload on config change. Resolves the stow symlink so it watches the real dotfiles dir.
local watchDir = hs.fs.pathToAbsolute(hs.configdir .. "/init.lua"):gsub("/[^/]+$", "")
configWatcher = hs.pathwatcher
	.new(watchDir, function(files)
		for _, f in ipairs(files) do
			if f:sub(-4) == ".lua" then
				hs.reload()
			end
		end
	end)
	:start()
hs.alert.show("Hammerspoon config loaded")
