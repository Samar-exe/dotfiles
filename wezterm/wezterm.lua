local wezterm = require("wezterm")
local config = wezterm.config_builder({})

config.font = wezterm.font_with_fallback({
	"JetBrains Mono",
	"Noto Color Emoji",
})
config.color_scheme = "Poimandres"
--kannagawa
-- config.colors = {
-- foreground = "#dcd7ba",
-- 		background = "#1f1f28",
--
-- 		cursor_bg = "#c8c093",
-- 		cursor_fg = "#c8c093",
-- 		cursor_border = "#c8c093",
--
-- 		selection_fg = "#c8c093",
-- 		selection_bg = "#2d4f67",
--
-- 		scrollbar_thumb = "#16161d",
-- 		split = "#16161d",
--
-- 		ansi = { "#090618", "#c34043", "#76946a", "#c0a36e", "#7e9cd8", "#957fb8", "#6a9589", "#c8c093" },
-- 		brights = { "#727169", "#e82424", "#98bb6c", "#e6c384", "#7fb4ca", "#938aa9", "#7aa89f", "#dcd7ba" },
-- 		indexed = { [16] = "#ffa066", [17] = "#ff5d62" },
-- }
--
-- Decay
-- config.colors = {
-- indexed = {[16] = "#f1cf8a", [17] = "#dee1e6"},
--
--     scrollbar_thumb = "#384148",
--     split = "#22262e",
--
--     tab_bar = {
--       background = "#22262e",
--         active_tab = {
--           bg_color = "#70a5eb",
-- 	  fg_color = "#fafdff"
--         },
--         inactive_tab = {
-- 	  bg_color = "#22262e",
-- 	  fg_color = "#fafdff"
-- 	},
--         inactive_tab_hover = {
-- 	  bg_color = "#384148",
-- 	  fg_color = "#fafdff"
-- 	},
-- 	new_tab = {
-- 	  bg_color = "#22262e",
-- 	  fg_color = "#fafdff"
-- 	},
-- 	new_tab_hover = {
-- 	  bg_color = "#384148",
-- 	  fg_color = "#fafdff",
-- 	  italic = true
-- 	},
--       },
--
--     visual_bell = "#384148",
--
--     -- nightbuild only
--     compose_cursor = "#f1cf8a",
--
--     -- Theme Colors (Decay)
--     foreground = "#b6beca",
--     background = "#171a1f",
--     cursor_bg = "#dee1e6",
--     cursor_border = "#fafdff",
--     cursor_fg = "#22262e",
--     selection_bg = "#575268",
--     selection_fg = "#D9E0EE",
--
--     ansi = {"#1c252c", "#e05f65", "#78dba9", "#f1cf8a", "#70a5eb", "#c68aee","#74bee9", "#dee1e6"},
--     brights = {"#384148", "#fc7b81", "#94f7c5", "#ffeba6", "#8cc1ff", "#e2a6ff", "#90daff", "#fafdff"},
-- }
config.font.font_size=12
config.window_background_opacity = 0.45
config.enable_wayland = false
config.enable_scroll_bar = false
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "NONE"
config.keys = {
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
		key = "k",
		mods = "CTRL",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
}
return config
