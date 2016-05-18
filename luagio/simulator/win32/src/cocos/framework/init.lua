--[[

Copyright (c) 2011-2015 chukong-incc.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

]]

if type(DEBUG) ~= "number" then DEBUG = 0 end

-- load framework
printInfo("")
printInfo("# DEBUG                        = " .. DEBUG)
printInfo("#")

device     = require("cocos.framework.device")
display    = require("cocos.framework.display")
audio      = require("cocos.framework.audio")
transition = require("cocos.framework.transition")

require("cocos.framework.extends.NodeEx")
require("cocos.framework.extends.SpriteEx")
require("cocos.framework.extends.LayerEx")
require("cocos.framework.extends.MenuEx")

if ccui then
require("cocos.framework.extends.UIWidget")
require("cocos.framework.extends.UICheckBox")
require("cocos.framework.extends.UIEditBox")
require("cocos.framework.extends.UIListView")
require("cocos.framework.extends.UIPageView")
require("cocos.framework.extends.UIScrollView")
require("cocos.framework.extends.UISlider")
require("cocos.framework.extends.UITextField")
end

--require("cocos.framework.package_support")

-- register the build-in packages
--cc.register("event", require("cocos.framework.components.event"))

-- export global variable
local __g = _G
cc.exports = {}
setmetatable(cc.exports, {
    __newindex = function(_, name, value)
        rawset(__g, name, value)
    end,

    __index = function(_, name)
        return rawget(__g, name)
    end
})

-- disable create unexpected global variable
function cc.disable_global()
    setmetatable(__g, {
        __newindex = function(_, name, value)
            error(string.format("USE \" cc.exports.%s = value \" INSTEAD OF SET GLOBAL VARIABLE", name), 0)
        end
    })
end


-- Function string.gfind was renamed string.gmatch. (Option LUA_COMPAT_GFIND) 
function getglobal(f)
    local v = cc
    -- for w in string.gfind(f, "[%w_]") do
    for w in string.gmatch(f, "[%w_]+") do
        v = v[w]
    end
    return v
end

function setglobal(f, v)
    local t = cc
    -- for w, d in string.gfind(f, "([%w_]+)(.?)") do
    for w, d in string.gmatch(f, "([%w_]+)(.?)") do
        if d == "." then -- not last field
            t[w] = t[w] or {}   -- create table if absent
            t = t[w]            -- get the table
        else                    -- last field
            t[w] = v            -- do the assignment
        end
    end
end


if CC_DISABLE_GLOBAL then
    cc.disable_global()
end
