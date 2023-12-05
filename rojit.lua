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

--[[
    r_enum_item & r_enum rewritten from: https://github.com/raphtalia/Enum/
]]

local r_enum_item do
    r_enum_item = {}

    function r_enum_item.new(item_name, item_value, item_type)
        local item_type = tostring(item_type)

        local props do
            props = {
                Name = item_name,
                Value = item_type,
                EnumType = item_type
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

    Everything from here on now *has* to be exported 1-1 to Roblox.
    AKA API Code

]]

local Enum do
    Enum = newproxy(true)
    
    EnumInternal = getmetatable(Enum)
    EnumInternal[r_type] = "Enum"

    do
        EnumInternal.AccessModifierType = r_enum.new("AccessModifierType", {
            allow = 0,
            deny = 1
        })

        EnumInternal.AccessoryType = r_enum.new("AccessoryType", {
            Unknown = 0,
            Hat = 1,
            Hair = 2,
            Face = 3,
            Neck = 4,
            Shoulder = 5,
            Front = 6,
            Back = 7,
            Waist = 8,
            TShirt = 9,
            Shirt = 10,
            Pants = 11,
            Jacket = 12,
            Sweater = 13,
            Shorts = 14,
            LeftShoe = 15,
            RightShoe = 16,
            DressSkirt = 17,
            Eyebrow = 18,
            Eyelash = 19
        })

        EnumInternal.ActionType = r_enum.new("ActionType", {
            Nothing = 0,
            Pause = 1,
            Lose = 2,
            Draw = 3,
            Win = 4
        })

        EnumInternal.ActuatorRelativeTo = r_enum.new("ActuatorRelativeTo", {
            Attachment0 = 0,
            Attachment1 = 1,
            World = 2
        })

        EnumInternal.ActuatorType = r_enum.new("ActuatorType", {
            None = 0,
            Motor = 1,
            Servo = 2
        })

        EnumInternal.AdEventType = r_enum.new("AdEventType", {
            VideoLoaded = 0,
            VideoRemoved = 1,
            UserCompletedVideo = 2
        })

        EnumInternal.AdShape = r_enum.new("AdShape", {
            HorizontalRectangle = 1
        })

        EnumInternal.AdTeleportMethod = r_enum.new("AdTeleportMethod", {
            Undefined = 0,
            PortalForward = 1,
            InGameMenuBackButton = 2,
            UiBackButton = 3
        })

        EnumInternal.AdUnitStatus = r_enum.new("AdUnitStatus", {
            Inactive = 0,
            Active = 1
        })

        EnumInternal.AdornCullingMode = r_enum.new("AdornCullingMode", {
            Automatic = 0,
            Never = 1
        })

        EnumInternal.AlignType = r_enum.new("AlignType", {
            Parallel = 0, --[[ Deprecated ]]
            Perpendicular = 1, --[[ Deprecated ]]
            PrimaryAxisParallel = 2,
            PrimaryAxisPerpendicular = 3,
            PrimaryAxisLookAt = 4,
            AllAxes = 5
        })

        EnumInternal.AlphaMode = r_enum.new("AlphaMode", {
            Overlay = 0,
            Transparency = 1
        })

        EnumInternal.AnalyticsEconomyAction = r_enum.new("AnalyticsEconomyAction", {
            Default = 0,
            Acquire = 1,
            Spend = 2
        })

        EnumInternal.AnalyticsLogLevel = r_enum.new("AnalyticsLogLevel", {
            Trace = 0,
            Debug = 1,
            Information = 2,
            Warning = 3,
            Error = 4,
            Fatal = 5
        })

        EnumInternal.AnalyticsProgressionStatus = r_enum.new("AnalyticsProgressionStatus", {
            Default = 0,
            Begin = 1,
            Complete = 2,
            Abandon = 3,
            Fail = 4
        })

        EnumInternal.AnimationClipFromVideoStatus = r_enum.new("AnimationClipFromVideoStatus", {
            Initializing = 0,
            Pending = 1,
            Processing = 2,
            ErrorGeneric = 4,
            Success = 6,
            ErrorVideoTooLong = 7,
            ErrorNoPersonDetected = 8,
            ErrorVideoUnstable = 9,
            Timeout = 10,
            Cancelled = 11,
            ErrorMultiplePeople = 12,
            ErrorUploadingVideo = 2001
        })

        EnumInternal.AnimationCompositorMode = r_enum.new("AnimationCompositorMode", {
            Default = 0,
            Enabled = 1,
            Disabled = 2
        })

        EnumInternal.AnimationPriority = r_enum.new("AnimationPriority", {
            Idle = 0,
            Movement = 1,
            Action = 2,
            Action2 = 3,
            Action3 = 4,
            Action4 = 5,
            Core = 1000
        })

        EnumInternal.AnimatorRetargetingMode = r_enum.new("AnimatorRetargetingMode", {
            default = 0,
            Disabled = 1,
            Enabled = 2
        })

        EnumInternal.AppShellActionType = r_enum.new("AppShellActionType", {
            None = 0,
            OpenApp = 1,
            TapChatTab = 2,
            TapConversationEntry = 3,
            TapAvatarTab = 4,
            ReadConversation = 5,
            TapGamePageTab = 6,
            TapHomePageTab = 7,
            GamePageLoaded = 8,
            HomePageLoaded = 9,
            AvatarEditorPageLoaded = 10
        })

        EnumInternal.AppShellFeature = r_enum.new("AppShellFeature", {
            None = 0,
            Chat = 1,
            AvatarEditor = 2,
            GamePage = 3,
            HomePage = 4,
            More = 5,
            Landing = 6
        })

        EnumInternal.AppUpdateStatus = r_enum.new("AppUpdateStatus", {
            Unknown = 0,
            NotSupported = 1,
            Failed = 2,
            NotAvailable = 3,
            Available = 4
        })

        EnumInternal.ApplyStrokeMode = r_enum.new("ApplyStrokeMode", {
            Contextual = 0,
            Border = 1
        })

        EnumInternal.AspectType = r_enum.new("AspectType", {
            FitWithinMaxSize = 0,
            ScaleWithParentSize = 1
        })

        EnumInternal.AssetCreatorType = r_enum.new("AssetCreatorType", {
            User = 0,
            Group = 1
        })

        EnumInternal.AssetFetchStatus = r_enum.new("AssetFetchStatus", {
            Success = 0,
            Failure = 1,
            None = 2,
            Loading = 3,
            TimedOut = 4
        })

        EnumInternal.AssetType = r_enum.new("AssetType", {
            Image = 1,
            TShirt = 2,
            Audio = 3,
            Mesh = 4,
            Lua = 5,
            Hat = 8,
            Place = 9,
            Model = 10,
            Shirt = 11,
            Pants = 12,
            Decal = 13,
            Head = 17,
            Face = 18,
            Gear = 19,
            Badge = 21,
            Animation = 24,
            Torso = 27,
            RightArm = 28,
            LeftArm = 29,
            LeftLeg = 30,
            RightLeg = 31,
            Package = 32,
            GamePass = 34,
            Plugin = 38,
            MeshPart = 40,
            HairAccessory = 41,
            FaceAccessory = 42,
            NeckAccessory = 43,
            ShoulderAccessory = 44,
            FrontAccessory = 45,
            BackAccessory = 46,
            WaistAccessory = 47,
            ClimbAnimation = 48,
            DeathAnimation = 49,
            FallAnimation = 50,
            IdleAnimation = 51,
            JumpAnimation = 52,
            RunAnimation = 53,
            SwimAnimation = 54,
            WalkAnimation = 55,
            PoseAnimation = 56,
            EarAccessory = 57,
            EmoteAnimation = 61,
            Video = 62,
            TShirtAccessory = 64,
            ShirtAccessory = 65,
            PantsAccessory = 66,
            JacketAccessory = 67,
            SweaterAccessory = 68,
            ShortsAccessory = 69,
            LeftShoeAccessory = 70,
            RightShoeAccessory = 71,
            DressSkirtAccessory = 72,
            FontFamily = 73,
            EyebrowAccessory = 76,
            EyelashAccessory = 77,
            MoodAnimation = 78,
            DynamicHead = 79
        })

        EnumInternal.AssetTypeVerification = r_enum.new("AssetTypeVerification", {
            Default = 1,
            ClientOnly = 2,
            Always = 3
        })

        EnumInternal.AudioApiRollout = r_enum.new("AudioApiRollout", {
            Disabled = 0,
            Automatic = 1,
            Enabled = 2
        })

        EnumInternal.AudioSubType = r_enum.new("AudioSubType", {
            Music = 1,
            SoundEffect = 2
        })

        EnumInternal.AudioWindowSize = r_enum.new("AudioWindowSize", {
            Small = 0,
            Medium = 1,
            Large = 2
        })

        EnumInternal.AutoIndentRule = r_enum.new("AutoIndentRule", {
            Off = 0,
            Absolute = 1,
            Relative = 2
        })

        EnumInternal.AutomaticSize = r_enum.new("AutomaticSize", {
            None = 0,
            X = 1,
            Y = 2,
            XY = 3
        })

        EnumInternal.AvatarAssetType = r_enum.new("AvatarAssetType", {
            TShirt = 2,
            Hat = 8,
            Shirt = 11,
            Pants = 12,
            Head = 17,
            Face = 18,
            Gear = 19,
            Torso = 27,
            RightArm = 28,
            LeftArm = 29,
            LeftLeg = 30,
            RightLeg = 31,
            HairAccessory = 41,
            FaceAccessory = 42,
            NeckAccessory = 43,
            ShoulderAccessory = 44,
            FrontAccessory = 45,
            BackAccessory = 46,
            WaistAccessory = 47,
            ClimbAnimation = 48,
            FallAnimation = 50,
            IdleAnimation = 51,
            JumpAnimation = 52,
            RunAnimation = 53,
            SwimAnimation = 54,
            WalkAnimation = 55,
            EmoteAnimation = 61,
            TShirtAccessory = 64,
            ShirtAccessory = 65,
            PantsAccessory = 66,
            JacketAccessory = 67,
            SweaterAccessory = 68,
            ShortsAccessory = 69,
            LeftShoeAccessory = 70,
            RightShoeAccessory = 71,
            DressSkirtAccessory = 72,
            EyebrowAccessory = 76,
            EyelashAccessory = 77,
            MoodAnimation = 78,
            DynamicHead = 79
        })

        EnumInternal.AvatarChatServiceFeature = r_enum.new("AvatarChatServiceFeature", {
            None = 0,
            UniverseAudio = 1,
            UniverseVideo = 2,
            PlaceAudio = 4,
            PlaceVideo = 8,
            UserAudioEligible = 16,
            UserAudio = 32,
            UserVideoEligible = 64,
            UserVideo = 128,
            UserBanned = 256
        })

        EnumInternal.AvatarContextMenuOption = r_enum.new("AvatarContextMenuOption", {
            Friend = 0,
            Chat = 1,
            Emote = 2,
            InspectMenu = 3
        })

        EnumInternal.AvatarItemType = r_enum.new("AvatarItemType", {
            Asset = 1,
            Bundle = 2
        })

        EnumInternal.AvatarJointUpgrade = r_enum.new("AvatarJointUpgrade", {
            Default = 0,
            Enabled = 1,
            Disabled = 2
        })

        EnumInternal.AvatarPromptResult = r_enum.new("AvatarPromptResult", {
            Success = 1,
            PermissionDenied = 2,
            Failed = 3
        })

        EnumInternal.AvatarThumbnailCustomizationType = r_enum.new("AvatarThumbnailCustomizationType", {
            Closeup = 1,
            FullBody = 2
        })

        EnumInternal.AvatarUnificationMode = r_enum.new("AvatarUnificationMode", {
            Default = 0,
            Disabled = 1,
            Enabled = 2
        })

        EnumInternal.Axis = r_enum.new("Axis", {
            X = 0,
            Y = 1,
            Z = 2
        })
    end
end

