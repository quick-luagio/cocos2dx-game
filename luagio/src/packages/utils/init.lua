import(".var")
import(".table")

-- game.namespace = {}
-- game.ns = game.namespace

-- local packages_ = {}

-- game.import = function(name)
-- 	local p
-- 	if packages_[name] then
-- 		p = packages_[name]
-- 	else
-- 		p = require(name)
-- 		packages_[name] = p
-- 	end
-- 	return p
-- end

-- game.register_namespace = function(nsdata)
-- 	local obj
-- 	if istable(nsdata) and isset(nsdata.namespace) then
-- 		game.namespace[nsdata.namespace] = {}
-- 		obj = game.namespace[nsdata.namespace]
-- 	else
-- 		obj = game.namespace
-- 	end

-- 	for name, path in pairs(nsdata.modules) do
-- 		obj[name] = {}
-- 		local callback = nsdata.methods[name]

-- 		local mt_ = {}
-- 		mt_.__index = function(table, key)
-- 			if isfunction(callback) then
-- 				return callback(key, path)
-- 			else
-- 				return game.import(path..key)
-- 			end
-- 		end
-- 		setmetatable(obj[name], mt_)
-- 	end
-- end

function tostring(obj, ...)
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


function appendPath(...)
	local args = {...}
	for i=1, #args do
		local pkgPath = package.path  
		package.path = string.format("%s;%s?.lua;%s?/init.lua",  
			pkgPath, args[i], args[i]) 
	end
end




function eval(input)
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

function escape(s)
	if s == nil then return '' end
	local esc, i = s:gsub('&', '&amp'):gsub('<', '&lt'):gsub('>', '&gt')

	return esc
end




function checkObjName(clsName)
  if not clsName then return clsName end
  return string.lower(string.sub(clsName,0,1))..string.sub(clsName,0)
end


