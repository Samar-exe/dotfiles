local xresources = require("beautiful.xresources")
local xrdb = xresources.get_current_theme()
local awful = require("awful")
local beautiful = require("beautiful")
local mod = require("binds.mod")
local wibox = require("wibox")
local modkey = mod.modkey
local gears = require("gears")
return function(s)
	-- Create a taglist widget
	return awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = {
			-- Left-clicking a tag changes to it.
			awful.button(nil, 1, function(t)
				t:view_only()
			end),
			-- Mod + Left-clicking a tag sends the currently focused client to it.
			awful.button({ modkey }, 1, function(t)
				if client.focus then
					client.focus:move_to_tag(t)
				end
			end),
			-- Right-clicking a tag makes its contents visible in the current one.
			awful.button(nil, 3, awful.tag.viewtoggle),
			-- Mod + Right-clicking a tag makes the currently focused client visible
			-- in it.
			awful.button({ modkey }, 3, function(t)
				if client.focus then
					client.focus:toggle_tag(t)
				end
			end),
			-- Mousewheel scrolling cycles through tags.
			awful.button(nil, 4, function(t)
				awful.tag.viewprev(t.screen)
			end),
			awful.button(nil, 5, function(t)
				awful.tag.viewnext(t.screen)
			end),
		},
		widget_template = {
			id = "background_role",
			forced_width = 17,
			widget = wibox.container.background,
			create_callback = function(widget, tag, _, _)
				widget:connect_signal("mouse::enter", function()
					widget.bg = xrdb.color1
				end)
				widget:connect_signal("mouse::leave", function()
					widget.bg = beautiful.taglist_shape_border_color
				end)
			end,
		},
	})
end
