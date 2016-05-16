--[[--
模块配置文件

]]

-----------------------------模块监听 layz load---------------------------
local _module_configs ={}

_module_configs["user"] = {
	events = {},
	views  = {},
	proxys = {},
}


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




