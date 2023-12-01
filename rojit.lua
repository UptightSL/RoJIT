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
--> r_wait - custom function in Roblox, used for setting up "sleeps"/waits.
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

--[[
    r_enum_item & r_enum rewritten from: https://github.com/raphtalia/Enum/
]]

local r_enum_item do
    r_enum_item = {}

    function r_enum_item.new(item_name, item_value, item_type)
        local item_type = tostring(item_type)

        local props do
            props = {
                name = item_name,
                value = item_type,
                enum_type = item_type
            }
        end

        local enum_item_proxy do
            enum_item_proxy = newproxy(true)

            do
                local enum_item_proxy_mt = getmetatable(enum_item_proxy)

                enum_item_proxy_mt.__metatable = "the metatable is locked"

                enum_item_proxy_mt.__tostring = function()
                    return ("Enum.%s.%s"):format(item_type, item_name)
                end

                enum_item_proxy_mt.__index = function(_, index)
                    local value = props[index]

                    if (not value) then
                        --> Error has not yet been implemented...
                        return
                    end

                    return value
                end

                enum_item_proxy_mt.__newindex = function(_, index)
                    --> Error has not yet been implemented...
                    return
                end
            end
        end

        return enum_item_proxy
    end
end

local r_enum do
    r_enum = {}

    function r_enum.new(enum_name, enum_item_list)
        local enum_items = {}

        local enum_methods do
            enum_methods = {}

            function enum_methods:get_enum_items()
                local list = {}

                for _, enum_item in pairs(enum_items) do
                    table.insert(list, enum_item)
                end

                return list
            end
        end

        local enum_proxy do
            enum_proxy = newproxy(true)

            local enum_proxy_mt do
                enum_proxy_mt = getmetatable(enum_proxy)

                enum_proxy_mt.__metatable = "the metatable is locked"

                enum_proxy_mt.__tostring = function()
                    return enum_name
                end

                enum_proxy_mt.__index = function(_, index)
                    local value = enum_methods[index] or enum_items[index]

                    if (not value) then
                        --> Error has not yet been implemented...
                        return
                    end

                    return value
                end

                enum_proxy_mt.__newindex = function(_, index)
                    --> Error has not yet been implemented...
                    return
                end

                for index, value in pairs(enum_item_list) do
                    local enum_item_name, enum_item_value;
                    
                    if (type(index) == "number") then
                        enum_item_name = value
                        enum_item_value = index

                        if (not type(value) == "string") then
                            --> Error has not yet been implemented...
                            return
                        end
                    elseif (type(index) == "string") then
                        enum_item_name = index
                        enum_item_value = value
                    else
                        --> Error has not yet been implemented...
                    end

                    enum_items[enum_item_name] = r_enum_item.new(enum_item_name, enum_item_value, enum_proxy)
                end
            end
        end

        return enum_proxy
    end
end

--[[
    r_enmum end
]]

--[[
    enumeration implementations
]]

local enum do
    enum = {}

    do
        local enum_mt = getmetatable(enum)

        enum_mt[r_type] = "enum"
    end

    do
        enum["access_modifier_type"] = enum.new("access_modifier_type", {
            allow = 0,
            deny = 1
        })

        enum["accessory_type"] = enum.new("accessory_type", {
            unknown = 0,
            hat = 1,
            hair = 2,
            face = 3,
            neck = 4,
            shoulder = 5,
            front = 6,
            back = 7,
            waist = 8,
            tshirt = 9,
            shirt = 10,
            pants = 11,
            jacket = 12,
            sweater = 13,
            shorts = 14,
            left_shoe = 15,
            right_shoe = 16,
            dress_skirt = 17,
            eyebrow = 18,
            eyelash = 19
        })

        enum["action_type"] = enum.new("action_type", {
            nothing = 0,
            pause = 1,
            lose = 2,
            draw = 3,
            win = 4
        })

        enum["actuator_relative_to"] = enum.new("actuator_relative_to", {
            attachment_0 = 0,
            attachment_1 = 1,
            world = 2
        })

        enum["actuator_type"] = enum.new("actuator_type", {
            none = 0,
            motor = 1,
            servo = 2
        })

        enum["ad_event_type"] = enum.new("ad_event_type", {
            video_loaded = 0,
            video_removed = 1,
            user_completed_video = 2
        })

        enum["ad_shape"] = enum.new("ad_shape", {
            horizontal_rectangle = 1
        })

        enum["ad_teleport_method"] = enum.new("ad_teleport_method", {
            undefined = 0,
            portal_forward = 1,
            in_game_menu_back_button = 2,
            ui_back_button = 3
        })
    end
end