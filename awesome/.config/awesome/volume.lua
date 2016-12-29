-- Volume widget

local vicious = require("vicious")
local wibox = require("wibox")
local awful = require("awful")

module("volume")

local widget = wibox.widget.textbox()

local function volume_callback (_, args)
	local muted = args[2]
	local volume = args[1]

	if muted == "♫" then
		return "🔊" .. volume .. "%"
	else
		return "🔇"
	end
end

local function volume_command (command)
	local step = "5%"
	local base = "amixer set Master "

	if command == "mute" then
		awful.util.spawn(base .. "toggle")
	else
		awful.util.spawn(base .. step .. command)
	end

	vicious.force({widget})
end


widget.increase = function()
	volume_command("+")
end

widget.decrease = function()
	volume_command("-")
end

widget.mute = function()
	volume_command("mute")
end

vicious.register(widget, vicious.widgets.volume, volume_callback, 60, "Master")

return widget
