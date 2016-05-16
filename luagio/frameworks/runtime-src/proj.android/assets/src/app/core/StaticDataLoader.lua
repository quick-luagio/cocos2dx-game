--[[--
静态数据加载

]]


static_Keys_={}

function __STATIC__READ__(name,process)
   local keys,list = unpack(require("UserStatic"))
   package.loaded["UserStatic"] = nil
   static_Keys_[name] = keys
   local function _get(table,key)
      return table[static_Keys_[name][key]]
   end
   for i,item in ipairs(list) do
      setmetatable(object,{__index=_get} )
      process(i,item)
   end
end

StaticDataLoader = {}





---- 加载用户静态----
function StaticDataLoader.loadUser()
   local data ={}

   __STATIC__READ__(name,function(i,item)  


   end)
   return data
end

