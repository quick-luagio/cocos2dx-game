#include "lua_net_proxy_auto.hpp"
#include "NetProxy.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"


int lua_cocos2dx_net_proxy_NetProxy_NetInit(lua_State* tolua_S)
{
	int argc = 0;
	bool ok = true;

#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
	if (!tolua_isusertable(tolua_S, 1, "NetProxy", 0, &tolua_err)) goto tolua_lerror;
#endif

	argc = lua_gettop(tolua_S) - 1;

	if (argc == 4)
	{
		std::string arg0;
		unsigned int arg1;
		std::string arg2;
		int arg3;
		ok &= luaval_to_std_string(tolua_S, 2, &arg0, "NetProxy:NetInit");
		ok &= luaval_to_uint32(tolua_S, 3, &arg1, "NetProxy:NetInit");
		ok &= luaval_to_std_string(tolua_S, 4, &arg2, "NetProxy:NetInit");
		if (!ok)
		{
			tolua_error(tolua_S, "invalid arguments in function 'lua_cocos2dx_net_proxy_NetProxy_NetInit'", nullptr);
			return 0;
		}
#if COCOS2D_DEBUG >= 1
		if (!toluafix_isfunction(tolua_S, 5, "LUA_FUNCTION", 0, &tolua_err))
		{
			goto tolua_lerror;
		}
#endif
		LUA_FUNCTION handler = (toluafix_ref_function(tolua_S, 5, 0));
		
		NetProxy::NetInit(arg0, arg1, arg2, handler);
		lua_settop(tolua_S, 1);
		return 1;
	}
	luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "NetProxy:NetInit", argc, 4);
	return 0;
#if COCOS2D_DEBUG >= 1
tolua_lerror:
	tolua_error(tolua_S, "#ferror in function 'lua_cocos2dx_net_proxy_NetProxy_NetInit'.", &tolua_err);
#endif
	return 0;
}
int lua_cocos2dx_net_proxy_NetProxy_NetSend(lua_State* tolua_S)
{
	int argc = 0;
	bool ok = true;

#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
	if (!tolua_isusertable(tolua_S, 1, "NetProxy", 0, &tolua_err)) goto tolua_lerror;
#endif

	argc = lua_gettop(tolua_S) - 1;

	if (argc == 1)
	{
		const char* arg0;
		std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "NetProxy:NetSend"); arg0 = arg0_tmp.c_str();
		if (!ok)
		{
			tolua_error(tolua_S, "invalid arguments in function 'lua_cocos2dx_net_proxy_NetProxy_NetSend'", nullptr);
			return 0;
		}
		NetProxy::NetSend(arg0);
		lua_settop(tolua_S, 1);
		return 1;
	}
	luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "NetProxy:NetSend", argc, 1);
	return 0;
#if COCOS2D_DEBUG >= 1
tolua_lerror:
	tolua_error(tolua_S, "#ferror in function 'lua_cocos2dx_net_proxy_NetProxy_NetSend'.", &tolua_err);
#endif
	return 0;
}
int lua_cocos2dx_net_proxy_NetProxy_NetReconnect(lua_State* tolua_S)
{
	int argc = 0;
	bool ok = true;

#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
	if (!tolua_isusertable(tolua_S, 1, "NetProxy", 0, &tolua_err)) goto tolua_lerror;
#endif

	argc = lua_gettop(tolua_S) - 1;

	if (argc == 0)
	{
		if (!ok)
		{
			tolua_error(tolua_S, "invalid arguments in function 'lua_cocos2dx_net_proxy_NetProxy_NetReconnect'", nullptr);
			return 0;
		}
		NetProxy::NetReconnect();
		lua_settop(tolua_S, 1);
		return 1;
	}
	luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "NetProxy:NetReconnect", argc, 0);
	return 0;
#if COCOS2D_DEBUG >= 1
tolua_lerror:
	tolua_error(tolua_S, "#ferror in function 'lua_cocos2dx_net_proxy_NetProxy_NetReconnect'.", &tolua_err);
#endif
	return 0;
}
static int lua_cocos2dx_net_proxy_NetProxy_finalize(lua_State* tolua_S)
{
	printf("luabindings: finalizing LUA object (NetProxy)");
	return 0;
}

int lua_register_cocos2dx_net_proxy_NetProxy(lua_State* tolua_S)
{
	tolua_usertype(tolua_S, "NetProxy");
	tolua_cclass(tolua_S, "NetProxy", "NetProxy", "", nullptr);

	tolua_beginmodule(tolua_S, "NetProxy");
	tolua_function(tolua_S, "NetInit", lua_cocos2dx_net_proxy_NetProxy_NetInit);
	tolua_function(tolua_S, "NetSend", lua_cocos2dx_net_proxy_NetProxy_NetSend);
	tolua_function(tolua_S, "NetReconnect", lua_cocos2dx_net_proxy_NetProxy_NetReconnect);
	tolua_endmodule(tolua_S);
	std::string typeName = typeid(NetProxy).name();
	g_luaType[typeName] = "NetProxy";
	g_typeCast["NetProxy"] = "NetProxy";
	return 1;
}
TOLUA_API int register_all_cocos2dx_net_proxy(lua_State* tolua_S)
{
	tolua_open(tolua_S);

	tolua_module(tolua_S, "cc", 0);
	tolua_beginmodule(tolua_S, "cc");

	lua_register_cocos2dx_net_proxy_NetProxy(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

