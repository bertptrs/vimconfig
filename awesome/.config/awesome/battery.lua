local naughty = require("naughty")
local beautiful = require("beautiful")
local vicious = require("vicious")
local wibox = require("wibox")
local pairs = pairs

module("battery")

-- Battery (based on http://awesome.naquadah.org/wiki/Gigamo_Battery_Widget)
-- Edited by TobiasKappe

local limits = { {25, 5},
                 {12, 3},
                 { 7, 1},
                  {0}}

local function getnextlim (num)
    for ind, pair in pairs(limits) do
        lim = pair[1]; step = pair[2]; nextlim = limits[ind+1][1] or 0
        if num > nextlim then
            repeat
                lim = lim - step
            until num > lim
            if lim < nextlim then
                lim = nextlim
            end
            return lim
        end
    end
end

function batclosure ()
    local nextlim = limits[1][1]
    return function (_, args)
        local prefix = "⚡"
        local state, charge = args[1], args[2]
        if not charge then return end

        if state == "−" then
            dirsign = "↓"
            prefix = "Bat:"
            if charge <= nextlim then
                naughty.notify({
                    title = "⚡ Waarschuwing! ⚡",
                    text = "Accu bijna leeg ( ⚡ " ..charge.."%)!",
                    timeout = 7,
                    position = "bottom_right",
                    fg = beautiful.fg_focus,
                    bg = beautiful.bg_focus
                })
                nextlim = getnextlim(charge)
            end
        elseif state == "+" then
            dirsign = "↑"
            nextlim = limits[1][1]
        else
            return " ⚡ "
        end
        if dir ~= 0 then charge = charge.."%" end
        return " "..prefix.." "..dirsign..charge..dirsign.." "
    end
end

local widget = wibox.widget.textbox()
vicious.register(widget, vicious.widgets.bat, batclosure(), 31, "BAT0")

return widget
