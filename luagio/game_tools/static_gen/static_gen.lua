local project_dir = '../../'

package.path = string.format("%s;%s?.lua;%s?/init.lua",  
			package.path , project_dir, project_dir) -- 添加路径 '..\\..\\'

require("src/packages/utils/ioutil")
require("src/cocos/cocos2d/functions")
require("src/config")
mysql = require "luasql.mysql"

local static_path = "res/static/"
local static = {}
local static_config = nil

--生成静态文件
function static.genStatics(debug)
	static.trim = debug and debug == 0 or false
    if not static_config then
       static_config = require("src/app/config/Statics")
	end
	--生成静态数据加载
    static.genStaticLoader(table.keys(static_config))

    local conn = static.createSqlConn()
    
    for name,keys in pairs(static_config) do
    	static.genStatic(name,keys)
    end

	static.closeSqlConn()
end

--关闭数据库
function static.closeSqlConn()
   if static.env then
      static.env:close()
   end
   if static.conn then
      static.conn:close()
   end
end

--生成数据库连接
function static.createSqlConn()
    local env  = mysql.mysql()
	local conn = env:connect("game_baizhu","baizhu","baizhu123","120.25.211.165",3306)

	static.env = env
	static.conn = conn
end

--生成单个静态文件
function static.genStatic(name,keys)
   if not static.conn then return end

   print(string.format("处理静态数据:[%s]",name))
   local sql = static.genStaticSql(name,keys)
   local cursor,errorString = static.conn:execute(sql)
   if not cursor or errorString then
      print(string.format("sql[%s] execute error:[%s]",sql,errorString or ""))
   end
   local content = static.readStatic(cursor,keys)
   local format = "{\n%s\n}"
   content = string.format(format,content)
   static.writeStatic(name,content)
end

--从数据库读取静态内容
function static.readStatic(cursor,staticKeys)
   if not cursor then return end
   local keys = table.keys(staticKeys)

   local row = cursor:fetch({}, "a")
   local content = ""
   while row do
   	  content = content.."\t{"
   	  for i,key in ipairs(keys) do
          local value = row[key]
          if static.isStringType(staticKeys[key]) then
             value = "'"..value.."'"
          end
   	  	  content = content..value

   	  	  if i ~= #keys then
             content = content..","
   	  	  end
   	  end
   	  content = content.."}"
	  row = cursor:fetch (row, "a")
	  if row then
         content = content..",\n"
	  end
   end
   cursor:close()
   return content
end

--生成静态数据加载
function static.genStaticLoader(statics)
   local path = project_dir.."src/app/core/StaticDataLoader.lua"
   local content = io.readfile(path)
   local lines = static.getFileLines(path)

   for _,staticName in ipairs(statics) do
   	   	local action = "load"..string.upper(string.sub(staticName,0,1))..string.sub(staticName,2)
   	   	if not string.find(content,action) then
           local i,line = static.getLine(lines,"return%s*".."StaticDataLoader")
           local content = static.addLines(lines,static.getMethodTemplate(staticName),i)
           io.writefile(path,content)
           print(string.format("%s add method [%s]","StaticDataLoader",action))
   	   	else
           print(string.format("%s has method [%s]","StaticDataLoader",action))
   	   	end
   end   
end




--获取函数 template
function static.getMethodTemplate(name)
   local content = io.readfile("Method.lua")
   if name then
      content = string.gsub(content,"template",string.lower(name))
      content = string.gsub(content,"Template",string.upper(string.sub(name,0,1))..string.sub(name,2))
   end
   return content
end

--往文件行内加内容
function static.addLines(lines,content,i)
   if not content then return end
   table.insert( lines, i,content )
   local fileContent = table.concat(lines, '\n')
   return fileContent
end

function static.getLine(lines,str)
   for i,line in ipairs(lines) do
   	   if string.find(line,str) then
          return i,line
   	   end
   end
   return 0,nil
end

--按行的取
function static.getFileLines(dir)
	local f = io.open(dir)
    local lines = {}
    local i = 0
    for line in f:lines() do
		i = i + 1
		lines[#lines + 1] = line
	end
    io.close(f)
	return lines
end

--1表示数值型
function static.isStringType(type)
   return type==2
end

function static.isStrNumber(valueStr)
   local value = tonumber(valueStr)
   if value and string.len(value) == string.len(valueStr) then
      return true
   end
   return false
end

function static.writeStatic(name,content)
   local path = project_dir..static_path..string.format("%s.lua",name)
   if static.trim then
      content = string.gsub(content,"\t","")
      content = string.gsub(content,"\n","")
      content = string.gsub(content,"%s","")
   end
   print(string.format("写入静态数据文件[%s.lua]",name))
   io.writefile(path,content)
end

--生成数据库语句
function static.genStaticSql(name,keys)
  local sql = string.format("select %s from %s",table.concat(table.keys(keys),","),name)
  print(string.format("执行数据库语句:[%s]",sql))
  return sql
end


static.genStatics(DEBUG)



-- require "luasql.mysql"

-- --创建环境对象
-- env = luasql.mysql()

-- --连接数据库
-- conn = env:connect("test","baizhu","baizhu123","120.25.211.165",3306)

-- --设置数据库的编码格式
-- conn:execute"SET NAMES UTF8"

-- --执行数据库操作
-- cur = conn:execute("select * from role")
