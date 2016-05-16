function appendPath(...)
	local args = {...}
	for i=1, #args do
		local pkgPath = package.path  
		package.path = string.format("%s;%s?.lua;%s?/init.lua",  
			pkgPath, args[i], args[i]) 
	end
end

appendPath('..\\..\\',"..\\")

package.path = package.path .. ";./?.lua"
print(package.path)
require("src/packages/utils/ioutil")

local t = scandir(".")
for k,v in pairs(t) do
	print(k,v)
end

--1、读取文件
--2、生成文件


--处理控制器
--处理视图
--处理代理
