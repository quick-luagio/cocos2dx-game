--[[--
静态数据加载

]]



local static_configs = {}

static_configs["test"] = {id=1,name=1,age=1}  

function __STATIC__READ__(name,process)
   if not static_configs then
      static_configs = cc.cmg.getStaticConfigs()
   end
   local file = cc.paths.Static_Path..string.format("%s.lua",name)
   local content = io.readfile(file)
   if not content then
      printInfo(string.format("not found file name [%s]",file))
      return
   end
   local list = loadstring("return "..content)()
   if not list or type(list) ~= "table" then
      printInfo(string.format("can not get list, name [%s]",file))
      return
   end

   local function _get(table,key)
      print(static_configs[name][key],name,key)
      return table[static_configs[name][key]]
   end
   
   for i,item in ipairs(list) do
      setmetatable(item,{__index=_get} )
      process(i,item)
   end
end



local StaticDataLoader = {}


---- 加载用户静态----
function StaticDataLoader.loadTest()
   local data ={}

   __STATIC__READ__("test",function(i,item)  

       print(item.name)
   end)
   return data
end

cc = {paths = {}}

local project_dir = '../../../'

cc.paths.Static_Path = project_dir.."res/static/"

function io.readfile(path)
    local file = io.open(path, "r")
    if file then
        local content = file:read("*a")
        io.close(file)
        return content
    end
    return nil
end


package.path = string.format("%s;%s?.lua;%s?/init.lua",  
         package.path , project_dir, project_dir) -- 添加路径 '..\\..\\'


StaticDataLoader.loadTest()


return StaticDataLoader