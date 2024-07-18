local awful = require("awful")
local wibox = require("wibox")
-- local command = "/home/samar/Widget-module/print"
-- local mytext = wibox.widget.textbox()
-- awful.spawn.easy_async_with_shell(command, function(out)
-- 	mytext.text = out
-- 	mytext.font = "sans 14"
-- end)
-- return mytext
return awful.widget.watch("/home/samar/Widget-module/print", 1)
