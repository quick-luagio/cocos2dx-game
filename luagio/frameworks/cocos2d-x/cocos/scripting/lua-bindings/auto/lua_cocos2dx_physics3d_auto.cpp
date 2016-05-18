#include "lua_cocos2dx_physics3d_auto.hpp"
#if CC_USE_3D_PHYSICS && CC_ENABLE_BULLET_INTEGRATION
#include "CCPhysics3D.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"

TOLUA_API int register_all_cocos2dx_physics3d(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cc",0);
	tolua_beginmodule(tolua_S,"cc");


	tolua_endmodule(tolua_S);
	return 1;
}

#endif
