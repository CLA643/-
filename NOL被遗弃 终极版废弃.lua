


local repo = 'https://raw.githubusercontent.com/deividcomsono/Obsidian/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local Options = Library.Options
local Toggles = Library.Toggles


local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")


if not table.clone then
    table.clone = function(t)
        local nt = {}
        for k,v in pairs(t) do nt[k] = v end
        return nt
    end
end

Library.ShowToggleFrameInKeybinds = true 
Library.ShowCustomCursor = true
Library.NotifySide = "Right"

local Window = Library:CreateWindow({
    Title = 'HUK | Forsaken',
    Footer = "Semi-British[國際化]",
    Icon = 106397684977541,
    Center = true,
    AutoShow = true,
    Resizable = true,
    ShowCustomCursor = true,
    NotifySide = "Right",
    TabPadding = 8,
    MenuFadeTime = 0
})

local Tabs = {
    new = Window:AddTab('Announcement[公告]', 'user'),
    Main = Window:AddTab('Main[主要]','house'),
    Aimbot = Window:AddTab('Aimbot[自瞄]','earth'),
    Esp = Window:AddTab('ESP[绘制]','eye'),
    tzq = Window:AddTab('Notice[通知提示]','eye'),
    ani = Window:AddTab('Anti-loophole[反效果]','earth'),
    Max = Window:AddTab('Action[动作]','file'),
    Sat = Window:AddTab('Physical[体力]','moon'),
    zdg = Window:AddTab('Auto block[自动格挡]','file'),
    zdx = Window:AddTab('Fix Generator[修机]','file'),
    lol = Window:AddTab('Pizza[披萨]','earth'),
    tfz = Window:AddTab('Killing[杀戮]','moon'),
    mhg = Window:AddTab('skin[美化]','moon')
}

local _env = getgenv and getgenv() or {}
local _hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")

local new = Tabs.new:AddLeftGroupbox('最新公告')

new:AddLabel("[+]HUK 中國最強Forsaken腳本")
new:AddLabel("[+]修復大部分功能")
new:AddLabel("[+]新增反效果漏洞")







local KillerSurvival = Tabs.Main:AddLeftGroupbox("调节功能")

game.Players.LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
    if _env.NoStun == true and game.Players.LocalPlayer.Character.Humanoid.WalkSpeed < 16 then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

game.Players.LocalPlayer.CharacterAdded:Connect(function()
    game.Players.LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if _env.NoStun == true and game.Players.LocalPlayer.Character.Humanoid.WalkSpeed < 16 then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end)
end)

KillerSurvival:AddToggle("NS",{
    Text = "去除前后摇",
    Callback = function(v)
        _env.NoStun = v
    end
})

KillerSurvival:AddDivider()

KillerSurvival:AddSlider("SB",{
    Text = "速度调节",
    Min = 0, Max = 3,
    Default = 1, Compact = true,
    Rounding = 1,
    Callback = function(v)
        _env.SpeedBoostValue = v
    end
})

_env.SpeedBoostValue = 1

KillerSurvival:AddToggle("SB",{
    Text = "启用速度",
    Callback = function(v)
        _env.SpeedBoost = v
        while _env.SpeedBoost do
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame += game.Players.LocalPlayer.Character.Humanoid.MoveDirection * _env.SpeedBoostValue
            game.Players.LocalPlayer.Character.HumanoidRootPart.CanCollide = true
            task.wait()
        end
    end
})

KillerSurvival:AddToggle('MyToggle', {
    Text = '顯示聊天框丨需要每局开一次',
    Default = false,
    Tooltip = '显示聊天框',
    Callback = function(state)
    if state then
    game.TextChatService.ChatWindowConfiguration.Enabled = true
    else
    game.TextChatService.ChatWindowConfiguration.Enabled = false    
    end
    end
})


local MainTabbox = Tabs.Main:AddRightTabbox()
local Lighting = MainTabbox:AddTab("亮度调节")

Lighting:AddSlider("B",{
    Text = "亮度数值",
    Min = 0,
    Default = 0,
    Max = 3,
    Rounding = 1,
    Compact = true,
    Callback = function(v)
        _env.Brightness = v
    end
})

Lighting:AddToggle("无阴影",{
    Text = "无阴影",
    Default = false,
    Callback = function(v)
        _env.GlobalShadows = v
    end
})

Lighting:AddToggle("除雾",{
    Text = "除雾",
    Default = false,
    Callback = function(v)
        _env.NoFog = v
    end
})

Lighting:AddDivider()

Lighting:AddToggle("启用功能",{
    Text = "启用",
    Default = false,
    Callback = function(v)
        _env.Fullbright = v
        game:GetService("RunService").RenderStepped:Connect(function()
            if not game.Lighting:GetAttribute("FogStart") then 
                game.Lighting:SetAttribute("FogStart", game.Lighting.FogStart) 
            end
            if not game.Lighting:GetAttribute("FogEnd") then 
                game.Lighting:SetAttribute("FogEnd", game.Lighting.FogEnd) 
            end
            game.Lighting.FogStart = _env.NoFog and 0 or game.Lighting:GetAttribute("FogStart")
            game.Lighting.FogEnd = _env.NoFog and math.huge or game.Lighting:GetAttribute("FogEnd")
            
            local fog = game.Lighting:FindFirstChildOfClass("Atmosphere")
            if fog then
                if not fog:GetAttribute("Density") then 
                    fog:SetAttribute("Density", fog.Density) 
                end
                fog.Density = _env.NoFog and 0 or fog:GetAttribute("Density")
            end
            
            if _env.Fullbright then
                game.Lighting.OutdoorAmbient = Color3.new(1,1,1)
                game.Lighting.Brightness = _env.Brightness or 0
                game.Lighting.GlobalShadows = not _env.GlobalShadows
            else
                game.Lighting.OutdoorAmbient = Color3.fromRGB(55,55,55)
                game.Lighting.Brightness = 0
                game.Lighting.GlobalShadows = true
            end
        end)
    end
    
})








local NOL = Tabs.Main:AddLeftGroupbox("服务器")

