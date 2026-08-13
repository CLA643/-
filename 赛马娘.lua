local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Potato5466794/Wind/refs/heads/main/Wind.luau"))()

getgenv().TransparencyEnabled = getgenv().TransparencyEnabled or false





local function gradient(text, startColor, endColor)
    local result, chars = "", {}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        chars[#chars + 1] = uchar
    end
    
    for i = 1, #chars do
        local t = (i - 1) / math.max(#chars - 1, 1)
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255), 
            math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255), 
            math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255), 
            chars[i])
    end
    return result
end

local themes = {"Dark", "Light", "Mocha", "Aqua"}
local currentThemeIndex = 1


local Window = WindUI:CreateWindow({
    Title = "<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>S</font><font color='#444444'>C</font><font color='#222222'>R</font><font color='#111111'>I</font><font color='#000000'>P</font><font color='#000000'>T</font><font color='#FFAEC4'></font>",
    IconTransparency = 1,
    Author = "zy",
    Folder = "ZiYang",
    Size = UDim2.fromOffset(700, 500),
    Transparent = true,
    Theme = "Dark",
    UserEnabled = true,
    SideBarWidth = 220,
    HasOutline = true,
    Background = "video:https://raw.githubusercontent.com/xiaoxi9008/chesksks/refs/heads/main/VID_20260323_161157.mp4",
    ScrollBarEnabled = true
})

Window:Tag({
        Title = "免费版",
        Radius = 10,
        Color = Color3.fromHex("#ffffff"),
    })

    Window:Tag({
        Title = "赛马娘",
        Radius = 10,
        Color = Color3.fromHex("#ffffff"),
    })



WindUI.Themes.Dark.Button = Color3.fromRGB(255, 255, 255)  
WindUI.Themes.Dark.ButtonBorder = Color3.fromRGB(255, 255, 255)  

local function addButtonBorderStyle()
    local mainFrame = Window.UIElements.Main
    if not mainFrame then return end
    
    local styleSheet = Instance.new("StyleSheet")
    styleSheet.Parent = mainFrame
    
    local rule = Instance.new("StyleRule")
    rule.Selector = "Button, ImageButton, TextButton"
    rule.Parent = styleSheet
    
    local borderProp = Instance.new("StyleProperty")
    borderProp.Name = "BorderSizePixel"
    borderProp.Value = 1
    borderProp.Parent = rule
    
    local colorProp = Instance.new("StyleProperty")
    colorProp.Name = "BorderColor3"
    colorProp.Value = Color3.fromRGB(255, 255, 255)
    colorProp.Parent = rule
end

Window:CreateTopbarButton("theme-switcher", "moon", function()
    local themes_list = {"Dark", "Light", "Mocha", "Aqua"}
    currentThemeIndex = (currentThemeIndex % #themes_list) + 1
    local newTheme = themes_list[currentThemeIndex]
    WindUI:SetTheme(newTheme)
    WindUI:Notify({
        Title = "主题已切换",
        Content = "当前主题: "..newTheme,
        Duration = 2
    })
end, 990)

WindUI.Themes.Dark.Toggle = Color3.fromHex("FF69B4")
WindUI.Themes.Dark.Checkbox = Color3.fromHex("FFB6C1")
WindUI.Themes.Dark.Button = Color3.fromHex("FF1493")
WindUI.Themes.Dark.Slider = Color3.fromHex("FF69B4")

local COLOR_SCHEMES = {
    ["彩虹颜色"] = {ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("FF0000")),
        ColorSequenceKeypoint.new(0.16, Color3.fromHex("FFA500")),
        ColorSequenceKeypoint.new(0.33, Color3.fromHex("FFFF00")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("00FF00")),
        ColorSequenceKeypoint.new(0.66, Color3.fromHex("0000FF")),
        ColorSequenceKeypoint.new(0.83, Color3.fromHex("4B0082")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("EE82EE"))
    }), "palette"},
    
    ["樱花粉1"] = {ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("FF69B4")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF1493")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("FFB6C1"))
    }), "candy"},

    ["樱花粉2"] = {ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("FED0E0")),
        ColorSequenceKeypoint.new(0.2, Color3.fromHex("FDBAD2")),
        ColorSequenceKeypoint.new(0.4, Color3.fromHex("FCA5C5")),
        ColorSequenceKeypoint.new(0.6, Color3.fromHex("FB8FB7")),
        ColorSequenceKeypoint.new(0.8, Color3.fromHex("FA7AA9")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("F9649B"))
    }), "waves"},
}

