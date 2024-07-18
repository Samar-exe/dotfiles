local awful = require("awful")
-- local wibox = require("wibox")
-- local gears = require("gears")
local module = require("module")
return function(s)
	-- Create the wibox
	s.mywibox = awful.wibar({
		position = "right",
		height = 300,
		width = 250,
		opacity = 0.9,
		align = "top",
		x = 200,
		y = -40,
		border_width = 2,
		border_color = "#ffffff",
		screen = s,
		widget = {
			-- In the body 3 more widgets will be added using the awesomewm api. Im referring a lot to the docs sincce its tough to remember everything.

			-- The Image box widget
			-- The text Wiget/
			{
				widget:
			}
			-- The control widget
		},
	})
end
