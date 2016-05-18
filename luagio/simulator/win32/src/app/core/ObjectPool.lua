--[[--
   一个对象池
   1、支持class定义 类型对象
   2、不支持同名class
]]

local ObjectPool = class("ObjectPool")

function ObjectPool:ctor()
   self._classes = {}
   self._objects = {}
end

function ObjectPool:take(className)
   if not className then print("ge") return end
   if not self._classes[className] then
      printInfo("[%s] not register in ObjectPool",class and className or "nil")
      return 
   end
   if #self._objects[className]  > 0 then
      return table.remove(self._objects[className],1)
   else
      return self._classes[className].class.new()
   end
end

function ObjectPool:takeBack(object)
   if not object then return end
   local className = object.__cname
   if #self._objects[className] < self._classes[className].count then
       table.insert(self._objects[className],object)
   end
end

function ObjectPool:register(class,count)
   if not class then return end
   count = count or 2
   local className = class.__cname
   if not className then
      printInfo(" not support class styte ")
      return
   end
   if not self._objects[className] then
      self._objects[className] = {}
   end
   if not self._classes[className] then
      self._classes[className] = {count = count,class = class}
      printInfo("register [%s] in ObjectPool",className)
   end
end

function ObjectPool:getInstance()
   if not self._instance then
      self._instance = ObjectPool.new()
   end
   return self._instance
end

return ObjectPool