local project_dir = '../../'

package.path = string.format("%s;%s?.lua;%s?/init.lua",  
			package.path , project_dir, project_dir) -- 添加路径 '..\\..\\'

require("src/packages/utils/ioutil")
require("src/cocos/cocos2d/functions")

local module_path = "src/app/modules/"

--1 读取module配置文件
local template = {}

-- 暂时支持的模板类型,支持Model Vo也很简单
local template_types = {"Proxy","Controller","View"}
local method_types = {"Notice"}

local modules_config = nil
--生成模块
function template.genModules()
	if not modules_config then
       modules_config = require("src/app/config/Modules")
	end

	for module,config in pairs(modules_config) do
		template.genModule(module,config)
	end
end

--生成单独模块
function template.genModule(module,config)
   print(string.format("生成模块[%s]:",module))
   template.checkDir(module)
   template.genController(module,module.."Controller",config.events)
   if config.views then
      for i,view in ipairs(config.views) do
      	template.genView(module,view.."View")
      end
   end

   if config.proxys then
      for i,proxy in ipairs(config.proxys) do
      	 template.genProxy(module,proxy.."Proxy")
      end
   else
      template.genProxy(module,module.."Proxy")
   end
end

--生成控制器
function template.genController(module,controller,events)
   local path = template.checkModuleFile(module,controller)
   if not path then return end
   local content = io.readfile(path)
   local lines = template.getFileLines(path)

   for _,event in ipairs(events) do
   	   	local action = "notice"..string.gsub(event,"_","")
   	   	if not string.find(content,action) then
           local i,line = template.getLine(lines,"return")
           local content = template.addLines(lines,template.getMethodTemplate(controller,action,"notification"),i)
           io.writefile(path,content)
           print(string.format("%s add method [%s]",controller,action))
   	   	else
           print(string.format("%s has method [%s]",controller,action))
   	   	end
   end
end


--生成视图
function template.genView(module,view)
   --local t= string.find(str,":%s*dispose%s*%(")
   local path = template.checkModuleFile(module,view)
end

--生成代理
function template.genProxy(module,proxy)
  template.checkModuleFile(module,proxy)
end

--获取函数 template
function template.getMethodTemplate(class,method,paramater)
   local content = io.readfile("template/Method.lua")
   if class then
      content = string.gsub(content,"Class",class)
   end
   if method then
      content = string.gsub(content,"method",method)
   end
   if paramater then
      content = string.gsub(content,"paramater",paramater)
   end
   return content
end

--往文件行内加内容
function template.addLines(lines,content,i)
   if not content then return end
   table.insert( lines, i,content )
   local fileContent = table.concat(lines, '\n')
   return fileContent
end

function template.getLine(lines,str)
   for i,line in ipairs(lines) do
   	   if string.find(line,str) then
          return i,line
   	   end
   end
   return 0,nil
end

--按行的取
function template.getFileLines(dir)
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

-- 检测模块文件
function template.checkModuleFile(module,file)
   if not module or not file then return end
   
   local exist = template.isExistsTempalteFile(module,file)
   local path = project_dir..module_path..string.lower(module)..string.format("/%s.lua",file)


   if exist then return path end
   local _type,name = template.getType(file)
   if not _type then return end
   
   local content = io.readfile(string.format("template/Template%s.lua",_type))
   content = string.gsub(content,"Template",name)
   content = string.gsub(content,"template",string.upper(string.sub(name,0,1))..string.sub(name,2))

   print(string.format("写入文件[%s]",string.format("%s.lua",file)))
   io.writefile(path,content)

   return path
end


--获取类型
function template.getType(fileName)
   for i,_type in ipairs(template_types) do
   	  if string.find(fileName,_type) then
         return _type,string.sub(fileName,0,string.find(fileName,_type)-1)
   	  end
   end
   print(string.format("不支持的文件名[%s],对应模板类型不存在",fileName))
   return nil
end



--检测生成模块文件目录
function template.checkDir(module)
	module = string.lower(module)
	local list = scandir(project_dir..module_path)
    local exist = false
    for i,file in ipairs(list) do
    	if file == module then
           exist = true
           break
    	end
    end
    if not exist then
       print(string.format("生成模块目录[%s]",module))
       os.execute("mkdir "..template.toWindowsDir(project_dir..module_path..module)) --windows
    end
end

--转换为windows dir格式
function template.toWindowsDir(dir)
   return string.gsub(dir,"/","\\")
end

--判断是否存在
function template.isExistsTempalteFile(module,file)
   return io.exists(project_dir..module_path..string.format("%s/%s.lua",module,file))
end




template.genModules()



