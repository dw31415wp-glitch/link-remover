--[[
Simple shell for {{Deprecated archive}}.

The template renders a normal external link and keeps deprecated archive values
only as template parameters in the page source.
]]

require('strict')

local p = {}

local tracking_category = '[[Category:Pages using deprecated archive template]]'

local function trim(value)
	if value == nil then
		return ''
	end
	return mw.text.trim(tostring(value))
end

local function is_set(value)
	return trim(value) ~= ''
end

local function first_set(args, names)
	for _, name in ipairs(names) do
		if is_set(args[name]) then
			return trim(args[name])
		end
	end
	return ''
end

local function archive_protocol(args)
	local protocol = first_set(args, { 'protocol' })
	if not is_set(protocol) then
		return 'https'
	end
	return protocol
end

local function get_args(frame)
	local args = {}
	local parent = frame and frame:getParent()

	if parent then
		for key, value in pairs(parent.args) do
			if is_set(value) then
				args[key] = value
			end
		end
	end

	if frame then
		for key, value in pairs(frame.args) do
			if is_set(value) then
				args[key] = value
			end
		end
	end

	return args
end

local function external_link(url, label)
	if not is_set(url) then
		return mw.text.nowiki(label)
	end

	label = is_set(label) and label or url
	return string.format('[%s %s]', url, mw.text.nowiki(label))
end

function p._main(args)
	local sourceurl = first_set(args, { 'sourceurl', 1 })
	local label = first_set(args, { 'title', 2 })
	local archivehostpath = first_set(args, { 'archivehostpath', 3 })
	local protocol = archive_protocol(args)

	-- Shell parameters for future maintenance tooling; intentionally not rendered.
	local _ = { archivehostpath = archivehostpath, protocol = protocol }

	return external_link(sourceurl, label) .. tracking_category
end

function p.main(frame)
	return p._main(get_args(frame))
end

return p
