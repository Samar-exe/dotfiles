local wibox = require("wibox")
return {
	wibox.widget({
		markup = "This <i>is</i> a <b>textbox</b>!!!",
		halign = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	}),
}
