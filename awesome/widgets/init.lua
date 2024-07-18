local wibox = require("wibox")
return function()
	local bg = wibox.container.background()
	bg.bg = "#ffffff"

	local tb1 = wibox.widget.textbox("foo")
	local tb2 = wibox.widget.textbox("bar")

	tb1.text = "foo"
	tb2.text = "bar"

	local l = wibox.layout.fixed.vertical()
	l:add(tb1)
	l:add(tb2)

	bg.widget = l
	return bg
end
