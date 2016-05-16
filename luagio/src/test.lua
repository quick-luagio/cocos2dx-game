 -- mysql = require "luasql.mysql"

 -- print(mysql)

 require("packages.utils.ioutil")

--  function scandir(directory)
--     local i, t, popen = 0, {}, io.popen
--     -- for filename in popen('ls -a "'..directory..'"'):lines() do
--     for filename in popen('dir "'..directory..'" /b /ad'):lines() do
--         i = i + 1
--         t[i] = filename
--     end
--     return t
-- end
local t = scandir(".")
for k,v in pairs(t) do
	print(k,v)
end