local project_dir = '../../'

package.path = string.format("%s;%s?.lua;%s?/init.lua",  
			package.path , project_dir, project_dir) -- 添加路径 '..\\..\\'

require("src/packages/utils/ioutil")
require("src/cocos/cocos2d/functions")

local module_path = "src/app/modules/"

--1 读取module配置文件
local protocol = {}

function protocol.genProtocols()


end




protocol.genProtocols()


platform_list_get 10002{
	pf_ids:arr[
      id:int32,
      name:str,
      tokens:str
	]
}


---读取pf_ids
local function read_pf_ids(buffer)
   local len = buffer.readByte()
   local array = {}
   for i=1,len do
   	   local id = read_id(buffer)
   	   local name = read_name(buffer)
   	   local tokens = read_tokens(buffer)

   	   table.insert(array,readInt(buffer))
   	   table.insert(array,readString(buffer))
   	   table.insert(array,readString(buffer))
   end
   return list
end

local function read_id(buffer)
   return buffer.readInt()
end

local function read_name(buffer)
   local len = buffer.readByte()
   return buffer.readString(len)
end

local function read_tokens(buffer)
   local len = buffer.readByte()
   return buffer.readString(len)
end