Window:EditOpenButton({
    Title = "<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>S</font><font color='#444444'>C</font><font color='#222222'>R</font><font color='#111111'>I</font><font color='#000000'>P</font><font color='#000000'>T</font>",
    CornerRadius = UDim.new(16,16),
    StrokeThickness = 2,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 188, 217)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 153, 204)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 105, 180)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 192, 203))
    }),
    Draggable = true,
})

local function createRainbowBorder(window, colorScheme, speed)
    local mainFrame = window.UIElements.Main
    if not mainFrame then return nil end
    
    local existingStroke = mainFrame:FindFirstChild("RainbowStroke")
    if existingStroke then
        existingStroke:Destroy()
    end
    
    if not mainFrame:FindFirstChildOfClass("UICorner") then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 16)
        corner.Parent = mainFrame
    end
    
    local rainbowStroke = Instance.new("UIStroke")
    rainbowStroke.Name = "RainbowStroke"
    rainbowStroke.Thickness = 2
    rainbowStroke.Color = Color3.new(1, 1, 1)
    rainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    rainbowStroke.LineJoinMode = Enum.LineJoinMode.Round
    rainbowStroke.Parent = mainFrame
    
    local glowEffect = Instance.new("UIGradient")
    glowEffect.Name = "GlowEffect"
    
    local schemeData = COLOR_SCHEMES[colorScheme or "樱花粉2"]
    if schemeData then
        glowEffect.Color = schemeData[1]
    else
        glowEffect.Color = COLOR_SCHEMES["樱花粉2"][1]
    end
    
    glowEffect.Rotation = 0
    glowEffect.Parent = rainbowStroke
    
    return rainbowStroke
end

local function startBorderAnimation(window, speed)
    local mainFrame = window.UIElements.Main
    if not mainFrame then return nil end
    
    local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
    if not rainbowStroke then return nil end
    
    local glowEffect = rainbowStroke:FindFirstChild("GlowEffect")
    if not glowEffect then return nil end
    
    local animation = game:GetService("RunService").Heartbeat:Connect(function()
        if not rainbowStroke or rainbowStroke.Parent == nil then
            animation:Disconnect()
            return
        end
        
        local time = tick()
        glowEffect.Rotation = (time * speed * 60) % 360
    end)
    
    return animation
end

local borderAnimation
local borderEnabled = true
local currentColor = "樱花粉2"
local animationSpeed = 5

local rainbowStroke = createRainbowBorder(Window, currentColor, animationSpeed)
if rainbowStroke then
    borderAnimation = startBorderAnimation(Window, animationSpeed)
end

Window:SetToggleKey(Enum.KeyCode.F, true)

local Tabs = {
    Main = Window:Tab({ Title = "主页", Icon = "home" }),
    Elements = Window:Tab({ Title = "速度区", Icon = "layout-grid" }),
    Rage = Window:Tab({ Title = "体力区", Icon = "skull" }), 
    LoadScript = Window:Tab({ Title = "音乐区", Icon = "file" }), 
    Settings = Window:Tab({ Title = "设置", Icon = "settings" }),
    Config = Window:Tab({ Title = "配置", Icon = "save" })
}

-- ==================== 主页内容 ====================
Tabs.Main:Paragraph({
    Title = "欢迎使用ZiYang赛马娘",
    Desc = "作者：zy｜ UI提供：zy｜赛马娘\n版本：v1.0.0\n\n本人亲自制作",
    ImageSize = 50,
    Thumbnail = "https://raw.githubusercontent.com/xiaoxi9008/chesksks/refs/heads/main/1357873301.jpg",
    ThumbnailSize = 170
})

