--[[--
游戏相关的辅助类
]]

function checkObjName(clsName)
  if not clsName or string.len(clsName) <2 then return clsName end
  return string.lower(string.sub(clsName,0,1))..string.sub(clsName,2)
end


