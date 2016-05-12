game = game or {}

require "game.helpers.var"
require "game.helpers.i18n"

game.namespace = {}
game.ns = game.namespace

local packages_ = {}

game.import = function(name)
	local p
	if packages_[name] then
		p = packages_[name]
	else
		p = require(name)
		packages_[name] = p
	end
	return p
end

game.register_namespace = function(nsdata)
	local obj
	if istable(nsdata) and isset(nsdata.namespace) then
		game.namespace[nsdata.namespace] = {}
		obj = game.namespace[nsdata.namespace]
	else
		obj = game.namespace
	end

	for name, path in pairs(nsdata.modules) do
		obj[name] = {}
		local callback = nsdata.methods[name]

		local mt_ = {}
		mt_.__index = function(table, key)
			if isfunction(callback) then
				return callback(key, path)
			else
				return game.import(path..key)
			end
		end
		setmetatable(obj[name], mt_)
	end
end

function game.tostring(obj, ...)
	if type(obj) == "table" then
		return table.tostring(obj)
	end

	if ... then
		obj = string.format(tostring(obj), ...)
	else
		obj = tostring(obj)
	end

	return obj
end

function sputs(obj, ...)
	if type(obj) == "table" then
		obj = game.tostring(obj)
	else
		if type(obj)=="string" and string.indexOf(obj, "%%s") ~= -1 then
			if ... then
				obj = obj:format(...)
			end
		else
			obj = game.tostring(obj)
			if ... then
				local len = select("#", ...)
				for i=1,len do
					obj = string.format("%s %s", obj, game.tostring(select(i, ...)))
				end
			end
		end
	end
	return obj
end

function puts(obj, ...)
	print(sputs(obj, ...))
end

function game.appendPath(...)
	local args = {...}
	for i=1, #args do
		local pkgPath = package.path  
		package.path = string.format("%s;%s?.lua;%s?/init.lua",  
			pkgPath, args[i], args[i]) 
	end
end

-- Function string.gfind was renamed string.gmatch. (Option LUA_COMPAT_GFIND) 
function game.getglobal(f)
	local v = _G
	-- for w in string.gfind(f, "[%w_]") do
	for w in string.gmatch(f, "[%w_]+") do
		v = v[w]
	end
	return v
end

function game.setglobal(f, v)
	local t = _G
	-- for w, d in string.gfind(f, "([%w_]+)(.?)") do
	for w, d in string.gmatch(f, "([%w_]+)(.?)") do
		if d == "." then -- not last field
			t[w] = t[w] or {}	-- create table if absent
			t = t[w]			-- get the table
		else					-- last field
			t[w] = v 			-- do the assignment
		end
	end
end

function game.vardump(...)
	local count = select("#", ...)
	if count < 1 then return end

	print("vardump:")
	for i = 1, count do
		local v = select(i, ...)
		local t = type(v)
		if t == "string" then
			print(string.format("  %02d: [string] %s", i, v))
		elseif t == "boolean" then
			print(string.format("  %02d: [boolean] %s", i, tostring(v)))
		elseif t == "number" then
			print(string.format("  %02d: [number] %0.2f", i, v))
		else
			print(string.format("  %02d: [%s] %s", i, t, tostring(v)))
		end
	end
end

function game.eval(input)
	return pcall(function()
		if not input:match("=") then
			input = "do return (" .. input .. ") end"
		end

		local code, err = loadstring(input, "REPL")
		if err then
			error("Syntax Error: " .. err)
		else
			print(code())
		end
	end)
end

function game.escape(s)
	if s == nil then return '' end
	local esc, i = s:gsub('&', '&amp'):gsub('<', '&lt'):gsub('>', '&gt')

	return esc
end

function game.urlencode(s)
	return s:gsub("\n", "\r\n"):gsub("([^%-%-%/]", 
		function(c) return ("%%%02X"):format(string.byte(c))
	end)
end

function game.lazy(tables)
   return function() return tables end 
end