NOL:AddToggle("服务器位置", {
    Text = "显示你在服务器上的位置",
    Default = false,
    Callback = function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 创建霓虹跟随者模型
local neonModel = Instance.new("Model")
neonModel.Name = player.Name.."_NeonFollower"
neonModel.Parent = workspace

-- 创建R6标准部件函数
local function createR6Part(name, size, offset)
    local part = Instance.new("Part")
    part.Name = name
    part.Shape = Enum.PartType.Block
    part.Size = size
    part.Material = Enum.Material.ForceField
    part.Color = Color3.fromRGB(255, 0, 0)
    part.Transparency = 0.5
    part.CanCollide = false
    part.Anchored = true
    part.TopSurface = Enum.SurfaceType.Smooth
    part.BottomSurface = Enum.SurfaceType.Smooth
    part.Parent = neonModel
    return part, offset
end

-- 创建并组装部件
local parts = {}
parts.torso, parts.torsoOffset = createR6Part("Torso", Vector3.new(2, 2, 1), CFrame.new(0,0,0))
parts.head, parts.headOffset = createR6Part("Head", Vector3.new(1, 1, 1), CFrame.new(0, 1.5, 0))
parts.leftArm, parts.leftArmOffset = createR6Part("Left Arm", Vector3.new(1, 2, 1), CFrame.new(-1.5, 0, 0))
parts.rightArm, parts.rightArmOffset = createR6Part("Right Arm", Vector3.new(1, 2, 1), CFrame.new(1.5, 0, 0))
parts.leftLeg, parts.leftLegOffset = createR6Part("Left Leg", Vector3.new(1, 2, 1), CFrame.new(-0.5, -2, 0))
parts.rightLeg, parts.rightLegOffset = createR6Part("Right Leg", Vector3.new(1, 2, 1), CFrame.new(0.5, -2, 0))

-- 初始位置
local baseCFrame = humanoidRootPart.CFrame
for name, part in pairs(parts) do
    if type(part) == "Instance" then
        part.CFrame = baseCFrame * parts[name .. "Offset"]
    end
end

-- 位置历史记录
local positionHistory = {}
local maxHistoryLength = 20
local replaySpeed = 0.5
for i = 1, maxHistoryLength do positionHistory[i] = baseCFrame end

-- 动画参数
local walkCycle = 0
local walkSpeed = 12

-- 官方R6动画偏移
local function getOfficialR6Offsets(cycle)
    local sin = math.sin(cycle)
    local cos = math.cos(cycle)
    return {
        head = CFrame.new(0, 0, 0),
        torso = CFrame.new(0, cos * 0.05, 0),
        leftArm = CFrame.Angles(sin * math.rad(30), 0, 0),
        rightArm = CFrame.Angles(-sin * math.rad(30), 0, 0),
        leftLeg = CFrame.Angles(-sin * math.rad(35), 0, 0),
        rightLeg = CFrame.Angles(sin * math.rad(35), 0, 0)
    }
end

local connection
connection = RunService.Heartbeat:Connect(function(deltaTime)
    if not character or not character.Parent then
        connection:Disconnect()
        neonModel:Destroy()
        return
    end

    -- 更新位置历史
    table.insert(positionHistory, 1, humanoidRootPart.CFrame)
    if #positionHistory > maxHistoryLength then table.remove(positionHistory) end

    -- 计算延迟位置
    local replayIndex = math.clamp(math.floor(#positionHistory * replaySpeed), 1, #positionHistory)
    local targetCFrame = positionHistory[replayIndex]

    -- 平滑移动 torso
    local currentCFrame = parts.torso.CFrame
    local lerpFactor = math.min(10 * deltaTime, 1)
    local newPosition = currentCFrame.Position:Lerp(targetCFrame.Position, lerpFactor)
    local newRotation = currentCFrame.Rotation:Lerp(targetCFrame.Rotation, lerpFactor)
    local newTorsoCFrame = CFrame.new(newPosition) * newRotation
    parts.torso.CFrame = newTorsoCFrame

    -- 检测移动
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local isMoving = humanoid and humanoid.MoveDirection.Magnitude > 0
    
    -- 更新走路周期
    if isMoving then
        walkCycle = (walkCycle + deltaTime * walkSpeed) % (math.pi * 2)
    else
        walkCycle = walkCycle * (1 - deltaTime * 5)
        if math.abs(walkCycle) < 0.01 then walkCycle = 0 end
    end

    -- 获取偏移
    local offsets = getOfficialR6Offsets(walkCycle)
    
    -- 应用动画
    for name, part in pairs(parts) do
        if type(part) == "Instance" then
            local offsetName = name
            part.CFrame = newTorsoCFrame * parts[name .. "Offset"] * offsets[offsetName]
        end
    end
end)
    end
})


local ZZ = Tabs.Main:AddRightGroupbox('机会自动投币')

ZZ:AddToggle('自動投幣', {
    Text = '自动投掷硬币',
    Default = false,
    Tooltip = '自动使用硬币投掷能力',
    
    Callback = function(state)
        _G.AutoFlipCoins = state
        
        if _G.AutoFlipCoins then
            flipCoinsThread = task.spawn(function()
                while _G.AutoFlipCoins and task.wait() do
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer("UseActorAbility", "CoinFlip")
                end
            end)
        elseif flipCoinsThread then
            task.cancel(flipCoinsThread)
            flipCoinsThread = nil
        end
    end
})



local ZZ = Tabs.Main:AddRightGroupbox('自動拾取物品')


ZZ:AddToggle('医疗包传送并拾取', {
    Text = '医疗包传送并拾取',
    Default = false,
    Tooltip = '自动将医疗包传送到自己位置并互动',
    
    Callback = function(state)
        autoTeleportMedkitEnabled = state
        
        if autoTeleportMedkitEnabled then
            teleportMedkitThread = task.spawn(function()
                while autoTeleportMedkitEnabled and task.wait(0.5) do
                  
                    local character = game.Players.LocalPlayer.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local humanoidRootPart = character.HumanoidRootPart
                        
                      
                        local medkit = workspace:FindFirstChild("Map", true)
                        if medkit then
                            medkit = medkit:FindFirstChild("Ingame", true)
                            if medkit then
                                medkit = medkit:FindFirstChild("Medkit", true)
                                if medkit then
                                    local itemRoot = medkit:FindFirstChild("ItemRoot", true)
                                    if itemRoot then
                                       
                                        itemRoot.CFrame = humanoidRootPart.CFrame + humanoidRootPart.CFrame.LookVector * 3
                                        
                                       
                                        local prompt = itemRoot:FindFirstChild("ProximityPrompt", true)
                                        if prompt then
                                            fireproximityprompt(prompt)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        elseif teleportMedkitThread then
            task.cancel(teleportMedkitThread)
            teleportMedkitThread = nil
        end
    end
})


ZZ:AddToggle('可乐传送并拾取', {
    Text = '可乐传送并拾取',
    Default = false,
    Tooltip = '自动将可乐传送到自己位置并互动',
    
    Callback = function(state)
        autoTeleportColaEnabled = state
        
        if autoTeleportColaEnabled then
            teleportColaThread = task.spawn(function()
                while autoTeleportColaEnabled and task.wait(0.5) do
                    -- 获取玩家角色
                    local character = game.Players.LocalPlayer.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local humanoidRootPart = character.HumanoidRootPart
                        
                        -- 查找可乐
                        local cola = workspace:FindFirstChild("Map", true)
                        if cola then
                            cola = cola:FindFirstChild("Ingame", true)
                            if cola then
                                cola = cola:FindFirstChild("BloxyCola", true)
                                if cola then
                                    local itemRoot = cola:FindFirstChild("ItemRoot", true)
                                    if itemRoot then
                                        -- 将可乐传送到玩家前方3个单位的位置
                                        itemRoot.CFrame = humanoidRootPart.CFrame + humanoidRootPart.CFrame.LookVector * 3
                                        
                                        -- 查找互动提示并触发
                                        local prompt = itemRoot:FindFirstChild("ProximityPrompt", true)
                                        if prompt then
                                            fireproximityprompt(prompt)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        elseif teleportColaThread then
            task.cancel(teleportColaThread)
            teleportColaThread = nil
        end
    end
})



ZZ:AddToggle('自动拾取医疗包', {
    Text = '自动互动医疗包',
    Default = false,
    Tooltip = '自动与医疗包互动',
    
    Callback = function(state)
        autoMedkitEnabled = state
        
        if autoMedkitEnabled then
            medkitThread = task.spawn(function()
                while autoMedkitEnabled and task.wait(0.5) do
                    local medkit = workspace:FindFirstChild("Map", true)
                    if medkit then
                        medkit = medkit:FindFirstChild("Ingame", true)
                        if medkit then
                            medkit = medkit:FindFirstChild("Medkit", true)
                            if medkit then
                                local itemRoot = medkit:FindFirstChild("ItemRoot", true)
                                if itemRoot then
                                    local prompt = itemRoot:FindFirstChild("ProximityPrompt", true)
                                    if prompt then
                                        fireproximityprompt(prompt)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        elseif medkitThread then
            task.cancel(medkitThread)
            medkitThread = nil
        end
    end
})


ZZ:AddToggle('自动拾取可乐', {
    Text = '自动互动可乐',
    Default = false,
    Tooltip = '自动与可乐互动',
    
    Callback = function(state)
        autoColaEnabled = state
        
        if autoColaEnabled then
            colaThread = task.spawn(function()
                while autoColaEnabled and task.wait(0.5) do
                    local cola = workspace:FindFirstChild("Map", true)
                    if cola then
                        cola = cola:FindFirstChild("Ingame", true)
                        if cola then
                            cola = cola:FindFirstChild("BloxyCola", true)
                            if cola then
                                local itemRoot = cola:FindFirstChild("ItemRoot", true)
                                if itemRoot then
                                    local prompt = itemRoot:FindFirstChild("ProximityPrompt", true)
                                    if prompt then
                                        fireproximityprompt(prompt)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        elseif colaThread then
            task.cancel(colaThread)
            colaThread = nil
        end
    end
})


local Camera = MainTabbox:AddTab("视野")
Camera:AddSlider("视野范围",{
    Text = "调节范围",
    Min = 70,Default = 70,
    Max = 120,Rounding = 1,
    Compact = true,
    Callback = function(v)
        _env.FovValue = v
    end
})

_G.FovValue = 70

Camera:AddToggle("应用范围",{
    Text = "应用",
    Callback = function(v)
        _env.FOV = v
        game:GetService("RunService").RenderStepped:Connect(function()
            if _env.FOV then
                workspace.Camera.FieldOfView = _env.FovValue
            end
        end)
    end
})

local Size = 5
local speed = 1
local player = game:GetService("Players").LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local rootPart = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- 为每个自瞄功能创建独立的最大距离变量
local chanceMaxDistance = 50
local twoTimeMaxDistance = 50
local shedletskyMaxDistance = 50
local x1x4MaxDistance = 50
local coolMaxDistance = 50
local johnMaxDistance = 50
local jasonMaxDistance = 50

-- 创建UI
local SB = Tabs.Aimbot:AddLeftGroupbox('幸存者')

-- 机会自瞄距离滑块
SB:AddSlider('ChanceDistance', {
    Text = '机会自瞄距离',
    Default = 50,
    Min = 10,
    Max = 150,
    Rounding = 1,
    Compact = false,
    Callback = function(value)
        chanceMaxDistance = value
    end
})

-- 两次自瞄距离滑块
SB:AddSlider('TwoTimeDistance', {
    Text = '两次自瞄距离',
    Default = 50,
    Min = 10,
    Max = 150,
    Rounding = 1,
    Compact = false,
    Callback = function(value)
        twoTimeMaxDistance = value
    end
})

-- 谢德利茨基自瞄距离滑块
SB:AddSlider('ShedletskyDistance', {
    Text = '谢德利茨基自瞄距离',
    Default = 50,
    Min = 10,
    Max = 150,
    Rounding = 1,
    Compact = false,
    Callback = function(value)
        shedletskyMaxDistance = value
    end
})

-- 幸存者自瞄功能
local function chanceAimbot(state)
    CA = state
    if state then
        if game.Players.LocalPlayer.Character.Name ~= "Chance" then
            Library:Notify("你用的角色好像不是机会,无法生效", nil, 4590657391)
            return
        end
        
        local RemoteEvent = game:GetService("ReplicatedStorage")
            :WaitForChild("Modules")
            :WaitForChild("Network")
            :WaitForChild("RemoteEvent")
            
        CAbotConnection = RemoteEvent.OnClientEvent:Connect(function(...)
            local args = {...}
            if args[1] == "UseActorAbility" and args[2] == "Shoot" then 
                local killerContainer = game.Workspace.Players:FindFirstChild("Killers")
                if killerContainer then 
                    local killer = killerContainer:FindFirstChildOfClass("Model")
                    if killer and killer:FindFirstChild("HumanoidRootPart") then 
                        local killerHRP = killer.HumanoidRootPart
                        local playerHRP = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if playerHRP then 
                            local distance = (killerHRP.Position - playerHRP.Position).Magnitude
                            if distance <= chanceMaxDistance then
                                local TMP = 0.35
                                local AMD = 2
                                local endTime = tick() + AMD
                                while tick() < endTime do
                                    RunService.RenderStepped:Wait()
                                    local predictedTarget = killerHRP.Position + (killerHRP.Velocity * TMP)
                                    game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = killerHRP.CFrame + Vector3.new(0, 0, -2)
                                end
                                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = PICF
                            end
                        end
                    end
                end
            end
        end)
    else
        if CAbotConnection then
            CAbotConnection:Disconnect()
            CAbotConnection = nil
        end
    end
end

local function TWO(state)
    local TWOsounds = {
        "rbxassetid://86710781315432",
        "rbxassetid://99820161736138"
    }
    
    TWOTIME = state

    if game:GetService("Players").LocalPlayer.Character.Name ~= "TwoTime" and state then
        Library:Notify("你的角色不是Two Time，无法生效", nil, 4590657391)
        return 
    end

    if state then
        TWOloop = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.ChildAdded:Connect(function(child)
            if not TWOTIME then return end
            for _, v in pairs(TWOsounds) do
                if child.Name == v then
                    local survivors = {}
                    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                        if player ~= game:GetService("Players").LocalPlayer then
                            local character = player.Character
                            if character and character:FindFirstChild("HumanoidRootPart") then
                                table.insert(survivors, character)
                            end
                        end
                    end

                    local nearestSurvivor = nil
                    local shortestDistance = math.huge  
                    
                    for _, survivor in pairs(survivors) do
                        local survivorHRP = survivor.HumanoidRootPart
                        local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        
                        if playerHRP then
                            local distance = (survivorHRP.Position - playerHRP.Position).Magnitude
                            if distance < shortestDistance and distance <= twoTimeMaxDistance then
                                shortestDistance = distance
                                nearestSurvivor = survivor
                            end
                        end
                    end
                    
                    if nearestSurvivor then
                        local nearestHRP = nearestSurvivor.HumanoidRootPart
                        local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        
                        if playerHRP then
                            local direction = (nearestHRP.Position - playerHRP.Position).Unit
                            local num = 1
                            local maxIterations = 100 
                            
                            if child.Name == "rbxassetid://79782181585087" then
                                maxIterations = 220  
                            end

                            while num <= maxIterations do
                                task.wait(0.01)
                                num = num + 1
                                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, nearestHRP.Position)
                                playerHRP.CFrame = CFrame.lookAt(playerHRP.Position, Vector3.new(nearestHRP.Position.X, nearestHRP.Position.Y, nearestHRP.Position.Z))  
                            end
                        end
                    end
                end
            end
        end)
    else
        if TWOloop then
            TWOloop:Disconnect()
            TWOloop = nil
        end
    end
end

local function shedletskyAimbot(state)
    shedaim = state
    if state then
        if game:GetService("Players").LocalPlayer.Character.Name ~= "Shedletsky" then
            Library:Notify("你用的角色好像不是谢德利茨基,无法生效", nil, 4590657391)
            return
        end
        
        shedloop = game:GetService("Players").LocalPlayer.Character.Sword.ChildAdded:Connect(function(child)
            if not shedaim then return end
            if child:IsA("Sound") then 
                local FAN = child.Name
                if FAN == "rbxassetid://12222225" or FAN == "83851356262523" then 
                    local killersFolder = game.Workspace.Players:FindFirstChild("Killers")
                    if killersFolder then 
                        local killer = killersFolder:FindFirstChildOfClass("Model")
                        if killer and killer:FindFirstChild("HumanoidRootPart") then 
                            local killerHRP = killer.HumanoidRootPart
                            local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if playerHRP then 
                                local distance = (killerHRP.Position - playerHRP.Position).Magnitude
                                if distance <= shedletskyMaxDistance then
                                    local num = 1
                                    local maxIterations = 100
                                    while num <= maxIterations do
                                        task.wait(0.01)
                                        num = num + 1
                                        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, killerHRP.Position)
                                        playerHRP.CFrame = CFrame.lookAt(playerHRP.Position, killerHRP.Position)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    else
        if shedloop then 
            shedloop:Disconnect()
            shedloop = nil
        end
    end
end

-- 杀手UI
local SC = Tabs.Aimbot:AddRightGroupbox('杀手')

-- 1x4自瞄距离滑块
SC:AddSlider('X1X4Distance', {
    Text = '1x4自瞄距离',
    Default = 50,
    Min = 10,
    Max = 150,
    Rounding = 1,
    Compact = false,
    Callback = function(value)
        x1x4MaxDistance = value
    end
})

-- 小孩自瞄距离滑块
SC:AddSlider('CoolDistance', {
    Text = '酷小孩自瞄距离',
    Default = 50,
    Min = 10,
    Max = 150,
    Rounding = 1,
    Compact = false,
    Callback = function(value)
        coolMaxDistance = value
    end
})

-- 约翰自瞄距离滑块
SC:AddSlider('JohnDistance', {
    Text = '约翰自瞄距离',
    Default = 50,
    Min = 10,
    Max = 150,
    Rounding = 1,
    Compact = false,
    Callback = function(value)
        johnMaxDistance = value
    end
})

-- 杰森自瞄距离滑块
SC:AddSlider('JasonDistance', {
    Text = '杰森自瞄距离',
    Default = 50,
    Min = 10,
    Max = 150,
    Rounding = 1,
    Compact = false,
    Callback = function(value)
        jasonMaxDistance = value
    end
})

-- 杀手自瞄功能
local function aimbot1x1x1x1(state)
    local aimbot1x1sounds = {
        "rbxassetid://101593173978979",
        "rbxassetid://72296288942160"
    }
    
    aimbot1x1 = state
    
    if game:GetService("Players").LocalPlayer.Character.Name ~= "1x1x1x1" and state then
        Library:Notify("你的角色不是1x4，无法生效", nil, 4590657391)
        return 
    end

    if state then
        aimbot1x1loop = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.ChildAdded:Connect(function(child)
            if not aimbot1x1 then return end
            for _, v in pairs(aimbot1x1sounds) do
                if child.Name == v then
                    local survivors = {}
                    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                        if player ~= game:GetService("Players").LocalPlayer then
                            local character = player.Character
                            if character and character:FindFirstChild("HumanoidRootPart") then
                                table.insert(survivors, character)
                            end
                        end
                    end

                    local nearestSurvivor = nil
                    local shortestDistance = math.huge  
                    
                    for _, survivor in pairs(survivors) do
                        local survivorHRP = survivor.HumanoidRootPart
                        local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        
                        if playerHRP then
                            local distance = (survivorHRP.Position - playerHRP.Position).Magnitude
                            if distance < shortestDistance and distance <= x1x4MaxDistance then
                                shortestDistance = distance
                                nearestSurvivor = survivor
                            end
                        end
                    end
                    
                    if nearestSurvivor then
                        local nearestHRP = nearestSurvivor.HumanoidRootPart
                        local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        
                        if playerHRP then
                            local direction = (nearestHRP.Position - playerHRP.Position).Unit
                            local num = 1
                            local maxIterations = 100 
                            
                            while num <= maxIterations do
                                task.wait(0.01)
                                num = num + 1
                                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, nearestHRP.Position)
                                playerHRP.CFrame = CFrame.lookAt(playerHRP.Position, Vector3.new(nearestHRP.Position.X, nearestHRP.Position.Y, nearestHRP.Position.Z))
                            end
                        end
                    end
                end
            end
        end)
    else
        if aimbot1x1loop then
            aimbot1x1loop:Disconnect()
            aimbot1x1loop = nil
        end
    end
end

local function cool(state)
    local coolsounds = {
        "rbxassetid://111033845010938",
        "rbxassetid://106484876889079"
    }
    
    cool = state

    if game:GetService("Players").LocalPlayer.Character.Name ~= "c00lkidd" and state then
        Library:Notify("你的角色不是c00lkidd，无法生效", nil, 4590657391)
        return 
    end

    if state then
        coolloop = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.ChildAdded:Connect(function(child)
            if not cool then return end
            for _, v in pairs(coolsounds) do
                if child.Name == v then
                    local survivors = {}
                    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                        if player ~= game:GetService("Players").LocalPlayer then
                            local character = player.Character
                            if character and character:FindFirstChild("HumanoidRootPart") then
                                table.insert(survivors, character)
                            end
                        end
                    end

                    local nearestSurvivor = nil
                    local shortestDistance = math.huge  
                    
                    for _, survivor in pairs(survivors) do
                        local survivorHRP = survivor.HumanoidRootPart
                        local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        
                        if playerHRP then
                            local distance = (survivorHRP.Position - playerHRP.Position).Magnitude
                            if distance < shortestDistance and distance <= coolMaxDistance then
                                shortestDistance = distance
                                nearestSurvivor = survivor
                            end
                        end
                    end
                    
                    if nearestSurvivor then
                        local nearestHRP = nearestSurvivor.HumanoidRootPart
                        local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        
                        if playerHRP then
                            local direction = (nearestHRP.Position - playerHRP.Position).Unit
                            local num = 1
                            local maxIterations = 100 
                            
                            if child.Name == "rbxassetid://79782181585087" then
                                maxIterations = 220  
                            end

                            while num <= maxIterations do
                                task.wait(0.01)
                                num = num + 1
                                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, nearestHRP.Position)
                            end
                        end
                    end
                end
            end
        end)
    else
        if coolloop then
            coolloop:Disconnect()
            coolloop = nil
        end
    end
end

local function johnaimbot(state)
    local johnaimbotsounds = {
        "rbxassetid://109525294317144"
    }
    
    johnaim = state
    if game:GetService("Players").LocalPlayer.Character.Name ~= "JohnDoe" and state then
        Library:Notify("角色不对，无法生效", nil, 4590657391)
        return 
    end
    
    if state then
        johnloop = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.ChildAdded:Connect(function(child)
            if not johnaim then return end
            for _, v in pairs(johnaimbotsounds) do
                if child.Name == v then
                    local survivors = {}
                    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                        if player ~= game:GetService("Players").LocalPlayer then
                            local character = player.Character
                            if character and character:FindFirstChild("HumanoidRootPart") then
                                table.insert(survivors, character)
                            end
                        end
                    end

                    local nearestSurvivor = nil
                    local shortestDistance = math.huge  
                    
                    for _, survivor in pairs(survivors) do
                        local survivorHRP = survivor.HumanoidRootPart
                        local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        
                        if playerHRP then
                            local distance = (survivorHRP.Position - playerHRP.Position).Magnitude
                            if distance < shortestDistance and distance <= johnMaxDistance then
                                shortestDistance = distance
                                nearestSurvivor = survivor
                            end
                        end
                    end
                    
                    if nearestSurvivor then
                        local nearestHRP = nearestSurvivor.HumanoidRootPart
                        local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local maxIterations = 330
                        if playerHRP then
                            local direction = (nearestHRP.Position - playerHRP.Position).Unit
                            local num = 1
                            
                            while num <= maxIterations do
                                task.wait(0.01)
                                num = num + 1
                                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, nearestHRP.Position)
                                playerHRP.CFrame = CFrame.lookAt(playerHRP.Position, Vector3.new(nearestHRP.Position.X, nearestHRP.Position.Y, nearestHRP.Position.Z))
                            end
                        end
                    end
                end
            end
        end)
    else
        if johnloop then
            johnloop:Disconnect()
            johnloop = nil
        end
    end
end

local function jasonaimbot(state)
    local jasonaimbotsounds = {
        "rbxassetid://112809109188560",
        "rbxassetid://102228729296384"
    }
    
    jasonaim = state
    if game:GetService("Players").LocalPlayer.Character.Name ~= "Jason" and state then
        Library:Notify("角色不对，无法生效", nil, 4590657391)
        return 
    end
    
    if state then
        jasonaimbotloop = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.ChildAdded:Connect(function(child)
            if not jasonaim then return end
            for _, v in pairs(jasonaimbotsounds) do
                if child.Name == v then
                    local survivors = {}
                    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                        if player ~= game:GetService("Players").LocalPlayer then
                            local character = player.Character
                            if character and character:FindFirstChild("HumanoidRootPart") then
                                table.insert(survivors, character)
                            end
                        end
                    end

                    local nearestSurvivor = nil
                    local shortestDistance = math.huge  
                    
                    for _, survivor in pairs(survivors) do
                        local survivorHRP = survivor.HumanoidRootPart
                        local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        
                        if playerHRP then
                            local distance = (survivorHRP.Position - playerHRP.Position).Magnitude
                            if distance < shortestDistance and distance <= jasonMaxDistance then
                                shortestDistance = distance
                                nearestSurvivor = survivor
                            end
                        end
                    end
                    
                    if nearestSurvivor then
                        local nearestHRP = nearestSurvivor.HumanoidRootPart
                        local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local maxIterations = 70
                        if playerHRP then
                            local direction = (nearestHRP.Position - playerHRP.Position).Unit
                            local num = 1
                            
                            while num <= maxIterations do
                                task.wait(0.01)
                                num = num + 1
                                playerHRP.CFrame = CFrame.lookAt(playerHRP.Position, Vector3.new(nearestHRP.Position.X, nearestHRP.Position.Y, nearestHRP.Position.Z))
                            end
                        end
                    end
                end
            end
        end)
    else
        if jasonaimbotloop then
            jasonaimbotloop:Disconnect()
            jasonaimbotloop = nil
        end
    end
end

-- 幸存者UI
SB:AddToggle('MyToggle', {
    Text = '机会 自瞄 ',
    Default = false,
    Tooltip = '自瞄',
    Callback = chanceAimbot
})

SB:AddToggle('MyToggle', {
    Text = '两次 自瞄',
    Default = false,
    Tooltip = '自瞄',
    Callback = TWO
})

SB:AddToggle('MyToggle', {
    Text = '谢德利茨基 自瞄',
    Default = false,
    Tooltip = '自瞄',
    Callback = shedletskyAimbot
})

-- 杀手UI
SC:AddToggle('MyToggle', {
    Text = '1x4自瞄',
    Default = false,
    Tooltip = '自瞄',
    Callback = aimbot1x1x1x1
})

SC:AddToggle('MyToggle', {
    Text = '酷小孩自瞄',
    Default = false,
    Tooltip = '自瞄',
    Callback = cool
})

SC:AddToggle('MyToggle', {
    Text = '约翰自瞄',
    Default = false,
    Tooltip = '自瞄',
    Callback = johnaimbot
})

SC:AddToggle('MyToggle', {
    Text = '杰森自瞄',
    Default = false,
    Tooltip = '自瞄',
    Callback = jasonaimbot
})



local SpecialAimbot = Tabs.Aimbot:AddLeftGroupbox("角色自瞄(静默)")

-- 默认距离设置
local defaultAimDistance = 100
local aimDistanceSettings = {
    CSA = defaultAimDistance,
    SSA = defaultAimDistance,
    GAA = defaultAimDistance
}

-- 添加距离调节滑块
SpecialAimbot:AddSlider("CSA_Distance", {
    Text = "机会自瞄距离",
    Default = defaultAimDistance,
    Min = 10,
    Max = 500,
    Rounding = 1,
    Callback = function(value)
        aimDistanceSettings.CSA = value
    end
})

SpecialAimbot:AddSlider("SSA_Distance", {
    Text = "谢德自瞄距离",
    Default = defaultAimDistance,
    Min = 10,
    Max = 500,
    Rounding = 1,
    Callback = function(value)
        aimDistanceSettings.SSA = value
    end
})

SpecialAimbot:AddSlider("GAA_Distance", {
    Text = "访客自瞄距离",
    Default = defaultAimDistance,
    Min = 10,
    Max = 500,
    Rounding = 1,
    Callback = function(value)
        aimDistanceSettings.GAA = value
    end
})

function AimShootChance(value)
    local aimshootchance = value
    if value then
        local chanceaimbotsounds = {
            "rbxassetid://201858045",
            "rbxassetid://139012439429121"
        }
        aimshootchance = game.Players.LocalPlayer.Character.HumanoidRootPart.ChildAdded:Connect(function(child)
            if not aimshootchance then return end
            for _, v in ipairs(chanceaimbotsounds) do
                if child.Name == v then
                    local targetkiller = game.Workspace.Players:FindFirstChild("Killers"):FindFirstChildOfClass("Model")
                    if targetkiller and targetkiller:FindFirstChild("HumanoidRootPart") then
                        if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local distance = (targetkiller.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                            if distance <= aimDistanceSettings.CSA then
                                local number = 1
                                game:GetService("RunService").RenderStepped:Connect(function()
                                    if number <= 100 then
                                        task.wait(0.01)
                                        number = number + 1
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.lookAt(
                                            game.Players.LocalPlayer.Character.HumanoidRootPart.Position, 
                                            targetkiller.HumanoidRootPart.Position
                                        )
                                    end
                                end)
                            end
                        end
                    end
                end
            end
        end)
    else
        if aimshootchance then
            aimshootchance:Disconnect()
        end
    end
end

function AimSlashShedletsky(value)
    local aimslashsword = value
    if value then
        local shedaimbotsounds = {
            "rbxassetid://106397684977541",
            "rbxassetid://106397684977541"
        }
        aimslash = game.Players.LocalPlayer.Character.Sword.ChildAdded:Connect(function(child)
            if not aimslashsword then return end
            for _, v in ipairs(shedaimbotsounds) do
                if child.Name == v then
                    local targetkiller = game.Workspace.Players:FindFirstChild("Killers"):FindFirstChildOfClass("Model")
                    if targetkiller and targetkiller:FindFirstChild("HumanoidRootPart") then
                        if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local distance = (targetkiller.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                            if distance <= aimDistanceSettings.SSA then
                                local number = 1
                                game:GetService("RunService").RenderStepped:Connect(function()
                                    if number <= 100 then
                                        task.wait(0.01)
                                        number = number + 1
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.lookAt(
                                            game.Players.LocalPlayer.Character.HumanoidRootPart.Position, 
                                            targetkiller.HumanoidRootPart.Position
                                        )
                                    end
                                end)
                            end
                        end
                    end
                end
            end
        end)
    else
        if aimslash then
            aimslash:Disconnect()
        end
    end
end

function AimAttackGuest(value)
    local aimattackguest = value
    if value then
        aimguest = game:GetService("ReplicatedStorage").Modules.Network.RemoteEvent.OnClientEvent:Connect(function(eventName, eventArg)
            if not aimattackguest then return end
            if eventName == "UseActorAbility" and eventArg == "Punch" then
                local targetkiller = game.Workspace.Players:FindFirstChild("Killers"):FindFirstChildOfClass("Model")
                if targetkiller and targetkiller:FindFirstChild("HumanoidRootPart") then
                    if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (targetkiller.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if distance <= aimDistanceSettings.GAA then
                            local number = 1
                            local connection
                            connection = game:GetService("RunService").RenderStepped:Connect(function()
                                if number <= 100 then
                                    task.wait(0.01)
                                    number = number + 1
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.lookAt(
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.Position, 
                                        targetkiller.HumanoidRootPart.Position
                                    )
                                else
                                    connection:Disconnect()
                                end
                            end)
                        end
                    end
                end
            end
        end)
    else
        if aimguest then
            aimguest:Disconnect()
        end
    end
end

SpecialAimbot:AddToggle("CSA",{
    Text = "机会自瞄",
    Callback = function(v)
        AimShootChance(v)
    end
})

SpecialAimbot:AddToggle("SSA",{
    Text = "谢德自瞄",
    Callback = function(v)
        AimSlashShedletsky(v)
    end
})

SpecialAimbot:AddToggle("GAA",{
    Text = "访客自瞄",
    Callback = function(v)
        AimAttackGuest(v)
    end
})


local function chanceAimbot(state)
    local settings = {
        maxDistance = 50,
        predictionFactor = 0.5,
        smoothFactor = 0.2
    }

    local CA = false
    local CAbotConnection = nil

    local function activateAimbot()
        if not game:GetService("Players").LocalPlayer.Character then return end
        if game.Players.LocalPlayer.Character.Name ~= "Chance" then
            Library:Notify("需要Chance角色才能使用", nil, 4590657391)
            return
        end

        local RemoteEvent = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")
        
        CAbotConnection = RemoteEvent.OnClientEvent:Connect(function(...)
            local args = {...}
            if args[1] == "UseActorAbility" and args[2] == "Shoot" then 
                local killerContainer = game.Workspace.Players:FindFirstChild("Killers")
                if killerContainer then 
                    local killer = killerContainer:FindFirstChildOfClass("Model")
                    if killer and killer:FindFirstChild("HumanoidRootPart") then 
                        local killerHRP = killer.HumanoidRootPart
                        local playerHRP = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        
                        if playerHRP then 
                            local distance = (killerHRP.Position - playerHRP.Position).Magnitude
                            if distance <= settings.maxDistance then
                                local originalCFrame = playerHRP.CFrame
                                local originalCamCFrame = workspace.CurrentCamera.CFrame
                                
                                while CA do
                                    RunService.RenderStepped:Wait()
                                    local predictedPosition = killerHRP.Position + (killerHRP.Velocity * settings.predictionFactor)
                                    local targetCFrame = CFrame.lookAt(playerHRP.Position, predictedPosition)
                                    playerHRP.CFrame = playerHRP.CFrame:Lerp(targetCFrame, settings.smoothFactor)
                                    local camTarget = CFrame.new(workspace.CurrentCamera.CFrame.Position, predictedPosition)
                                    workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(camTarget, settings.smoothFactor)
                                end
                                
                                if CA then
                                    playerHRP.CFrame = originalCFrame
                                    workspace.CurrentCamera.CFrame = originalCamCFrame
                                end
                            end
                        end
                    end
                end
            end
        end)
    end

    CA = state
    if state then
        activateAimbot()
    else
        if CAbotConnection then
            CAbotConnection:Disconnect()
            CAbotConnection = nil
        end
    end
end

local SpecialAimbot = Tabs.Aimbot:AddLeftGroupbox("机会自瞄(预判)")






local ZZ = Tabs.Aimbot:AddLeftGroupbox('自瞄杀手')


local aimSettings = {
    distance = 100,
    fov = 100,
    size = 10,
    noWall = false,
    rainbowMode = true 
}

local aimbotData = {
    FOVring = nil,
    connections = {}
}

ZZ:AddSlider('AimDistance', {
    Text = '自瞄距离',
    Default = 100,
    Min = 0,
    Max = 1000,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        aimSettings.distance = Value
    end
})

ZZ:AddSlider('FOVSize', {
    Text = '圈圈大小',
    Default = 100,
    Min = 0,
    Max = 1000,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        aimSettings.fov = Value
    end
})

ZZ:AddSlider('TargetSize', {
    Text = '自瞄大小',
    Default = 10,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        aimSettings.size = Value
    end
})

ZZ:AddToggle('NoWallToggle', {
    Text = '掩体检测',
    Default = false,
    Tooltip = '自瞄',
    Callback = function(state)
        aimSettings.noWall = state
    end
})

ZZ:AddDropdown('ColorSelector', {
    Values = {
        'Red',
        'Green',
        'Blue',
        'White',
        'Yellow',
        'Cyan',
        'Magenta',
        'Rainbow'
    },
    Default = 8,  
    Multi = false,
    Text = '选择颜色',
    Tooltip = '用于自瞄圈圈的颜色',
    Callback = function(Value)
        local colorMap = {
            Red = Color3.fromRGB(255, 0, 0),
            Green = Color3.fromRGB(0, 255, 0),
            Blue = Color3.fromRGB(0, 0, 255),
            White = Color3.fromRGB(255, 255, 255),
            Yellow = Color3.fromRGB(255, 255, 0),
            Cyan = Color3.fromRGB(0, 255, 255),
            Magenta = Color3.fromRGB(255, 0, 255)
        }

        if Value == 'Rainbow' then
            aimSettings.rainbowMode = true
        else
            aimSettings.rainbowMode = false
            local selectedColor = colorMap[Value] or Color3.fromRGB(231, 231, 236)
            if aimbotData.FOVring then
                aimbotData.FOVring.Color = selectedColor
            end
        end
    end
})

local bai = {}
bai.Aim = false
local aimConnection

Spy = ZZ:AddToggle("AimbotToggle", {
    Text = "自瞄杀手",
    Default = false,
    Callback = function(state)
        bai.Aim = state
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local Cam = workspace.CurrentCamera
        local UserInputService = game:GetService("UserInputService")
        local RaycastParams = RaycastParams.new()
        RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist

        
        local function cleanup()
            if aimbotData.FOVring then
                aimbotData.FOVring:Remove()
                aimbotData.FOVring = nil
            end
            if aimConnection then
                aimConnection:Disconnect()
                aimConnection = nil
            end
        end

        
        if state then
            if not aimbotData.FOVring then
                aimbotData.FOVring = Drawing.new("Circle")
                aimbotData.FOVring.Visible = true
                aimbotData.FOVring.Thickness = 2
                aimbotData.FOVring.Filled = false
                aimbotData.FOVring.Color = Color3.fromHSV(0, 1, 1)  
            end

            aimConnection = RunService.RenderStepped:Connect(function()
              
                aimbotData.FOVring.Radius = aimSettings.fov
                aimbotData.FOVring.Position = Cam.ViewportSize / 2

               
                local killersFolder = workspace.Players:FindFirstChild("Killers")
                local target = nil
                local closestDist = math.huge
                local mousePos = Cam.ViewportSize / 2

                if killersFolder then
                    for _, killerModel in pairs(killersFolder:GetChildren()) do
                        local hrp = killerModel:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local screenPos, onScreen = Cam:WorldToViewportPoint(hrp.Position)
                            local distance = (Cam.CFrame.Position - hrp.Position).Magnitude
                            if onScreen and distance <= aimSettings.distance then
                                if aimSettings.noWall then
                                    RaycastParams.FilterDescendantsInstances = {
                                        Players.LocalPlayer.Character,
                                        workspace.Players
                                    }
                                    local result = workspace:Raycast(Cam.CFrame.Position, hrp.Position - Cam.CFrame.Position, RaycastParams)
                                    if result and not result.Instance:IsDescendantOf(killerModel) then
                                        break
                                    end
                                end
                                local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                                if screenDist < closestDist and screenDist <= aimSettings.fov then
                                    closestDist = screenDist
                                    target = hrp
                                end
                            end
                        end
                    end
                end

                if target then
                    local lookVector = (target.Position - Cam.CFrame.Position).Unit
                    Cam.CFrame = CFrame.new(Cam.CFrame.Position, Cam.CFrame.Position + lookVector)
                end

                
                if aimSettings.rainbowMode and aimbotData.FOVring then
                    local hue = (tick() * 0.2) % 1
                    aimbotData.FOVring.Color = Color3.fromHSV(hue, 1, 1)
                end
            end)

           
            aimbotData.connections.keyEvent = UserInputService.InputBegan:Connect(function(input)
                if input.KeyCode == Enum.KeyCode.Delete then
                    bai.Aim = false
                    Spy:SetValue(false)
                    cleanup()
                end
            end)
        else
            cleanup()
        end
    end
}):AddKeyPicker("AimKeyPicker", {
    Text = "自瞄杀手",
    Default = "E",
    Mode = "Toggle",
    SyncToggleState = true,
})





local ZZ = Tabs.Aimbot:AddRightGroupbox('自瞄幸存者')



local aimSettings = {
    distance = 100,
    fov = 100,
    size = 10,
    noWall = false,
    rainbowMode = true 
}

local aimbotData = {
    FOVring = nil,
    connections = {}
}

ZZ:AddSlider('AimDistance', {
    Text = '自瞄距离',
    Default = 100,
    Min = 0,
    Max = 1000,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
        aimSettings.distance = Value
    end
})

ZZ:AddSlider('FOVSize', {
    Text = '圈圈大小',
    Default = 100,
    Min = 0,
    Max = 1000,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
        aimSettings.fov = Value
    end
})

ZZ:AddSlider('TargetSize', {
    Text = '自瞄大小',
    Default = 10,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
        aimSettings.size = Value
    end
})

ZZ:AddToggle('NoWallToggle', {
    Text = '掩体检测',
    Default = false,
    Tooltip = '自瞄',
    Callback = function(state)
        aimSettings.noWall = state
    end
})

ZZ:AddDropdown('ColorSelector', {
    Values = {
        'Red',
        'Green',
        'Blue',
        'White',
        'Yellow',
        'Cyan',
        'Magenta',
        'Rainbow'
    },
    Default = 8,
    Multi = false,
    Text = '选择颜色',
    Tooltip = '用于自瞄圈圈的颜色',
    Callback = function(Value)
        local colorMap = {
            Red = Color3.fromRGB(255, 0, 0),
            Green = Color3.fromRGB(0, 255, 0),
            Blue = Color3.fromRGB(0, 0, 255),
            White = Color3.fromRGB(255, 255, 255),
            Yellow = Color3.fromRGB(255, 255, 0),
            Cyan = Color3.fromRGB(0, 255, 255),
            Magenta = Color3.fromRGB(255, 0, 255)
        }

        if Value == 'Rainbow' then
            aimSettings.rainbowMode = true
        else
            aimSettings.rainbowMode = false
            local selectedColor = colorMap[Value] or Color3.fromRGB(231, 231, 236)
            if aimbotData.FOVring then
                aimbotData.FOVring.Color = selectedColor
            end
        end
    end
})

local bai = {}
bai.Aim = false
local aimConnection

Spy = ZZ:AddToggle("AimbotToggle", {
    Text = "自瞄幸存者",
    Default = false,
    Callback = function(state)
        bai.Aim = state
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local Cam = workspace.CurrentCamera
        local UserInputService = game:GetService("UserInputService")
        local RaycastParams = RaycastParams.new()
        RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist

        local function cleanup()
            if aimbotData.FOVring then
                aimbotData.FOVring:Remove()
                aimbotData.FOVring = nil
            end
            if aimConnection then
                aimConnection:Disconnect()
                aimConnection = nil
            end
        end

        if state then
            if not aimbotData.FOVring then
                aimbotData.FOVring = Drawing.new("Circle")
                aimbotData.FOVring.Visible = true
                aimbotData.FOVring.Thickness = 2
                aimbotData.FOVring.Filled = false
                aimbotData.FOVring.Color = Color3.fromHSV(0, 1, 1)
            end

            aimConnection = RunService.RenderStepped:Connect(function()
                aimbotData.FOVring.Radius = aimSettings.fov
                aimbotData.FOVring.Position = Cam.ViewportSize / 2

                local survivorsFolder = workspace.Players:FindFirstChild("Survivors")
                local target = nil
                local closestDist = math.huge
                local mousePos = Cam.ViewportSize / 2

                if survivorsFolder then
                    for _, survivorModel in pairs(survivorsFolder:GetChildren()) do
                        if survivorModel == Players.LocalPlayer.Character then
                            break
                        end

                        local hrp = survivorModel:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local screenPos, onScreen = Cam:WorldToViewportPoint(hrp.Position)
                            local distance = (Cam.CFrame.Position - hrp.Position).Magnitude
                            if onScreen and distance <= aimSettings.distance then
                                if aimSettings.noWall then
                                    RaycastParams.FilterDescendantsInstances = {
                                        Players.LocalPlayer.Character,
                                        workspace.Players
                                    }
                                    local result = workspace:Raycast(Cam.CFrame.Position, hrp.Position - Cam.CFrame.Position, RaycastParams)
                                    if result and not result.Instance:IsDescendantOf(survivorModel) then
                                        break
                                    end
                                end
                                local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                                if screenDist < closestDist and screenDist <= aimSettings.fov then
                                    closestDist = screenDist
                                    target = hrp
                                end
                            end
                        end
                    end
                end

                if target then
                    local lookVector = (target.Position - Cam.CFrame.Position).Unit
                    Cam.CFrame = CFrame.new(Cam.CFrame.Position, Cam.CFrame.Position + lookVector)
                end

                if aimSettings.rainbowMode and aimbotData.FOVring then
                    local hue = (tick() * 0.2) % 1
                    aimbotData.FOVring.Color = Color3.fromHSV(hue, 1, 1)
                end
            end)

            aimbotData.connections.keyEvent = UserInputService.InputBegan:Connect(function(input)
                if input.KeyCode == Enum.KeyCode.Delete then
                    bai.Aim = false
                    Spy:SetValue(false)
                    cleanup()
                end
            end)
        else
            cleanup()
        end
    end
}):AddKeyPicker("AimKeyPicker", {
    Text = "自瞄幸存者",
    Default = "E",
    Mode = "Toggle",
    SyncToggleState = true,
})









local Visual = Tabs.Esp:AddRightGroupbox("高亮绘制")

-- 高亮绘制设置
local HighlightSettings = {
    ShowSurvivorHighlights = true,
    ShowKillerHighlights = true,
    FillTransparency = 0.5,
    OutlineTransparency = 0,
    connection = nil,
    highlights = {}  -- 存储所有高亮对象
}

-- 更新颜色预设
HighlightSettings.SurvivorColors = {
    ["绿色"] = Color3.fromRGB(0, 255, 0),
    ["白色"] = Color3.fromRGB(255, 255, 255),
    ["紫色"] = Color3.fromRGB(128, 0, 128),
    ["青色"] = Color3.fromRGB(0, 255, 255),
    ["橙色"] = Color3.fromRGB(255, 165, 0),
    ["柠檬绿"] = Color3.fromRGB(173, 255, 47)  -- 新增柠檬绿
}

HighlightSettings.KillerColors = {
    ["红色"] = Color3.fromRGB(255, 0, 0),
    ["粉色"] = Color3.fromRGB(255, 105, 180),
    ["黑色"] = Color3.fromRGB(0, 0, 0),
    ["蓝色"] = Color3.fromRGB(0, 0, 255),
    ["猩红色"] = Color3.fromRGB(220, 20, 60),  -- 新增猩红色
    ["杏色"] = Color3.fromRGB(251, 206, 177)   -- 新增杏色
}

-- 边缘颜色使用与填充颜色相同的选项
HighlightSettings.SurvivorOutlineColors = table.clone(HighlightSettings.SurvivorColors)
HighlightSettings.KillerOutlineColors = table.clone(HighlightSettings.KillerColors)

-- 默认颜色
HighlightSettings.SelectedSurvivorColor = "青色"
HighlightSettings.SelectedKillerColor = "红色"
HighlightSettings.SelectedSurvivorOutlineColor = "青色"
HighlightSettings.SelectedKillerOutlineColor = "红色"

-- 清理高亮对象
local function cleanupHighlights()
    for _, highlight in pairs(HighlightSettings.highlights) do
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
    end
    HighlightSettings.highlights = {}
end

-- 更新高亮显示
local function updateHighlights()
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    
    -- 获取幸存者和杀手文件夹
    local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
    local killersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
    
    -- 只处理幸存者和杀手
    local function processFolder(folder, isKiller)
        if not folder then return end
        
        for _, model in ipairs(folder:GetChildren()) do
            if model:IsA("Model") then
                -- 确定颜色
                local fillColor = isKiller and HighlightSettings.KillerColors[HighlightSettings.SelectedKillerColor] 
                                          or HighlightSettings.SurvivorColors[HighlightSettings.SelectedSurvivorColor]
                
                local outlineColor = isKiller and HighlightSettings.KillerOutlineColors[HighlightSettings.SelectedKillerOutlineColor] 
                                              or HighlightSettings.SurvivorOutlineColors[HighlightSettings.SelectedSurvivorOutlineColor]
                
                -- 根据设置决定是否显示
                if (isKiller and HighlightSettings.ShowKillerHighlights) or 
                   (not isKiller and HighlightSettings.ShowSurvivorHighlights) then
                    
                    if not HighlightSettings.highlights[model] then
                        local highlight = Instance.new("Highlight")
                        highlight.Parent = game.CoreGui
                        HighlightSettings.highlights[model] = highlight
                    end
                    
                    local highlight = HighlightSettings.highlights[model]
                    highlight.Adornee = model
                    highlight.FillColor = fillColor
                    highlight.OutlineColor = outlineColor
                    highlight.FillTransparency = HighlightSettings.FillTransparency
                    highlight.OutlineTransparency = HighlightSettings.OutlineTransparency
                elseif HighlightSettings.highlights[model] then
                    HighlightSettings.highlights[model].Adornee = nil
                end
            end
        end
    end
    
    -- 处理幸存者
    processFolder(survivorsFolder, false)
    
    -- 处理杀手
    processFolder(killersFolder, true)
    
    -- 清理不再存在的模型的高亮
    for model, highlight in pairs(HighlightSettings.highlights) do
        if not model or not model.Parent then
            highlight:Destroy()
            HighlightSettings.highlights[model] = nil
        end
    end
end

-- 主开关
Visual:AddToggle("HighlightToggle", {
    Text = "启用高亮绘制",
    Default = false,
    Callback = function(enabled)
        if enabled then
            -- 初始化连接
            if not HighlightSettings.connection then
                HighlightSettings.connection = game:GetService("RunService").RenderStepped:Connect(updateHighlights)
            end
        else
            -- 关闭连接
            if HighlightSettings.connection then
                HighlightSettings.connection:Disconnect()
                HighlightSettings.connection = nil
            end
            -- 清理高亮对象
            cleanupHighlights()
        end
    end
})

-- 幸存者开关
Visual:AddToggle("ShowSurvivorHighlights", {
    Text = "绘制幸存者高亮",
    Default = true,
    Callback = function(enabled)
        HighlightSettings.ShowSurvivorHighlights = enabled
    end
})

-- 杀手开关
Visual:AddToggle("ShowKillerHighlights", {
    Text = "绘制杀手高亮",
    Default = true,
    Callback = function(enabled)
        HighlightSettings.ShowKillerHighlights = enabled
    end
})

-- 幸存者填充颜色选择
Visual:AddDropdown("SurvivorFillColor", {
    Values = {"绿色", "白色", "紫色", "青色", "橙色", "柠檬绿"},
    Default = "青色",
    Text = "幸存者填充颜色",
    Callback = function(value)
        HighlightSettings.SelectedSurvivorColor = value
    end
})

-- 杀手填充颜色选择
Visual:AddDropdown("KillerFillColor", {
    Values = {"红色", "粉色", "黑色", "蓝色", "猩红色", "杏色"},
    Default = "红色",
    Text = "杀手填充颜色",
    Callback = function(value)
        HighlightSettings.SelectedKillerColor = value
    end
})

-- 幸存者边缘颜色选择
Visual:AddDropdown("SurvivorOutlineColor", {
    Values = {"绿色", "白色", "紫色", "青色", "橙色", "柠檬绿"},
    Default = "青色",
    Text = "幸存者边缘颜色",
    Callback = function(value)
        HighlightSettings.SelectedSurvivorOutlineColor = value
    end
})

-- 杀手边缘颜色选择
Visual:AddDropdown("KillerOutlineColor", {
    Values = {"红色", "粉色", "黑色", "蓝色", "猩红色", "杏色"},
    Default = "红色",
    Text = "杀手边缘颜色",
    Callback = function(value)
        HighlightSettings.SelectedKillerOutlineColor = value
    end
})

-- 填充透明度调节滑块
Visual:AddSlider("FillTransparency", {
    Text = "填充透明度",
    Min = 0,
    Max = 1,
    Default = 0.5,
    Rounding = 1,
    Compact = false,
    Callback = function(value)
        HighlightSettings.FillTransparency = value
    end
})

-- 边缘透明度调节滑块
Visual:AddSlider("OutlineTransparency", {
    Text = "边缘透明度",
    Min = 0,
    Max = 1,
    Default = 0,
    Rounding = 1,
    Compact = false,
    Callback = function(value)
        HighlightSettings.OutlineTransparency = value
    end
})


local Visual = Tabs.Esp:AddLeftGroupbox("血量条绘制")


-- 血量条设置
local HealthBarSettings = {
    ShowSurvivorBars = true,
    ShowKillerBars = true,
    BarWidth = 100,      -- 固定宽度
    BarHeight = 5,       -- 固定高度
    TextSize = 14,       -- 固定文字大小
    BarOffset = Vector2.new(0, -50), -- 基础偏移（头顶）
    TextOffset = Vector2.new(0, -60)  -- 文字偏移
}

-- 预设颜色方案
local ColorPresets = {
    Survivor = {
        FullHealth = Color3.fromRGB(0, 255, 255),    -- 青色(满血)
        HalfHealth = Color3.fromRGB(0, 255, 0),      -- 绿色(半血)
        LowHealth = Color3.fromRGB(255, 165, 0)      -- 橙色(低血)
    },
    Killer = {
        FullHealth = Color3.fromRGB(255, 0, 0),      -- 红色(满血)
        HalfHealth = Color3.fromRGB(255, 165, 0),    -- 橙色(半血)
        LowHealth = Color3.fromRGB(255, 255, 0)      -- 黄色(低血)
    },
    Common = {
        Background = Color3.fromRGB(50, 50, 50),
        Outline = Color3.fromRGB(0, 0, 0),
        Text = Color3.fromRGB(255, 255, 255)        -- 白色文字
    }
}

-- 存储所有绘制对象
local HealthBarDrawings = {}

-- 创建血量条绘制对象
local function createHealthBarDrawing()
    local drawing = {
        background = Drawing.new("Square"),
        bar = Drawing.new("Square"),
        outline = Drawing.new("Square"),
        text = Drawing.new("Text")
    }
    
    -- 背景设置
    drawing.background.Thickness = 1
    drawing.background.Filled = true
    drawing.background.Color = ColorPresets.Common.Background
    
    -- 血量条设置
    drawing.bar.Thickness = 1
    drawing.bar.Filled = true
    
    -- 边框设置
    drawing.outline.Thickness = 2
    drawing.outline.Filled = false
    drawing.outline.Color = ColorPresets.Common.Outline
    
    -- 文字设置
    drawing.text.Center = true
    drawing.text.Outline = true
    drawing.text.Font = 2
    drawing.text.Color = ColorPresets.Common.Text
    
    return drawing
end

-- 根据血量获取颜色
local function getHealthColor(humanoid, isKiller)
    local healthPercent = (humanoid.Health / humanoid.MaxHealth) * 100
    
    if isKiller then
        if healthPercent > 50 then
            return ColorPresets.Killer.FullHealth
        elseif healthPercent > 25 then
            return ColorPresets.Killer.HalfHealth
        else
            return ColorPresets.Killer.LowHealth
        end
    else
        if healthPercent > 75 then
            return ColorPresets.Survivor.FullHealth
        elseif healthPercent > 35 then
            return ColorPresets.Survivor.HalfHealth
        else
            return ColorPresets.Survivor.LowHealth
        end
    end
end

-- 获取角色头顶位置
local function get_head_position(character)
    local head = character:FindFirstChild("Head")
    if head then
        return head.Position + Vector3.new(0, 1.5, 0) -- 稍微高于头部
    end
    return character:GetModelCFrame().Position
end

-- 更新血量条
local function updateHealthBars()
    local camera = workspace.CurrentCamera
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    
    -- 处理幸存者
    if HealthBarSettings.ShowSurvivorBars then
        local survivors = workspace.Players:FindFirstChild("Survivors") or workspace:FindFirstChild("Survivors")
        if survivors then
            for _, survivor in ipairs(survivors:GetChildren()) do
                if survivor:IsA("Model") and survivor ~= localPlayer.Character then -- 不显示自身血条
                    local humanoid = survivor:FindFirstChildOfClass("Humanoid")
                    
                    if humanoid then
                        -- 获取或创建绘制对象
                        if not HealthBarDrawings[survivor] then
                            HealthBarDrawings[survivor] = createHealthBarDrawing()
                        end
                        
                        local drawing = HealthBarDrawings[survivor]
                        local headPos = get_head_position(survivor)
                        local screenPos, onScreen = camera:WorldToViewportPoint(headPos)
                        
                        if onScreen then
                            -- 计算血量百分比
                            local healthPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
                            local healthBarWidth = HealthBarSettings.BarWidth * (healthPercent / 100)
                            
                            -- 水平条位置（头顶）
                            local barPos = Vector2.new(
                                screenPos.X + HealthBarSettings.BarOffset.X - (HealthBarSettings.BarWidth / 2),
                                screenPos.Y + HealthBarSettings.BarOffset.Y
                            )
                            
                            -- 背景和边框
                            drawing.background.Size = Vector2.new(HealthBarSettings.BarWidth, HealthBarSettings.BarHeight)
                            drawing.background.Position = barPos
                            drawing.background.Visible = true
                            
                            drawing.outline.Size = Vector2.new(HealthBarSettings.BarWidth, HealthBarSettings.BarHeight)
                            drawing.outline.Position = barPos
                            drawing.outline.Visible = true
                            
                            -- 血量条
                            drawing.bar.Color = getHealthColor(humanoid, false)
                            drawing.bar.Size = Vector2.new(healthBarWidth, HealthBarSettings.BarHeight)
                            drawing.bar.Position = barPos
                            drawing.bar.Visible = true
                            
                            -- 文字
                            drawing.text.Text = tostring(healthPercent) .. "%"
                            drawing.text.Size = HealthBarSettings.TextSize
                            drawing.text.Position = Vector2.new(
                                screenPos.X + HealthBarSettings.TextOffset.X,
                                screenPos.Y + HealthBarSettings.TextOffset.Y
                            )
                            drawing.text.Visible = true
                        else
                            -- 不在屏幕内则隐藏
                            for _, obj in pairs(drawing) do
                                obj.Visible = false
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- 处理杀手
    if HealthBarSettings.ShowKillerBars then
        local killers = workspace.Players:FindFirstChild("Killers") or workspace:FindFirstChild("Killers")
        if killers then
            for _, killer in ipairs(killers:GetChildren()) do
                if killer:IsA("Model") and killer ~= localPlayer.Character then -- 不显示自身血条
                    local humanoid = killer:FindFirstChildOfClass("Humanoid")
                    
                    if humanoid then
                        -- 获取或创建绘制对象
                        if not HealthBarDrawings[killer] then
                            HealthBarDrawings[killer] = createHealthBarDrawing()
                        end
                        
                        local drawing = HealthBarDrawings[killer]
                        local headPos = get_head_position(killer)
                        local screenPos, onScreen = camera:WorldToViewportPoint(headPos)
                        
                        if onScreen then
                            -- 计算血量百分比
                            local healthPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
                            local healthBarWidth = HealthBarSettings.BarWidth * (healthPercent / 100)
                            
                            -- 水平条位置（头顶）
                            local barPos = Vector2.new(
                                screenPos.X + HealthBarSettings.BarOffset.X - (HealthBarSettings.BarWidth / 2),
                                screenPos.Y + HealthBarSettings.BarOffset.Y
                            )
                            
                            -- 背景和边框
                            drawing.background.Size = Vector2.new(HealthBarSettings.BarWidth, HealthBarSettings.BarHeight)
                            drawing.background.Position = barPos
                            drawing.background.Visible = true
                            
                            drawing.outline.Size = Vector2.new(HealthBarSettings.BarWidth, HealthBarSettings.BarHeight)
                            drawing.outline.Position = barPos
                            drawing.outline.Visible = true
                            
                            -- 血量条
                            drawing.bar.Color = getHealthColor(humanoid, true)
                            drawing.bar.Size = Vector2.new(healthBarWidth, HealthBarSettings.BarHeight)
                            drawing.bar.Position = barPos
                            drawing.bar.Visible = true
                            
                            -- 文字
                            drawing.text.Text = tostring(healthPercent) .. "%"
                            drawing.text.Size = HealthBarSettings.TextSize
                            drawing.text.Position = Vector2.new(
                                screenPos.X + HealthBarSettings.TextOffset.X,
                                screenPos.Y + HealthBarSettings.TextOffset.Y
                            )
                            drawing.text.Visible = true
                        else
                            -- 不在屏幕内则隐藏
                            for _, obj in pairs(drawing) do
                                obj.Visible = false
                            end
                        end
                    end
                end
            end
        end
    end
end

-- 清理血量条
local function cleanupHealthBars()
    for _, drawing in pairs(HealthBarDrawings) do
        for _, obj in pairs(drawing) do
            if obj then
                obj:Remove()
            end
        end
    end
    HealthBarDrawings = {}
end

-- 主开关
Visual:AddToggle("HealthBarsToggle", {
    Text = "启用血量条",
    Default = false,
    Callback = function(enabled)
        if enabled then
            -- 初始化连接
            if not HealthBarSettings.connection then
                HealthBarSettings.connection = game:GetService("RunService").RenderStepped:Connect(updateHealthBars)
            end
            
            -- 监听角色移除
            if not HealthBarSettings.removedConnection then
                HealthBarSettings.removedConnection = workspace.DescendantRemoving:Connect(function(descendant)
                    if HealthBarDrawings[descendant] then
                        for _, obj in pairs(HealthBarDrawings[descendant]) do
                            obj:Remove()
                        end
                        HealthBarDrawings[descendant] = nil
                    end
                end)
            end
        else
            -- 关闭连接
            if HealthBarSettings.connection then
                HealthBarSettings.connection:Disconnect()
                HealthBarSettings.connection = nil
            end
            
            if HealthBarSettings.removedConnection then
                HealthBarSettings.removedConnection:Disconnect()
                HealthBarSettings.removedConnection = nil
            end
            
            -- 清理绘制对象
            cleanupHealthBars()
        end
    end
})

-- 幸存者开关
Visual:AddToggle("ShowSurvivorBars", {
    Text = "显示幸存者血量条",
    Default = true,
    Callback = function(enabled)
        HealthBarSettings.ShowSurvivorBars = enabled
    end
})

-- 杀手开关
Visual:AddToggle("ShowKillerBars", {
    Text = "显示杀手血量条",
    Default = true,
    Callback = function(enabled)
        HealthBarSettings.ShowKillerBars = enabled
    end
})




local Visual = Tabs.Esp:AddRightGroupbox("假Noli绘制")
local NoliHighlight = {
    Enabled = false,
    FillTransparency = 0.5,
    OutlineTransparency = 0,
    connection = nil,
    highlights = {},
    labels = {}
}

local function cleanupAll()
    for _, highlight in pairs(NoliHighlight.highlights) do
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
    end
    NoliHighlight.highlights = {}
    
    for _, label in pairs(NoliHighlight.labels) do
        if label and label.Parent then
            label:Destroy()
        end
    end
    NoliHighlight.labels = {}
end

local function isFakeNoli(model)
    local humanoidRootPart = model:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    for _, sound in ipairs(humanoidRootPart:GetChildren()) do
        if sound:IsA("Sound") then
            return false
        end
    end
    return true
end

local function updateHighlights()
    local killersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
    
    if killersFolder and NoliHighlight.Enabled then
        local noliModel = killersFolder:FindFirstChild("Noli")
        if noliModel and noliModel:IsA("Model") and isFakeNoli(noliModel) then
            if not NoliHighlight.highlights[noliModel] then
                local highlight = Instance.new("Highlight")
                highlight.Parent = game.CoreGui
                NoliHighlight.highlights[noliModel] = highlight
            end
            
            local highlight = NoliHighlight.highlights[noliModel]
            highlight.Adornee = noliModel
            highlight.FillColor = Color3.fromRGB(128, 0, 128)
            highlight.OutlineColor = Color3.fromRGB(128, 0, 128)
            highlight.FillTransparency = NoliHighlight.FillTransparency
            highlight.OutlineTransparency = NoliHighlight.OutlineTransparency
            
            if not NoliHighlight.labels[noliModel] then
                local billboardGui = Instance.new("BillboardGui")
                local textLabel = Instance.new("TextLabel")
                
                billboardGui.Name = "NoliLabel"
                billboardGui.Adornee = noliModel:FindFirstChild("Head") or noliModel:FindFirstChild("HumanoidRootPart") or noliModel.PrimaryPart
                billboardGui.Size = UDim2.new(0, 200, 0, 50)
                billboardGui.StudsOffset = Vector3.new(0, 2, 0)
                billboardGui.AlwaysOnTop = true
                
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.Text = "[假Noli]"
                textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                textLabel.TextScaled = true
                textLabel.BackgroundTransparency = 1
                textLabel.Font = Enum.Font.SourceSansBold
                textLabel.TextStrokeTransparency = 0
                textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                
                textLabel.Parent = billboardGui
                billboardGui.Parent = game.CoreGui
                
                NoliHighlight.labels[noliModel] = billboardGui
            end
        end
    end
    
    for model, highlight in pairs(NoliHighlight.highlights) do
        if not model or not model.Parent then
            highlight:Destroy()
            NoliHighlight.highlights[model] = nil
            
            if NoliHighlight.labels[model] then
                NoliHighlight.labels[model]:Destroy()
                NoliHighlight.labels[model] = nil
            end
        end
    end
end

Visual:AddToggle("NoliHighlightToggle", {
    Text = "假Noli绘制",
    Default = false,
    Callback = function(enabled)
        NoliHighlight.Enabled = enabled
        if enabled then
            if not NoliHighlight.connection then
                NoliHighlight.connection = game:GetService("RunService").RenderStepped:Connect(updateHighlights)
            end
        else
            if NoliHighlight.connection then
                NoliHighlight.connection:Disconnect()
                NoliHighlight.connection = nil
            end
            cleanupAll()
        end
    end
})

Visual:AddSlider("NoliFillTransparency", {
    Text = "填充透明度",
    Min = 0,
    Max = 1,
    Default = 0.5,
    Rounding = 1,
    Compact = false,
    Callback = function(value)
        NoliHighlight.FillTransparency = value
    end
})

Visual:AddSlider("NoliOutlineTransparency", {
    Text = "边缘透明度",
    Min = 0,
    Max = 1,
    Default = 0,
    Rounding = 1,
    Compact = false,
    Callback = function(value)
        NoliHighlight.OutlineTransparency = value
    end
})


local Visual = Tabs.Esp:AddLeftGroupbox("角色名称绘制")

local NameTagSettings = {
    ShowSurvivorNames = true,
    ShowKillerNames = true,
    BaseTextSize = 14,
    MinTextSize = 10,
    MaxTextSize = 20,
    TextOffset = Vector3.new(0, 3, 0),
    DistanceScale = {
        MinDistance = 10,
        MaxDistance = 50
    },
    SurvivorColor = Color3.fromRGB(0, 191, 255),
    KillerColor = Color3.fromRGB(255, 0, 0),
    OutlineColor = Color3.fromRGB(0, 0, 0),
    ShowDistance = true
}

local NameTagDrawings = {}

local function createNameTagDrawing()
    local drawing = Drawing.new("Text")
    drawing.Size = NameTagSettings.BaseTextSize
    drawing.Center = true
    drawing.Outline = true
    drawing.OutlineColor = NameTagSettings.OutlineColor
    drawing.Font = 2
    return drawing
end

local function getHeadPosition(character)
    local head = character:FindFirstChild("Head")
    if head then
        local headHeight = head.Size.Y
        return head.Position + Vector3.new(0, headHeight + 0.5, 0)
    end
    return character:GetPivot().Position
end

local function cleanupInvalidDrawings()
    local players = game:GetService("Players")
    local survivors = workspace.Players:FindFirstChild("Survivors")
    local killers = workspace.Players:FindFirstChild("Killers")
    
    local validCharacters = {}
    if survivors then
        for _, survivor in ipairs(survivors:GetChildren()) do
            if survivor:IsA("Model") then
                validCharacters[survivor] = true
            end
        end
    end
    if killers then
        for _, killer in ipairs(killers:GetChildren()) do
            if killer:IsA("Model") then
                validCharacters[killer] = true
            end
        end
    end
    
    for model, drawing in pairs(NameTagDrawings) do
        if not validCharacters[model] then
            drawing:Remove()
            NameTagDrawings[model] = nil
        end
    end
end

local function updateNameTags()
    local camera = workspace.CurrentCamera
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    local localCharacter = localPlayer.Character
    local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")

    if not localRoot then return end
    
    cleanupInvalidDrawings()

    if NameTagSettings.ShowSurvivorNames then
        local survivors = workspace.Players:FindFirstChild("Survivors")
        if survivors then
            for _, survivor in ipairs(survivors:GetChildren()) do
                if survivor:IsA("Model") and survivor ~= localCharacter then
                    local humanoid = survivor:FindFirstChildOfClass("Humanoid")
                    
                    if not NameTagDrawings[survivor] then
                        NameTagDrawings[survivor] = createNameTagDrawing()
                    end
                    
                    local drawing = NameTagDrawings[survivor]
                    
                    if not humanoid or humanoid.Health <= 0 then
                        drawing.Visible = false
                        continue
                    end
                    
                    local headPos = getHeadPosition(survivor)
                    local screenPos, onScreen = camera:WorldToViewportPoint(headPos + NameTagSettings.TextOffset)
                    
                    if onScreen then
                        local distance = (headPos - localRoot.Position).Magnitude
                        local scale = math.clamp(
                            1 - (distance - NameTagSettings.DistanceScale.MinDistance) / 
                            (NameTagSettings.DistanceScale.MaxDistance - NameTagSettings.DistanceScale.MinDistance), 
                            0.3, 1
                        )
                        
                        local textSize = math.floor(NameTagSettings.BaseTextSize * scale)
                        textSize = math.clamp(textSize, NameTagSettings.MinTextSize, NameTagSettings.MaxTextSize)
                        
                        local displayText = survivor.Name
                        if NameTagSettings.ShowDistance then
                            displayText = string.format("%s [%d]", survivor.Name, math.floor(distance))
                        end
                        
                        drawing.Text = displayText
                        drawing.Color = NameTagSettings.SurvivorColor
                        drawing.Size = textSize
                        drawing.Position = Vector2.new(screenPos.X, screenPos.Y)
                        drawing.Visible = true
                    else
                        drawing.Visible = false
                    end
                end
            end
        end
    end

    if NameTagSettings.ShowKillerNames then
        local killers = workspace.Players:FindFirstChild("Killers")
        if killers then
            for _, killer in ipairs(killers:GetChildren()) do
                if killer:IsA("Model") then
                    local humanoid = killer:FindFirstChildOfClass("Humanoid")
                    
                    if not NameTagDrawings[killer] then
                        NameTagDrawings[killer] = createNameTagDrawing()
                    end
                    
                    local drawing = NameTagDrawings[killer]
                    
                    if not humanoid or humanoid.Health <= 0 then
                        drawing.Visible = false
                        continue
                    end
                    
                    local headPos = getHeadPosition(killer)
                    local screenPos, onScreen = camera:WorldToViewportPoint(headPos + NameTagSettings.TextOffset)
                    
                    if onScreen then
                        local distance = (headPos - localRoot.Position).Magnitude
                        local scale = math.clamp(
                            1 - (distance - NameTagSettings.DistanceScale.MinDistance) / 
                            (NameTagSettings.DistanceScale.MaxDistance - NameTagSettings.DistanceScale.MinDistance), 
                            0.3, 1
                        )
                        
                        local textSize = math.floor(NameTagSettings.BaseTextSize * scale)
                        textSize = math.clamp(textSize, NameTagSettings.MinTextSize, NameTagSettings.MaxTextSize)
                        
                        local displayText = killer.Name
                        if NameTagSettings.ShowDistance then
                            displayText = string.format("%s [%dm]", killer.Name, math.floor(distance))
                        end
                        
                        drawing.Text = displayText
                        drawing.Color = NameTagSettings.KillerColor
                        drawing.Size = textSize
                        drawing.Position = Vector2.new(screenPos.X, screenPos.Y)
                        drawing.Visible = true
                    else
                        drawing.Visible = false
                    end
                end
            end
        end
    end
end

local function cleanupNameTags()
    for _, drawing in pairs(NameTagDrawings) do
        if drawing then
            drawing:Remove()
        end
    end
    NameTagDrawings = {}
end

Visual:AddToggle("NameTagsToggle", {
    Text = "启用名称绘制",
    Default = false,
    Callback = function(enabled)
        if enabled then
            if not NameTagSettings.connection then
                NameTagSettings.connection = game:GetService("RunService").RenderStepped:Connect(updateNameTags)
            end
            
            if not NameTagSettings.removedConnection then
                NameTagSettings.removedConnection = game:GetService("Players").PlayerRemoving:Connect(function(player)
                    for model, drawing in pairs(NameTagDrawings) do
                        if model.Name == player.Name then
                            drawing:Remove()
                            NameTagDrawings[model] = nil
                        end
                    end
                end)
            end
        else
            if NameTagSettings.connection then
                NameTagSettings.connection:Disconnect()
                NameTagSettings.connection = nil
            end
            
            if NameTagSettings.removedConnection then
                NameTagSettings.removedConnection:Disconnect()
                NameTagSettings.removedConnection = nil
            end
            
            cleanupNameTags()
        end
    end
})

Visual:AddToggle("ShowSurvivorNames", {
    Text = "显示幸存者名称",
    Default = true,
    Callback = function(enabled)
        NameTagSettings.ShowSurvivorNames = enabled
    end
})

Visual:AddToggle("ShowKillerNames", {
    Text = "显示杀手名称",
    Default = true,
    Callback = function(enabled)
        NameTagSettings.ShowKillerNames = enabled
    end
})

Visual:AddToggle("ShowDistance", {
    Text = "显示距离",
    Default = true,
    Callback = function(enabled)
        NameTagSettings.ShowDistance = enabled
    end
})



 Visual = Tabs.Esp:AddLeftGroupbox("血量绘制［备用］")


local camera = workspace.CurrentCamera
local localPlayer = game:GetService("Players").LocalPlayer

Visual:AddToggle("SurvivorHealth", {
    Text = "绘制幸存者血量(文字)",
    Default = false,
    Callback = function(v)
        if v then
            local sur = workspace.Players.Survivors
            
            local function survivoresp(char)
                local billboard = Instance.new("BillboardGui")
                billboard.Size = UDim2.new(3, 0, 1, 0)
                billboard.StudsOffset = Vector3.new(0, 1.5, 0)
                billboard.Adornee = char.Head
                billboard.Parent = char.Head
                billboard.AlwaysOnTop = true
                
                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.Position = UDim2.new(0, 0, 0, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.TextScaled = false
                textLabel.Text = "血量: "..char.Humanoid.Health.."/"..char.Humanoid.MaxHealth
                textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                textLabel.Font = Enum.Font.Arcade
                textLabel.Parent = billboard

              
                local distanceUpdate
                distanceUpdate = game:GetService("RunService").RenderStepped:Connect(function()
                    if char:FindFirstChild("Head") and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (char.Head.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
                        
                        local textSize = math.clamp(30 - (distance / 2), 12, 20)
                        textLabel.TextSize = textSize
                    end
                end)

                local healthUpdate = char:FindFirstChild("Humanoid").HealthChanged:Connect(function()
                    textLabel.Text = "血量: "..char:FindFirstChild("Humanoid").Health.."/"..char:FindFirstChild("Humanoid").MaxHealth
                end)

                char:FindFirstChild("Humanoid").Died:Connect(function()
                    distanceUpdate:Disconnect()
                    healthUpdate:Disconnect()
                    textLabel.Text = ""
                end)

                return {billboard = billboard, connections = {distanceUpdate, healthUpdate}}
            end

            getgenv().SurvivorHealthConnections = {
                Added = sur.DescendantAdded:Connect(function(v)
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") then
                        repeat wait() until v:FindFirstChild("Humanoid")
                        survivoresp(v)
                    end
                end)
            }

            for _,v in pairs(sur:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") then
                    repeat wait() until v:FindFirstChild("Humanoid")
                    survivoresp(v)
                end
            end
        else
            if getgenv().SurvivorHealthConnections then
                getgenv().SurvivorHealthConnections.Added:Disconnect()
            end
            
            for _,v in pairs(workspace.Players.Survivors:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("Head") then
                    for _,child in pairs(v.Head:GetChildren()) do
                        if child:IsA("BillboardGui") then
                            child:Destroy()
                        end
                    end
                end
            end
        end
    end
})

Visual:AddToggle("KillerHealth", {
    Text = "绘制杀手血量(文字)",
    Default = false,
    Callback = function(v)
        if v then
            local kil = workspace.Players.Killers
            
            local function killeresp(char)
                local billboard = Instance.new("BillboardGui")
                billboard.Size = UDim2.new(3, 0, 1, 0)
                billboard.StudsOffset = Vector3.new(0, 1.5, 0)
                billboard.Adornee = char.Head
                billboard.Parent = char.Head
                billboard.AlwaysOnTop = true
                
                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.Position = UDim2.new(0, 0, 0, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.TextScaled = false
                textLabel.Text = "血量: "..char.Humanoid.Health.."/"..char.Humanoid.MaxHealth
                textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                textLabel.Font = Enum.Font.Arcade
                textLabel.Parent = billboard

                -- 添加距离检测更新
                local distanceUpdate
                distanceUpdate = game:GetService("RunService").RenderStepped:Connect(function()
                    if char:FindFirstChild("Head") and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (char.Head.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
                        -- 根据距离动态调整文字大小 (10-30米范围内变化)
                        local textSize = math.clamp(30 - (distance / 2), 12, 20)
                        textLabel.TextSize = textSize
                    end
                end)

                local healthUpdate = char:FindFirstChild("Humanoid").HealthChanged:Connect(function()
                    textLabel.Text = "血量: "..char:FindFirstChild("Humanoid").Health.."/"..char:FindFirstChild("Humanoid").MaxHealth
                end)

                char:FindFirstChild("Humanoid").Died:Connect(function()
                    distanceUpdate:Disconnect()
                    healthUpdate:Disconnect()
                    textLabel.Text = ""
                end)

                return {billboard = billboard, connections = {distanceUpdate, healthUpdate}}
            end

            getgenv().KillerHealthConnections = {
                Added = kil.DescendantAdded:Connect(function(v)
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") then
                        repeat wait() until v:FindFirstChild("Humanoid")
                        killeresp(v)
                    end
                end)
            }

            for _,v in pairs(kil:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") then
                    repeat wait() until v:FindFirstChild("Humanoid")
                    killeresp(v)
                end
            end
        else
            if getgenv().KillerHealthConnections then
                getgenv().KillerHealthConnections.Added:Disconnect()
            end
            
            for _,v in pairs(workspace.Players.Killers:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("Head") then
                    for _,child in pairs(v.Head:GetChildren()) do
                        if child:IsA("BillboardGui") then
                            child:Destroy()
                        end
                    end
                end
            end
        end
    end
})





local Visual   = Tabs.Esp:AddLeftGroupbox('电机绘制')
-- 真电机ESP
Visual:AddToggle("RealGeneratorESP", {
    Text = "绘制真电机",
    Default = false,
    Callback = function(enabled)
        if not _G.RealGeneratorESP then
            _G.RealGeneratorESP = {
                Active = false,
                Data = {},
                Connections = {}
            }
        end
        
        if not enabled then
            if _G.RealGeneratorESP.Active then
                for _, connection in pairs(_G.RealGeneratorESP.Connections) do
                    if connection and connection.Connected then
                        connection:Disconnect()
                    end
                end
                
                for gen, data in pairs(_G.RealGeneratorESP.Data) do
                    if type(data) == "table" then
                        if data.Billboard and data.Billboard.Parent then
                            data.Billboard:Destroy()
                        end
                        if data.DistanceBillboard and data.DistanceBillboard.Parent then
                            data.DistanceBillboard:Destroy()
                        end
                        if data.Highlight and data.Highlight.Parent then
                            data.Highlight:Destroy()
                        end
                    end
                end
                
                _G.RealGeneratorESP.Data = {}
                _G.RealGeneratorESP.Connections = {}
                _G.RealGeneratorESP.Active = false
            end
            return
        end
        
        if _G.RealGeneratorESP.Active then
            return
        end
        
        _G.RealGeneratorESP.Active = true
        
        local scanInterval = 1.0
        local lastScanTime = 0
        local maxGenerators = 20
        
        local distanceSettings = {
            MinDistance = 5,
            MaxDistance = 500,
            MinScale = 0.8,
            MaxScale = 1.5,
            MinTextSize = 8,
            MaxTextSize = 10
        }
        
        local function updateGeneratorESP(gen, data)
            if not gen or not gen.Parent or not gen:FindFirstChild("Main") then
                return false
            end
            
            if table.getn(_G.RealGeneratorESP.Data) > maxGenerators then
                return false
            end
            
            if gen:FindFirstChild("Progress") then
                local progress = gen.Progress.Value
                if progress >= 99 then
                    return false
                end
                
                if data.TextLabel then
                    data.TextLabel.Text = string.format("真电机: %d%%", progress)
                end
                
                local character = game:GetService("Players").LocalPlayer.Character
                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                
                if humanoidRootPart and data.DistanceLabel then
                    local distance = (gen.Main.Position - humanoidRootPart.Position).Magnitude
                    
                    data.DistanceLabel.Text = string.format("距离: %d米", math.floor(distance))
                    
                    local distanceRatio = math.clamp(
                        (distance - distanceSettings.MinDistance) / 
                        (distanceSettings.MaxDistance - distanceSettings.MinDistance),
                        0, 1
                    )
                    
                    local scale = distanceSettings.MinScale + 
                        distanceRatio * (distanceSettings.MaxScale - distanceSettings.MinScale)
                    
                    local textSize = distanceSettings.MinTextSize + 
                        distanceRatio * (distanceSettings.MaxTextSize - distanceSettings.MinTextSize)
                    
                    if data.Billboard then 
                        data.Billboard.Size = UDim2.new(4 * scale, 0, 1 * scale, 0)
                        data.Billboard.Enabled = true
                    end
                    
                    if data.DistanceBillboard then 
                        data.DistanceBillboard.Size = UDim2.new(4 * scale, 0, 1 * scale, 0)
                        data.DistanceBillboard.Enabled = true
                    end
                    
                    if data.TextLabel then 
                        data.TextLabel.TextSize = textSize
                        data.TextLabel.Visible = true
                    end
                    
                    if data.DistanceLabel then 
                        data.DistanceLabel.TextSize = textSize
                        data.DistanceLabel.Visible = true
                    end
                    
                    if data.Highlight then
                        data.Highlight.Enabled = true
                        local transparency = math.clamp((distance - 50) / 100, 0, 0.4)
                        data.Highlight.FillTransparency = 0.85 + (transparency * 0.5)
                        data.Highlight.OutlineColor = Color3.fromRGB(0, 255, 0) -- 绿色
                        data.Highlight.FillColor = Color3.fromRGB(0, 255, 0)
                    end
                end
            end
            
            return true
        end
        
        local function createGeneratorESP(gen)
            if not gen or not gen:FindFirstChild("Main") or _G.RealGeneratorESP.Data[gen] then 
                return 
            end
            
            if table.getn(_G.RealGeneratorESP.Data) >= maxGenerators then
                return
            end
            
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "RealGeneratorESP"
            billboard.Size = UDim2.new(4, 0, 1, 0)
            billboard.StudsOffset = Vector3.new(0, 2.5, 0)
            billboard.Adornee = gen.Main
            billboard.Parent = gen.Main
            billboard.AlwaysOnTop = true
            billboard.Enabled = true
            
            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 0.5, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextScaled = false
            textLabel.Text = "真电机加载中..."
            textLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- 绿色
            textLabel.Font = Enum.Font.Arcade
            textLabel.TextStrokeTransparency = 0
            textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            textLabel.TextSize = 8
            textLabel.Parent = billboard
            
            local distanceBillboard = Instance.new("BillboardGui")
            distanceBillboard.Name = "RealGeneratorDistanceESP"
            distanceBillboard.Size = UDim2.new(4, 0, 1, 0)
            distanceBillboard.StudsOffset = Vector3.new(0, 3.5, 0)
            distanceBillboard.Adornee = gen.Main
            distanceBillboard.Parent = gen.Main
            distanceBillboard.AlwaysOnTop = true
            distanceBillboard.Enabled = true
            
            local distanceLabel = Instance.new("TextLabel")
            distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
            distanceLabel.BackgroundTransparency = 1
            distanceLabel.TextScaled = false
            distanceLabel.Text = "计算距离中..."
            distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
            distanceLabel.Font = Enum.Font.Arcade
            distanceLabel.TextStrokeTransparency = 0
            distanceLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            distanceLabel.TextSize = 8
            distanceLabel.Parent = distanceBillboard
            
            local highlight = Instance.new("Highlight")
            highlight.Name = "RealGeneratorHighlight"
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Enabled = true
            highlight.OutlineColor = Color3.fromRGB(0, 255, 0) -- 绿色
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.FillTransparency = 0.9
            highlight.OutlineTransparency = 0
            highlight.Parent = gen
            
            _G.RealGeneratorESP.Data[gen] = {
                Billboard = billboard,
                DistanceBillboard = distanceBillboard,
                TextLabel = textLabel,
                DistanceLabel = distanceLabel,
                Highlight = highlight
            }
            
            local destroyConnection
            destroyConnection = gen.Destroying:Connect(function()
                if _G.RealGeneratorESP.Data[gen] then
                    if _G.RealGeneratorESP.Data[gen].Billboard then 
                        _G.RealGeneratorESP.Data[gen].Billboard:Destroy() 
                    end
                    if _G.RealGeneratorESP.Data[gen].DistanceBillboard then 
                        _G.RealGeneratorESP.Data[gen].DistanceBillboard:Destroy() 
                    end
                    if _G.RealGeneratorESP.Data[gen].Highlight then 
                        _G.RealGeneratorESP.Data[gen].Highlight:Destroy() 
                    end
                    _G.RealGeneratorESP.Data[gen] = nil
                end
                if destroyConnection then
                    destroyConnection:Disconnect()
                end
            end)
            
            table.insert(_G.RealGeneratorESP.Connections, destroyConnection)
        end
        
        local function scanGenerators()
            local mapFolder = workspace:FindFirstChild("Map")
            if mapFolder then
                local ingameFolder = mapFolder:FindFirstChild("Ingame")
                if ingameFolder then
                    local mapSubFolder = ingameFolder:FindFirstChild("Map")
                    if mapSubFolder then
                        local generators = mapSubFolder:GetDescendants()
                        for _, gen in pairs(generators) do
                            if gen:IsA("Model") and gen:FindFirstChild("Main") and gen.Name == "Generator" then
                                createGeneratorESP(gen)
                            end
                        end
                    end
                end
            end
        end
        
        local mainConnection
        local mapFolder = workspace:FindFirstChild("Map")
        if mapFolder then
            local ingameFolder = mapFolder:FindFirstChild("Ingame")
            if ingameFolder then
                local mapSubFolder = ingameFolder:FindFirstChild("Map")
                if mapSubFolder then
                    mainConnection = mapSubFolder.DescendantAdded:Connect(function(v)
                        if v:IsA("Model") and v:FindFirstChild("Main") and v.Name == "Generator" then
                            createGeneratorESP(v)
                        end
                    end)
                end
            end
        end
        
        if mainConnection then
            table.insert(_G.RealGeneratorESP.Connections, mainConnection)
        end
        
        local heartbeatConnection = game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
            lastScanTime = lastScanTime + deltaTime
            if lastScanTime >= scanInterval then
                lastScanTime = 0
                scanGenerators()
            end
            
            local gensToRemove = {}
            for gen, data in pairs(_G.RealGeneratorESP.Data) do
                if not gen or not gen.Parent then
                    table.insert(gensToRemove, gen)
                else
                    if not updateGeneratorESP(gen, data) then
                        table.insert(gensToRemove, gen)
                    end
                end
            end
            
            for _, gen in ipairs(gensToRemove) do
                if _G.RealGeneratorESP.Data[gen] then
                    if _G.RealGeneratorESP.Data[gen].Billboard then 
                        _G.RealGeneratorESP.Data[gen].Billboard:Destroy() 
                    end
                    if _G.RealGeneratorESP.Data[gen].DistanceBillboard then 
                        _G.RealGeneratorESP.Data[gen].DistanceBillboard:Destroy() 
                    end
                    if _G.RealGeneratorESP.Data[gen].Highlight then 
                        _G.RealGeneratorESP.Data[gen].Highlight:Destroy() 
                    end
                    _G.RealGeneratorESP.Data[gen] = nil
                end
            end
        end)
        
        table.insert(_G.RealGeneratorESP.Connections, heartbeatConnection)
        
        scanGenerators()
    end
})

-- 假电机ESP
Visual:AddToggle("FakeGeneratorESP", {
    Text = "绘制假电机",
    Default = false,
    Callback = function(enabled)
        if not _G.FakeGeneratorESP then
            _G.FakeGeneratorESP = {
                Active = false,
                Data = {},
                Connections = {}
            }
        end
        
        if not enabled then
            if _G.FakeGeneratorESP.Active then
                for _, connection in pairs(_G.FakeGeneratorESP.Connections) do
                    if connection and connection.Connected then
                        connection:Disconnect()
                    end
                end
                
                for gen, data in pairs(_G.FakeGeneratorESP.Data) do
                    if type(data) == "table" then
                        if data.Highlight and data.Highlight.Parent then
                            data.Highlight:Destroy()
                        end
                        if data.NameLabel and data.NameLabel.Parent then
                            data.NameLabel:Destroy()
                        end
                    end
                end
                
                _G.FakeGeneratorESP.Data = {}
                _G.FakeGeneratorESP.Connections = {}
                _G.FakeGeneratorESP.Active = false
            end
            return
        end
        
        if _G.FakeGeneratorESP.Active then
            _G.FakeGeneratorESP.Callback(false)
        end
        
        _G.FakeGeneratorESP.Active = true
        
        local scanInterval = 1.0
        local lastScanTime = 0
        
        local function createFakeGeneratorESP(gen)
            if not gen or not gen:FindFirstChild("Main") or _G.FakeGeneratorESP.Data[gen] then 
                return 
            end
            
            local highlight = Instance.new("Highlight")
            highlight.Name = "FakeGeneratorHighlight"
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Enabled = true
            highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.FillTransparency = 0.9
            highlight.OutlineTransparency = 0
            highlight.Parent = gen
            
            local nameBillboard = Instance.new("BillboardGui")
            nameBillboard.Name = "FakeGeneratorNameESP"
            nameBillboard.Size = UDim2.new(4, 0, 1, 0)
            nameBillboard.StudsOffset = Vector3.new(0, 2.5, 0)
            nameBillboard.Adornee = gen.Main
            nameBillboard.Parent = gen.Main
            nameBillboard.AlwaysOnTop = true
            nameBillboard.Enabled = true
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextScaled = false
            nameLabel.Text = "假电机"
            nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            nameLabel.Font = Enum.Font.Arcade
            nameLabel.TextStrokeTransparency = 0
            nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            nameLabel.TextSize = 12
            nameLabel.Parent = nameBillboard
            
            _G.FakeGeneratorESP.Data[gen] = {
                Highlight = highlight,
                NameLabel = nameLabel,
                NameBillboard = nameBillboard
            }
            
            local destroyConnection
            destroyConnection = gen.Destroying:Connect(function()
                if _G.FakeGeneratorESP.Data[gen] then
                    if _G.FakeGeneratorESP.Data[gen].Highlight then 
                        _G.FakeGeneratorESP.Data[gen].Highlight:Destroy() 
                    end
                    if _G.FakeGeneratorESP.Data[gen].NameLabel then 
                        _G.FakeGeneratorESP.Data[gen].NameLabel:Destroy() 
                    end
                    if _G.FakeGeneratorESP.Data[gen].NameBillboard then 
                        _G.FakeGeneratorESP.Data[gen].NameBillboard:Destroy() 
                    end
                    _G.FakeGeneratorESP.Data[gen] = nil
                end
                if destroyConnection then
                    destroyConnection:Disconnect()
                end
            end)
            
            table.insert(_G.FakeGeneratorESP.Connections, destroyConnection)
        end
        
        local function scanGenerators()
            local mapFolder = workspace:FindFirstChild("Map")
            if mapFolder then
                local ingameFolder = mapFolder:FindFirstChild("Ingame")
                if ingameFolder then
                    local mapSubFolder = ingameFolder:FindFirstChild("Map")
                    if mapSubFolder then
                        local generators = mapSubFolder:GetDescendants()
                        for _, gen in pairs(generators) do
                            if gen:IsA("Model") and gen:FindFirstChild("Main") and gen.Name == "FakeGenerator" then
                                createFakeGeneratorESP(gen)
                            end
                        end
                    end
                end
            end
        end
        
        local mainConnection
        local mapFolder = workspace:FindFirstChild("Map")
        if mapFolder then
            local ingameFolder = mapFolder:FindFirstChild("Ingame")
            if ingameFolder then
                local mapSubFolder = ingameFolder:FindFirstChild("Map")
                if mapSubFolder then
                    mainConnection = mapSubFolder.DescendantAdded:Connect(function(v)
                        if v:IsA("Model") and v:FindFirstChild("Main") and v.Name == "FakeGenerator" then
                            createFakeGeneratorESP(v)
                        end
                    end)
                end
            end
        end
        
        if mainConnection then
            table.insert(_G.FakeGeneratorESP.Connections, mainConnection)
        end
        
        local heartbeatConnection = game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
            lastScanTime = lastScanTime + deltaTime
            if lastScanTime >= scanInterval then
                lastScanTime = 0
                scanGenerators()
            end
            
            local gensToRemove = {}
            for gen, data in pairs(_G.FakeGeneratorESP.Data) do
                if not gen or not gen.Parent then
                    table.insert(gensToRemove, gen)
                end
            end
            
            for _, gen in ipairs(gensToRemove) do
                if _G.FakeGeneratorESP.Data[gen] then
                    if _G.FakeGeneratorESP.Data[gen].Highlight then 
                        _G.FakeGeneratorESP.Data[gen].Highlight:Destroy() 
                    end
                    if _G.FakeGeneratorESP.Data[gen].NameLabel then 
                        _G.FakeGeneratorESP.Data[gen].NameLabel:Destroy() 
                    end
                    if _G.FakeGeneratorESP.Data[gen].NameBillboard then 
                        _G.FakeGeneratorESP.Data[gen].NameBillboard:Destroy() 
                    end
                    _G.FakeGeneratorESP.Data[gen] = nil
                end
            end
        end)
        
        table.insert(_G.FakeGeneratorESP.Connections, heartbeatConnection)
        
        scanGenerators()
    end
})

-- 特殊电机ESP
Visual:AddToggle("NoliWarningESP", {
    Text = "绘制Noli传送电机",
    Default = false,
    Callback = function(enabled)
        if not _G.NoliWarningESP then
            _G.NoliWarningESP = {
                Active = false,
                Data = {},
                Connections = {}
            }
        end
        
        if not enabled then
            if _G.NoliWarningESP.Active then
                for _, connection in pairs(_G.NoliWarningESP.Connections) do
                    if connection and connection.Connected then
                        connection:Disconnect()
                    end
                end
                
                for gen, data in pairs(_G.NoliWarningESP.Data) do
                    if type(data) == "table" then
                        if data.Highlight and data.Highlight.Parent then
                            data.Highlight:Destroy()
                        end
                        if data.Label and data.Label.Parent then
                            data.Label:Destroy()
                        end
                    end
                end
                
                _G.NoliWarningESP.Data = {}
                _G.NoliWarningESP.Connections = {}
                _G.NoliWarningESP.Active = false
            end
            return
        end
        
        if _G.NoliWarningESP.Active then
            return
        end
        
        _G.NoliWarningESP.Active = true
        
        local scanInterval = 1.0
        local lastScanTime = 0
        
        local function hasNoliWarning(gen)
            if string.find(gen.Name, "NoliWarningIncoming") then
                return true
            end
            
            for _, child in pairs(gen:GetDescendants()) do
                if (child:IsA("StringValue") or child:IsA("ObjectValue")) and 
                   string.find(tostring(child.Value), "NoliWarningIncoming") then
                    return true
                elseif child:IsA("BasePart") and string.find(child.Name, "NoliWarningIncoming") then
                    return true
                end
            end
            
            return false
        end
        
        local function createNoliWarningESP(gen)
            if not gen or not gen:FindFirstChild("Main") or _G.NoliWarningESP.Data[gen] then 
                return 
            end
            
            if not hasNoliWarning(gen) then
                return
            end
            
            local highlight = Instance.new("Highlight")
            highlight.Name = "NoliWarningHighlight"
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Enabled = true
            highlight.OutlineColor = Color3.fromRGB(255, 0, 255)
            highlight.FillColor = Color3.fromRGB(255, 0, 255)
            highlight.FillTransparency = 0.7
            highlight.OutlineTransparency = 0
            highlight.Parent = gen
            
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "NoliWarningBillboard"
            billboard.Size = UDim2.new(6, 0, 2, 0)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.Adornee = gen.Main
            billboard.Parent = gen.Main
            billboard.AlwaysOnTop = true
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = "[Noli即将传送]"
            label.TextColor3 = Color3.fromRGB(255, 0, 255)
            label.Font = Enum.Font.Arcade
            label.TextSize = 14
            label.TextStrokeTransparency = 0
            label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            label.Parent = billboard
            
            _G.NoliWarningESP.Data[gen] = {
                Highlight = highlight,
                Label = label,
                Billboard = billboard,
                LastCheck = os.time()
            }
            
            local destroyConnection
            destroyConnection = gen.Destroying:Connect(function()
                if _G.NoliWarningESP.Data[gen] then
                    if _G.NoliWarningESP.Data[gen].Highlight then 
                        _G.NoliWarningESP.Data[gen].Highlight:Destroy() 
                    end
                    if _G.NoliWarningESP.Data[gen].Label then 
                        _G.NoliWarningESP.Data[gen].Label:Destroy() 
                    end
                    if _G.NoliWarningESP.Data[gen].Billboard then 
                        _G.NoliWarningESP.Data[gen].Billboard:Destroy() 
                    end
                    _G.NoliWarningESP.Data[gen] = nil
                end
                if destroyConnection then
                    destroyConnection:Disconnect()
                end
            end)
            
            table.insert(_G.NoliWarningESP.Connections, destroyConnection)
        end
        
        local function scanGenerators()
            local generators = workspace:GetDescendants()
            for _, gen in pairs(generators) do
                if gen:IsA("Model") and gen:FindFirstChild("Main") and 
                   (gen.Name == "Generator" or gen.Name == "FakeGenerator") then
                    createNoliWarningESP(gen)
                end
            end
        end
        
        local function updateExistingGenerators()
            local gensToRemove = {}
            for gen, data in pairs(_G.NoliWarningESP.Data) do
                if not gen or not gen.Parent then
                    table.insert(gensToRemove, gen)
                else
                    if os.time() - data.LastCheck > 5 then
                        if not hasNoliWarning(gen) then
                            table.insert(gensToRemove, gen)
                        else
                            data.LastCheck = os.time()
                        end
                    end
                end
            end
            
            for _, gen in ipairs(gensToRemove) do
                if _G.NoliWarningESP.Data[gen] then
                    if _G.NoliWarningESP.Data[gen].Highlight then 
                        _G.NoliWarningESP.Data[gen].Highlight:Destroy() 
                    end
                    if _G.NoliWarningESP.Data[gen].Label then 
                        _G.NoliWarningESP.Data[gen].Label:Destroy() 
                    end
                    if _G.NoliWarningESP.Data[gen].Billboard then 
                        _G.NoliWarningESP.Data[gen].Billboard:Destroy() 
                    end
                    _G.NoliWarningESP.Data[gen] = nil
                end
            end
        end
        
        local mainConnection = workspace.DescendantAdded:Connect(function(v)
            if v:IsA("Model") and v:FindFirstChild("Main") and 
               (v.Name == "Generator" or v.Name == "FakeGenerator") then
                createNoliWarningESP(v)
            end
        end)
        
        table.insert(_G.NoliWarningESP.Connections, mainConnection)
        
        local heartbeatConnection = game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
            lastScanTime = lastScanTime + deltaTime
            if lastScanTime >= scanInterval then
                lastScanTime = 0
                scanGenerators()
                updateExistingGenerators()
            end
        end)
        
        table.insert(_G.NoliWarningESP.Connections, heartbeatConnection)
        
        scanGenerators()
    end
})




local Visual = Tabs.Esp:AddRightGroupbox("2D方框")


Visual:AddToggle("SE", {
    Text = "绘制幸存者方框",
    Default = false,
    Callback = function(v)
        if v then
            local a = workspace:WaitForChild("Players")
            local c = a:WaitForChild("Survivors")
            local d = game:GetService("RunService")
            local e = game:GetService("Players").LocalPlayer
            
            local function f(g, h)
                if not g:IsA("Model") then return end
                if g == e.Character then return end
                local i = g:FindFirstChild("HumanoidRootPart")
                if not i then return end
                if i:FindFirstChild("playeresp") then return end
                
                local j = Instance.new("BillboardGui")
                j.Name = "playeresp"
                j.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                j.Active = true
                j.AlwaysOnTop = true
                j.LightInfluence = 1.000
                j.Size = UDim2.new(3, 0, 5, 0)
                j.Adornee = i
                j.Parent = i
                
                local k = Instance.new("Frame")
                k.Name = "playershow"
                k.BackgroundColor3 = Color3.fromRGB(255, 25, 25)
                k.BackgroundTransparency = 1
                k.Size = UDim2.new(1, 0, 1, 0)
                k.Parent = j
                
                local l = Instance.new("UIStroke")
                l.Color = h
                l.Thickness = 2
                l.Transparency = 0.2
                l.Parent = k
            end
            
            SurvivorESPConnection = d.RenderStepped:Connect(function()
                for m, o in ipairs(c:GetChildren()) do
                    f(o, Color3.fromRGB(0, 255, 0))
                end
            end)
            
            -- 添加新加入的幸存者
            SurvivorAddedConnection = c.ChildAdded:Connect(function(o)
                f(o, Color3.fromRGB(0, 255, 0))
            end)
        else
            if SurvivorESPConnection then
                SurvivorESPConnection:Disconnect()
            end
            if SurvivorAddedConnection then
                SurvivorAddedConnection:Disconnect()
            end
            
            -- 清除所有幸存者ESP
            local a = workspace:WaitForChild("Players")
            local c = a:WaitForChild("Survivors")
            for _, o in ipairs(c:GetChildren()) do
                if o:IsA("Model") then
                    local i = o:FindFirstChild("HumanoidRootPart")
                    if i and i:FindFirstChild("playeresp") then
                        i.playeresp:Destroy()
                    end
                end
            end
        end
    end
})

Visual:AddToggle("KE", {
    Text = "绘制杀手方框",
    Default = false,
    Callback = function(v)
        if v then
            local a = workspace:WaitForChild("Players")
            local b = a:WaitForChild("Killers")
            local d = game:GetService("RunService")
            local e = game:GetService("Players").LocalPlayer
            
            local function f(g, h)
                if not g:IsA("Model") then return end
                if g == e.Character then return end
                local i = g:FindFirstChild("HumanoidRootPart")
                if not i then return end
                if i:FindFirstChild("playeresp") then return end
                
                local j = Instance.new("BillboardGui")
                j.Name = "playeresp"
                j.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                j.Active = true
                j.AlwaysOnTop = true
                j.LightInfluence = 1.000
                j.Size = UDim2.new(3, 0, 5, 0)
                j.Adornee = i
                j.Parent = i
                
                local k = Instance.new("Frame")
                k.Name = "playershow"
                k.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                k.BackgroundTransparency = 1
                k.Size = UDim2.new(1, 0, 1, 0)
                k.Parent = j
                
                local l = Instance.new("UIStroke")
                l.Color = h
                l.Thickness = 2
                l.Transparency = 0.2
                l.Parent = k
            end
            
            KillerESPConnection = d.RenderStepped:Connect(function()
                for m, o in ipairs(b:GetChildren()) do
                    f(o, Color3.fromRGB(255, 0, 0))
                end
            end)
            
            -- 添加新加入的杀手
            KillerAddedConnection = b.ChildAdded:Connect(function(o)
                f(o, Color3.fromRGB(255, 0, 0))
            end)
        else
            if KillerESPConnection then
                KillerESPConnection:Disconnect()
            end
            if KillerAddedConnection then
                KillerAddedConnection:Disconnect()
            end
            
            -- 清除所有杀手ESP
            local a = workspace:WaitForChild("Players")
            local b = a:WaitForChild("Killers")
            for _, o in ipairs(b:GetChildren()) do
                if o:IsA("Model") then
                    local i = o:FindFirstChild("HumanoidRootPart")
                    if i and i:FindFirstChild("playeresp") then
                        i.playeresp:Destroy()
                    end
                end
            end
        end
    end
})

local Visual = Tabs.Esp:AddLeftGroupbox("物品绘制")

local LibESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/ImamGV/Script/main/ESP"))()

Visual:AddToggle("EKE",{
    Text = "杀手机器人绘制",
    Callback = function(v)
        if v then
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v.Name == "PizzaDeliveryRig" or v.Name == "Bunny" or v.Name == "Mafiaso1" or v.Name == "Mafiaso2" or v.Name == "Mafiaso3" then
                    LibESP:AddESP(v, "披萨送货员", Color3.fromRGB(255, 52, 179), 14, "Other_ESP")
                elseif v:IsA("Model") and v.Name == "1x1x1x1Zombie" then
                    LibESP:AddESP(v, "1x1x1x1 (僵尸)", Color3.fromRGB(224, 102, 255), 14, "Other_ESP")
                end
            end
            OtherESP = workspace.DescendantAdded:Connect(function(v)
                if v:IsA("Model") and v.Name == "PizzaDeliveryRig" or v.Name == "Bunny" or v.Name == "Mafiaso1" or v.Name == "Mafiaso2" or v.Name == "Mafiaso3" then
                    LibESP:AddESP(v, "披萨送货员", Color3.fromRGB(255, 52, 179), 14, "Other_ESP")
                elseif v:IsA("Model") and v.Name == "1x1x1x1Zombie" then
                    LibESP:AddESP(v, "1x1x1x1 (僵尸)", Color3.fromRGB(224, 102, 255), 14, "Other_ESP")
                end
            end)
        else
            OtherESP:Disconnect()
            LibESP:Delete("Other_ESP")
        end
    end
})





Visual:AddToggle("TWE",{
Text = "塔夫绊线绘制",
Default = false,
Callback = function(v)
if v then
for _, v in ipairs(workspace:GetDescendants()) do
if v:match("TaphTripwire") and not v:FindFirstChild("TripWire_ESP") then
LibESP:AddESP(v, "Trip Wire", Color3.new(0,1,0), 14,"TripWire_ESP")
end
end
TripWireESP = workspace.Map.Ingame.DescendantAdded:Connect(function(v)
wait(1)
if v:match("TaphTripwire") and not v:FindFirstChild("TripWire_ESP") then
LibESP:AddESP(v, "Trip Wire", Color3.new(0,1,0), 14,"TripWire_ESP")
end
end)
else
TripWireESP:Disconnect()
LibESP:Delete("TripWire_ESP")
end
end})



Visual:AddToggle("ST",{
Text = "空间炸弹绘制",
Callback = function(v)
if v then
for _, v in ipairs(workspace:GetDescendants()) do
if v:IsA("Model") and v.Name == "SubspaceTripmine" and not v:FindFirstChild("SubspaceTripmine_ESP") then
LibESP:AddESP(v, "", Color3.fromRGB(255, 0, 255), 14, "SubspaceTripmine_ESP")
end
end
SubspaceTripmineESP = workspace.DescendantAdded:Connect(function(v)
if v:IsA("Model") and v.Name == "SubspaceTripmine" and not v:FindFirstChild("SubspaceTripmine_ESP") then
LibESP:AddESP(v, "", Color3.fromRGB(255, 0, 255), 14, "SubspaceTripmine_ESP")
end
end)
else
SubspaceTripmineESP:Disconnect()
LibESP:Delete("SubspaceTripmine_ESP")
end
end})
Visual:AddToggle("ME",{
Text = "医疗箱绘制",
Callback = function(v)
if v then
for _, v in ipairs(workspace:GetDescendants()) do
if v:IsA("Model") and v.Name == "Medkit" and not v:FindFirstChild("Medkit_ESP") then
LibESP:AddESP(v, "Medkit", Color3.fromRGB(187, 255, 255), 14, "Medkit_ESP")
end
end
MedkitESP = workspace.DescendantAdded:Connect(function(v)
if v:IsA("Model") and v.Name == "Medkit" and not v:FindFirstChild("Medkit_ESP") then
LibESP:AddESP(v, "Medkit", Color3.fromRGB(187, 255, 255), 14, "Medkit_ESP")
end
end)
else
Medkit:Disconnect()
LibESP:Delete("Medkit_ESP")
end
end})
Visual:AddToggle("BCE",{
Text = "可乐绘制",
Callback = function(v)
if v then
for _, v in ipairs(workspace:GetDescendants()) do
if v:IsA("Model") and v.Name == "BloxyCola" and not v:FindFirstChild("BloxyCola_ESP") then
LibESP:AddESP(v, "Bloxy Cola", Color3.fromRGB(131, 111, 255), 14, "BloxyCola_ESP")
end
end
ColaESP = workspace.DescendantAdded:Connect(function(v)
if v:IsA("Model") and v.Name == "BloxyCola" and not v:FindFirstChild("BloxyCola_ESP") then
LibESP:AddESP(v, "Bloxy Cola", Color3.fromRGB(131, 111, 255), 14, "BloxyCola_ESP")
end
end)
else
ColaESP:Disconnect()
LibESP:Delete("BloxyCola_ESP")
end
end})




local Warning = Tabs.tzq:AddLeftGroupbox("杀手靠近提示")

-- 杀手靠近提示设置
local KillerWarningSettings = {
    Enabled = false,
    WarningDistance = 100, -- 警告距离(米)
    WarningColor = Color3.fromRGB(255, 0, 0), -- 警告颜色(红色)
    TextSize = 20, -- 文字大小
    BlinkInterval = 0.5, -- 闪烁间隔(秒)
    LastWarningTime = 0, -- 上次警告时间
    WarningCooldown = 5, -- 警告冷却时间(秒)
    WarningSoundId = "rbxassetid://6545327576", -- 警告音效ID
    SoundVolume = 0.5 -- 音效音量
}

-- 存储绘制对象
local warningLabel = Drawing.new("Text")
warningLabel.Visible = false
warningLabel.Center = true
warningLabel.Outline = true
warningLabel.Font = 2 -- 粗体字体
warningLabel.Color = KillerWarningSettings.WarningColor
warningLabel.Size = KillerWarningSettings.TextSize

-- 存储音效对象
local warningSound = Instance.new("Sound")
warningSound.SoundId = KillerWarningSettings.WarningSoundId
warningSound.Volume = KillerWarningSettings.SoundVolume
warningSound.Parent = game:GetService("SoundService")

-- 更新警告显示
local function updateKillerWarning()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local killersFolder = workspace.Players:FindFirstChild("Killers")
    if not killersFolder then return end
    
    local closestDistance = math.huge
    local closestKiller = nil
    
    -- 寻找最近的杀手
    for _, killer in ipairs(killersFolder:GetChildren()) do
        if killer:IsA("Model") and killer:FindFirstChild("HumanoidRootPart") then
            local distance = (character.HumanoidRootPart.Position - killer.HumanoidRootPart.Position).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestKiller = killer
            end
        end
    end
    
    -- 检查距离并显示警告
    if closestKiller and closestDistance <= KillerWarningSettings.WarningDistance then
        local currentTime = tick()
        
        -- 闪烁效果
        if currentTime - KillerWarningSettings.LastWarningTime >= KillerWarningSettings.BlinkInterval then
            warningLabel.Visible = not warningLabel.Visible
            KillerWarningSettings.LastWarningTime = currentTime
        end
        
        -- 设置警告文本
        warningLabel.Text = string.format("警告! 杀手 %s 在 %d 米内!", closestKiller.Name, math.floor(closestDistance))
        warningLabel.Position = Vector2.new(
            workspace.CurrentCamera.ViewportSize.X / 2,
            workspace.CurrentCamera.ViewportSize.Y * 0.2
        )
        
        -- 播放警告音效(冷却时间内只播放一次)
        if currentTime - KillerWarningSettings.LastWarningTime >= KillerWarningSettings.WarningCooldown then
            warningSound:Play()
            KillerWarningSettings.LastWarningTime = currentTime
        end
    else
        warningLabel.Visible = false
    end
end

-- 主开关
Warning:AddToggle("KillerWarningToggle", {
    Text = "杀手靠近提示",
    Default = false,
    Callback = function(enabled)
        KillerWarningSettings.Enabled = enabled
        if enabled then
            -- 初始化连接
            if not KillerWarningSettings.connection then
                KillerWarningSettings.connection = game:GetService("RunService").RenderStepped:Connect(updateKillerWarning)
            end
        else
            -- 关闭连接
            if KillerWarningSettings.connection then
                KillerWarningSettings.connection:Disconnect()
                KillerWarningSettings.connection = nil
            end
            warningLabel.Visible = false
            warningSound:Stop()
        end
    end
})

-- 距离设置
Warning:AddSlider("WarningDistance", {
    Text = "警告距离(米)",
    Min = 10,
    Max = 200,
    Default = 100,
    Rounding = 0,
    Callback = function(value)
        KillerWarningSettings.WarningDistance = value
    end
})

-- 文字大小设置
Warning:AddSlider("WarningTextSize", {
    Text = "文字大小",
    Min = 10,
    Max = 30,
    Default = 20,
    Rounding = 0,
    Callback = function(value)
        KillerWarningSettings.TextSize = value
        warningLabel.Size = value
    end
})

-- 闪烁速度设置
Warning:AddSlider("BlinkSpeed", {
    Text = "闪烁速度",
    Min = 0.1,
    Max = 1,
    Default = 0.5,
    Rounding = 1,
    Callback = function(value)
        KillerWarningSettings.BlinkInterval = value
    end
})

-- 警告颜色选择
Warning:AddDropdown("WarningColor", {
    Values = {"红色", "橙色", "黄色", "粉色", "紫色"},
    Default = "红色",
    Text = "警告颜色",
    Callback = function(value)
        local colorMap = {
            ["红色"] = Color3.fromRGB(255, 0, 0),
            ["橙色"] = Color3.fromRGB(255, 165, 0),
            ["黄色"] = Color3.fromRGB(255, 255, 0),
            ["粉色"] = Color3.fromRGB(255, 192, 203),
            ["紫色"] = Color3.fromRGB(128, 0, 128)
        }
        KillerWarningSettings.WarningColor = colorMap[value] or Color3.fromRGB(255, 0, 0)
        warningLabel.Color = KillerWarningSettings.WarningColor
    end
})


local Visual = Tabs.tzq:AddRightGroupbox("Noli监听")



Visual:AddToggle("NoliTeleportAlert", {
    Text = "Noli传送提示",
    Default = false,
    Callback = function(v)
        if v then
            local activeConnections = {}
            local lastNotifyTime = 0
            local COOLDOWN = 2
            local TARGET_SOUND_ID = "rbxassetid://125253972523701"

            local function safeNotify()
                local currentTime = tick()
                if currentTime - lastNotifyTime > COOLDOWN then
                    Library:Notify("警告\nNoli正在传送")
                    lastNotifyTime = currentTime
                end
            end

            local function checkSoundPlaying(sound)
                return sound and sound.IsPlaying or false
            end

            local function monitorSound(sound)
                task.spawn(function()
                    while sound.Parent and checkSoundPlaying(sound) do
                        safeNotify()
                        task.wait(COOLDOWN)
                    end
                end)
            end

            local function setupKiller(killer)
                local humanoidRootPart = killer:WaitForChild("HumanoidRootPart", 5)
                if humanoidRootPart then
                   
                    for _, child in ipairs(humanoidRootPart:GetChildren()) do
                        if child:IsA("Sound") and child.SoundId == TARGET_SOUND_ID then
                            monitorSound(child)
                        end
                    end

                
                    local connection = humanoidRootPart.ChildAdded:Connect(function(child)
                        if child:IsA("Sound") and child.SoundId == TARGET_SOUND_ID then
                            monitorSound(child)
                        end
                    end)
                    
                    table.insert(activeConnections, connection)
                end
            end

        
            table.insert(activeConnections, workspace.Players.Killers.ChildAdded:Connect(setupKiller))

          
            for _, killer in ipairs(workspace.Players.Killers:GetChildren()) do
                task.spawn(setupKiller, killer)
            end
        else
           
            for _, conn in ipairs(activeConnections) do
                conn:Disconnect()
            end
            activeConnections = {}
        end
    end
})


Visual:AddToggle("NoliTeleportCancel", {
    Text = "Noli传送取消提示",
    Default = false,
    Callback = function(v)
        if v then
            local activeConnections = {}
            local lastNotifyTime = 0
            local COOLDOWN = 2 
            
            local function checkSound(humanoidRootPart)
                for _, child in ipairs(humanoidRootPart:GetChildren()) do
                    if child:IsA("Sound") and child.SoundId == "rbxassetid://9125639499" and child.IsPlaying then
                        local currentTime = tick()
                        if currentTime - lastNotifyTime > COOLDOWN then
                            Library:Notify("警告\nNoli取消了传送")
                            lastNotifyTime = currentTime
                        end
                        return true
                    end
                end
                return false
            end

            local function setupKiller(killer)
                local humanoidRootPart = killer:WaitForChild("HumanoidRootPart", 5)
                if humanoidRootPart then
                    local connection
                    connection = humanoidRootPart.ChildAdded:Connect(function(child)
                        if child:IsA("Sound") and child.SoundId == "rbxassetid://9125639499" then
                            task.spawn(function()
                                while child.Parent and child.IsPlaying do
                                    local currentTime = tick()
                                    if currentTime - lastNotifyTime > COOLDOWN then
                                        Library:Notify("警告\nNoli取消了传送")
                                        lastNotifyTime = currentTime
                                    end
                                    task.wait(0.1)
                                end
                            end)
                        end
                    end)
                    
                    table.insert(activeConnections, connection)
                    
                    -- 初始检查
                    task.spawn(function()
                        while killer.Parent do
                            if checkSound(humanoidRootPart) then
                                task.wait(COOLDOWN)
                            else
                                task.wait(0.1)
                            end
                        end
                        connection:Disconnect()
                    end)
                end
            end

            -- 监听新杀手
            table.insert(activeConnections, workspace.Players.Killers.ChildAdded:Connect(setupKiller))
            
            -- 检查现有杀手
            for _, killer in ipairs(workspace.Players.Killers:GetChildren()) do
                task.spawn(setupKiller, killer)
            end
        else
            for _, conn in ipairs(activeConnections) do
                conn:Disconnect()
            end
            activeConnections = {}
        end
    end
})

Visual:AddToggle("NoliMotorSelect", {
    Text = "Noli电机选择提示",
    Default = false,
    Callback = function(v)
        local soundId = "rbxassetid://124468317999247"
        local notificationMessage = "警告\nNoli正在选择电机"
        local connections = {}
        local cooldown = 2 -- 通知冷却时间(秒)
        local lastNotifyTime = 0

        local function disconnectAll()
            for _, conn in pairs(connections) do
                conn:Disconnect()
            end
            connections = {}
        end

        local function safeNotify()
            local now = os.time()
            if now - lastNotifyTime >= cooldown then
                Library:Notify(notificationMessage)
                lastNotifyTime = now
            end
        end

        local function setupSoundListener(humanoidRootPart)
            local function onChildAdded(child)
                if child:IsA("Sound") and child.SoundId == soundId then
                    safeNotify()
                end
            end

            local conn = humanoidRootPart.ChildAdded:Connect(onChildAdded)
            table.insert(connections, conn)

            -- 检查已存在的音频
            for _, child in ipairs(humanoidRootPart:GetChildren()) do
                if child:IsA("Sound") and child.SoundId == soundId then
                    safeNotify()
                    break
                end
            end
        end

        local function onKillerAdded(killer)
            local humanoidRootPart = killer:FindFirstChild("HumanoidRootPart") or killer:WaitForChild("HumanoidRootPart", 3)
            if humanoidRootPart then
                setupSoundListener(humanoidRootPart)
            end
        end

        if v then
            -- 监听新杀手
            local mainConn = workspace.Players.Killers.ChildAdded:Connect(onKillerAdded)
            table.insert(connections, mainConn)

            -- 初始化现有杀手
            for _, killer in ipairs(workspace.Players.Killers:GetChildren()) do
                task.spawn(onKillerAdded, killer)
            end
        else
            disconnectAll()
        end
    end
})





Visual:AddToggle("NoliMotorSelect", {
    Text = "Noli冲刺提示",
    Default = false,
    Callback = function(v)
        local soundId = "rbxassetid://126318185932771"
        local notificationMessage = "Noli正在冲刺"
        local endNotificationMessage = "Noli冲刺结束"
        local connections = {}
        local cooldown = 2
        local lastNotifyTime = 0

        local function disconnectAll()
            for _, conn in pairs(connections) do
                conn:Disconnect()
            end
            connections = {}
        end

        local function safeNotify(message)
            local now = os.time()
            if now - lastNotifyTime >= cooldown then
                Library:Notify(message)
                lastNotifyTime = now
            end
        end

        local function setupSoundListener(humanoidRootPart)
            local function onChildAdded(child)
                if child:IsA("Sound") and child.SoundId == soundId then
                    safeNotify(notificationMessage)
                    local endedConn = child.Ended:Connect(function()
                        safeNotify(endNotificationMessage)
                        endedConn:Disconnect()
                    end)
                    table.insert(connections, endedConn)
                end
            end

            local conn = humanoidRootPart.ChildAdded:Connect(onChildAdded)
            table.insert(connections, conn)

            for _, child in ipairs(humanoidRootPart:GetChildren()) do
                if child:IsA("Sound") and child.SoundId == soundId then
                    safeNotify(notificationMessage)
                    if child.IsPlaying then
                        local endedConn = child.Ended:Connect(function()
                            safeNotify(endNotificationMessage)
                            endedConn:Disconnect()
                        end)
                        table.insert(connections, endedConn)
                    end
                    break
                end
            end
        end

        local function onKillerAdded(killer)
            local humanoidRootPart = killer:FindFirstChild("HumanoidRootPart") or killer:WaitForChild("HumanoidRootPart", 3)
            if humanoidRootPart then
                setupSoundListener(humanoidRootPart)
            end
        end

        if v then
            local mainConn = workspace.Players.Killers.ChildAdded:Connect(onKillerAdded)
            table.insert(connections, mainConn)
            for _, killer in ipairs(workspace.Players.Killers:GetChildren()) do
                task.spawn(onKillerAdded, killer)
            end
        else
            disconnectAll()
        end
    end
})













local Visual = Tabs.tzq:AddLeftGroupbox('1x4技能监听通知')





Visual:AddToggle("NoliMotorSelect", {
    Text = "1x4缠绕监听",
    Default = false,
    Callback = function(v)
        local soundId = "rbxassetid://101593173978979"
        local notificationMessage = "小心缠绕"
        local endNotificationMessage = "小心缠绕"
        local connections = {}
        local cooldown = 2
        local lastNotifyTime = 0

        local function disconnectAll()
            for _, conn in pairs(connections) do
                conn:Disconnect()
            end
            connections = {}
        end

        local function safeNotify(message)
            local now = os.time()
            if now - lastNotifyTime >= cooldown then
                Library:Notify(message)
                lastNotifyTime = now
            end
        end

        local function setupSoundListener(humanoidRootPart)
            local function onChildAdded(child)
                if child:IsA("Sound") and child.SoundId == soundId then
                    safeNotify(notificationMessage)
                    local endedConn = child.Ended:Connect(function()
                        safeNotify(endNotificationMessage)
                        endedConn:Disconnect()
                    end)
                    table.insert(connections, endedConn)
                end
            end

            local conn = humanoidRootPart.ChildAdded:Connect(onChildAdded)
            table.insert(connections, conn)

            for _, child in ipairs(humanoidRootPart:GetChildren()) do
                if child:IsA("Sound") and child.SoundId == soundId then
                    safeNotify(notificationMessage)
                    if child.IsPlaying then
                        local endedConn = child.Ended:Connect(function()
                            safeNotify(endNotificationMessage)
                            endedConn:Disconnect()
                        end)
                        table.insert(connections, endedConn)
                    end
                    break
                end
            end
        end

        local function onKillerAdded(killer)
            local humanoidRootPart = killer:FindFirstChild("HumanoidRootPart") or killer:WaitForChild("HumanoidRootPart", 3)
            if humanoidRootPart then
                setupSoundListener(humanoidRootPart)
            end
        end

        if v then
            local mainConn = workspace.Players.Killers.ChildAdded:Connect(onKillerAdded)
            table.insert(connections, mainConn)
            for _, killer in ipairs(workspace.Players.Killers:GetChildren()) do
                task.spawn(onKillerAdded, killer)
            end
        else
            disconnectAll()
        end
    end
})







Visual:AddToggle("NoliMotorSelect", {
    Text = "1x4大规模监听",
    Default = false,
    Callback = function(v)
        local soundId = "rbxassetid://72296288942160"
        local notificationMessage = "小心大规模"
        local endNotificationMessage = "小心大规模"
        local connections = {}
        local cooldown = 2
        local lastNotifyTime = 0

        local function disconnectAll()
            for _, conn in pairs(connections) do
                conn:Disconnect()
            end
            connections = {}
        end

        local function safeNotify(message)
            local now = os.time()
            if now - lastNotifyTime >= cooldown then
                Library:Notify(message)
                lastNotifyTime = now
            end
        end

        local function setupSoundListener(humanoidRootPart)
            local function onChildAdded(child)
                if child:IsA("Sound") and child.SoundId == soundId then
                    safeNotify(notificationMessage)
                    local endedConn = child.Ended:Connect(function()
                        safeNotify(endNotificationMessage)
                        endedConn:Disconnect()
                    end)
                    table.insert(connections, endedConn)
                end
            end

            local conn = humanoidRootPart.ChildAdded:Connect(onChildAdded)
            table.insert(connections, conn)

            for _, child in ipairs(humanoidRootPart:GetChildren()) do
                if child:IsA("Sound") and child.SoundId == soundId then
                    safeNotify(notificationMessage)
                    if child.IsPlaying then
                        local endedConn = child.Ended:Connect(function()
                            safeNotify(endNotificationMessage)
                            endedConn:Disconnect()
                        end)
                        table.insert(connections, endedConn)
                    end
                    break
                end
            end
        end

        local function onKillerAdded(killer)
            local humanoidRootPart = killer:FindFirstChild("HumanoidRootPart") or killer:WaitForChild("HumanoidRootPart", 3)
            if humanoidRootPart then
                setupSoundListener(humanoidRootPart)
            end
        end

        if v then
            local mainConn = workspace.Players.Killers.ChildAdded:Connect(onKillerAdded)
            table.insert(connections, mainConn)
            for _, killer in ipairs(workspace.Players.Killers:GetChildren()) do
                task.spawn(onKillerAdded, killer)
            end
        else
            disconnectAll()
        end
    end
})




local Visual = Tabs.tzq:AddRightGroupbox('其他监听')


Visual:AddToggle('杀手通知', {
    Text = '杀手进入提示',
    Default = false,
    Tooltip = '当杀手进入游戏时显示通知',
    
    Callback = function(state)
        if state then
            NotifyKillers = workspace.Players.Killers.DescendantAdded:Connect(function(v)
                if v.Parent.Name == "Killers" then
                    Window:Notify({
                        Title = "NOL | 警告",
                        Desc = v.Name .. " 是杀手",
                        Time = 3
                    })
                end
            end)
        elseif NotifyKillers then
            NotifyKillers:Disconnect()
            NotifyKillers = nil
        end
    end
})



Visual:AddToggle("NST",{
Text = "三角炸弹生成提示",
Default = false,
Callback = function(v)
if v then
NotifySubspaceTripmine = workspace.Map.Ingame.DescendantAdded:Connect(function(v)
if v.Name == "塔夫三角炸弹" then
Library:Notify("BETA TEST | Warning\nBlock '三角炸弹已生成！")
end
end)
else
NotifySubspaceTripmine:Disconnect()
end
end})
Visual:AddToggle("NEK",{
Text = "实体生成提示",
Default = false,
Callback = function(v)
if v then
NotifyEntityKillers = workspace.DescendantAdded:Connect(function(v)
if v:IsA("Model") and v.Name == "PizzaDeliveryRig" or v.Name == "Bunny" or v.Name == "Mafiaso1" or v.Name == "Mafiaso2" or v.Name == "Mafiaso3" then
Library:Notify("BETA TEST | Warning\nEntity '" .. v.Name .. "' 生成了！")
elseif v:IsA("Model") and v.Name == "1x1x1x1Zombie" then
Library:Notify("BETA TEST | Warning\nEntity '1x1x1x1 (僵尸)' 生成了！")
end
end)
else
NotifyEntityKillers:Disconnect()
end
end})

local Player = Tabs.Max:AddLeftGroupbox("动作功能")


Player:AddToggle("SillyBillyToggle", {
    Text = "Silly Billy",
    Default = false,
    Tooltip = "播放Silly Billy表情动作",
    Callback = function(state)
        local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        local humanoid = char:WaitForChild("Humanoid")
        local rootPart = char:WaitForChild("HumanoidRootPart")
        
        if state then
            -- 激活状态
            humanoid.PlatformStand = true
            humanoid.JumpPower = 0
            
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            bodyVelocity.Velocity = Vector3.zero
            bodyVelocity.Parent = rootPart
            
            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://107464355830477"
            local animationTrack = humanoid:LoadAnimation(animation)
            animationTrack:Play()
            
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://77601084987544"
            sound.Parent = rootPart
            sound.Volume = 0.5
            sound.Looped = false
            sound:Play()
            
            animationTrack.Stopped:Connect(function()
                humanoid.PlatformStand = false
                if bodyVelocity and bodyVelocity.Parent then
                    bodyVelocity:Destroy()
                end
                
                for _, assetName in ipairs({"EmoteHatAsset", "EmoteLighting", "PlayerEmoteHand"}) do
                    local asset = char:FindFirstChild(assetName)
                    if asset then asset:Destroy() end
                end
            end)
        else
            -- 关闭状态
            humanoid.PlatformStand = false
            humanoid.JumpPower = 0
            
            for _, assetName in ipairs({"EmoteHatAsset", "EmoteLighting", "PlayerEmoteHand"}) do
                local asset = char:FindFirstChild(assetName)
                if asset then asset:Destroy() end
            end
            
            local bodyVelocity = rootPart:FindFirstChildOfClass("BodyVelocity")
            if bodyVelocity then bodyVelocity:Destroy() end
            
            local sound = rootPart:FindFirstChildOfClass("Sound")
            if sound then
                sound:Stop()
                sound:Destroy()
            end
            
            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                if track.Animation.AnimationId == "rbxassetid://107464355830477" then
                    track:Stop()
                end
            end
        end
    end
})

-- Silly of it 动作按钮
Player:AddToggle("SillyOfItToggle", {
    Text = "Silly of it",
    Default = false,
    Tooltip = "播放Silly of it表情动作",
    Callback = function(state)
        local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        local humanoid = char:WaitForChild("Humanoid")
        local rootPart = char:WaitForChild("HumanoidRootPart")
        
        if state then
            -- 激活状态（完整实现，与原始函数相同）
            humanoid.PlatformStand = true
            humanoid.JumpPower = 0
            
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            bodyVelocity.Velocity = Vector3.zero
            bodyVelocity.Parent = rootPart
            
            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://107464355830477"
            local animationTrack = humanoid:LoadAnimation(animation)
            animationTrack:Play()
            
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://120176009143091"
            sound.Parent = rootPart
            sound.Volume = 0.5
            sound.Looped = false
            sound:Play()
            
            animationTrack.Stopped:Connect(function()
                humanoid.PlatformStand = false
                if bodyVelocity and bodyVelocity.Parent then
                    bodyVelocity:Destroy()
                end
                
                for _, assetName in ipairs({"EmoteHatAsset", "EmoteLighting", "PlayerEmoteHand"}) do
                    local asset = char:FindFirstChild(assetName)
                    if asset then asset:Destroy() end
                end
            end)
        else
            -- 关闭状态（完整实现）
            humanoid.PlatformStand = false
            humanoid.JumpPower = 0
            
            for _, assetName in ipairs({"EmoteHatAsset", "EmoteLighting", "PlayerEmoteHand"}) do
                local asset = char:FindFirstChild(assetName)
                if asset then asset:Destroy() end
            end
            
            local bodyVelocity = rootPart:FindFirstChildOfClass("BodyVelocity")
            if bodyVelocity then bodyVelocity:Destroy() end
            
            local sound = rootPart:FindFirstChildOfClass("Sound")
            if sound then
                sound:Stop()
                sound:Destroy()
            end
            
            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                if track.Animation.AnimationId == "rbxassetid://107464355830477" then
                    track:Stop()
                end
            end
        end
    end
})

-- Subterfuge 动作按钮
Player:AddToggle("SubterfugeToggle", {
    Text = "Subterfuge",
    Default = false,
    Tooltip = "播放Subterfuge表情动作",
    Callback = function(state)
        local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        local humanoid = char:WaitForChild("Humanoid")
        local rootPart = char:WaitForChild("HumanoidRootPart")
        
        if state then
            -- 激活状态（完整实现）
            humanoid.PlatformStand = true
            humanoid.JumpPower = 0
            
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            bodyVelocity.Velocity = Vector3.zero
            bodyVelocity.Parent = rootPart
            
            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://87482480949358"
            local animationTrack = humanoid:LoadAnimation(animation)
            animationTrack:Play()
            
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://132297506693854"
            sound.Parent = rootPart
            sound.Volume = 2
            sound.Looped = false
            sound:Play()
            
            local args = {
                [1] = "PlayEmote",
                [2] = "Animations",
                [3] = "_Subterfuge"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
            
            animationTrack.Stopped:Connect(function()
                humanoid.PlatformStand = false
                if bodyVelocity and bodyVelocity.Parent then
                    bodyVelocity:Destroy()
                end
            end)
        else
            -- 关闭状态（完整实现）
            humanoid.PlatformStand = false
            humanoid.JumpPower = 0
            
            local bodyVelocity = rootPart:FindFirstChildOfClass("BodyVelocity")
            if bodyVelocity then bodyVelocity:Destroy() end
            
            local sound = rootPart:FindFirstChildOfClass("Sound")
            if sound then
                sound:Stop()
                sound:Destroy()
            end
            
            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                if track.Animation.AnimationId == "rbxassetid://87482480949358" then
                    track:Stop()
                end
            end
        end
    end
})

-- Aw Shucks 动作按钮
Player:AddToggle("AwShucksToggle", {
    Text = "Aw Shucks",
    Default = false,
    Tooltip = "播放Aw Shucks表情动作",
    Callback = function(state)
        local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        local humanoid = char:WaitForChild("Humanoid")
        local rootPart = char:WaitForChild("HumanoidRootPart")
        
        if state then
            -- 激活状态（完整实现）
            humanoid.PlatformStand = true
            humanoid.JumpPower = 0
            
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            bodyVelocity.Velocity = Vector3.zero
            bodyVelocity.Parent = rootPart
            
            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://74238051754912"
            local animationTrack = humanoid:LoadAnimation(animation)
            animationTrack:Play()
            
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://123236721947419"
            sound.Parent = rootPart
            sound.Volume = 0.5
            sound.Looped = false
            sound:Play()
            
            local args = {
                [1] = "PlayEmote",
                [2] = "Animations",
                [3] = "Shucks"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
            
            animationTrack.Stopped:Connect(function()
                humanoid.PlatformStand = false
                if bodyVelocity and bodyVelocity.Parent then
                    bodyVelocity:Destroy()
                end
            end)
        else
            -- 关闭状态（完整实现）
            humanoid.PlatformStand = false
            humanoid.JumpPower = 0
            
            local bodyVelocity = rootPart:FindFirstChildOfClass("BodyVelocity")
            if bodyVelocity then bodyVelocity:Destroy() end
            
            local sound = rootPart:FindFirstChildOfClass("Sound")
            if sound then
                sound:Stop()
                sound:Destroy()
            end
            
            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                if track.Animation.AnimationId == "rbxassetid://74238051754912" then
                    track:Stop()
                end
            end
        end
    end
})

-- Miss The Quiet 动作按钮
Player:AddToggle("MissTheQuietToggle", {
    Text = "Miss The Quiet",
    Default = false,
    Tooltip = "播放Miss The Quiet表情动作",
    Callback = function(state)
        local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        local humanoid = char:WaitForChild("Humanoid")
        local rootPart = char:WaitForChild("HumanoidRootPart")
        
        if state then
            -- 激活状态（完整实现）
            humanoid.PlatformStand = true
            humanoid.JumpPower = 0
            
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            bodyVelocity.Velocity = Vector3.zero
            bodyVelocity.Parent = rootPart
            
            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://100986631322204"
            local animationTrack = humanoid:LoadAnimation(animation)
            animationTrack:Play()
            
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://131936418953291"
            sound.Parent = rootPart
            sound.Volume = 0.5
            sound.Looped = false
            sound:Play()
            
            animationTrack.Stopped:Connect(function()
                humanoid.PlatformStand = false
                if bodyVelocity and bodyVelocity.Parent then
                    bodyVelocity:Destroy()
                end
                
                for _, assetName in ipairs({"EmoteHatAsset", "EmoteLighting", "PlayerEmoteHand"}) do
                    local asset = char:FindFirstChild(assetName)
                    if asset then asset:Destroy() end
                end
            end)
        else
            -- 关闭状态（完整实现）
            humanoid.PlatformStand = false
            humanoid.JumpPower = 0
            
            for _, assetName in ipairs({"EmoteHatAsset", "EmoteLighting", "PlayerEmoteHand"}) do
                local asset = char:FindFirstChild(assetName)
                if asset then asset:Destroy() end
            end
            
            local bodyVelocity = rootPart:FindFirstChildOfClass("BodyVelocity")
            if bodyVelocity then bodyVelocity:Destroy() end
            
            local sound = rootPart:FindFirstChildOfClass("Sound")
            if sound then
                sound:Stop()
                sound:Destroy()
            end
            
            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                if track.Animation.AnimationId == "rbxassetid://100986631322204" then
                    track:Stop()
                end
            end
        end
    end
})



local Player = Tabs.Max:AddRightGroupbox('VIP舞蹈')




Player:AddToggle("VIPToggleNew", {
    Text = "VIP (新音频)",
    Default = false,
    Tooltip = "播放VIP表情动作（新版音频）",
    Callback = function(state)
        local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        local humanoid = char:WaitForChild("Humanoid")
        local rootPart = char:WaitForChild("HumanoidRootPart")
        
        if state then
            -- 激活状态（完整实现）
            humanoid.PlatformStand = true
            humanoid.JumpPower = 0
            
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            bodyVelocity.Velocity = Vector3.zero
            bodyVelocity.Parent = rootPart
            
            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://138019937280193"
            local animationTrack = humanoid:LoadAnimation(animation)
            animationTrack:Play()
            
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://109474987384441"
            sound.Parent = rootPart
            sound.Volume = 0.5
            sound.Looped = true
            sound:Play()
            
            local effect = game:GetService("ReplicatedStorage").Assets.Emotes.HakariDance.HakariBeamEffect:Clone()
            effect.Name = "PlayerEmoteVFX"
            effect.CFrame = char.PrimaryPart.CFrame * CFrame.new(0, -1, -0.3)
            effect.WeldConstraint.Part0 = char.PrimaryPart
            effect.WeldConstraint.Part1 = effect
            effect.Parent = char
            effect.CanCollide = false
            
            local args = {
                [1] = "PlayEmote",
                [2] = "Animations",
                [3] = "HakariDance"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
            
            animationTrack.Stopped:Connect(function()
                humanoid.PlatformStand = false
                if bodyVelocity and bodyVelocity.Parent then
                    bodyVelocity:Destroy()
                end
            end)
        else
            -- 关闭状态（完整实现）
            humanoid.PlatformStand = false
            humanoid.JumpPower = 0
            
            local bodyVelocity = rootPart:FindFirstChildOfClass("BodyVelocity")
            if bodyVelocity then bodyVelocity:Destroy() end
            
            local sound = rootPart:FindFirstChildOfClass("Sound")
            if sound then
                sound:Stop()
                sound:Destroy()
            end
            
            local effect = char:FindFirstChild("PlayerEmoteVFX")
            if effect then effect:Destroy() end
            
            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                if track.Animation.AnimationId == "rbxassetid://138019937280193" then
                    track:Stop()
                end
            end
        end
    end
})

-- VIP动作（旧音频）按钮
Player:AddToggle("VIPToggleOld", {
    Text = "VIP (旧音频)",
    Default = false,
    Tooltip = "播放VIP表情动作（旧版音频）",
    Callback = function(state)
        local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        local humanoid = char:WaitForChild("Humanoid")
        local rootPart = char:WaitForChild("HumanoidRootPart")
        
        if state then
            -- 激活状态（完整实现）
            humanoid.PlatformStand = true
            humanoid.JumpPower = 0
            
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            bodyVelocity.Velocity = Vector3.zero
            bodyVelocity.Parent = rootPart
            
            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://138019937280193"
            local animationTrack = humanoid:LoadAnimation(animation)
            animationTrack:Play()
            
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://87166578676888"
            sound.Parent = rootPart
            sound.Volume = 0.5
            sound.Looped = true
            sound:Play()
            
            local effect = game:GetService("ReplicatedStorage").Assets.Emotes.HakariDance.HakariBeamEffect:Clone()
            effect.Name = "PlayerEmoteVFX"
            effect.CFrame = char.PrimaryPart.CFrame * CFrame.new(0, -1, -0.3)
            effect.WeldConstraint.Part0 = char.PrimaryPart
            effect.WeldConstraint.Part1 = effect
            effect.Parent = char
            effect.CanCollide = false
            
            local args = {
                [1] = "PlayEmote",
                [2] = "Animations",
                [3] = "HakariDance"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
            
            animationTrack.Stopped:Connect(function()
                humanoid.PlatformStand = false
                if bodyVelocity and bodyVelocity.Parent then
                    bodyVelocity:Destroy()
                end
            end)
        else
            -- 关闭状态（完整实现）
            humanoid.PlatformStand = false
            humanoid.JumpPower = 0
            
            local bodyVelocity = rootPart:FindFirstChildOfClass("BodyVelocity")
            if bodyVelocity then bodyVelocity:Destroy() end
            
            local sound = rootPart:FindFirstChildOfClass("Sound")
            if sound then
                sound:Stop()
                sound:Destroy()
            end
            
            local effect = char:FindFirstChild("PlayerEmoteVFX")
            if effect then effect:Destroy() end
            
            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                if track.Animation.AnimationId == "rbxassetid://138019937280193" then
                    track:Stop()
                end
            end
        end
    end
})



local ZZ = Tabs.ani:AddLeftGroupbox('Noli反效果')


local RunService = game:GetService("RunService")
local Players = game:GetService("Players")


local noliDeleterActive = false
local deletionConnection = nil
local allowedNoli = nil


local function deleteNewNoli()
    local killersFolder = workspace:WaitForChild("Players")
    local killers = killersFolder:WaitForChild("Killers")
    
   
    allowedNoli = killers:FindFirstChild("Noli")
    
   
    deletionConnection = RunService.Heartbeat:Connect(function()
        for _, child in ipairs(killers:GetChildren()) do
            if child.Name == "Noli" and child ~= allowedNoli then
                child:Destroy()
                print("✅ 已删除新Noli: "..child:GetFullName())
            end
        end
    end)
end


ZZ:AddToggle("NoliDeleter", {
    Text = "反假Noli",
    Default = false,
    Callback = function(enabled)
        noliDeleterActive = enabled
        
        if enabled then
          
            local success, err = pcall(function()
                deleteNewNoli()
            end)
            
            if success then
                print("🟢 Noli清理器已激活 | 白名单: "..(allowedNoli and allowedNoli:GetFullName() or "无"))
            else
                warn("❌ 初始化失败: "..tostring(err))
                noliDeleterActive = false
            end
        else
         
            if deletionConnection then
                deletionConnection:Disconnect()
                deletionConnection = nil
            end
            print("🔴 Noli清理器已停用")
        end
    end
})




local player = game:GetService("Players").LocalPlayer
local isVoidRushCrashed = false
local characterCheckLoop = nil

local function manageVoidRushState(character)
    while isVoidRushCrashed and character and character.Parent do
        character:SetAttribute("VoidRushState", "Crashed")
        task.wait(0.5)  
    end
end

ZZ:AddToggle("無視障礙[Noli]", {
    Text = "Noli冲刺无视障碍",
    Default = false,
    Callback = function(enabled)
        isVoidRushCrashed = enabled
        local character = player.Character or player.CharacterAdded:Wait()
        
        if enabled then
            if characterCheckLoop then task.cancel(characterCheckLoop) end
            characterCheckLoop = task.spawn(function()
                manageVoidRushState(character)
            end)
            print("✅ 崩溃状态持续生效中...")
        else
            if characterCheckLoop then
                task.cancel(characterCheckLoop)
                characterCheckLoop = nil
            end
            character:SetAttribute("VoidRushState", nil)
            print("✅ 已恢复正常状态")
        end
    end
})

player.CharacterAdded:Connect(function(newCharacter)
    if isVoidRushCrashed then
        if characterCheckLoop then task.cancel(characterCheckLoop) end
        characterCheckLoop = task.spawn(function()
            manageVoidRushState(newCharacter)
        end)
    end
end)





ZZ:AddToggle("VoidRushOverride", {
    Text = "Noli衝刺優化[需要鎖定視角]",
    Default = false,
    Callback = function(enabled)
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        
        local Character
        local Humanoid
        local HumanoidRootPart
        local monitorTask
        local overrideConnection
        local characterAddedConnection
        
        local ORIGINAL_DASH_SPEED = 60
        local DEFAULT_WALK_SPEED = 16
        
        local function setupCharacter()
            if LocalPlayer.Character then
                Character = LocalPlayer.Character
                Humanoid = Character:WaitForChild("Humanoid")
                HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
                Humanoid.WalkSpeed = DEFAULT_WALK_SPEED
                Humanoid.AutoRotate = true
            end
        end
        
        local function startOverride()
            if overrideConnection then return end
            
            overrideConnection = RunService.RenderStepped:Connect(function()
                if not Character or not Humanoid or not HumanoidRootPart then
                    return
                end
                
                Humanoid.WalkSpeed = ORIGINAL_DASH_SPEED
                Humanoid.AutoRotate = false
                
                local direction = HumanoidRootPart.CFrame.LookVector
                local horizontalDirection = Vector3.new(direction.X, 0, direction.Z).Unit
                Humanoid:Move(horizontalDirection)
            end)
        end
        
        local function stopOverride()
            if overrideConnection then
                overrideConnection:Disconnect()
                overrideConnection = nil
            end
            
            if Humanoid then
                Humanoid.WalkSpeed = DEFAULT_WALK_SPEED
                Humanoid.AutoRotate = true
                Humanoid:Move(Vector3.new(0, 0, 0))
            end
        end
        
        local function monitorVoidRush()
            while enabled and task.wait() do
                if not Character or not Humanoid or not HumanoidRootPart then
                    setupCharacter()
                    if not Character then continue end
                end
                
                local voidRushState = Character:GetAttribute("VoidRushState")
                if voidRushState == "Dashing" then
                    startOverride()
                else
                    stopOverride()
                end
            end
            stopOverride()
        end
        
        local function cleanup()
            if monitorTask then
                task.cancel(monitorTask)
                monitorTask = nil
            end
            
            if characterAddedConnection then
                characterAddedConnection:Disconnect()
                characterAddedConnection = nil
            end
            
            stopOverride()
            setupCharacter()
        end
        
        if enabled then
            cleanup()
            setupCharacter()
            monitorTask = task.spawn(monitorVoidRush)
            
            characterAddedConnection = LocalPlayer.CharacterAdded:Connect(function(newChar)
                Character = newChar
                Humanoid = Character:WaitForChild("Humanoid")
                HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
                if not enabled then
                    Humanoid.WalkSpeed = DEFAULT_WALK_SPEED
                    Humanoid.AutoRotate = true
                end
            end)
        else
            cleanup()
        end
    end
})





local ZZ = Tabs.ani:AddRightGroupbox('1x4反效果')
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local RemoteEvent = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")

local AutoPopup = {
    Enabled = false,
    Task = nil,
    Connections = {},
    Interval = 0.5
}

local function deletePopups()
    if not LocalPlayer or not LocalPlayer:FindFirstChild("PlayerGui") then
        return false
    end
    
    local tempUI = LocalPlayer.PlayerGui:FindFirstChild("TemporaryUI")
    if not tempUI then
        return false
    end
    
    local deleted = false
    for _, popup in ipairs(tempUI:GetChildren()) do
        if popup.Name == "1x1x1x1Popup" then
            popup:Destroy()
            deleted = true
        end
    end
    return deleted
end

local function triggerEntangled()
    local args = { [1] = "Entangled" }
    pcall(function()
        RemoteEvent:FireServer(unpack(args))
    end)
end

local function setupPopupListener()
    if not LocalPlayer or not LocalPlayer:FindFirstChild("PlayerGui") then return end
    
    local tempUI = LocalPlayer.PlayerGui:FindFirstChild("TemporaryUI")
    if not tempUI then
        tempUI = Instance.new("Folder")
        tempUI.Name = "TemporaryUI"
        tempUI.Parent = LocalPlayer.PlayerGui
    end
    
    if AutoPopup.Connections.ChildAdded then
        AutoPopup.Connections.ChildAdded:Disconnect()
    end
    
    AutoPopup.Connections.ChildAdded = tempUI.ChildAdded:Connect(function(child)
        if AutoPopup.Enabled and child.Name == "1x1x1x1Popup" then
            task.defer(function()
                child:Destroy()
            end)
        end
    end)
end

local function runMainTask()
    while AutoPopup.Enabled do
        deletePopups()
        triggerEntangled()
        task.wait(AutoPopup.Interval) -- 使用设置的间隔时间
    end
end

local function startAutoPopup()
    if AutoPopup.Enabled then return end
    
    AutoPopup.Enabled = true
    setupPopupListener()
    
    if AutoPopup.Task then
        task.cancel(AutoPopup.Task)
    end
    AutoPopup.Task = task.spawn(runMainTask)
end

local function stopAutoPopup()
    if not AutoPopup.Enabled then return end
    
    AutoPopup.Enabled = false
    
    if AutoPopup.Task then
        task.cancel(AutoPopup.Task)
        AutoPopup.Task = nil
    end
    
    for _, connection in pairs(AutoPopup.Connections) do
        connection:Disconnect()
    end
    AutoPopup.Connections = {}
end

-- 添加间隔时间调整滑块
ZZ:AddSlider('AutoPopupInterval', {
    Text = '执行间隔(秒)',
    Default = 0.5,
    Min = 0.5,
    Max = 2,
    Rounding = 0,
    Tooltip = '设置自动执行的间隔时间(1-5秒)',
    Callback = function(value)
        AutoPopup.Interval = value
    end
})

ZZ:AddToggle('AutoPopupToggle', {
    Text = '反1x4弹窗(反懒惰效果)',
    Default = false,
    Tooltip = '去除弹窗和懒惰效果',
    Callback = function(state)
        if state then
            startAutoPopup()
        else
            stopAutoPopup()
        end
    end
})

if LocalPlayer then
    LocalPlayer:GetPropertyChangedSignal("Parent"):Connect(function()
        if not LocalPlayer.Parent then
            stopAutoPopup()
        end
    end)
end



ZZ:AddToggle("RemoveUnstableEye", {
    Text = "反不稳定之眼不能移动", 
    Default = false,
    Callback = function(v)
        if not _G.UnstableEyeCleanup then _G.UnstableEyeCleanup = {} end
        local connections = _G.UnstableEyeCleanup

        -- 先清理现有的连接
        for _, conn in pairs(connections) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            end
        end
        _G.UnstableEyeCleanup = {}

        -- 如果关闭按钮，直接返回
        if not v then return end

        local function CleanUnstableEyeEffects()
            local killersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
            if not killersFolder then return end
            
            for _, killer in ipairs(killersFolder:GetDescendants()) do
                if killer.Name == "UnstableEye" then
                    killer:Destroy()
                end
            end
        end

        -- 初始清理
        task.spawn(CleanUnstableEyeEffects)

        -- 设置定期清理
        connections.heartbeat = game:GetService("RunService").Heartbeat:Connect(function()
            task.wait(1.5)
            CleanUnstableEyeEffects()
        end)

        -- 设置新对象添加时的监听
        local killersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
        if killersFolder then
            connections.descendantAdded = killersFolder.DescendantAdded:Connect(function(descendant)
                if descendant.Name == "UnstableEye" then
                    descendant:Destroy()
                end
            end)
        end
    end
})

ZZ:AddToggle("RemoveBlindness", {
    Text = "反失明效果", 
    Default = false,
    Callback = function(v)
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        
        -- 获取 Modules.StatusEffects 路径
        local modulesFolder = ReplicatedStorage:FindFirstChild("Modules")
        local statusEffects = modulesFolder and modulesFolder:FindFirstChild("StatusEffects")
        
        if v then
            -- 确保路径存在
            if not statusEffects then
                warn("未找到 ReplicatedStorage.Modules.StatusEffects 路径")
                return
            end
            
            -- 查找并删除 Blindness 模块
            local blindness = statusEffects:FindFirstChild("Blindness")
            if blindness then
                blindness:Destroy()
                print("已删除 Blindness 模块")
            else
                print("未找到 Blindness 模块")
            end
            
            -- 设置持续检查
            if not _G.BlindnessCleanup then _G.BlindnessCleanup = {} end
            local connections = _G.BlindnessCleanup
            
            -- 定期检查
            connections.heartbeat = game:GetService("RunService").Heartbeat:Connect(function()
                task.wait(1.5)
                local blindness = statusEffects:FindFirstChild("Blindness")
                if blindness then
                    blindness:Destroy()
                end
            end)
            
            -- 监听新增模块
            connections.descendantAdded = statusEffects.DescendantAdded:Connect(function(descendant)
                if descendant.Name == "Blindness" then
                    task.wait(0.1) -- 确保模块完全加载
                    descendant:Destroy()
                end
            end)
        else
            -- 关闭时清理连接
            if _G.BlindnessCleanup then
                for _, conn in pairs(_G.BlindnessCleanup) do
                    conn:Disconnect()
                end
                _G.BlindnessCleanup = {}
            end
        end
    end
})

local ZZ = Tabs.ani:AddRightGroupbox('谢德反效果')

ZZ:AddToggle("RemoveStunningKiller", {
    Text = "反谢德出剑缓慢移速", 
    Default = false,
    Callback = function(v)
        -- 初始化全局变量
        if not _G.StunningKillerCleanup then _G.StunningKillerCleanup = {} end
        local connections = _G.StunningKillerCleanup

        -- 关闭时清理所有连接
        for _, conn in pairs(connections) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            end
        end
        _G.StunningKillerCleanup = {}

        -- 如果关闭按钮，直接返回
        if not v then return end

        local function CleanStunningKillers()
            local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
            if not survivorsFolder then return end
            
            local survivorList = survivorsFolder:GetChildren()
            for i = 1, #survivorList, 5 do
                task.spawn(function()
                    for j = i, math.min(i + 4, #survivorList) do
                        local survivor = survivorList[j]
                        local stunningKiller = survivor:FindFirstChild("StunningKiller")
                        if stunningKiller then
                            stunningKiller:Destroy()
                        end
                    end
                end)
            end
        end

        -- 初始清理
        task.spawn(CleanStunningKillers)

        -- 设置定期清理
        connections.heartbeat = game:GetService("RunService").Heartbeat:Connect(function()
            task.wait(2)
            CleanStunningKillers()
        end)

        -- 设置新对象添加时的监听
        local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
        if survivorsFolder then
            connections.descendantAdded = survivorsFolder.DescendantAdded:Connect(function(descendant)
                if descendant.Name == "StunningKiller" then
                    descendant:Destroy()
                end
            end)
        end
    end
})


local ZZ = Tabs.ani:AddRightGroupbox('Noob反效果')

ZZ:AddToggle("RemoveSlateskin", {
    Text = "反Noob石板皮肤缓慢效果", 
    Default = false,
    Callback = function(v)
        if SlateskinCleanupConnection then
            SlateskinCleanupConnection:Disconnect()
            SlateskinCleanupConnection = nil
            table.clear(slateskinCache)
        end

        if v then
            local function CleanSlateskins()
                local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
                if not survivorsFolder then return end
                
                local survivorList = survivorsFolder:GetChildren()
                for i = 1, #survivorList, 5 do
                    task.spawn(function()
                        for j = i, math.min(i + 4, #survivorList) do
                            local survivor = survivorList[j]
                            local slateskin = survivor:FindFirstChild("SlateskinStatus")
                            if slateskin then
                                slateskin:Destroy()
                            end
                        end
                    end)
                end
            end

            task.spawn(CleanSlateskins)

            SlateskinCleanupConnection = game:GetService("RunService").Heartbeat:Connect(function()
                task.wait(2)
                CleanSlateskins()
            end)

            local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
            if survivorsFolder then
                survivorsFolder.DescendantAdded:Connect(function(descendant)
                    if descendant.Name == "SlateskinStatus" then
                        descendant:Destroy()
                    end
                end)
            end
        end
    end
})




local Disabled = Tabs.ani:AddLeftGroupbox('访客反效果')
-- 1. 反访客冲刺没有击中都缓慢
Disabled:AddToggle("RemoveSlowed", {
    Text = "反访客冲刺没有击中都缓慢", 
    Default = false,
    Callback = function(v)
        -- 修复点：使用局部变量保存连接
        if not _G.SlowedCleanup then _G.SlowedCleanup = {} end
        local connections = _G.SlowedCleanup

        -- 关闭时断开所有连接
        if not v then
            for _, conn in pairs(connections) do
                conn:Disconnect()
            end
            _G.SlowedCleanup = {}
            return
        end

        -- 修复点：显式保存 DescendantAdded 事件
        local function CleanSlowedStatuses()
            local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
            if not survivorsFolder then return end
            
            for _, survivor in ipairs(survivorsFolder:GetDescendants()) do
                if survivor.Name == "SlowedStatus" then
                    survivor:Destroy()
                end
            end
        end

        task.spawn(CleanSlowedStatuses)

        -- 保存心跳连接
        connections.heartbeat = game:GetService("RunService").Heartbeat:Connect(function()
            task.wait(1.5)
            CleanSlowedStatuses()
        end)

        -- 保存新增监听
        local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
        if survivorsFolder then
            connections.descendantAdded = survivorsFolder.DescendantAdded:Connect(function(descendant)
                if descendant.Name == "SlowedStatus" then
                    descendant:Destroy()
                end
            end)
        end
    end
})

-- 2. 反访客格挡时移速问题 (独立变量名)
Disabled:AddToggle("RemoveBlockingSlow", {
    Text = "反访客格挡时移速问题", 
    Default = false,
    Callback = function(v)
        if not _G.BlockingCleanup then _G.BlockingCleanup = {} end
        local connections = _G.BlockingCleanup

        if not v then
            for _, conn in pairs(connections) do
                conn:Disconnect()
            end
            _G.BlockingCleanup = {}
            return
        end

        local function CleanStatuses()
            local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
            if not survivorsFolder then return end
            
            for _, survivor in ipairs(survivorsFolder:GetDescendants()) do
                if survivor.Name == "ResistanceStatus" or survivor.Name == "GuestBlocking" then
                    survivor:Destroy()
                end
            end
        end

        task.spawn(CleanStatuses)

        connections.heartbeat = game:GetService("RunService").Heartbeat:Connect(function()
            task.wait(1.5)
            CleanStatuses()
        end)

        local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
        if survivorsFolder then
            connections.descendantAdded = survivorsFolder.DescendantAdded:Connect(function(descendant)
                if descendant.Name == "ResistanceStatus" or descendant.Name == "GuestBlocking" then
                    descendant:Destroy()
                end
            end)
        end
    end
})

-- 3. 反访客拳击时移速问题 (独立变量名)
Disabled:AddToggle("RemovePunchSlow", {
    Text = "反访客拳击时移速问题", 
    Default = false,
    Callback = function(v)
        if not _G.PunchCleanup then _G.PunchCleanup = {} end
        local connections = _G.PunchCleanup

        if not v then
            for _, conn in pairs(connections) do
                conn:Disconnect()
            end
            _G.PunchCleanup = {}
            return
        end

        local function CleanStatuses()
            local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
            if not survivorsFolder then return end
            
            for _, survivor in ipairs(survivorsFolder:GetDescendants()) do
                if survivor.Name == "ResistanceStatus" or survivor.Name == "PunchAbility" then
                    survivor:Destroy()
                end
            end
        end

        task.spawn(CleanStatuses)

        connections.heartbeat = game:GetService("RunService").Heartbeat:Connect(function()
            task.wait(1.5)
            CleanStatuses()
        end)

        local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
        if survivorsFolder then
            connections.descendantAdded = survivorsFolder.DescendantAdded:Connect(function(descendant)
                if descendant.Name == "ResistanceStatus" or descendant.Name == "PunchAbility" then
                    descendant:Destroy()
                end
            end)
        end
    end
})



-- 5. 反访客冲刺结束效果
Disabled:AddToggle("RemoveChargeEnded", {
    Text = "反访客冲刺结束效果", 
    Default = false,
    Callback = function(v)
        if not _G.ChargeEndedCleanup then _G.ChargeEndedCleanup = {} end
        local connections = _G.ChargeEndedCleanup

        if not v then
            for _, conn in pairs(connections) do
                conn:Disconnect()
            end
            _G.ChargeEndedCleanup = {}
            return
        end

        local function CleanChargeEndedEffects()
            local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
            if not survivorsFolder then return end
            
            for _, survivor in ipairs(survivorsFolder:GetDescendants()) do
                if survivor.Name == "GuestChargeEnded" then
                    survivor:Destroy()
                end
            end
        end

        task.spawn(CleanChargeEndedEffects)

        connections.heartbeat = game:GetService("RunService").Heartbeat:Connect(function()
            task.wait(1.5)
            CleanChargeEndedEffects()
        end)

        local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
        if survivorsFolder then
            connections.descendantAdded = survivorsFolder.DescendantAdded:Connect(function(descendant)
                if descendant.Name == "GuestChargeEnded" then
                    descendant:Destroy()
                end
            end)
        end
    end
})





local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 创建一个体力功能组
local MVP = Tabs.Sat:AddLeftGroupbox("体力功能")

-- 体力系统设置
local StaminaSettings = {
    MaxStamina = 100,      -- 最大体力值
    StaminaGain = 25,      -- 体力恢复速度
    StaminaLoss = 10,      -- 体力消耗速度
    SprintSpeed = 28,      -- 奔跑速度
    InfiniteGain = 9999    -- 无限体力恢复速度
}

-- 体力控制开关
local SettingToggles = {
    MaxStamina = true,
    StaminaGain = true,
    StaminaLoss = true,
    SprintSpeed = true
}

-- 获取游戏体力模块
local SprintingModule = ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Character"):WaitForChild("Game"):WaitForChild("Sprinting")
local GetModule = function() return require(SprintingModule) end

-- 实时更新体力设置
task.spawn(function()
    while true do
        local m = GetModule()
        for key, value in pairs(StaminaSettings) do
            if SettingToggles[key] then
                m[key] = value
            end
        end
        task.wait(0.5)
    end
end)

-- 无限体力功能
local bai = {Spr = false}
local connection

MVP:AddToggle('MyToggle', {
    Text = '无限体力',
    Default = false,
    Tooltip = '体力',
    Callback = function(state)
        bai.Spr = state
        local Sprinting = GetModule()

        if state then
            Sprinting.StaminaLoss = 0
            Sprinting.StaminaGain = StaminaSettings.InfiniteGain or 9999

            if connection then connection:Disconnect() end
            connection = RunService.Heartbeat:Connect(function()
                if not bai.Spr then return end
                Sprinting.StaminaLoss = 0
                Sprinting.StaminaGain = StaminaSettings.InfiniteGain or 9999
            end)
        else
            Sprinting.StaminaLoss = StaminaSettings.StaminaLoss or 10
            Sprinting.StaminaGain = StaminaSettings.StaminaGain or 25

            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end
})

MVP:AddToggle('MaxStaminaToggle', {
    Text = '启用体力大小调节',
    Default = true,
    Callback = function(Value)
        SettingToggles.MaxStamina = Value
    end
})


MVP:AddToggle('StaminaGainToggle', {
    Text = '启用体力恢复调节',
    Default = true,
    Callback = function(Value)
        SettingToggles.StaminaGain = Value
    end
})

MVP:AddToggle('StaminaLossToggle', {
    Text = '启用体力消耗调节',
    Default = true,
    Callback = function(Value)
        SettingToggles.StaminaLoss = Value
    end
})

MVP:AddToggle('SprintSpeedToggle', {
    Text = '启用奔跑速度调节',
    Default = true,
    Callback = function(Value)
        SettingToggles.SprintSpeed = Value
    end
})







local MVP = Tabs.Sat:AddRightGroupbox("调试区")



MVP:AddSlider('InfStaminaGainSlider', {
    Text = '无限体力恢复速度',
    Default = 9999,
    Min = 0,
    Max = 50000,
    Rounding = 0,
    Callback = function(Value)
        StaminaSettings.InfiniteGain = Value
    end
})


MVP:AddSlider('MySlider1', {
    Text = '体力大小',
    Default = 100,
    Min = 0,
    Max = 99999,
    Rounding = 0,
    Callback = function(Value)
        StaminaSettings.MaxStamina = Value
    end
})


MVP:AddSlider('MySlider2', {
    Text = '体力恢复',
    Default = 25,
    Min = 0,
    Max = 250,
    Rounding = 0,
    Callback = function(Value)
        StaminaSettings.StaminaGain = Value
    end
})


MVP:AddSlider('MySlider3', {
    Text = '体力消耗',
    Default = 10,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        StaminaSettings.StaminaLoss = Value
    end
})


MVP:AddSlider('MySlider4', {
    Text = '奔跑速度',
    Default = 28,
    Min = 0,
    Max = 200,
    Rounding = 0,
    Callback = function(Value)
        StaminaSettings.SprintSpeed = Value
    end
})




local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local PZ = Tabs.lol:AddLeftGroupbox("披萨功能")

local pizzaConnection = nil
local pizzaTPConnection = nil
local pizzaAttractionActive = false
local pizzaCache = {}
local pizzaEffects = {}

local function createPizzaEffect(pizza, effectName)
    if not pizza:FindFirstChild(effectName) then
        local effect = Instance.new("ParticleEmitter")
        effect.Name = effectName
        effect.Texture = "rbxassetid://242487987"
        effect.LightEmission = 0.8
        effect.Size = NumberSequence.new(0.5)
        if effectName == "TeleportEffect" then
            effect.Lifetime = NumberRange.new(0.5)
        end
        effect.Parent = pizza
        pizzaEffects[pizza] = effect
        return effect
    end
    return pizzaEffects[pizza]
end

local function cleanUpEffects()
    for pizza, effect in pairs(pizzaEffects) do
        if not pizza or not pizza.Parent then
            effect:Destroy()
            pizzaEffects[pizza] = nil
        end
    end
end

local function findClosestPizza(rootPart)
    local pizzaFolder = workspace:FindFirstChild("Pizzas") or workspace.Map
    if not pizzaFolder then return nil end
    
    local closestPizza, closestDistance = nil, math.huge
    for _, pizza in ipairs(pizzaFolder:GetDescendants()) do
        if pizza:IsA("BasePart") and pizza.Name == "Pizza" and not pizzaCache[pizza] then
            local distance = (rootPart.Position - pizza.Position).Magnitude
            if distance < closestDistance then
                closestPizza = pizza
                closestDistance = distance
            end
        end
    end
    return closestPizza
end

PZ:AddToggle("AEP", {
    Text = "自动吃披萨(追踪传送)",
    Default = false,
    Tooltip = "当生命值低于设定值时自动吸引附近的披萨",
    Callback = function(enabled)
        _G.AutoEatPizza = enabled
        
        if pizzaConnection then
            pizzaConnection:Disconnect()
            pizzaConnection = nil
        end
        
        if enabled then
            pizzaConnection = RunService.Heartbeat:Connect(function()
                local player = Players.LocalPlayer
                local character = player.Character
                if not character or not character:FindFirstChild("Humanoid") or not character:FindFirstChild("HumanoidRootPart") then
                    return
                end
                
                local humanoid = character.Humanoid
                local rootPart = character.HumanoidRootPart
                
                if _G.HealthEatPizza and humanoid.Health >= _G.HealthEatPizza then
                    return
                end
                
                local closestPizza = findClosestPizza(rootPart)
                if closestPizza then
                    closestPizza.CFrame = closestPizza.CFrame:Lerp(
                        rootPart.CFrame * CFrame.new(0, 0, -2),
                        0.5
                    )
                    createPizzaEffect(closestPizza, "AttractEffect")
                end
                cleanUpEffects()
            end)
        end
    end
})

PZ:AddToggle("ATP", {
    Text = "自动吃披萨(TP)",
    Default = false,
    Tooltip = "当生命值低于设定值时自动将最近的披萨传送到玩家",
    Callback = function(enabled)
        _G.AutoTeleportPizza = enabled
        
        if pizzaTPConnection then
            pizzaTPConnection:Disconnect()
            pizzaTPConnection = nil
        end
        
        if enabled then
            pizzaTPConnection = RunService.Heartbeat:Connect(function()
                local player = Players.LocalPlayer
                local character = player.Character
                if not character or not character:FindFirstChild("Humanoid") or not character:FindFirstChild("HumanoidRootPart") then
                    return
                end
                
                local humanoid = character.Humanoid
                local rootPart = character.HumanoidRootPart
                
                if _G.HealthEatPizza and humanoid.Health >= _G.HealthEatPizza then
                    return
                end
                
                local closestPizza = findClosestPizza(rootPart)
                if closestPizza then
                    closestPizza.CFrame = rootPart.CFrame * CFrame.new(0, 0, -2)
                    local effect = createPizzaEffect(closestPizza, "TeleportEffect")
                    task.delay(1, function()
                        if effect and effect.Parent then
                            effect:Destroy()
                            pizzaEffects[closestPizza] = nil
                        end
                    end)
                end
                cleanUpEffects()
            end)
        end
    end
})


PZ:AddDivider()  

PZ:AddSlider("HealthThreshold", {
    Text = "生命閾值",
    Default = 50,
    Min = 10,
    Max = 130,
    Rounding = 0,
    Tooltip = "当生命值低于设置生命值吃披萨",
    
    Callback = function(value)
        _G.HealthEatPizza = value
    end
})






PZ:AddDivider()  

PZ:AddButton("InstantAttract", {
    Text = "TP Pizza to feet[將披薩傳送到腳下]",
    Func = function()
        local player = Players.LocalPlayer
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local rootPart = character.HumanoidRootPart
            for _, pizza in ipairs(workspace:GetDescendants()) do
                if pizza:IsA("BasePart") and pizza.Name == "Pizza" then
                    pizza.CFrame = rootPart.CFrame
                    break
                end
            end
        end
    end
})

local Misc = Tabs.lol:AddRightGroupbox('自动吃披萨［2］')

Misc:AddSlider("HealthEatPizza",{
Text = "life threshold[生命閾值]",
Min = 1,
Default = 50,
Max = 50,
Rounding = 1,
Compact = true,
Callback = function(v)
_G.HealthEatPizza = v
end})
Misc:AddSlider("DistanceEatPizza",{
Text = "Distance range[距離范圍]",
Min = 10,
Default = 10,
Max = 50,
Rounding = 1,
Compact = true,
Callback = function(v)
_G.DistanceEatPizza = v
end})

_G.HealthEatPizza = 50
_G.DistanceEatPizza = 10

Misc:AddToggle("AlwaysEatPizza",{
Text = "Auto eat pizza［自動吃披薩］",
Default = false,
Callback = function(v)
_G.AlwaysEatPizza = v
game:GetService("RunService").RenderStepped:Connect(function()
if _G.AlwaysEatPizza and workspace.Map:FindFirstChild("Ingame"):FindFirstChild("Pizza") then
if game.Players.LocalPlayer.Character.Humanoid.Health < _G.HealthEatPizza and (workspace.Map:FindFirstChild("Ingame"):FindFirstChild("Pizza").Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < _G.DistanceEatPizza then
workspace.Map:FindFirstChild("Ingame"):FindFirstChild("Pizza").Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
end
end
end)
end})



local SM = Tabs.tfz:AddLeftGroupbox('杀戮功能[杀手]')



local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local silentAimEnabled = false
local targetPlayer = nil
local maxDistance = 100
local silentAimConnection = nil

local function isKiller()
    local killersFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers")
    if killersFolder and LocalPlayer.Character and table.find(killersFolder:GetChildren(), LocalPlayer.Character) then
        return true
    end
    return false
end

local function getClosestSurvivor()
    local survivorsFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Survivors")
    if not survivorsFolder then return nil end

    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = myChar.HumanoidRootPart.Position

    local closest = nil
    local shortest = math.huge

    for _, model in ipairs(survivorsFolder:GetChildren()) do
        if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") then
            local dist = (model.HumanoidRootPart.Position - myPos).Magnitude
            if dist < shortest and dist <= maxDistance then
                shortest = dist
                closest = model
            end
        end
    end

    return closest
end

local function faceTarget(model)
    if not model or not model:FindFirstChild("HumanoidRootPart") then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local root = char.HumanoidRootPart
    local targetPos = model.HumanoidRootPart.Position
    local look = CFrame.new(root.Position, Vector3.new(targetPos.X, root.Position.Y, targetPos.Z))
    root.CFrame = look
end

getgenv().GetSilentAimTargetPosition = function()
    if silentAimEnabled and isKiller() then
        local target = getClosestSurvivor()
        if target and target:FindFirstChild("Head") then
            return target.Head.Position
        end
    end
    return nil
end

SM:AddToggle("静默瞄准", {
    Text = "Silent Aiming[静默瞄准]",
    Callback = function(state)
        silentAimEnabled = state
       
        if state then
            if not silentAimConnection then
                silentAimConnection = RunService.Heartbeat:Connect(function()
                    if not isKiller() then return end
                    targetPlayer = getClosestSurvivor()
                    if targetPlayer then
                        faceTarget(targetPlayer)
                    end
                end)
            end
        else
   
            if silentAimConnection then
                silentAimConnection:Disconnect()
                silentAimConnection = nil
            end
            targetPlayer = nil
        end
    end
})



-- 创建全局连接管理表
if not _G.HitboxTracking then
    _G.HitboxTracking = {
        Connection = nil,
        Active = false
    }
end

SM:AddToggle("HitboxTrackingToggle", {
    Text = "Adsorption Kill Aura[吸附杀戮光环]",
    Tooltip = "启用/禁用命中框追踪",
    Default = false,
    Disabled = false,
    Visible = true,
    Risky = false,

    Callback = function(state)
        -- 关闭功能
        if not state then
            if _G.HitboxTracking.Connection then
                _G.HitboxTracking.Connection:Disconnect()
                _G.HitboxTracking.Connection = nil
            end
            _G.HitboxTracking.Active = false
            return
        end

        -- 确保游戏加载完成
        repeat task.wait() until game:IsLoaded()

        -- 初始化服务
        local Players = game:GetService('Players')
        local RunService = game:GetService('RunService')
        local Player = Players.LocalPlayer

        -- 初始化角色部件
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")
        local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

        -- 角色变化处理
        Player.CharacterAdded:Connect(function(NewCharacter)
            Character = NewCharacter
            Humanoid = Character:WaitForChild("Humanoid")
            HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
        end)

local AttackAnimations = {
	'rbxassetid://131430497821198', --// MassInfection, 1x1x1x1
	'rbxassetid://83829782357897', --// Slash, 1x1x1x1
	'rbxassetid://126830014841198', --// Slash, Jason
	'rbxassetid://126355327951215', --// Behead, Jason
	'rbxassetid://121086746534252', --// GashingWoundStart, Jason
	'rbxassetid://105458270463374', --// Slash, JohnDoe
	'rbxassetid://127172483138092', --// CorruptEnergy, JohnDoe
	'rbxassetid://18885919947', --// CorruptNature, c00lkidd
	'rbxassetid://18885909645', --// Attack, c00lkidd
	'rbxassetid://87259391926321', --// ParryPunch, Guest1337
	'rbxassetid://106014898528300', --// Charge, Guest1337
	'rbxassetid://87259391926321', --// Punch, Guest1337
	'rbxassetid://86545133269813', --// Stab, TwoTime
	'rbxassetid://89448354637442', --// LungeStart, TwoTime
	'rbxassetid://90499469533503', --// GunFire, Chance
	'rbxassetid://116618003477002', --// Slash, Shedletsky
	'rbxassetid://106086955212611', --// Stab, TwoTime, Skin: PhilosopherTwotime
	'rbxassetid://107640065977686', --// LungeStart, TwoTime, Skin: PhilosopherTwotime
	'rbxassetid://77124578197357', --// GunFire, Chance, Skin: OutlawChance
	'rbxassetid://101771617803133', --// GunFire, Chance, Skin: #CassidyChance
	'rbxassetid://134958187822107', --// GunFire, Chance, Skin: RetroChance
	'rbxassetid://111313169447787', --// GunFire, Chance, Skin: MLGChance
	'rbxassetid://71685573690338', --// GunFire, Chance, Skin: Milestone100Chance
	'rbxassetid://71685573690338', --// GunFire, Chance, Skin: Milestone75Chance
	'rbxassetid://129843313690921', --// ParryPunch, Guest1337, Skin: #NerfedDemomanGuest
	'rbxassetid://97623143664485', --// Charge, Guest1337, Skin: #NerfedDemomanGuest
	'rbxassetid://129843313690921', --// Punch, Guest1337, Skin: #NerfedDemomanGuest
	'rbxassetid://136007065400978', --// ParryPunch, Guest1337, Skin: LittleBrotherGuest
	'rbxassetid://136007065400978', --// Punch, Guest1337, Skin: LittleBrotherGuest
	'rbxassetid://86096387000557', --// ParryPunch, Guest1337, Skin: Milestone100Guest
	'rbxassetid://86096387000557', --// ParryPunch, Guest1337, Skin: Milestone75Guest
	'rbxassetid://108807732150251', --// ParryPunch, Guest1337, Skin: GreenbeltGuest
	'rbxassetid://138040001965654', --// Punch, Guest1337, Skin: GreenbeltGuest
	'rbxassetid://73502073176819', --// Charge, Guest1337, Skin: GreenbeltGuest
	'rbxassetid://129843313690921', --// ParryPunch, Guest1337, Skin: #DemomanGuest
	'rbxassetid://97623143664485', --// Charge, Guest1337, Skin: #DemomanGuest
	'rbxassetid://129843313690921', --// Punch, Guest1337, Skin: #DemomanGuest
	'rbxassetid://97623143664485', --// Charge, Guest1337, Skin: GunnerGuest
	'rbxassetid://97623143664485', --// Charge, Guest1337, Skin: BobbyGuest
	'rbxassetid://97623143664485', --// Charge, Guest1337, Skin: !JuggernautGuest
	'rbxassetid://86709774283672', --// ParryPunch, Guest1337, Skin: SorcererGuest
	'rbxassetid://106014898528300', --// Charge, Guest1337, Skin: SorcererGuest
	'rbxassetid://87259391926321', --// Punch, Guest1337, Skin: SorcererGuest
	'rbxassetid://140703210927645', --// ParryPunch, Guest1337, Skin: DragonGuest
	'rbxassetid://96173857867228', --// Charge, Guest1337, Skin: AllyGuest
	'rbxassetid://121255898612475', --// Slash, Shedletsky, Skin: RetroShedletsky
	'rbxassetid://98031287364865', --// Slash, Shedletsky, Skin: BrightEyesShedletsky
	'rbxassetid://119462383658044', --// Slash, Shedletsky, Skin: NessShedletsky
	'rbxassetid://77448521277146', --// Slash, Shedletsky, Skin: Milestone100Shedletsky
	'rbxassetid://77448521277146', --// Slash, Shedletsky, Skin: Milestone75Shedletsky
	'rbxassetid://103741352379819', --// Slash, Shedletsky, Skin: #RolandShedletsky
	'rbxassetid://119462383658044', --// Slash, Shedletsky, Skin: HeartbrokenShedletsky
	'rbxassetid://131696603025265', --// Slash, Shedletsky, Skin: JamesSunderlandShedletsky
	'rbxassetid://122503338277352', --// Slash, Shedletsky, Skin: SkiesShedletsky
	'rbxassetid://97648548303678', --// Slash, Shedletsky, Skin: #JohnWardShedletsky
	'rbxassetid://94162446513587', --// Slash, JohnDoe, Skin: !Joner
	'rbxassetid://84426150435898', --// CorruptEnergy, JohnDoe, Skin: !Joner
	'rbxassetid://93069721274110', --// Slash, JohnDoe, Skin: AnnihilationJohnDoe
	'rbxassetid://114620047310688', --// CorruptEnergy, JohnDoe, Skin: AnnihilationJohnDoe
	'rbxassetid://97433060861952', --// Slash, JohnDoe, Skin: #SK
	'rbxassetid://82183356141401', --// CorruptEnergy, JohnDoe, Skin: #SK
	'rbxassetid://100592913030351', --// MassInfection, 1x1x1x1, Skin: Fleskhjerta1x1x1x1
	'rbxassetid://121293883585738', --// Slash, 1x1x1x1, Skin: Fleskhjerta1x1x1x1
	'rbxassetid://100592913030351', --// MassInfection, 1x1x1x1, Skin: AceOfSpades1x1x1x1
	'rbxassetid://121293883585738', --// Slash, 1x1x1x1, Skin: AceOfSpades1x1x1x1
	'rbxassetid://100592913030351', --// MassInfection, 1x1x1x1, Skin: Lancer1x1x1x1
	'rbxassetid://121293883585738', --// Slash, 1x1x1x1, Skin: Lancer1x1x1x1
	'rbxassetid://70447634862911', --// MassInfection, 1x1x1x1, Skin: Hacklord1x1x1x1
	'rbxassetid://92173139187970', --// Slash, 1x1x1x1, Skin: Hacklord1x1x1x1
	'rbxassetid://106847695270773', --// GashingWoundStart, Jason, Skin: Subject0Jason
	'rbxassetid://125403313786645', --// Slash, Jason, Skin: Subject0Jason
	'rbxassetid://81639435858902', --// Behead, Jason, Skin: WhitePumpkinJason
	'rbxassetid://137314737492715', --// GashingWoundStart, Jason, Skin: WhitePumpkinJason
	'rbxassetid://120112897026015', --// Slash, Jason, Skin: WhitePumpkinJason
	'rbxassetid://82113744478546', --// Behead, Jason, Skin: KillerKyleJason
	'rbxassetid://118298475669935', --// Slash, Jason, Skin: KillerKyleJason
	'rbxassetid://82113744478546', --// Behead, Jason, Skin: #SmartestJason
	'rbxassetid://118298475669935', --// Slash, Jason, Skin: #SmartestJason
	'rbxassetid://126681776859538', --// Behead, Jason, Skin: PursuerJason
	'rbxassetid://129976080405072', --// GashingWoundStart, Jason, Skin: PursuerJason
	'rbxassetid://109667959938617', --// Slash, Jason, Skin: PursuerJason
	'rbxassetid://74707328554358', --// Slash, Jason, Skin: #DeadRabbitsJason
	'rbxassetid://133336594357903', --// Behead, Jason, Skin: #DeadRabbitsJason
	'rbxassetid://86204001129974', --// GashingWoundStart, Jason, Skin: #DeadRabbitsJason
	'rbxassetid://82113744478546', --// Behead, Jason, Skin: RetroJason
	'rbxassetid://118298475669935', --// Slash, Jason, Skin: RetroJason
	'rbxassetid://124243639579224', --// CorruptNature, c00lkidd, Skin: MafiosoC00l
	'rbxassetid://70371667919898', --// Attack, c00lkidd, Skin: MafiosoC00l
	'rbxassetid://131543461321709', --// Attack, c00lkidd, Skin: SaviorC00l
	'rbxassetid://136323728355613', --// Swing, Noli
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: Devesto
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: Yourself
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: YAAI
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: Toolbox
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: ASPX
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: RedRoomCurse
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: Saggitial
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: Quimera
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: 035
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: Artful
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: Robert
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: Ephialtes
    'rbxassetid://109230267448394' --// Swing, Noli, Skin: Umbra
};
        local RNG = Random.new()

        -- 清除旧连接
        if _G.HitboxTracking.Connection then
            _G.HitboxTracking.Connection:Disconnect()
        end

        -- 标记为活动状态
        _G.HitboxTracking.Active = true

        -- 创建新连接
        _G.HitboxTracking.Connection = RunService.Heartbeat:Connect(function()
            -- 双重活动检查
            if not _G.HitboxTracking.Active then return end
            if not HumanoidRootPart or not HumanoidRootPart:IsDescendantOf(workspace) then return end

            -- 攻击动画检测
            local isAttacking = false
            for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
                if track.Animation and table.find(AttackAnimations, track.Animation.AnimationId) then
                    if (track.TimePosition / track.Length) < 0.75 then
                        isAttacking = true
                        break
                    end
                end
            end

            if not isAttacking then return end

            -- 目标查找
            local target, nearestDist = nil, 12

            local function findTargets(targets)
                for _, entity in pairs(targets) do
                    if entity == Character or not entity:FindFirstChild("HumanoidRootPart") then
                        continue
                    end

                    local distance = (entity.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
                    if distance < nearestDist then
                        nearestDist = distance
                        target = entity
                    end
                end
            end

            -- 检查玩家
            if workspace:FindFirstChild("Players") then
                findTargets(workspace.Players:GetDescendants())
            end
            
            -- 检查NPC
            local npcsFolder = workspace.Map:FindFirstChild("NPCs", true)
            if npcsFolder then
                findTargets(npcsFolder:GetChildren())
            end

            if not target then return end

            -- 计算移动向量
            local ping = Player:GetNetworkPing()
            local randomOffset = Vector3.new(
                RNG:NextNumber(-1.5, 1.5),
                0,
                RNG:NextNumber(-1.5, 1.5)
            )
            
            local requiredVelocity = (target.HumanoidRootPart.Position + randomOffset + 
                                    (target.HumanoidRootPart.Velocity * (ping * 1.25)) - 
                                    HumanoidRootPart.Position) / (ping * 2)

            -- 应用移动
            local originalVelocity = HumanoidRootPart.Velocity
            HumanoidRootPart.Velocity = requiredVelocity
            task.wait()
            HumanoidRootPart.Velocity = originalVelocity
        end)
    end
})



local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerName = player.Name
local hitbox = nil
local updateConnection = nil

local hitboxesFolder = Workspace:FindFirstChild("Hitboxes")
if not hitboxesFolder then
    hitboxesFolder = Instance.new("Folder")
    hitboxesFolder.Name = "Hitboxes"
    hitboxesFolder.Parent = Workspace
end

local function createHitbox()
    local part = Instance.new("Part")
    part.Name = playerName .. "_Hitbox"
    part.Size = Vector3.new(4, 7, 4)
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 0.5
    part.Material = Enum.Material.ForceField
    part.Color = Color3.fromRGB(255, 255, 200)
    part.Parent = hitboxesFolder
    return part
end

local function updateHitbox()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") and hitbox then
        local root = character.HumanoidRootPart
        local offset = root.CFrame.LookVector * 4
        hitbox.CFrame = CFrame.new(root.Position + offset, root.Position + root.CFrame.LookVector)
    end
end

SM:AddToggle("打人", {
    Text = "Show HitBox[显示碰撞箱]",
    Default = false,
    Callback = function(state)
        if state then
       
            hitbox = createHitbox()
            updateConnection = RunService.RenderStepped:Connect(updateHitbox)
         
            player.CharacterAdded:Connect(function(char)
                task.wait(1)
                if hitbox then
                    hitbox:Destroy()
                end
                hitbox = createHitbox()
            end)
        else
            
            if updateConnection then
                updateConnection:Disconnect()
                updateConnection = nil
            end
            if hitbox then
                hitbox:Destroy()
                hitbox = nil
            end
        end
    end
})



local SM = Tabs.tfz:AddLeftGroupbox('自调碰撞箱追踪')

SM:AddSlider("DistanceSlider", {
    Text = "距离范围",
    Tooltip = "调整自动攻击的最大距离",
    Default = 8,
    Min = 1,
    Max = 120,
    Rounding = 0,
    Compact = false,
    Callback = function(value)
        MaxDistance = value
    end
})

SM:AddToggle("InfiniteJumpToggle", {
    Text = "Hitbox Tracking[自调追踪]",
    Tooltip = "启用",
    Default = false,
    Disabled = false,
    Visible = true,
    Risky = false,

    Callback = function(state)
        repeat task.wait() until game:IsLoaded();

        local Players = game:GetService('Players');
        local Player = Players.LocalPlayer;
        local PlayerGui = Player:WaitForChild("PlayerGui");
        local Character = Player.Character or Player.CharacterAdded:Wait();
        local Humanoid = Character:WaitForChild("Humanoid");
        local Animator = Humanoid:WaitForChild("Animator");
        local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart");

        Player.CharacterAdded:Connect(function(NewCharacter)
            Character = NewCharacter;
            Humanoid = Character:WaitForChild("Humanoid");
            Animator = Humanoid:WaitForChild("Animator");
            HumanoidRootPart = Character:WaitForChild("HumanoidRootPart");
        end);

local AttackAnimations = {
	'rbxassetid://131430497821198', --// MassInfection, 1x1x1x1
	'rbxassetid://83829782357897', --// Slash, 1x1x1x1
	'rbxassetid://126830014841198', --// Slash, Jason
	'rbxassetid://126355327951215', --// Behead, Jason
	'rbxassetid://121086746534252', --// GashingWoundStart, Jason
	'rbxassetid://105458270463374', --// Slash, JohnDoe
	'rbxassetid://127172483138092', --// CorruptEnergy, JohnDoe
	'rbxassetid://18885919947', --// CorruptNature, c00lkidd
	'rbxassetid://18885909645', --// Attack, c00lkidd
	'rbxassetid://87259391926321', --// ParryPunch, Guest1337
	'rbxassetid://106014898528300', --// Charge, Guest1337
	'rbxassetid://87259391926321', --// Punch, Guest1337
	'rbxassetid://86545133269813', --// Stab, TwoTime
	'rbxassetid://89448354637442', --// LungeStart, TwoTime
	'rbxassetid://90499469533503', --// GunFire, Chance
	'rbxassetid://116618003477002', --// Slash, Shedletsky
	'rbxassetid://106086955212611', --// Stab, TwoTime, Skin: PhilosopherTwotime
	'rbxassetid://107640065977686', --// LungeStart, TwoTime, Skin: PhilosopherTwotime
	'rbxassetid://77124578197357', --// GunFire, Chance, Skin: OutlawChance
	'rbxassetid://101771617803133', --// GunFire, Chance, Skin: #CassidyChance
	'rbxassetid://134958187822107', --// GunFire, Chance, Skin: RetroChance
	'rbxassetid://111313169447787', --// GunFire, Chance, Skin: MLGChance
	'rbxassetid://71685573690338', --// GunFire, Chance, Skin: Milestone100Chance
	'rbxassetid://71685573690338', --// GunFire, Chance, Skin: Milestone75Chance
	'rbxassetid://129843313690921', --// ParryPunch, Guest1337, Skin: #NerfedDemomanGuest
	'rbxassetid://97623143664485', --// Charge, Guest1337, Skin: #NerfedDemomanGuest
	'rbxassetid://129843313690921', --// Punch, Guest1337, Skin: #NerfedDemomanGuest
	'rbxassetid://136007065400978', --// ParryPunch, Guest1337, Skin: LittleBrotherGuest
	'rbxassetid://136007065400978', --// Punch, Guest1337, Skin: LittleBrotherGuest
	'rbxassetid://86096387000557', --// ParryPunch, Guest1337, Skin: Milestone100Guest
	'rbxassetid://86096387000557', --// ParryPunch, Guest1337, Skin: Milestone75Guest
	'rbxassetid://108807732150251', --// ParryPunch, Guest1337, Skin: GreenbeltGuest
	'rbxassetid://138040001965654', --// Punch, Guest1337, Skin: GreenbeltGuest
	'rbxassetid://73502073176819', --// Charge, Guest1337, Skin: GreenbeltGuest
	'rbxassetid://129843313690921', --// ParryPunch, Guest1337, Skin: #DemomanGuest
	'rbxassetid://97623143664485', --// Charge, Guest1337, Skin: #DemomanGuest
	'rbxassetid://129843313690921', --// Punch, Guest1337, Skin: #DemomanGuest
	'rbxassetid://97623143664485', --// Charge, Guest1337, Skin: GunnerGuest
	'rbxassetid://97623143664485', --// Charge, Guest1337, Skin: BobbyGuest
	'rbxassetid://97623143664485', --// Charge, Guest1337, Skin: !JuggernautGuest
	'rbxassetid://86709774283672', --// ParryPunch, Guest1337, Skin: SorcererGuest
	'rbxassetid://106014898528300', --// Charge, Guest1337, Skin: SorcererGuest
	'rbxassetid://87259391926321', --// Punch, Guest1337, Skin: SorcererGuest
	'rbxassetid://140703210927645', --// ParryPunch, Guest1337, Skin: DragonGuest
	'rbxassetid://96173857867228', --// Charge, Guest1337, Skin: AllyGuest
	'rbxassetid://121255898612475', --// Slash, Shedletsky, Skin: RetroShedletsky
	'rbxassetid://98031287364865', --// Slash, Shedletsky, Skin: BrightEyesShedletsky
	'rbxassetid://119462383658044', --// Slash, Shedletsky, Skin: NessShedletsky
	'rbxassetid://77448521277146', --// Slash, Shedletsky, Skin: Milestone100Shedletsky
	'rbxassetid://77448521277146', --// Slash, Shedletsky, Skin: Milestone75Shedletsky
	'rbxassetid://103741352379819', --// Slash, Shedletsky, Skin: #RolandShedletsky
	'rbxassetid://119462383658044', --// Slash, Shedletsky, Skin: HeartbrokenShedletsky
	'rbxassetid://131696603025265', --// Slash, Shedletsky, Skin: JamesSunderlandShedletsky
	'rbxassetid://122503338277352', --// Slash, Shedletsky, Skin: SkiesShedletsky
	'rbxassetid://97648548303678', --// Slash, Shedletsky, Skin: #JohnWardShedletsky
	'rbxassetid://94162446513587', --// Slash, JohnDoe, Skin: !Joner
	'rbxassetid://84426150435898', --// CorruptEnergy, JohnDoe, Skin: !Joner
	'rbxassetid://93069721274110', --// Slash, JohnDoe, Skin: AnnihilationJohnDoe
	'rbxassetid://114620047310688', --// CorruptEnergy, JohnDoe, Skin: AnnihilationJohnDoe
	'rbxassetid://97433060861952', --// Slash, JohnDoe, Skin: #SK
	'rbxassetid://82183356141401', --// CorruptEnergy, JohnDoe, Skin: #SK
	'rbxassetid://100592913030351', --// MassInfection, 1x1x1x1, Skin: Fleskhjerta1x1x1x1
	'rbxassetid://121293883585738', --// Slash, 1x1x1x1, Skin: Fleskhjerta1x1x1x1
	'rbxassetid://100592913030351', --// MassInfection, 1x1x1x1, Skin: AceOfSpades1x1x1x1
	'rbxassetid://121293883585738', --// Slash, 1x1x1x1, Skin: AceOfSpades1x1x1x1
	'rbxassetid://100592913030351', --// MassInfection, 1x1x1x1, Skin: Lancer1x1x1x1
	'rbxassetid://121293883585738', --// Slash, 1x1x1x1, Skin: Lancer1x1x1x1
	'rbxassetid://70447634862911', --// MassInfection, 1x1x1x1, Skin: Hacklord1x1x1x1
	'rbxassetid://92173139187970', --// Slash, 1x1x1x1, Skin: Hacklord1x1x1x1
	'rbxassetid://106847695270773', --// GashingWoundStart, Jason, Skin: Subject0Jason
	'rbxassetid://125403313786645', --// Slash, Jason, Skin: Subject0Jason
	'rbxassetid://81639435858902', --// Behead, Jason, Skin: WhitePumpkinJason
	'rbxassetid://137314737492715', --// GashingWoundStart, Jason, Skin: WhitePumpkinJason
	'rbxassetid://120112897026015', --// Slash, Jason, Skin: WhitePumpkinJason
	'rbxassetid://82113744478546', --// Behead, Jason, Skin: KillerKyleJason
	'rbxassetid://118298475669935', --// Slash, Jason, Skin: KillerKyleJason
	'rbxassetid://82113744478546', --// Behead, Jason, Skin: #SmartestJason
	'rbxassetid://118298475669935', --// Slash, Jason, Skin: #SmartestJason
	'rbxassetid://126681776859538', --// Behead, Jason, Skin: PursuerJason
	'rbxassetid://129976080405072', --// GashingWoundStart, Jason, Skin: PursuerJason
	'rbxassetid://109667959938617', --// Slash, Jason, Skin: PursuerJason
	'rbxassetid://74707328554358', --// Slash, Jason, Skin: #DeadRabbitsJason
	'rbxassetid://133336594357903', --// Behead, Jason, Skin: #DeadRabbitsJason
	'rbxassetid://86204001129974', --// GashingWoundStart, Jason, Skin: #DeadRabbitsJason
	'rbxassetid://82113744478546', --// Behead, Jason, Skin: RetroJason
	'rbxassetid://118298475669935', --// Slash, Jason, Skin: RetroJason
	'rbxassetid://124243639579224', --// CorruptNature, c00lkidd, Skin: MafiosoC00l
	'rbxassetid://70371667919898', --// Attack, c00lkidd, Skin: MafiosoC00l
	'rbxassetid://131543461321709', --// Attack, c00lkidd, Skin: SaviorC00l
	'rbxassetid://136323728355613', --// Swing, Noli
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: Devesto
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: Yourself
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: YAAI
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: Toolbox
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: ASPX
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: RedRoomCurse
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: Saggitial
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: Quimera
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: 035
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: Artful
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: Robert
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: Ephialtes
    'rbxassetid://109230267448394' --// Swing, Noli, Skin: Umbra
};

        local RNG = Random.new();
        game:GetService('RunService').Heartbeat:Connect(function()
            if not HumanoidRootPart then
                return;
            end

            local Playing = false;
            for _,v in Humanoid:GetPlayingAnimationTracks() do
                if table.find(AttackAnimations, v.Animation.AnimationId) and (v.TimePosition / v.Length < 0.75) then
                    Playing = true;
                end
            end

            if not Playing then
                return;
            end

            local Target;
            local NearestDist = MaxDistance; -- 使用滑块设置的距离

            local function loop(t)
                for _,v in t do
                    if v == Character or not v:FindFirstChild("HumanoidRootPart") then
                        continue;
                    end

                    local Dist = (v.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude;

                    if Dist < NearestDist then
                        NearestDist = Dist;
                        Target = v;
                    end
                end
            end

            loop(workspace.Players:GetDescendants());
            loop(workspace.Map:FindFirstChild("NPCs", true):GetChildren());

            if not Target then
                return;
            end

            local OldVelocity = HumanoidRootPart.Velocity;
            local NeededVelocity =
            (Target.HumanoidRootPart.Position + vector.create(
                RNG:NextNumber(-1.5, 1.5),
                0,
                RNG:NextNumber(-1.5, 1.5)
            ) + (Target.HumanoidRootPart.Velocity * (Player:GetNetworkPing() * 1.25))
                - HumanoidRootPart.Position
            ) / (Player:GetNetworkPing() * 2);

            HumanoidRootPart.Velocity = NeededVelocity;
            game:GetService('RunService').RenderStepped:Wait();
            HumanoidRootPart.Velocity = OldVelocity;
        end);
    end,
})



local SM = Tabs.tfz:AddRightGroupbox('Hitbox Tracking[碰撞箱追踪]')

SM:AddToggle("InfiniteJumpToggle", {
    Text = "Hitbox Tracking[100%]",
    Tooltip = "启用",
    Default = false,
    Disabled = false,
    Visible = true,
    Risky = false,

    Callback = function(state)
       repeat task.wait() until game:IsLoaded();

local Players = game:GetService('Players');
local Player = Players.LocalPlayer;
local PlayerGui = Player:WaitForChild("PlayerGui");
local Character = Player.Character or Player.CharacterAdded:Wait();
local Humanoid = Character:WaitForChild("Humanoid");
local Animator = Humanoid:WaitForChild("Animator");
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart");

Player.CharacterAdded:Connect(function(NewCharacter)
    Character = NewCharacter;
    Humanoid = Character:WaitForChild("Humanoid");
    Animator = Humanoid:WaitForChild("Animator");
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart");
end);

local AttackAnimations = {
	'rbxassetid://131430497821198', --// MassInfection, 1x1x1x1
	'rbxassetid://83829782357897', --// Slash, 1x1x1x1
	'rbxassetid://126830014841198', --// Slash, Jason
	'rbxassetid://126355327951215', --// Behead, Jason
	'rbxassetid://121086746534252', --// GashingWoundStart, Jason
	'rbxassetid://105458270463374', --// Slash, JohnDoe
	'rbxassetid://127172483138092', --// CorruptEnergy, JohnDoe
	'rbxassetid://18885919947', --// CorruptNature, c00lkidd
	'rbxassetid://18885909645', --// Attack, c00lkidd
	'rbxassetid://87259391926321', --// ParryPunch, Guest1337
	'rbxassetid://106014898528300', --// Charge, Guest1337
	'rbxassetid://87259391926321', --// Punch, Guest1337
	'rbxassetid://86545133269813', --// Stab, TwoTime
	'rbxassetid://89448354637442', --// LungeStart, TwoTime
	'rbxassetid://90499469533503', --// GunFire, Chance
	'rbxassetid://116618003477002', --// Slash, Shedletsky
	'rbxassetid://106086955212611', --// Stab, TwoTime, Skin: PhilosopherTwotime
	'rbxassetid://107640065977686', --// LungeStart, TwoTime, Skin: PhilosopherTwotime
	'rbxassetid://77124578197357', --// GunFire, Chance, Skin: OutlawChance
	'rbxassetid://101771617803133', --// GunFire, Chance, Skin: #CassidyChance
	'rbxassetid://134958187822107', --// GunFire, Chance, Skin: RetroChance
	'rbxassetid://111313169447787', --// GunFire, Chance, Skin: MLGChance
	'rbxassetid://71685573690338', --// GunFire, Chance, Skin: Milestone100Chance
	'rbxassetid://71685573690338', --// GunFire, Chance, Skin: Milestone75Chance
	'rbxassetid://129843313690921', --// ParryPunch, Guest1337, Skin: #NerfedDemomanGuest
	'rbxassetid://97623143664485', --// Charge, Guest1337, Skin: #NerfedDemomanGuest
	'rbxassetid://129843313690921', --// Punch, Guest1337, Skin: #NerfedDemomanGuest
	'rbxassetid://136007065400978', --// ParryPunch, Guest1337, Skin: LittleBrotherGuest
	'rbxassetid://136007065400978', --// Punch, Guest1337, Skin: LittleBrotherGuest
	'rbxassetid://86096387000557', --// ParryPunch, Guest1337, Skin: Milestone100Guest
	'rbxassetid://86096387000557', --// ParryPunch, Guest1337, Skin: Milestone75Guest
	'rbxassetid://108807732150251', --// ParryPunch, Guest1337, Skin: GreenbeltGuest
	'rbxassetid://138040001965654', --// Punch, Guest1337, Skin: GreenbeltGuest
	'rbxassetid://73502073176819', --// Charge, Guest1337, Skin: GreenbeltGuest
	'rbxassetid://129843313690921', --// ParryPunch, Guest1337, Skin: #DemomanGuest
	'rbxassetid://97623143664485', --// Charge, Guest1337, Skin: #DemomanGuest
	'rbxassetid://129843313690921', --// Punch, Guest1337, Skin: #DemomanGuest
	'rbxassetid://97623143664485', --// Charge, Guest1337, Skin: GunnerGuest
	'rbxassetid://97623143664485', --// Charge, Guest1337, Skin: BobbyGuest
	'rbxassetid://97623143664485', --// Charge, Guest1337, Skin: !JuggernautGuest
	'rbxassetid://86709774283672', --// ParryPunch, Guest1337, Skin: SorcererGuest
	'rbxassetid://106014898528300', --// Charge, Guest1337, Skin: SorcererGuest
	'rbxassetid://87259391926321', --// Punch, Guest1337, Skin: SorcererGuest
	'rbxassetid://140703210927645', --// ParryPunch, Guest1337, Skin: DragonGuest
	'rbxassetid://96173857867228', --// Charge, Guest1337, Skin: AllyGuest
	'rbxassetid://121255898612475', --// Slash, Shedletsky, Skin: RetroShedletsky
	'rbxassetid://98031287364865', --// Slash, Shedletsky, Skin: BrightEyesShedletsky
	'rbxassetid://119462383658044', --// Slash, Shedletsky, Skin: NessShedletsky
	'rbxassetid://77448521277146', --// Slash, Shedletsky, Skin: Milestone100Shedletsky
	'rbxassetid://77448521277146', --// Slash, Shedletsky, Skin: Milestone75Shedletsky
	'rbxassetid://103741352379819', --// Slash, Shedletsky, Skin: #RolandShedletsky
	'rbxassetid://119462383658044', --// Slash, Shedletsky, Skin: HeartbrokenShedletsky
	'rbxassetid://131696603025265', --// Slash, Shedletsky, Skin: JamesSunderlandShedletsky
	'rbxassetid://122503338277352', --// Slash, Shedletsky, Skin: SkiesShedletsky
	'rbxassetid://97648548303678', --// Slash, Shedletsky, Skin: #JohnWardShedletsky
	'rbxassetid://94162446513587', --// Slash, JohnDoe, Skin: !Joner
	'rbxassetid://84426150435898', --// CorruptEnergy, JohnDoe, Skin: !Joner
	'rbxassetid://93069721274110', --// Slash, JohnDoe, Skin: AnnihilationJohnDoe
	'rbxassetid://114620047310688', --// CorruptEnergy, JohnDoe, Skin: AnnihilationJohnDoe
	'rbxassetid://97433060861952', --// Slash, JohnDoe, Skin: #SK
	'rbxassetid://82183356141401', --// CorruptEnergy, JohnDoe, Skin: #SK
	'rbxassetid://100592913030351', --// MassInfection, 1x1x1x1, Skin: Fleskhjerta1x1x1x1
	'rbxassetid://121293883585738', --// Slash, 1x1x1x1, Skin: Fleskhjerta1x1x1x1
	'rbxassetid://100592913030351', --// MassInfection, 1x1x1x1, Skin: AceOfSpades1x1x1x1
	'rbxassetid://121293883585738', --// Slash, 1x1x1x1, Skin: AceOfSpades1x1x1x1
	'rbxassetid://100592913030351', --// MassInfection, 1x1x1x1, Skin: Lancer1x1x1x1
	'rbxassetid://121293883585738', --// Slash, 1x1x1x1, Skin: Lancer1x1x1x1
	'rbxassetid://70447634862911', --// MassInfection, 1x1x1x1, Skin: Hacklord1x1x1x1
	'rbxassetid://92173139187970', --// Slash, 1x1x1x1, Skin: Hacklord1x1x1x1
	'rbxassetid://106847695270773', --// GashingWoundStart, Jason, Skin: Subject0Jason
	'rbxassetid://125403313786645', --// Slash, Jason, Skin: Subject0Jason
	'rbxassetid://81639435858902', --// Behead, Jason, Skin: WhitePumpkinJason
	'rbxassetid://137314737492715', --// GashingWoundStart, Jason, Skin: WhitePumpkinJason
	'rbxassetid://120112897026015', --// Slash, Jason, Skin: WhitePumpkinJason
	'rbxassetid://82113744478546', --// Behead, Jason, Skin: KillerKyleJason
	'rbxassetid://118298475669935', --// Slash, Jason, Skin: KillerKyleJason
	'rbxassetid://82113744478546', --// Behead, Jason, Skin: #SmartestJason
	'rbxassetid://118298475669935', --// Slash, Jason, Skin: #SmartestJason
	'rbxassetid://126681776859538', --// Behead, Jason, Skin: PursuerJason
	'rbxassetid://129976080405072', --// GashingWoundStart, Jason, Skin: PursuerJason
	'rbxassetid://109667959938617', --// Slash, Jason, Skin: PursuerJason
	'rbxassetid://74707328554358', --// Slash, Jason, Skin: #DeadRabbitsJason
	'rbxassetid://133336594357903', --// Behead, Jason, Skin: #DeadRabbitsJason
	'rbxassetid://86204001129974', --// GashingWoundStart, Jason, Skin: #DeadRabbitsJason
	'rbxassetid://82113744478546', --// Behead, Jason, Skin: RetroJason
	'rbxassetid://118298475669935', --// Slash, Jason, Skin: RetroJason
	'rbxassetid://124243639579224', --// CorruptNature, c00lkidd, Skin: MafiosoC00l
	'rbxassetid://70371667919898', --// Attack, c00lkidd, Skin: MafiosoC00l
	'rbxassetid://131543461321709', --// Attack, c00lkidd, Skin: SaviorC00l
	'rbxassetid://136323728355613', --// Swing, Noli
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: Devesto
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: Yourself
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: YAAI
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: Toolbox
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: ASPX
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: RedRoomCurse
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: Saggitial
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: Quimera
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: 035
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: Artful
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: Robert
    'rbxassetid://109230267448394', --// Swing, Noli, Skin: Ephialtes
    'rbxassetid://109230267448394' --// Swing, Noli, Skin: Umbra
};

local RNG = Random.new();
game:GetService('RunService').Heartbeat:Connect(function()
    if not HumanoidRootPart then
        return;
    end

    local Playing = false;
    for _,v in Humanoid:GetPlayingAnimationTracks() do
        if table.find(AttackAnimations, v.Animation.AnimationId) and (v.TimePosition / v.Length < 0.75) then
            Playing = true;
        end
    end

    if not Playing then
        return;
    end

    local Target;
    local NearestDist = 12;

    local function loop(t)
        for _,v in t do
            if v == Character or not v:FindFirstChild("HumanoidRootPart") then
                continue;
            end

            local Dist = (v.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude;

            if Dist < NearestDist then
                NearestDist = Dist;
                Target = v;
            end
        end
    end

    loop(workspace.Players:GetDescendants());
    loop(workspace.Map:FindFirstChild("NPCs", true):GetChildren());

    if not Target then
        return;
    end

    local OldVelocity = HumanoidRootPart.Velocity;
    local NeededVelocity =
    (Target.HumanoidRootPart.Position + vector.create(
        RNG:NextNumber(-1.5, 1.5),
        0,
        RNG:NextNumber(-1.5, 1.5)
    ) + (Target.HumanoidRootPart.Velocity * (Player:GetNetworkPing() * 1.25))
        - HumanoidRootPart.Position
    ) / (Player:GetNetworkPing() * 2);

    HumanoidRootPart.Velocity = NeededVelocity;
    game:GetService('RunService').RenderStepped:Wait();
    HumanoidRootPart.Velocity = OldVelocity;
end); 
    end,
})

local ZZ = Tabs.zdg:AddRightGroupbox('自动格挡[动画检测]')

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local config = {
    Enabled = false,
    BaseDistance = 16,
    ScanInterval = 0.02,
    BlockCooldown = 0.35,
    MoveCompBase = 1.5,
    MoveCompFactor = 0.25,
    SpeedThreshold = 8,
    PredictBase = 4,
    PredictMax = 8,
    PredictFactor = 0.22,
    TargetAngle = 50,
    MinAttackSpeed = 12
}

local animationIds = {
    ["126830014841198"] = true,
    ["126355327951215"] = true,
    ["121086746534252"] = true,
    ["18885909645"] = true,
    ["98456918873918"] = true,
    ["105458270463374"] = true,
    ["83829782357897"] = true,
    ["125403313786645"] = true,
    ["118298475669935"] = true,
    ["82113744478546"] = true,
    ["70371667919898"] = true,
    ["99135633258223"] = true,
    ["97167027849946"] = true,
    ["109230267448394"] = true,
    ["139835501033932"] = true,
    ["126896426760253"] = true,
}

local LocalPlayer = Players.LocalPlayer
local RemoteEvent
local success, err = pcall(function()
    RemoteEvent = ReplicatedStorage:WaitForChild("Modules", 10):WaitForChild("Network", 10):WaitForChild("RemoteEvent", 10)
end)
if not success or not RemoteEvent then
    warn("Failed to find RemoteEvent: ", err)
end
local lastBlockTime = 0
local combatConnection = nil

local function HasTargetAnimation(character)
    if not character then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then return false end
    
    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
        if track.Animation then
            local animId = track.Animation.AnimationId
            if animId then
                animId = tostring(animId:match("%d+"))
            else
                animId = ""
            end
            if animationIds[animId] then
                return true
            end
        end
    end
    return false
end

local function GetMoveCompensation()
    if not LocalPlayer.Character then return 0 end
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return 0 end
    
    local speed = rootPart.Velocity.Magnitude
    if speed <= config.SpeedThreshold then return 0 end
    
    return config.MoveCompBase + (speed - config.SpeedThreshold) * config.MoveCompFactor
end

local function GetTotalDetectionRange(killer)
    local base = config.BaseDistance
    local moveBonus = GetMoveCompensation()
    local predict = 0
    
    if killer:FindFirstChild("HumanoidRootPart") then
        local killerSpeed = killer.HumanoidRootPart.Velocity.Magnitude
        predict = math.min(
            config.PredictBase + killerSpeed * config.PredictFactor,
            config.PredictMax
        )
    end
    
    return base + moveBonus + predict
end

local function IsTargetingMe(killer)
    local myCharacter = LocalPlayer.Character
    if not myCharacter then return false end
    
    local myRoot = myCharacter:FindFirstChild("HumanoidRootPart")
    local killerRoot = killer:FindFirstChild("HumanoidRootPart")
    if not myRoot or not killerRoot then return false end
    
    local toPlayer = (myRoot.Position - killerRoot.CFrame.Position)
    if toPlayer.Magnitude == 0 then return false end -- Avoid division by zero
    toPlayer = toPlayer.Unit
    local facing = killerRoot.CFrame.LookVector
    if math.deg(math.acos(toPlayer:Dot(facing))) < config.TargetAngle then
        return true
    end
    
    local velocity = killerRoot.Velocity
    if velocity.Magnitude > config.MinAttackSpeed then
        return velocity.Unit:Dot(toPlayer) > 0.7
    end
    
    return false
end

local function GetThreateningKillers()
    local killers = {}
    local killersFolder = workspace:FindFirstChild("Killers")
    if not killersFolder then
        for _, child in ipairs(workspace:GetChildren()) do
            if child.Name == "Killers" and child:IsA("Folder") then
                killersFolder = child
                break
            end
        end
    end
    if not killersFolder then return killers end
    
    local myCharacter = LocalPlayer.Character
    if not myCharacter then return killers end
    
    local myRoot = myCharacter:FindFirstChild("HumanoidRootPart")
    if not myRoot then return killers end
    
    for _, killer in ipairs(killersFolder:GetChildren()) do
        if killer:FindFirstChild("HumanoidRootPart") then
            local killerRoot = killer.HumanoidRootPart
            local distance = (killerRoot.Position - myRoot.Position).Magnitude
            local detectRange = GetTotalDetectionRange(killer)
            
            if distance <= detectRange and HasTargetAnimation(killer) and IsTargetingMe(killer) then
                table.insert(killers, {
                    killer = killer,
                    dangerScore = distance / (killerRoot.Velocity.Magnitude + 1)
                })
            end
        end
    end
    
    table.sort(killers, function(a, b)
        return a.dangerScore < b.dangerScore
    end)
    
    return killers
end

local function GetAdjustedCooldown()
    if not LocalPlayer.Character then return config.BlockCooldown end
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return config.BlockCooldown end
    
    return rootPart.Velocity.Magnitude > config.SpeedThreshold 
        and config.BlockCooldown * 0.9 
        or config.BlockCooldown
end

local function PerformBlock()
    local now = os.clock()
    if now - lastBlockTime >= GetAdjustedCooldown() then
        local success, result = pcall(function()
            RemoteEvent:FireServer("UseActorAbility", "Block")
        end)
        if success then
            lastBlockTime = now
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local moveSpeed = LocalPlayer.Character.HumanoidRootPart.Velocity.Magnitude
            if moveSpeed > config.SpeedThreshold then
                lastBlockTime = lastBlockTime + 0.03 * (moveSpeed / config.SpeedThreshold)
            end
        end
    end
end
end

local function CombatLoop()
    local killers = GetThreateningKillers()
    if #killers > 0 then
        PerformBlock()
    end
end

ZZ:AddToggle("AutoBlockToggle", {
    Text = "自动格挡",
    Default = false,
    Callback = function(enabled)
        config.Enabled = enabled
        if enabled then
            if combatConnection then
                combatConnection:Disconnect()
            end
            combatConnection = RunService.Stepped:Connect(function()
                pcall(CombatLoop)
            end)
        elseif combatConnection then
            combatConnection:Disconnect()
            combatConnection = nil
        end
    end
})

ZZ:AddSlider("BaseDistance", {
    Text = "格挡距离",
    Default = 16,
    Min = 5,
    Max = 30,
    Rounding = 1,
    Callback = function(value)
        config.BaseDistance = value
    end
})

LocalPlayer.CharacterAdded:Connect(function()
    if config.Enabled and combatConnection then
        combatConnection:Disconnect()
        combatConnection = RunService.Stepped:Connect(CombatLoop)
    end
end)



local ZZ = Tabs.zdg:AddLeftGroupbox('访客自动格挡[音频检测]')

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local config = {
    Enabled = false,
    BaseDistance = 16,
    ScanInterval = 0.02,
    BlockCooldown = 0.35,
    MoveCompBase = 1.5,
    MoveCompFactor = 0.25,
    SpeedThreshold = 8,
    PredictBase = 4,
    PredictMax = 8,
    PredictFactor = 0.22,
    TargetAngle = 50,
    MinAttackSpeed = 12,
    TargetSoundIds = {
        "rbxassetid://102228729296384",
        "rbxassetid://140242176732868",
        "rbxassetid://12222216",
        "rbxassetid://86174610237192",
        "rbxassetid://101199185291628",
        "rbxassetid://95079963655241",
        "rbxassetid://112809109188560",
        "rbxassetid://84307400688050",
        "rbxassetid://136323728355613",
        "rbxassetid://115026634746636",
        "rbxassetid://119942598489800",
        "rbxassetid://108907358619313",
        "rbxassetid://119942598489800"
    }
}

local LocalPlayer = Players.LocalPlayer
local RemoteEvent = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")
local lastBlockTime = 0
local combatConnection = nil

local function HasTargetSound(character)
    if not character then return false end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    
    for _, sound in ipairs(rootPart:GetDescendants()) do
        if sound:IsA("Sound") and sound.IsPlaying then
            for _, id in ipairs(config.TargetSoundIds) do
                if sound.SoundId == id then
                    return true
                end
            end
        end
    end
    return false
end

local function GetMoveCompensation()
    if not LocalPlayer.Character then return 0 end
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return 0 end
    
    local speed = rootPart.Velocity.Magnitude
    if speed <= config.SpeedThreshold then return 0 end
    
    return config.MoveCompBase + (speed - config.SpeedThreshold) * config.MoveCompFactor
end

local function GetTotalDetectionRange(killer)
    local base = config.BaseDistance
    local moveBonus = GetMoveCompensation()
    local predict = 0
    
    if killer:FindFirstChild("HumanoidRootPart") then
        local killerSpeed = killer.HumanoidRootPart.Velocity.Magnitude
        predict = math.min(
            config.PredictBase + killerSpeed * config.PredictFactor,
            config.PredictMax
        )
    end
    
    return base + moveBonus + predict
end

local function IsTargetingMe(killer)
    local myCharacter = LocalPlayer.Character
    if not myCharacter then return false end
    
    local myRoot = myCharacter:FindFirstChild("HumanoidRootPart")
    local killerRoot = killer:FindFirstChild("HumanoidRootPart")
    if not myRoot or not killerRoot then return false end
    
    local toPlayer = (myRoot.Position - killerRoot.Position).Unit
    local facing = killerRoot.CFrame.LookVector
    if math.deg(math.acos(toPlayer:Dot(facing))) < config.TargetAngle then
        return true
    end
    
    local velocity = killerRoot.Velocity
    if velocity.Magnitude > config.MinAttackSpeed then
        return velocity.Unit:Dot(toPlayer) > 0.85
    end
    
    return false
end

local function GetThreateningKillers()
    local killers = {}
    local killersFolder = workspace:FindFirstChild("Killers") or workspace:FindFirstChild("Players"):FindFirstChild("Killers")
    if not killersFolder then return killers end
    
    local myCharacter = LocalPlayer.Character
    if not myCharacter then return killers end
    
    local myRoot = myCharacter:FindFirstChild("HumanoidRootPart")
    if not myRoot then return killers end
    
    for _, killer in ipairs(killersFolder:GetChildren()) do
        if killer:FindFirstChild("HumanoidRootPart") then
            local killerRoot = killer.HumanoidRootPart
            local distance = (killerRoot.Position - myRoot.Position).Magnitude
            local detectRange = GetTotalDetectionRange(killer)
            
            if distance <= detectRange and HasTargetSound(killer) and IsTargetingMe(killer) then
                table.insert(killers, {
                    killer = killer,
                    dangerScore = distance / (killerRoot.Velocity.Magnitude + 1)
                })
            end
        end
    end
    
    table.sort(killers, function(a, b)
        return a.dangerScore < b.dangerScore
    end)
    
    return killers
end

local function GetAdjustedCooldown()
    if not LocalPlayer.Character then return config.BlockCooldown end
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return config.BlockCooldown end
    
    return rootPart.Velocity.Magnitude > config.SpeedThreshold 
        and config.BlockCooldown * 0.9 
        or config.BlockCooldown
end

local function PerformBlock()
    local now = os.clock()
    if now - lastBlockTime >= GetAdjustedCooldown() then
        RemoteEvent:FireServer("UseActorAbility", "Block")
        lastBlockTime = now
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local moveSpeed = LocalPlayer.Character.HumanoidRootPart.Velocity.Magnitude
            if moveSpeed > config.SpeedThreshold then
                lastBlockTime = lastBlockTime + 0.03 * (moveSpeed / config.SpeedThreshold)
            end
        end
    end
end

local function CombatLoop()
    local killers = GetThreateningKillers()
    if #killers > 0 then
        PerformBlock()
    end
end

ZZ:AddToggle("AutoBlockToggle", {
    Text = "Auto Block[自动格挡]",
    Default = false,
    Callback = function(enabled)
        config.Enabled = enabled
        if enabled then
            combatConnection = RunService.Stepped:Connect(function()
                pcall(CombatLoop)
            end)
        elseif combatConnection then
            combatConnection:Disconnect()
            combatConnection = nil
        end
    end
})

ZZ:AddSlider("BaseDistance", {
    Text = "格挡距离",
    Default = 16,
    Min = 5,
    Max = 30,
    Rounding = 1,
    Callback = function(value)
        config.BaseDistance = value
    end
})

LocalPlayer.CharacterAdded:Connect(function()
    if config.Enabled and combatConnection then
        combatConnection:Disconnect()
        combatConnection = RunService.Stepped:Connect(CombatLoop)
    end
end)











local Generator = Tabs.zdx:AddLeftGroupbox("[Fix Generator]修机功能")

Generator:AddDropdown('FixMode', {
    Values = {'危险模式[Danger]', '安全模式[Safe]', '自调模式[Custom]'},
    Default = 2,
    Multi = false,
    Text = 'Fix mod[修机模式]',
    Searchable = false,
    Callback = function(v)
        _G.FixMode = v
        if v == "危险模式" then
            Generator:SetValue("RepairSpeed", 3)
        elseif v == "安全模式" then
            Generator:SetValue("RepairSpeed", 5)
        end
    end
})

Generator:AddSlider("RepairSpeed", {
    Text = "Fix spend[修机速度] (s)",
    Default = 4,
    Min = 1,
    Max = 5,
    Rounding = 1,
    Compact = false,
    Callback = function(v)
        _G.CustomSpeed = v
    end
})

Generator:AddToggle("AutoGenerator",{
    Text = "自动修复发电机[Auto fix Generator]",
    Default = false,
    Callback = function(v)
        _G.AutoGen = v
        task.spawn(function()
            while _G.AutoGen do
                if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("PuzzleUI") then
                    local delayTime = _G.CustomSpeed or 3
                    
                    if _G.FixMode == "危险模式" then
                        delayTime = 2.5
                    elseif _G.FixMode == "安全模式" then
                        delayTime = 5
                    end
                    
                    wait(delayTime)
                    
                    for _,v in ipairs(workspace["Map"]["Ingame"]["Map"]:GetChildren()) do
                        if v.Name == "Generator" then
                            v["Remotes"]["RE"]:FireServer()
                        end
                    end
                end
                wait()
            end
        end)
    end
})

local KillerSurvival = Tabs.zdx:AddRightGroupbox('Tp fix Generator[Danger]『传送修机』')

KillerSurvival:AddButton({
    Text = '传送到发电机',
    Func = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        
        local generators = workspace.Map.Ingame.Map:GetChildren()
        for _, generator in ipairs(generators) do
            if generator.Name == "Generator" and 
               generator:FindFirstChild("Progress") and 
               generator.Progress.Value < 100 then
                
                local generatorPart = generator:FindFirstChild("Main") or  
                                     generator:FindFirstChild("Model") or
                                     generator:FindFirstChild("Base")
                
                if generatorPart then
                    character.HumanoidRootPart.CFrame = generatorPart.CFrame + Vector3.new(0, 3, 0)
                    return  
                end
            end
        end
        warn("没有找到可修理的发电机")
    end
})

KillerSurvival:AddToggle("AutoFix", {
    Text = "自动轮换修理发电机[TP Fix Generator]",
    Default = false,
    Callback = function(enabled)
        local threadId = tostring(math.random(1, 99999))
        _G.AutoFixThreadId = threadId
        
        local function shouldContinue()
            return _G.AutoFixThreadId == threadId and enabled
        end
        
        local function allGeneratorsFixed()
            for _, v in ipairs(game.Workspace.Map.Ingame.Map:GetChildren()) do
                if v.Name == "Generator" and v.Progress.Value < 100 then
                    return false
                end
            end
            return true
        end
        
        local function runGenerator()
            while shouldContinue() and not allGeneratorsFixed() do
                local generators = {}
                for i, v in ipairs(game.Workspace.Map.Ingame.Map:GetChildren()) do
                    if v.Name == "Generator" and v.Progress.Value < 100 then
                        table.insert(generators, v)
                    end
                end
                
                for _, generator in ipairs(generators) do
                    if not shouldContinue() or allGeneratorsFixed() then
                        return
                    end
                    
                    if generator.Progress.Value >= 100 then
                        continue
                    end
                    
                    local availablePositions = {
                        Left = true,
                        Right = true,
                        Center = true
                    }
                    
                    for _, player in ipairs(game.Players:GetPlayers()) do
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local hrp = player.Character.HumanoidRootPart
                            for posName, pos in pairs(generator.Positions:GetChildren()) do
                                if (hrp.Position - pos.Position).Magnitude < 5 then
                                    availablePositions[posName] = false
                                end
                            end
                        end
                    end
                    
                    local positionToUse
                    for posName, isAvailable in pairs(availablePositions) do
                        if isAvailable then
                            positionToUse = posName
                            break
                        end
                    end
                    
                    if positionToUse and shouldContinue() and not allGeneratorsFixed() then
                        local char = game.Players.LocalPlayer.Character
                        if not char or not char.PrimaryPart then
                            task.wait(1)
                            continue
                        end
                        
                        char.PrimaryPart.CFrame = generator.Positions[positionToUse].CFrame
                        task.wait(0.2)
                        generator.Remotes.RF:InvokeServer("enter")
                        
                        while shouldContinue() and generator.Progress.Value < 100 do
                            task.wait(1.7)
                            generator.Remotes.RE:FireServer()
                            task.wait(0.2)
                        end
                        
                        if shouldContinue() then
                            generator.Remotes.RF:InvokeServer("leave")
                        end
                    end
                end
                
                if shouldContinue() and not allGeneratorsFixed() then
                    task.wait(1)
                end
            end
        end

        if enabled then
            if _G.AutoFixThread then
                _G.AutoFixThreadId = tostring(math.random(1, 99999))
                task.cancel(_G.AutoFixThread)
            end
            _G.AutoFixThread = task.spawn(runGenerator)
        else
            _G.AutoFixThreadId = tostring(math.random(1, 99999))
            if _G.AutoFixThread then
                task.cancel(_G.AutoFixThread)
                _G.AutoFixThread = nil
            end
        end
    end
})




local ZZ = Tabs.zdx:AddRightGroupbox('切换服务器')

ZZ:AddButton({
    Text = "Switching server", 
    Func = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")
        local HttpService = game:GetService("HttpService")
        
        local requestFunc = http_request or syn.request or request
        if not requestFunc then return end
            
        local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        local response = requestFunc({Url = url, Method = "GET"})
        
        if response.StatusCode == 200 then
            local data = HttpService:JSONDecode(response.Body)
            if data and data.data and #data.data > 0 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, data.data[math.random(1, #data.data)].id, Players.LocalPlayer)
            end
        end
    end
})







local ZZ = Tabs.mhg:AddRightGroupbox('Noob Peter Skin')


ZZ:AddButton({
    Text = 'Noob Skin',
    Func = function()
        local character = player.Character or player.CharacterAdded:Wait()
        
      
        local bodyColors = character:FindFirstChild("Body Colors")
        if bodyColors then
            local black = BrickColor.new("Really black")
            bodyColors.HeadColor = black
            bodyColors.LeftArmColor = black
            bodyColors.RightArmColor = black
            bodyColors.LeftLegColor = black
            bodyColors.RightLegColor = black
            bodyColors.TorsoColor = black
        end

        -- Remove existing clothing
        for _, v in pairs(character:GetChildren()) do
            if v:IsA("Shirt") or v:IsA("Pants") then
                v:Destroy()
            end
        end

        -- Apply new shirt and pants
        local shirt = Instance.new("Shirt", character)
        shirt.ShirtTemplate = "http://www.roblox.com/asset/?id=15689522455"

        local pants = Instance.new("Pants", character)
        pants.PantsTemplate = "http://www.roblox.com/asset/?id=4959593720"

        -- Add Petah accessory
        local accessory = Instance.new("Accessory")
        accessory.Name = "Petah"

        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(1.54557204246521, 1.6104363203048706, 1.7840479612350464)
        handle.CanCollide = false
        handle.Anchored = false
        handle.Parent = accessory

        local mesh = Instance.new("SpecialMesh", handle)
        mesh.MeshId = "http://www.roblox.com/asset/?id=16059554270"
        mesh.TextureId = "http://www.roblox.com/asset/?id=16059557343"
        mesh.Scale = Vector3.new(1.1, 1.1, 1.1)

        local head = character:FindFirstChild("Head")
        if head then
            local weld = Instance.new("Weld")
            weld.Part0 = head
            weld.Part1 = handle
            weld.C0 = CFrame.new(0, -0.1, -0.05) * CFrame.Angles(math.rad(-177.024), math.rad(-4.698), math.rad(-179.757))
            weld.Parent = handle
        end

        accessory.Parent = character

        -- Make head invisible
        if head then
            head.Transparency = 1
            for _, decal in pairs(head:GetChildren()) do
                if decal:IsA("Decal") then
                    decal.Transparency = 1
                end
            end
        end

        -- Make expression invisible
        local ExpressionHolder = character:FindFirstChild("ExpressionHolder")
        if ExpressionHolder then
            local expression = ExpressionHolder:FindFirstChild("Expression")
            if expression then
                expression.Transparency = 1
            end
        end

        -- Remove hair
        local hair = character:FindFirstChild("CoolBoyHair")
        if hair then
            hair:Destroy()
        end
    end,
    HoverText = "应用Noob风格的美化效果"
})

ZZ:AddButton({
    Text = 'Clear skin',
    Func = function()
        local character = player.Character
        if not character then return end
        
        -- Reset body colors
        local bodyColors = character:FindFirstChild("Body Colors")
        if bodyColors then
            local default = BrickColor.new("Medium stone grey")
            bodyColors.HeadColor = default
            bodyColors.LeftArmColor = default
            bodyColors.RightArmColor = default
            bodyColors.LeftLegColor = default
            bodyColors.RightLegColor = default
            bodyColors.TorsoColor = default
        end
        
        -- Remove accessories
        for _, v in pairs(character:GetChildren()) do
            if v:IsA("Accessory") then
                v:Destroy()
            end
        end
        
        -- Remove clothing
        for _, v in pairs(character:GetChildren()) do
            if v:IsA("Shirt") or v:IsA("Pants") then
                v:Destroy()
            end
        end
        
        -- Make head visible again
        local head = character:FindFirstChild("Head")
        if head then
            head.Transparency = 0
            for _, decal in pairs(head:GetChildren()) do
                if decal:IsA("Decal") then
                    decal.Transparency = 0
                end
            end
        end
        
        -- Make expression visible again
        local ExpressionHolder = character:FindFirstChild("ExpressionHolder")
        if ExpressionHolder then
            local expression = ExpressionHolder:FindFirstChild("Expression")
            if expression then
                expression.Transparency = 0
            end
        end
    end,
    HoverText = "清除Noob风格的美化效果，恢复默认外观"
})


local ZZ = Tabs.mhg:AddLeftGroupbox('Guest skin')

ZZ:AddButton({
    Text = 'skin',
    Func = function()
        for _, v in pairs(player.Character:GetChildren()) do
            if v:IsA("Shirt") then
                v:Destroy()
            end

            if v:IsA("Pants") then
                v:Destroy()
            end
        end

        local headband = Instance.new("Accessory")
        local scarf = Instance.new("Accessory")
        local shirt = Instance.new("Shirt")
        local pants = Instance.new("Pants")

        local headbandhandle = Instance.new("Part")
        local scarfhandle = Instance.new("Part")
        local headbandhandleattach = Instance.new("Attachment")
        local scarfhandleattach = Instance.new("Attachment")
        local headbandweld = Instance.new("Weld")
        local scarfweld = Instance.new("Weld")

        scarfhandle.Name = "Handle"
        headbandhandle.Name = "Handle"
        scarfhandle.CanCollide = false
        headbandhandle.CanCollide = false

        local headbandmesh = Instance.new("SpecialMesh")
        local scarfmesh = Instance.new("SpecialMesh")

        shirt.ShirtTemplate = "http://www.roblox.com/asset/?id=836903658"
        pants.PantsTemplate = "http://www.roblox.com/asset/?id=731578592"
        shirt.Parent = player.Character
        pants.Parent = player.Character

        headband.Parent = player.Character
        scarf.Parent = player.Character
        scarfhandle.Parent = scarf
        headbandhandle.Parent = headband
        headbandhandleattach.Parent = headbandhandle
        scarfhandleattach.Parent = scarfhandle
        headbandmesh.Parent = headbandhandle
        scarfmesh.Parent = scarfhandle

        headbandhandle.Color = Color3.fromRGB(27, 42, 53)
        scarfhandle.Color = Color3.fromRGB(27, 42, 53)

        headbandweld.Parent = headbandhandle
        headbandweld.Name = "AccessoryWeld"
        headbandweld.Part0 = headbandhandle
        headbandweld.Part1 = player.Character.Head
        headbandweld.C0 = CFrame.new(0, 0, 0)
        headbandweld.C1 = CFrame.new(0, 0, 0)

        scarfweld.Parent = scarfhandle
        scarfweld.Name = "AccessoryWeld"
        scarfweld.Part0 = scarfhandle
        scarfweld.Part1 = player.Character.Torso
        scarfweld.C0 = CFrame.new(0, -0.4, 0)
        scarfweld.C1 = CFrame.new(0, 0, 0)

        headbandmesh.MeshId = "http://www.roblox.com/asset/?id=20407184"
        headbandmesh.Scale = Vector3.new(1.103, 1.071, 1.103)
        scarfmesh.MeshId = "http://www.roblox.com/asset/?id=99856331"
        scarfmesh.Scale = Vector3.new(1.071, 1.071, 1.071)
        scarfmesh.VertexColor = Vector3.new(1, 2, 1)

        headbandhandleattach.Name = "HatAttachment"
        headbandhandleattach.CFrame = CFrame.new(0, 0.557, 0)
        scarfhandleattach.Name = "NeckAttachment"
        scarfhandleattach.CFrame = CFrame.new(0, 0.519, 0)

        local playergui = player.PlayerGui
        local playerinfo = playergui.TemporaryUI.PlayerInfo
        playerinfo.PlayerIcon.Image = "http://www.roblox.com/asset/?id=97047410245118"
    end,
    HoverText = "为角色装备忍者服装和配件"
})


ZZ:AddButton({
    Text = 'Clear skin',
    Func = function()
        local character = player.Character
        if not character then return end
        
        for _, v in pairs(character:GetChildren()) do
            if v:IsA("Accessory") then
                v:Destroy()
            end
        end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            for _, v in pairs(character:GetChildren()) do
                if v:IsA("Shirt") or v:IsA("Pants") then
                    v:Destroy()
                end
            end
            
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                    if part.Name == "Head" then
                        for _, decal in pairs(part:GetChildren()) do
                            if decal:IsA("Decal") then
                                decal.Transparency = 0
                            end
                        end
                    end
                end
            end
            
            local playergui = player:FindFirstChild("PlayerGui")
            if playergui then
                local playerinfo = playergui:FindFirstChild("TemporaryUI")
                if playerinfo then
                    playerinfo = playerinfo:FindFirstChild("PlayerInfo")
                    if playerinfo then
                        playerinfo.PlayerIcon.Image = "rbxassetid://0"
                    end
                end
            end
        end
    end,
    HoverText = "清除所有美化效果，恢复默认外观"
})



local ZZ = Tabs.mhg:AddLeftGroupbox('Shedd skin')


local characterAccessories = {}
local originalFace = nil
local originalShirt = nil
local originalPants = nil
local isDressed = false

local function dressCharacter()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    originalFace = character:FindFirstChild("face")
    originalShirt = character:FindFirstChildOfClass("Shirt")
    originalPants = character:FindFirstChildOfClass("Pants")
    
    local shirt = character:FindFirstChildOfClass("Shirt") or Instance.new("Shirt", character)
    shirt.ShirtTemplate = "http://www.roblox.com/asset/?id=14248399102"
    
    local pants = character:FindFirstChildOfClass("Pants") or Instance.new("Pants", character)
    pants.PantsTemplate = "http://www.roblox.com/asset/?id=14248410313"
    
    local head = character:FindFirstChild("Head")
    if head then
        local face = head:FindFirstChild("face")
        if face then
            face:Destroy()
        end
    end
    
    local function addAccessory(name, meshId, textureId, parentPartName, handleSize, position, rotation, meshScale, meshOffset)
        local accessory = Instance.new("Accessory")
        accessory.Name = name
        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(unpack(handleSize))
        handle.CanCollide = false
        handle.Anchored = false
        handle.Parent = accessory
        
        local mesh = Instance.new("SpecialMesh", handle)
        mesh.MeshId = meshId
        if textureId ~= "" then
            mesh.TextureId = textureId
        end
        mesh.Scale = meshScale and Vector3.new(unpack(meshScale)) or Vector3.new(0.65, 0.65, 0.65)
        mesh.Offset = meshOffset and Vector3.new(unpack(meshOffset)) or Vector3.new(0, -0.55, 0)
        
        local targetPart = character:FindFirstChild(parentPartName)
        if not targetPart then return end
        
        local weld = Instance.new("Weld")
        weld.Part0 = targetPart
        weld.Part1 = handle
        weld.C0 = CFrame.new(unpack(position)) * CFrame.Angles(math.rad(rotation[1]), math.rad(rotation[2]), math.rad(rotation[3]))
        weld.Parent = handle
        
        table.insert(characterAccessories, accessory)
        accessory.Parent = character
    end
    
    addAccessory("Face", "rbxassetid://110562243236643", "rbxassetid://92220809340639", "Head", {1,1,1}, {0,0.55,0}, {0,180,0}, {1,1,1})
    addAccessory("Blade", "rbxassetid://18116147526", "rbxassetid://18955600612", "Right Arm", {1,1,1}, {-0.5,-1.1,-3.3}, {180,-100,0}, {1,1,1})
    addAccessory("Helmet", "rbxassetid://13252936277", "rbxassetid://13252949489", "Head", {1,1,1}, {0,0.8,0}, {0,0,0}, {1.1,1,1})
    addAccessory("Scarf", "rbxassetid://7459110498", "rbxassetid://7543326394", "Torso", {1,1,1}, {0,1.4,0}, {0,0,0}, {1,1,1})
    addAccessory("LeftSleeve", "rbxassetid://14886992040", "rbxassetid://14887049482", "Left Arm", {1,1,1}, {0,1.2,0}, {0,0,0}, {0.15,0.15,0.15})
    addAccessory("Hair", "rbxassetid://7666931987", "rbxassetid://7066058408", "Head", {1,1,1}, {0,-1.3,1.3}, {0,0,0}, {1,1,1})
    addAccessory("RightSleeve", "rbxassetid://7265541707", "rbxassetid://7265983163", "Right Arm", {1,1,1}, {0.25,1.5,0}, {0,0,0}, {1,1,1})
    
    local shedletsky = workspace.Players.Survivors:FindFirstChild("Shedletsky")
    if shedletsky then
        for _, child in ipairs({"ExpressionHolder", "ShedHair", "Sword"}) do
            local part = shedletsky:FindFirstChild(child)
            if part then part:Destroy() end
        end
    end
    
    isDressed = true
    ZZ:UpdateButton("美化", {Text = "移除装扮"})
end

local function cleanupDress()
    for _, accessory in ipairs(characterAccessories) do
        if accessory and accessory.Parent then
            accessory:Destroy()
        end
    end
    characterAccessories = {}
    
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character then
        local head = character:FindFirstChild("Head")
        if head and originalFace then
            originalFace:Clone().Parent = head
        end
        
        if originalShirt then
            originalShirt:Clone().Parent = character
        else
            local shirt = character:FindFirstChildOfClass("Shirt")
            if shirt then shirt:Destroy() end
        end
        
        if originalPants then
            originalPants:Clone().Parent = character
        else
            local pants = character:FindFirstChildOfClass("Pants")
            if pants then pants:Destroy() end
        end
    end
    
    isDressed = false
    ZZ:UpdateButton("谢德美化", {Text = "应用装扮"})
end

ZZ:AddButton("美化", {
    Text = isDressed and "移除装扮" or "应用装扮",
    Func = function()
        if isDressed then
            cleanupDress()
        else
            dressCharacter()
        end
    end
})

ZZ:AddButton("关闭美化", {
    Text = "关闭美化",
    Func = function()
        if isDressed then
            cleanupDress()
        else
            warn("装扮已经关闭")
        end
    end
})

game.Players.LocalPlayer.CharacterAdded:Connect(function()
    if isDressed then
        wait(1)
        dressCharacter()
    end
end)






local ZZ = Tabs.mhg:AddRightGroupbox('美化Marioso')

ZZ:AddButton("重做黑手党", {
    Text = '黑手党皮肤替换',
    Func = function()
        local oldassets = require(game.ReplicatedStorage.Assets.Skins.Killers.c00lkidd.MafiasoC00l.Config)
        game.ReplicatedStorage.Assets.Skins.Killers.c00lkidd.MafiasoC00l.Config:Destroy()
        game.ReplicatedStorage.Assets.Skins.Killers.c00lkidd["#MafiosoC00l"].Config:Clone().Parent = game.ReplicatedStorage.Assets.Skins.Killers.c00lkidd.MafiasoC00l
        game.ReplicatedStorage.Assets.Skins.Killers.c00lkidd.MafiasoC00l.Behavior:Destroy()
        game.ReplicatedStorage.Assets.Skins.Killers.c00lkidd["#MafiosoC00l"].Behavior:Clone().Parent = game.ReplicatedStorage.Assets.Skins.Killers.c00lkidd.MafiasoC00l
        game.ReplicatedStorage.Assets.Skins.Killers.c00lkidd["#MafiosoC00l"].CameraRig:Clone().Parent = game.ReplicatedStorage.Assets.Skins.Killers.c00lkidd.MafiasoC00l
        game.ReplicatedStorage.Assets.Skins.Killers.c00lkidd["#MafiosoC00l"].Behavior2:Clone().Parent = game.ReplicatedStorage.Assets.Skins.Killers.c00lkidd.MafiasoC00l
        
        local rigsource = game:GetObjects("rbxassetid://100745570500653")[1]
        rigsource.Parent = game.ReplicatedStorage
        
        local emoteTrack
        local emoteSound1
        local emoting = false
        local assets = require(game.ReplicatedStorage.Assets.Skins.Killers.c00lkidd["#MafiosoC00l"].Config)
        local minions = assets.Mafiasos
        local emoteButton
        local fakeEmoteButton

        function GetDescendants(tbl)
            local currentTbl = {}
            for i, v in pairs(tbl) do
                if type(v) == "table" then
                    for ind, val in pairs(GetDescendants(v)) do
                        table.insert(currentTbl, val)
                    end
                else
                    table.insert(currentTbl, v)
                end
            end
            return currentTbl
        end

        game:GetService("UserInputService").InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.G then
                emoting = false
                if emoteTrack then
                    emoteTrack:Stop()
                    emoteSound1:Stop()
                end
            end
        end)

        function setup()
            local rig = rigsource:Clone()
            rig.Parent = game.Players.LocalPlayer.Character
            local parttable = {}
            for i, v in ipairs(rig:GetChildren()) do
                if v:IsA("BasePart") then
                    if v.Name ~= "HumanoidRootPart" then
                        table.insert(parttable, {["Original"] = game.Players.LocalPlayer.Character:FindFirstChild(v.Name), ["new"] = v})
                    end
                end
            end
            game.Players.LocalPlayer.Character["Left Arm"].WalkieTalkie.Part0 = game.Players.LocalPlayer.Character["Right Arm"]
            for i, v in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") and not v:FindFirstAncestor("Mafioso") then
                    if v.Name ~= "firebrand" and v.Name ~= "WalkieTalkie" then
                        v.Transparency = 1
                        v.Changed:Connect(function(str)
                            if str == "Transparency" then
                                v.Transparency = 1
                            end
                        end)
                    end
                end
            end
            for i, v in ipairs(parttable) do
                local weld = Instance.new("Weld")
                weld.Parent = v["new"]
                weld.Part0 = v["new"]
                weld.Part1 = v["Original"]
            end
            connection = game.Players.LocalPlayer.Character.HumanoidRootPart.ChildAdded:Connect(function(v)
                if active then
                    if v:IsA("Sound") and table.find(GetDescendants(assets.Voicelines), v.SoundId) then
                        v:Destroy()
                    end
                else
                    connection:Disconnect()
                end
            end)
            game.Players.LocalPlayer.Character.Changed:Connect(function(str)
                if str == "Parent" then
                    rig:Destroy()
                end
            end)
            game.Players.LocalPlayer.Character.Humanoid.AnimationPlayed:Connect(function(track)
                if track.Animation.AnimationId == "rbxassetid://80139543732416" then
                    local anim = Instance.new("Animation") 
                    anim.AnimationId = "rbxassetid://117334224937914"
                    local Track = game.Players.LocalPlayer.Character.Humanoid.Animator:LoadAnimation(anim)
                    Track.Priority = Enum.AnimationPriority.Action4
                    Track:Play()
                    Track:AdjustSpeed(Track.Length/3.875)
                end
            end)
        end

        function playSound(SoundId, Volume, Parent, Loop)
            local sound = Instance.new("Sound", Parent)
            sound.SoundId = SoundId
            sound.Volume = Volume
            sound.Looped = Loop
            sound:Play()
            return sound
        end

        game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
            if char.Name == "c00lkidd" and game.Players.LocalPlayer.PlayerData.Equipped.Skins.c00lkidd.Value == "MafiasoC00l" then
                active = true
                task.spawn(setup)
            else
                active = false
            end
            
            wait(0.1)
            for i, v in ipairs(game.Players.LocalPlayer.PlayerGui.TopbarStandard.Holders.Left:GetChildren()) do
                if v.Name == "Widget" then
                    if v.IconButton.Menu.IconSpot.Contents.IconLabelContainer.IconLabel.Text == "Emote" then
                        emoteButton = v
                        fakeEmoteButton = emoteButton:Clone()
                        fakeEmoteButton.Name = 'fake'
                    end
                end
            end

            if fakeEmoteButton then
                fakeEmoteButton.IconButton.Menu.IconSpot.ClickRegion.MouseButton1Down:Connect(function()
                    emoting = false
                    if emoteTrack then
                        emoteTrack:Stop(0)
                        emoteSound1:Stop()
                    end
                end)
            end
        end)

        local hook;
        hook = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local args = {...}
            if self == game.ReplicatedStorage.Modules.Network.RemoteEvent then
                if not checkcaller() and (getnamecallmethod() == "FireServer" or getnamecallmethod() == "InvokeServer") then
                    if args[3] == "Snap" and args[1] == "PlayEmote" then
                        emoting = true
                        local anim = Instance.new("Animation") 
                        anim.AnimationId = assets.Emotes.Animations.Snap.AssetID
                        emoteTrack = game.Players.LocalPlayer.Character.Humanoid.Animator:LoadAnimation(anim)
                        emoteTrack.Looped = true
                        emoteTrack.Priority = Enum.AnimationPriority.Action4
                        emoteTrack:Play(0)
                        emoteSound1 = playSound(assets.Emotes.Animations.Snap.SFX, 0.5, game.Players.LocalPlayer.Character.PrimaryPart, true)
                        
                        if emoteButton then
                            emoteButton.Parent = game.ReplicatedStorage
                        end
                        if fakeEmoteButton then
                            fakeEmoteButton.Parent = game.Players.LocalPlayer.PlayerGui.TopbarStandard.Holders.Left
                        end
                        
                        local char = game.Players.LocalPlayer.Character
                        repeat
                            task.wait()
                            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 6
                        until emoting == false or char.Parent == nil
                        
                        emoting = false
                        fakeEmoteButton.Parent = game.ReplicatedStorage
                        if emoteButton then
                            emoteButton.Parent = game.Players.LocalPlayer.PlayerGui.TopbarStandard.Holders.Left
                        end
                    end
                end
            end
            return hook(self, ...)
        end))

        workspace.Map.Ingame.ChildAdded:Connect(function(v)
            if active then
                if string.find(v.Name, "Mafiaso") then
                    local died = false
                    local minion = minions[math.random(1, 4)]:Clone()
                    minion.Parent = workspace
                    
                    for i, val in ipairs(v:GetDescendants()) do
                        if val:IsA("BasePart") then
                            val.Transparency = 1
                            val.Changed:Connect(function(str)
                                if str == "Transparency" then
                                    val.Transparency = 1
                                end
                            end)
                        elseif val:IsA("Decal") then
                            val.Transparency = 1
                        elseif val:IsA("SelectionBox") and minion:FindFirstChild(val.Parent.Name) then
                            val.Adornee = minion:FindFirstChild(val.Parent.Name)
                        end
                    end
                    
                    task.spawn(function()
                        repeat
                            task.wait()
                            if v.Parent ~= nil then
                                minion.HumanoidRootPart.CFrame = v.PrimaryPart.CFrame
                            end
                        until v.Parent == nil
                        minion:Destroy()
                    end)
                    
                    v:WaitForChild("Humanoid")
                    local idleanim = Instance.new("Animation")
                    idleanim.AnimationId = assets.PizzaDeliveryAnimations.Idle
                    idleanim = minion.Humanoid.Animator:LoadAnimation(idleanim)
                    idleanim.Looped = true
                    
                    local runanim = Instance.new("Animation")
                    runanim.AnimationId = assets.PizzaDeliveryAnimations.Walk
                    runanim = minion.Humanoid.Animator:LoadAnimation(runanim)
                    runanim.Looped = true
                    
                    v:FindFirstChildOfClass("Humanoid").AnimationPlayed:Connect(function(track)
                        if track.Animation.AnimationId == oldassets.PizzaDeliveryAnimations.Hit then
                            local anim = Instance.new("Animation")
                            anim.AnimationId = assets.PizzaDeliveryAnimations.Hit
                            anim = minion.Humanoid.Animator:LoadAnimation(anim)
                            runanim:Stop()
                            anim:Play()
                        end
                    end)
                    
                    local introanim = Instance.new("Animation")
                    introanim.AnimationId = assets.PizzaDeliveryAnimations.Summoned
                    introanim = minion.Humanoid.Animator:LoadAnimation(introanim)
                    introanim:Play()
                    introanim.Stopped:Wait()
                    idleanim:Play()
                    v:FindFirstChildOfClass("Humanoid").AnimationPlayed:Wait()
                    idleanim:Stop()
                    runanim:Play()
                    
                elseif v.Name == "Bunny" then
                    v:WaitForChild("Head").Transparency = 1
                    v.Head:WaitForChild("Classic Default Face").Transparency = 1
                    v:WaitForChild("Torso").Transparency = 1
                    v:WaitForChild("Wedge").Transparency =1
                    
                    local suitcase = game.ReplicatedStorage.Assets.Instances.SuitcaseBase:Clone()
                    suitcase.Anchored = false
                    suitcase.Massless = true
                    suitcase.Parent = v
                    local weld = Instance.new("Weld")
                    weld.Parent = suitcase
                    weld.Part0 = suitcase
                    weld.Part1 = v.Torso
                end
            end
        end)
    end,
    HoverText = "替换c00lkidd角色为黑手党皮肤"
})


ZZ:AddButton("清除黑手党修改", {
    Text = '清除黑手党修改',
    Func = function()
        -- Reset the original files if they exist in ReplicatedStorage
        if game.ReplicatedStorage:FindFirstChild("OriginalMafiasoC00lConfig") then
            game.ReplicatedStorage.Assets.Skins.Killers.c00lkidd.MafiasoC00l.Config:Destroy()
            game.ReplicatedStorage.OriginalMafiasoC00lConfig:Clone().Parent = game.ReplicatedStorage.Assets.Skins.Killers.c00lkidd.MafiasoC00l
        end
        
        if game.ReplicatedStorage:FindFirstChild("OriginalMafiasoC00lBehavior") then
            game.ReplicatedStorage.Assets.Skins.Killers.c00lkidd.MafiasoC00l.Behavior:Destroy()
            game.ReplicatedStorage.OriginalMafiasoC00lBehavior:Clone().Parent = game.ReplicatedStorage.Assets.Skins.Killers.c00lkidd.MafiasoC00l
        end
        
        -- Remove any cloned rigs
        if game.Players.LocalPlayer.Character then
            for _, child in ipairs(game.Players.LocalPlayer.Character:GetChildren()) do
                if child.Name == "MafiosoRig" then
                    child:Destroy()
                end
            end
        end
        
        -- Reset character transparency
        if game.Players.LocalPlayer.Character then
            for _, part in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                end
            end
        end
        
        -- Remove any fake emote buttons
        if game.Players.LocalPlayer:FindFirstChild("PlayerGui") then
            local fakeButton = game.Players.LocalPlayer.PlayerGui.TopbarStandard.Holders.Left:FindFirstChild("fake")
            if fakeButton then
                fakeButton:Destroy()
            end
        end
        
        -- Restore original emote functionality
        if game.ReplicatedStorage:FindFirstChild("OriginalEmoteButton") then
            local original = game.ReplicatedStorage.OriginalEmoteButton
            if original then
                original.Parent = game.Players.LocalPlayer.PlayerGui.TopbarStandard.Holders.Left
            end
        end
        
        -- Clean up any minion replacements
        for _, minion in ipairs(workspace:GetChildren()) do
            if minion.Name == "MafiasoReplacement" then
                minion:Destroy()
            end
        end
        
        -- Clean up any suitcase replacements
        for _, bunny in ipairs(workspace.Map.Ingame:GetChildren()) do
            if bunny.Name == "Bunny" and bunny:FindFirstChild("SuitcaseBase") then
                bunny.SuitcaseBase:Destroy()
                if bunny:FindFirstChild("Head") then
                    bunny.Head.Transparency = 0
                    if bunny.Head:FindFirstChild("Classic Default Face") then
                        bunny.Head["Classic Default Face"].Transparency = 0
                    end
                end
                if bunny:FindFirstChild("Torso") then
                    bunny.Torso.Transparency = 0
                end
                if bunny:FindFirstChild("Wedge") then
                    bunny.Wedge.Transparency = 0
                end
            end
        end
        
        -- Reset walkie talkie attachment if it exists
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Left Arm") then
            local leftArm = game.Players.LocalPlayer.Character["Left Arm"]
            if leftArm:FindFirstChild("WalkieTalkie") then
                leftArm.WalkieTalkie.Part0 = leftArm
            end
        end
    end,
    HoverText = "清除所有黑手党皮肤修改并恢复原始设置"
})





