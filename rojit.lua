--[[
    RoJIT - Made for LuaJIT - Replicates various parts of the Roblox API, All in one file.

    This is meant to be used for *custom* specific scripts. Mostly for POC's and whatnot.
    It will make sure your code runs, so when you translate it to Luau everything goes smooth-sailing.

    Notice: This is a rewritten implementation of Lemur. Code is modified and obviously written in just one file.
]]

--> r_type and r_type_mt are used internally, hence why it's not a global variable
--> r_type is the main variable used for setting up types and whatnot.
--> r_type_mt is a direct reference to r_type's metatable
local r_type, r_type_mt do
    r_type = newproxy(true)
    r_type_mt = getmetatable(r_type)
    
    r_type_mt.__tostring = function()
        return ("ROJIT-R-TYPE-SYSTEM") 
    end
end

--> r_typeof - custom function in Roblox, used for advanced types.
local r_typeof do
    function r_typeof(object)
        local object_type = type(object)

        if (object_type == "userdata") then
            local object_metatable = getmetatable(object)

            if (object_metatable == nil) then
                return ("userdata")
            end

            if (object_metatable[r_type] == nil) then
                return ("userdata")
            end

            return object_metatable[r_type]
        end

        return object_type
    end
end