Tabs.Main:Divider()

Tabs.Main:Button({
    Title = "显示欢迎通知",
    Icon = "bell",
    Callback = function()
        WindUI:Notify({
            Title = "欢迎!",
            Content = "感谢使用ZiYang",
            Icon = "heart",
            Duration = 3
        })
    end
})

-- ==================== 速度选项卡 ====================
local elementSection = Tabs.Elements:Section({ Title = "速度（注意要过一分钟才能终点直接进终点就可以直接给你踢了）", Icon = "box", Opened = true })



local aimbotToggleState = false
local aimbotDemo = elementSection:Toggle({
    Title = "移速修改",
    Default = false,
    Callback = function(v)
        if v == true then
            sudu = game:GetService("RunService").Heartbeat:Connect(function()
                if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character.Humanoid and game:GetService("Players").LocalPlayer.Character.Humanoid.Parent then
                    if game:GetService("Players").LocalPlayer.Character.Humanoid.MoveDirection.Magnitude > 0 then
                        game:GetService("Players").LocalPlayer.Character:TranslateBy(game:GetService("Players").LocalPlayer.Character.Humanoid.MoveDirection * Speed / 10)
                    end
                end
            end)
        elseif not v and sudu then
            sudu:Disconnect()
            sudu = nil
        end
    end
})    
elementSection:Slider({
    Title = "速度设置",
    Value = {
        Min = 1,
        Max = 100,
        Default = 1,
    },
    Callback = function(Value)
        Speed = Value
    end
})




-- ==============================================
-- 暴力区内容
-- ==============================================

local RageSection = Tabs.Rage:Section({ Title = "体力设置" })

local oldNamecall = nil
local infiniteStaminaEnabled = false

RageSection:Toggle({
    Title = "无限体力",
    Value = false,
    Callback = function(value)
        infiniteStaminaEnabled = value
        if value then
            if not oldNamecall then
                oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                    if getnamecallmethod() == "FireServer" and tostring(self) == "RequestSprintAction" then
                        local args = {...}
                        if args[1] == "SpeedTarget" then
                            args[2] = 0
                            return oldNamecall(self, unpack(args))
                        end
                    end
                    return oldNamecall(self, ...)
                end)
            end
        else
            if oldNamecall then
                hookmetamethod(game, "__namecall", oldNamecall)
                oldNamecall = nil
            end
        end
    end
})

local RageSection = Tabs.Rage:Section({ Title = "演戏体力" })

RageSection:Slider({
    Title = "体力消耗值",
    Description = "0 = 10",
    Min = 0,
    Max = 10,
    Default = 0,
    StepRounding = 0,
    Callback = function(value)
        staminaCostValue = value
    end
})

-- 无限体力开关
RageSection:Toggle({
    Title = "体力开关",
    Value = false,
    Callback = function(value)
        infiniteStaminaEnabled = value
        if value then
            if not oldNamecall then
                oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                    if getnamecallmethod() == "FireServer" and tostring(self) == "RequestSprintAction" then
                        local args = {...}
                        if args[1] == "SpeedTarget" then
                            args[2] = staminaCostValue or 0
                            return oldNamecall(self, unpack(args))
                        end
                    end
                    return oldNamecall(self, ...)
                end)
            end
        else
            if oldNamecall then
                hookmetamethod(game, "__namecall", oldNamecall)
                oldNamecall = nil
            end
        end
    end
})
-- ==================== 加载脚本选项卡 ====================
Tabs.LoadScript:Paragraph({ -- 把 Scripts 改成 LoadScript
    Title = "加载其他脚本",
    Desc = "点击下方按钮加载对应的脚本"
})
Tabs.LoadScript:Divider() -- 把 Scripts 改成 LoadScript

Tabs.LoadScript:Button({ -- 把 Scripts 改成 LoadScript
    Title = "网易云音乐",
    Icon = "file",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E7%BD%91%E6%98%93%E4%BA%91.lua"))()
        end)
        if success then
            WindUI:Notify({
                Title = "加载成功",
                Content = "网易云音乐已加载",
                Type = "success"
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "错误: " .. tostring(err),
                Type = "error"
            })
        end
    end
})
 
