local wezterm = require("wezterm")
return {
	font = wezterm.font("JetBrains Mono", {}),
	font_size = 12,
	color_scheme = "Oxocarbon Dark (Gogh)",
	window_background_opacity = 0.5,
	enable_scroll_bar = true,
	use_fancy_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	window_decorations = "NONE",
	keys = {
		-- This will create a new split
		{
			key = "|",
			mods = "CTRL|SHIFT",
			action = wezterm.action.SplitPane({
				direction = "Left",
				size = { Percent = 50 },
			}),
		},

		{
			key = "-",
			mods = "CTRL",
			action = wezterm.action.SplitPane({
				direction = "Down",
				size = { Percent = 50 },
			}),
		},
		{
			key = "w",
			mods = "CTRL",
			action = wezterm.action.CloseCurrentPane({ confirm = true }),
		},
	},
}
