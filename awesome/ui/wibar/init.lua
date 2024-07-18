local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local module = require(... .. ".module")

return function(s)
	s.mypromptbox = awful.widget.prompt() -- Create a promptbox.

	-- Create the wibox
	s.mywibox = awful.wibar({
		position = "top",
		screen = s,
		widget = {
			layout = wibox.layout.align.horizontal,
			expand = "none",
			-- Left widgets.
			{
				layout = wibox.layout.fixed.horizontal,
				{
					{
						module.taglist(s),
						left = 15,
						right = 15,
						widget = wibox.container.margin,
					},
					bg = "#343536",
					shape = gears.shape.rounded_bar,
					widget = wibox.container.background,
				},
				s.mypromptbox,
			},
			-- Middle widgets.
			--
			wibox.widget.textclock(), -- Create a textclock widget.
			-- Right widgets.
			{
				layout = wibox.layout.fixed.horizontal,
				{
					wibox.widget.systray(),
					right = 15,
					widget = wibox.container.margin,
				},

				{
					{
						module.battery,
						left = 10,
						right = 10,
						widget = wibox.container.margin,
					},
					shape = gears.shape.rounded_bar,
					bg = "#343536",
					widget = wibox.container.background,
				},
			},
		},
	})
end
