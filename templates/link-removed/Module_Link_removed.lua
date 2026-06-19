--[[
Simple shell for {{Link removed}}.

The template renders a plain label followed by a visible marker indicating that
the original link was removed.
]]

require('strict')

local p = {}

local function trim(value)
	if value == nil then
		return ''
	end
	return mw.text.trim(tostring(value))
end

local function get_args(frame)
	local args = {}
	local parent = frame and frame:getParent()

	if parent then
		for key, value in pairs(parent.args) do
			args[key] = value
		end
	end

	if frame then
		for key, value in pairs(frame.args) do
			args[key] = value
		end
	end

	return args
end

function p._main(args)
	local label = trim(args[1] or args.label)
	local linkhostpath = trim(args.linkhostpath)
	local protocol = trim(args.protocol)

	if protocol == '' then
		protocol = 'https'
	end

	-- Tracking parameter for future maintenance tooling; intentionally not rendered.
	local _ = { linkhostpath = linkhostpath, protocol = protocol }

	return mw.text.nowiki(label) .. ' <sup>&#91;[[Wikipedia:Link_Removed|Link Removed]]&#93;</sup>'
end

function p.main(frame)
	return p._main(get_args(frame))
end

return p