-- ==================== 设置选项卡 ====================
-- 边框设置区域

local borderSection = Tabs.Settings:Section({ Title = "边框设置", Icon = "square", Opened = true })

borderSection:Toggle({
    Title = "启用边框",
    Value = true,
    Callback = function(value)
        borderEnabled = value
        local mainFrame = Window.UIElements.Main
        if mainFrame then
            local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
            if rainbowStroke then
                rainbowStroke.Enabled = value
                if value and not borderAnimation then
                    borderAnimation = startBorderAnimation(Window, animationSpeed)
                elseif not value and borderAnimation then
                    borderAnimation:Disconnect()
                    borderAnimation = nil
                end
            end
        end
    end
})

local colorNames = {}
for name, _ in pairs(COLOR_SCHEMES) do
    table.insert(colorNames, name)
end

borderSection:Dropdown({
    Title = "颜色方案",
    Values = colorNames,
    Value = "樱花粉2",
    Callback = function(value)
        currentColor = value
        local mainFrame = Window.UIElements.Main
        if mainFrame then
            local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
            if rainbowStroke then
                local glowEffect = rainbowStroke:FindFirstChild("GlowEffect")
                if glowEffect then
                    local schemeData = COLOR_SCHEMES[value]
                    if schemeData then
                        glowEffect.Color = schemeData[1]
                    end
                end
            end
        end
    end
})

borderSection:Slider({
    Title = "动画速度",
    Value = {
        Min = 1,
        Max = 10,
        Default = 5,
    },
    Callback = function(value)
        animationSpeed = value
        if borderAnimation then
            borderAnimation:Disconnect()
            borderAnimation = nil
        end
        if borderEnabled then
            borderAnimation = startBorderAnimation(Window, animationSpeed)
        end
    end
})

borderSection:Slider({
    Title = "边框粗细",
    Value = {
        Min = 1,
        Max = 5,
        Default = 2,
    },
    Step = 0.5,
    Callback = function(value)
        local mainFrame = Window.UIElements.Main
        if mainFrame then
            local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
            if rainbowStroke then
                rainbowStroke.Thickness = value
            end
        end
    end
})

borderSection:Slider({
    Title = "圆角大小",
    Value = {
        Min = 0,
        Max = 30,
        Default = 16,
    },
    Callback = function(value)
        local mainFrame = Window.UIElements.Main
        if mainFrame then
            local corner = mainFrame:FindFirstChildOfClass("UICorner")
            if not corner then
                corner = Instance.new("UICorner")
                corner.Parent = mainFrame
            end
            corner.CornerRadius = UDim.new(0, value)
        end
    end
})

-- 外观设置区域
local appearanceSection = Tabs.Settings:Section({ Title = "外观设置", Icon = "brush", Opened = true })

local themes_list = {}
for themeName, _ in pairs(WindUI:GetThemes()) do
    table.insert(themes_list, themeName)
end
table.sort(themes_list)

local themeDropdown = appearanceSection:Dropdown({
    Title = "选择主题",
    Values = themes_list,
    Value = "Dark",
    Callback = function(theme)
        WindUI:SetTheme(theme)
        WindUI:Notify({
            Title = "主题已应用",
            Content = theme,
            Icon = "palette",
            Duration = 2
        })
    end
})

local transparencySlider = appearanceSection:Slider({
    Title = "透明度",
    Value = { 
        Min = 0,
        Max = 1,
        Default = 0.2,
    },
    Step = 0.1,
    Callback = function(value)
        Window:ToggleTransparency(tonumber(value) > 0)
        WindUI.TransparencyValue = tonumber(value)
    end
})

-- ==================== 配置选项卡 ====================
local configSection = Tabs.Config:Section({ Title = "配置管理", Icon = "settings", Opened = true })

