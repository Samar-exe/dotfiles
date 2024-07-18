---------------------------------------------
-- Awesome theme which follows xrdb config --
--   by Yauhen Kirylau                    --
---------------------------------------------
local gears = require("gears")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local rnotification = require("ruled.notification")
local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()
local gdebug = require("gears.debug")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

-- inherit default theme
local theme = dofile(themes_path .. "default/theme.lua")
-- load vector assets' generators for this theme

theme.font = "MesloLGL 12"

theme.bg_normal = xrdb.background
theme.bg_focus = xrdb.color12
theme.bg_urgent = xrdb.color9
theme.bg_minimize = xrdb.color8
theme.bg_systray = theme.bg_normal

theme.fg_normal = xrdb.foreground
theme.fg_focus = theme.bg_normal
theme.fg_urgent = theme.bg_normal
theme.fg_minimize = theme.bg_normal

theme.useless_gap = dpi(10)
theme.border_width = dpi(2)
theme.border_color_normal = xrdb.color0
theme.border_color_active = xrdb.color11
theme.border_color_marked = xrdb.color10

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
theme.taglist_spacing = 20
theme.taglist_bg_focus = xrdb.color11
theme.taglist_bg_empty = "#000000"
theme.taglist_bg_urgent = "#ff0000"
theme.taglist_bg_occupied = xrdb.color3
theme.taglist_shape = gears.shape.circle
theme.taglist_shape_border_color = theme.border_normal
theme.taglist_shape_border_width = theme.border_width

theme.tooltip_fg = theme.fg_normal
theme.tooltip_bg = theme.bg_normal

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_bg_normal = xrdb.background
theme.menu_fg_normal = xrdb.foreground
theme.menu_bg_focus = xrdb.color3
theme.menu_fg_focus = xrdb.color12
theme.menu_height = dpi(50)
theme.menu_width = dpi(150)
theme.menu_submenu = ">"
theme.wibar_bg = xrdb.color0
theme.bg_systray = xrdb.color3
theme.systray_icon_spacing = 0
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Recolor Layout icons:
theme = theme_assets.recolor_layout(theme, theme.fg_normal)

-- Recolor titlebar icons:
--
local function darker(color_value, darker_n)
	local result = "#"
	for s in color_value:gmatch("[a-fA-F0-9][a-fA-F0-9]") do
		local bg_numeric_value = tonumber("0x" .. s) - darker_n
		if bg_numeric_value < 0 then
			bg_numeric_value = 0
		end
		if bg_numeric_value > 255 then
			bg_numeric_value = 255
		end
		result = result .. string.format("%2.2x", bg_numeric_value)
	end
	return result
end
theme = theme_assets.recolor_titlebar(theme, theme.fg_normal, "normal")
theme = theme_assets.recolor_titlebar(theme, darker(theme.fg_normal, -60), "normal", "hover")
theme = theme_assets.recolor_titlebar(theme, xrdb.color1, "normal", "press")
theme = theme_assets.recolor_titlebar(theme, theme.fg_focus, "focus")
theme = theme_assets.recolor_titlebar(theme, darker(theme.fg_focus, -60), "focus", "hover")
theme = theme_assets.recolor_titlebar(theme, xrdb.color1, "focus", "press")

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- Generate Awesome icon:

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

-- Try to determine if we are running light or dark colorscheme:
local bg_numberic_value = 0
for s in theme.bg_normal:gmatch("[a-fA-F0-9][a-fA-F0-9]") do
	bg_numberic_value = bg_numberic_value + tonumber("0x" .. s)
end
local is_dark_bg = (bg_numberic_value < 383)
-- Generate wallpaper:
theme.wallpaper = "/home/samar/Downloads/Pics/oxo-anime.jpg"
-- Set different colors for urgent notifications.
rnotification.connect_signal("request::rules", function()
	rnotification.append_rule({
		rule = { urgency = "critical" },
		properties = { bg = "#ff0000", fg = "#ffffff" },
	})
end)

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
