--[[--
模块配置文件
可以运行game_tools/module_gen/template_gen.lua 生成模块
旧的函数不会被覆盖，也无法修改。如果要修改或者删除请手动处理
]]

-------------名首字母大写  User---------------------------
local _module_configs ={}

_module_configs["User"] = {
	events = {"User_Proxy_GetInfo","User_Proxy_Test"},
	views  = {"User"},
	proxys = {"User"},
}

_module_configs["Login"] = {
	events = {"Login_Proxy_Login","Login_View_Show"},
	views  = {"Login"},
	proxys = {"Login"},
}












-------------------------------用户检测是否正确-------------------------
if not DEBUG or DEBUG>0 then
	function isUpper(str)
       return string.sub(str,0,1) == string.upper(string.sub(str,0,1))
	end
	function getUpperName(str)
       return string.upper(string.sub(str,0,1))..string.sub(str,2)
	end
	local errorFormat = "name [%s] should be upper(大写),right format is [%s]"

	function check(list,type)
		if not list then return end
		type = type or ""
		for i,which in ipairs(list) do
			if not isUpper(which) then
               error(string.format(type..errorFormat,which,getUpperName(which)))
			end
		end
	end
	
	function checkUpper()
       for key,config in pairs(_module_configs) do
       	   check({key},"module")
       	   check(config.views,"views")
       	   check(config.proxys,"proxys")
       	   check(config.events,"events")
       end
	end
	checkUpper()
end

return _module_configs


-- moduleName = {skippedModel, skippedService}


--[[

建议使用新的接口 by Andy

Usage:

local roleModel = ns.model.role 					-- "app.modules.role.role_m"
local talentModel = ns.model.role_talent			-- "app.modules.role.talent_m"

local roleService = ns.service.role 				-- "app.modules.role.role_s"
local talentService = ns.service.role_talent		-- "app.modules.role.talent_s"

local rolePane = ns.view.role 						-- "app.modules.role.view.rolepane"
local talentPane = ns.view.role_talent 				-- "app.modules.role.view.talentpane"

local roleVo = ns.vo.role 							-- "app.modules.role.role_vo"
local talentVo = ns.vo.role_talent				 	-- "app.modules.role.talent_vo"

--]]




