@echo off

set DIR=%~dp0
set PLAYER_ROOT=%DIR%..\simulator\win32\
set SCRIPT_ROOT_MAIN=%DIR%module_gen\template_gen.lua
set WORK_DIR=%DIR%..\ 

echo   APP_ROOT            = %PLAYER_ROOT%
echo   APP_ANDROID_ROOT    = %SCRIPT_ROOT%

rem if use quick-cocos2d-x mini, uncomments line below
rem set NDK_BUILD_FLAGS=CPPFLAGS=-DQUICK_MINI_TARGET=1 QUICK_MINI_TARGET=1

rem if use DEBUG, set NDK_DEBUG=1, otherwise set NDK_DEBUG=0
START %PLAYER_ROOT%luagio.exe -workdir %WORK_DIR% -file %SCRIPT_ROOT_MAIN% -size 800x480  -write-debug-log debug.log -console enable