configSection:Paragraph({
    Title = "配置管理器",
    Desc = "保存和加载你的设置",
    Image = "save",
    ImageSize = 20,
    Color = "White"
})

local configName = "default"
local configFile = nil
local MyPlayerData = {
    name = "Player1",
    level = 1,
    inventory = { "sword", "shield", "potion" }
}

configSection:Input({
    Title = "配置名称",
    Value = configName,
    Callback = function(value)
        configName = value
    end
})

local ConfigManager = Window.ConfigManager
if ConfigManager then
    ConfigManager:Init(Window)
    
    configSection:Button({
        Title = "保存配置",
        Icon = "save",
        Variant = "Primary",
        Callback = function()
            configFile = ConfigManager:CreateConfig(configName)
            
            configFile:Register("demo1", demo1)
            configFile:Register("themeDropdown", themeDropdown)
            configFile:Register("transparencySlider", transparencySlider)
            
            configFile:Set("playerData", MyPlayerData)
            configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))
            
            if configFile:Save() then
                WindUI:Notify({ 
                    Title = "保存配置", 
                    Content = "已保存为: "..configName,
                    Icon = "check",
                    Duration = 3
                })
            else
                WindUI:Notify({ 
                    Title = "错误", 
                    Content = "保存配置失败",
                    Icon = "x",
                    Duration = 3
                })
            end
        end
    })

    configSection:Button({
        Title = "加载配置",
        Icon = "folder",
        Callback = function()
            configFile = ConfigManager:CreateConfig(configName)
            local loadedData = configFile:Load()
            
            if loadedData then
                if loadedData.playerData then
                    MyPlayerData = loadedData.playerData
                end
                
                local lastSave = loadedData.lastSave or "未知"
                WindUI:Notify({ 
                    Title = "加载配置", 
                    Content = "已加载: "..configName.."\n上次保存: "..lastSave,
                    Icon = "refresh-cw",
                    Duration = 5
                })
                
                configSection:Paragraph({
                    Title = "玩家数据",
                    Desc = string.format("名称: %s\n等级: %d\n物品: %s", 
                        MyPlayerData.name, 
                        MyPlayerData.level, 
                        table.concat(MyPlayerData.inventory, ", "))
                })
            else
                WindUI:Notify({ 
                    Title = "错误", 
                    Content = "加载配置失败",
                    Icon = "x",
                    Duration = 3
                })
            end
        end
    })
    
    -- 配置文件列表
    configSection:Button({
        Title = "列出所有配置",
        Icon = "list",
        Callback = function()
            local files = ConfigManager:ListConfigs()
            local fileList = "找到 "..#files.." 个配置:\n"
            for i, file in ipairs(files) do
                fileList = fileList .. i .. ". " .. file .. "\n"
            end
            WindUI:Notify({
                Title = "配置文件列表",
                Content = fileList,
                Duration = 5
            })
        end
    })
else
    configSection:Paragraph({
        Title = "配置管理器不可用",
        Desc = "此功能需要ConfigManager",
        Image = "alert-triangle",
        ImageSize = 20,
        Color = "White"
    })
end

-- 关于信息
local aboutSection = Tabs.Config:Section({ Title = "关于" })
aboutSection:Paragraph({
    Title = "群号",
    Desc = "\n作者：zy子杨\n\n赛马娘 v1.0.0",
    Image = "🐧",
    ImageSize = 20,
    Color = "Grey",
    Buttons = {
        {
            Title = "复制链接",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("点击链接加入群聊"))
                WindUI:Notify({
                    Title = "已复制!",
                    Content = "qq主群链接已复制到剪贴板",
                    Duration = 2
                })
            end
        }
    }
})

-- 窗口关闭清理
Window:OnClose(function()
    print("窗口关闭")
    
    if borderAnimation then
        borderAnimation:Disconnect()
        borderAnimation = nil
    end
    
    if ConfigManager and configFile then
        configFile:Set("playerData", MyPlayerData)
        configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))
        configFile:Save()
        print("配置已自动保存")
    end
end)

Window:OnDestroy(function()
    print("窗口已销毁")
end)
