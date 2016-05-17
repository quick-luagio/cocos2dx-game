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






---- 加载数据静态 [Test]----
function StaticDataLoader.loadTest()
   local staicDic = {}

   __STATIC__READ__("test",function(i,item)  
   



   end)
   return staicDic
end




return StaticDataLoader