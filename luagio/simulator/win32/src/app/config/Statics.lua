--[[--
 静态数据表配置文件，如资源路径
 static_configs["test"] = {id=1,name=1,age=1}
 表名:test  表字段名:{id,name,age} ,作为字典，切记在后面加=1
  1表示数值型number,如id = 1
  2表示字符串string,如name = 2
]]

local static_configs = {}

static_configs["test"] = {id = 1,name = 2,age = 1}


return static_configs