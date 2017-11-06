
--[[

	Copyright 2017 Auke Kok <sofar@foo-projects.org>

	Permission is hereby granted, free of charge, to any person obtaining
	a copy of this software and associated documentation files (the
	"Software"), to deal in the Software without restriction, including
	without limitation the rights to use, copy, modify, merge, publish,
	distribute, sublicense, and/or sell copies of the Software, and to
	permit persons to whom the Software is furnished to do so, subject
	to the following conditions:

	The above copyright notice and this permission notice shall be included
	in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
	KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
	WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
	OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
	WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]--

local def = 300 -- server must be empty for this long
local int = 6   -- check interval in seconds

local to = def

local function do_shutdown()
	local i, _ = next(minetest.get_connected_players())
	if not i then
		to = to - int
	else
		to = def
		minetest.after(int, do_shutdown)
		return
	end
	if to < 0 then
		minetest.log("action", "autoshutdown")
		minetest.request_shutdown()
	else
		minetest.after(int, do_shutdown)
	end
end

minetest.register_chatcommand("autoshutdown", {
	params = "autoshutdown server",
	description = "shut the server down after the last player leaves",
	privs = {server = true},
	func = function(name, param)
		do_shutdown()
		return true, "autoshutdown issued"
	end,
})
