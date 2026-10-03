--zynb
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- ========== 连接管理 ==========
local AllConnections = {}

local function trackConnection(connection)
    if connection then
        table.insert(AllConnections, connection)
    end
    return connection
end

local function disconnectAll()
    for _, conn in ipairs(AllConnections) do
        pcall(function()
            if conn and typeof(conn) == "RBXScriptConnection" and conn.Connected then
                conn:Disconnect()
            end
        end)
    end
    AllConnections = {}
end

-- 清理上次执行残留
disconnectAll()

-- ========== 动画清理 ==========
local function isValidAnimationId(id)
    local num = tostring(id):match("%d+")
    if not num then return false end
    if tostring(id) ~= num then return false end
    return true
end

local function setAnimationId(anim, value)
    pcall(function()
        anim.AnimationId = value
    end)
end

local function sanitizeAnimation(anim)
    if not anim or not anim:IsA("Animation") then return end

    local ok, rawId = pcall(function()
        return anim.AnimationId
    end)
    if not ok then return end

    local id = tostring(rawId):match("%d+")
    if not id or not isValidAnimationId(id) then
        setAnimationId(anim, "")
    else
        setAnimationId(anim, "rbxassetid://" .. id)
    end
end

trackConnection(game.DescendantAdded:Connect(function(obj)
    if obj:IsA("Animation") then
        sanitizeAnimation(obj)
    end
end))

for _, v in ipairs(game:GetDescendants()) do
    if v:IsA("Animation") then
        sanitizeAnimation(v)
    end
end

-- ========== 远程加载 ==========
local function loadRemote(url)
    local ok, result = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok or not result or #result < 10 then
        return false, "HttpGet failed"
    end
    return true, result
end

if not loadstring then
    warn("[zy暴力区] 当前环境不支持 loadstring，无法加载 UI")
    return
end

local function compile(code)
    local func, err = loadstring(code)
    if not func then
        return false, err
    end
    local ok, result = pcall(func)
    if not ok then
        return false, result
    end
    return true, result
end

local success, content = loadRemote("https://raw.githubusercontent.com/SyndromeXph/Luoye-Pro-Hub/refs/heads/main/Wind.lua")
if not success then
    warn("[zy暴力区] 无法加载 Wind UI:", content)
    return
end

local modified = content:gsub("game%.Players", "game:GetService('Players')")
local ok, result = compile(modified)

if not ok then
    ok, result = compile(content)
    if not ok then
        warn("[zy暴力区] Wind UI 编译失败:", result)
        return
    end
end

local WindUI = result

-- ========== 主窗口 ==========
local Window = WindUI:CreateWindow({
    User = {
        Enabled = false,
        Callback = function() end,
        Anonymous = false,
    },
    Title = "zy暴力区",
    Author = "暴力区/作者zy",
    IconThemed = false,
    ScrollBarEnabled = true,
    Folder = "wind ui",
    HideSearchBar = true,
    Transparent = true,
    SideBarWidth = 200,
    Theme = "Dark",
    Icon = "crown",
    Size = UDim2.fromOffset(550, 300),
})

Window:EditOpenButton({
    Title = "zy暴力区",
    Icon = "crown",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
    Active = true,
    Color = ColorSequence.new(
        Color3.fromRGB(120, 170, 255),
        Color3.fromRGB(235, 240, 255)
    )
})

-- ========== FPS 标签 ==========
local fpsTag = Window:Tag({
    Title = "FPS: 0",
    Icon = "",
    Color = Color3.fromRGB(180, 255, 255),
    Radius = 13,
})

local frames, elapsed = 0, 0
trackConnection(RunService.RenderStepped:Connect(function(dt)
    frames += 1
    elapsed += dt
    if elapsed >= 0.5 then
        local fps = math.floor(frames / elapsed + 0.5)
        pcall(function()
            if fpsTag.SetTitle then
                fpsTag:SetTitle("FPS: " .. fps)
            else
                fpsTag.Title = "FPS: " .. fps
            end
        end)
        frames, elapsed = 0, 0
    end
end))

Window:Tag({
    Title = "版本v1.0",
    Icon = "",
    Color = Color3.fromRGB(180, 255, 255),
    Radius = 13,
})

-- ========== Tab 兼容层 ==========
do
    local orig = Window.Tab
    function Window:Tab(cfg)
        if not cfg.Collapsible then
            return orig(self, cfg)
        end
        local sec = self:Section({
            Title = cfg.Title,
            Icon = cfg.Icon,
            Opened = cfg.Opened ~= false,
        })
        local proxy = setmetatable({}, { __index = sec })
        function proxy:Tab(sc)
            return sec:Tab(sc)
        end
        return proxy
    end
end

local king = Window:Tab({
    Title = "通用列表",
    Collapsible = true,
    Opened = true,
    Locked = false,
})

local espTab = king:Tab({
    Title = "ESP/透视",
})

local survivor = Window:Tab({
    Title = "幸存者列表",
    Collapsible = true,
    Opened = true,
    Locked = false,
})

local dynTab = survivor:Tab({
    Title = "发电机",
})

local Killer = Window:Tab({
    Title = "杀手列表",
    Collapsible = true,
    Opened = true,
    Locked = false,
})

local autTab = Killer:Tab({
    Title = "自动攻击",
})

-- ========== ESP 配置 ==========
local Config = {
    ESP = {
        Killer = false,
        Survivor = false,
        Generator = false,
        Gate = false,
        Hook = false,
        Pallet = false,
        Window = false,
        ShowOnlyClosestHook = false,
        ShowDistance = true,
        MaxDistance = 500,
    },
    Performance = {
        UpdateRate = 0.5,
        UseDistanceCulling = true,
        MaxESPObjects = 100,
    },
}

local Highlights = {}
local BillboardGuis = {}
local LastUpdate = 0
local UpdateConnection = nil

local function getCharacterRootPart()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

local function getMap()
    return Workspace:FindFirstChild("Map")
end

local function validateInstance(instance)
    return instance and typeof(instance) == "Instance" and instance.Parent ~= nil
end

local function safeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("[zy暴力区] safeCall error:", result)
        return nil
    end
    return result
end

-- ========== Highlight ==========
local function createHighlight(obj, color)
    if not validateInstance(obj) then return end
    if Highlights[obj] and validateInstance(Highlights[obj]) then return end
    if Highlights[obj] then Highlights[obj] = nil end

    local existingH = obj:FindFirstChild("H")
    if existingH then existingH:Destroy() end

    safeCall(function()
        local h = Instance.new("Highlight")
        h.Name = "H"
        h.Adornee = obj
        h.FillColor = color
        h.OutlineColor = color
        h.FillTransparency = 0.5
        h.OutlineTransparency = 0
        h.Parent = obj
        Highlights[obj] = h
    end)
end

local function removeHighlight(obj)
    if not obj then return end
    if Highlights[obj] then
        safeCall(function()
            if validateInstance(Highlights[obj]) then
                Highlights[obj]:Destroy()
            end
        end)
        Highlights[obj] = nil
    end
    local existingH = obj:FindFirstChild("H")
    if existingH then
        pcall(function() existingH:Destroy() end)
    end
end

-- ========== Billboard Label ==========
local function createLabel(obj, text, color)
    if not validateInstance(obj) then return end
    local playerRoot = getCharacterRootPart()
    if not playerRoot then return end

    local rootPart = obj:IsA("Model") and obj:FindFirstChildWhichIsA("BasePart")
        or (obj:IsA("BasePart") and obj or nil)
    if not rootPart then return end

    local distance = (playerRoot.Position - rootPart.Position).Magnitude

    if Config.Performance.UseDistanceCulling and distance > Config.ESP.MaxDistance then
        if BillboardGuis[obj] and validateInstance(BillboardGuis[obj]) then
            safeCall(function() BillboardGuis[obj]:Destroy() end)
            BillboardGuis[obj] = nil
        end
        return
    end

    if BillboardGuis[obj] and validateInstance(BillboardGuis[obj]) then
        local textLabel = BillboardGuis[obj]:FindFirstChild("TextLabel")
        if textLabel then
            textLabel.Text = Config.ESP.ShowDistance
                and string.format("%s\n%.0fm", text, distance)
                or text
        end
        return
    end

    BillboardGuis[obj] = nil
    safeCall(function()
        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 140, 0, 35)
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.Adornee = rootPart
        billboard.Parent = obj

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = color
        textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        textLabel.TextStrokeTransparency = 0
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextScaled = true
        textLabel.Text = Config.ESP.ShowDistance
            and string.format("%s\n%.0fm", text, distance)
            or text
        textLabel.Parent = billboard

        BillboardGuis[obj] = billboard
    end)
end

local function removeLabel(obj)
    if not obj then return end
    if BillboardGuis[obj] then
        safeCall(function()
            if validateInstance(BillboardGuis[obj]) then
                BillboardGuis[obj]:Destroy()
            end
        end)
        BillboardGuis[obj] = nil
    end
end

local function clearAllESP()
    for obj, _ in pairs(Highlights) do
        removeHighlight(obj)
    end
    for obj, _ in pairs(BillboardGuis) do
        removeLabel(obj)
    end
    Highlights = {}
    BillboardGuis = {}
end

-- ========== ESP 更新 ==========
local function updatePlayerESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Team then
            local teamName = player.Team.Name
            if teamName == "Killer" and Config.ESP.Killer then
                createHighlight(player.Character, Color3.fromRGB(255, 0, 0))
                createLabel(player.Character, player.Name .. "\n[杀手]", Color3.fromRGB(255, 0, 0))
            elseif teamName == "Survivors" and Config.ESP.Survivor then
                createHighlight(player.Character, Color3.fromRGB(0, 255, 0))
                createLabel(player.Character, player.Name .. "\n[幸存者]", Color3.fromRGB(0, 255, 0))
            else
                removeHighlight(player.Character)
                removeLabel(player.Character)
            end
        end
    end
end

-- 合并物体 ESP：一次遍历 Map 处理发电机/大门/木板/窗户
local function updateObjectESP()
    local wantGen = Config.ESP.Generator
    local wantGate = Config.ESP.Gate
    local wantPallet = Config.ESP.Pallet
    local wantWindow = Config.ESP.Window

    if not (wantGen or wantGate or wantPallet or wantWindow) then return end

    local map = getMap()
    if not map then return end

    for _, obj in ipairs(map:GetDescendants()) do
        if obj:IsA("Model") then
            local n = obj.Name
            if wantGen and n == "Generator" then
                createHighlight(obj, Color3.fromRGB(203, 132, 66))
                createLabel(obj, "发电机", Color3.fromRGB(203, 132, 66))
            elseif wantGate and n == "Gate" then
                createHighlight(obj, Color3.fromRGB(255, 255, 255))
                createLabel(obj, "大门", Color3.fromRGB(255, 255, 255))
            elseif wantPallet and n == "Palletwrong" then
                createHighlight(obj, Color3.fromRGB(255, 255, 0))
                createLabel(obj, "木板", Color3.fromRGB(255, 255, 0))
            elseif wantWindow and n == "Window" then
                createHighlight(obj, Color3.fromRGB(173, 216, 230))
                createLabel(obj, "窗户", Color3.fromRGB(173, 216, 230))
            end
        end
    end
end

local function updateHookESP()
    if not Config.ESP.Hook then return end
    local map = getMap()
    if not map then return end

    local hooks = {}
    for _, obj in ipairs(map:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == "Hook" then
            table.insert(hooks, obj)
        end
    end

    if Config.ESP.ShowOnlyClosestHook then
        local hrp = getCharacterRootPart()
        if not hrp then return end

        local closestHook = nil
        local closestDist = math.huge

        for _, obj in ipairs(hooks) do
            local hookPart = obj:FindFirstChildWhichIsA("BasePart")
            if hookPart then
                local dist = (hookPart.Position - hrp.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closestHook = obj
                end
            end
        end

        for _, obj in ipairs(hooks) do
            removeHighlight(obj)
            removeLabel(obj)
            if obj:FindFirstChild("Model") then
                for _, part in ipairs(obj.Model:GetDescendants()) do
                    if part:IsA("MeshPart") then removeHighlight(part) end
                end
            end
        end

        if closestHook then
            if closestHook:FindFirstChild("Model") then
                for _, part in ipairs(closestHook.Model:GetDescendants()) do
                    if part:IsA("MeshPart") then
                        createHighlight(part, Color3.fromRGB(255, 255, 0))
                    end
                end
            end
            createLabel(closestHook, "最近的狂欢之椅", Color3.fromRGB(255, 255, 0))
        end
    else
        for _, obj in ipairs(hooks) do
            if obj:FindFirstChild("Model") then
                for _, part in ipairs(obj.Model:GetDescendants()) do
                    if part:IsA("MeshPart") then
                        createHighlight(part, Color3.fromRGB(255, 0, 0))
                    end
                end
            end
            createLabel(obj, "狂欢之椅", Color3.fromRGB(255, 0, 0))
        end
    end
end

local function updateAllESP()
    local currentTime = tick()
    if currentTime - LastUpdate < Config.Performance.UpdateRate then return end
    LastUpdate = currentTime

    local espCount = 0
    for obj, h in pairs(Highlights) do
        if not validateInstance(obj) or not validateInstance(h) then
            Highlights[obj] = nil
        else
            espCount = espCount + 1
        end
    end

    for obj, gui in pairs(BillboardGuis) do
        if not validateInstance(obj) or not validateInstance(gui) then
            BillboardGuis[obj] = nil
        end
    end

    if espCount >= Config.Performance.MaxESPObjects then return end

    safeCall(updatePlayerESP)
    safeCall(updateObjectESP)
    safeCall(updateHookESP)
end

local function startESP()
    if UpdateConnection then return end
    UpdateConnection = trackConnection(RunService.Heartbeat:Connect(updateAllESP))
end

local function stopESP()
    if UpdateConnection then
        UpdateConnection:Disconnect()
        UpdateConnection = nil
    end
    clearAllESP()
end

-- ========== ESP UI ==========
espTab:Section({
    Title = "玩家 ESP",
    Box = true,
    Opened = true,
})

espTab:Toggle({
    Title = "杀手 ESP",
    Value = false,
    Callback = function(state)
        Config.ESP.Killer = state
        if state then startESP() else
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Team and player.Team.Name == "Killer" then
                    removeHighlight(player.Character)
                    removeLabel(player.Character)
                end
            end
        end
    end
})

espTab:Toggle({
    Title = "幸存者 ESP",
    Value = false,
    Callback = function(state)
        Config.ESP.Survivor = state
        if state then startESP() else
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Team and player.Team.Name == "Survivors" then
                    removeHighlight(player.Character)
                    removeLabel(player.Character)
                end
            end
        end
    end
})

espTab:Section({
    Title = "物体 ESP",
    Box = true,
    Opened = true,
})

espTab:Toggle({
    Title = "发电机 ESP",
    Value = false,
    Callback = function(state)
        Config.ESP.Generator = state
        if state then startESP() else
            local map = getMap()
            if map then
                for _, obj in ipairs(map:GetDescendants()) do
                    if obj:IsA("Model") and obj.Name == "Generator" then
                        removeHighlight(obj)
                        removeLabel(obj)
                    end
                end
            end
        end
    end
})

espTab:Toggle({
    Title = "大门 ESP",
    Value = false,
    Callback = function(state)
        Config.ESP.Gate = state
        if state then startESP() else
            local map = getMap()
            if map then
                for _, obj in ipairs(map:GetDescendants()) do
                    if obj:IsA("Model") and obj.Name == "Gate" then
                        removeHighlight(obj)
                        removeLabel(obj)
                    end
                end
            end
        end
    end
})

espTab:Toggle({
    Title = "狂欢之椅 ESP",
    Value = false,
    Callback = function(state)
        Config.ESP.Hook = state
        if state then startESP() else
            local map = getMap()
            if map then
                for _, obj in ipairs(map:GetDescendants()) do
                    if obj:IsA("Model") and obj.Name == "Hook" then
                        removeHighlight(obj)
                        removeLabel(obj)
                        if obj:FindFirstChild("Model") then
                            for _, part in ipairs(obj.Model:GetDescendants()) do
                                if part:IsA("MeshPart") then removeHighlight(part) end
                            end
                        end
                    end
                end
            end
        end
    end
})

espTab:Toggle({
    Title = "仅显示最近的狂欢之椅",
    Value = false,
    Callback = function(state)
        Config.ESP.ShowOnlyClosestHook = state
        local map = getMap()
        if map then
            for _, obj in ipairs(map:GetDescendants()) do
                if obj:IsA("Model") and obj.Name == "Hook" then
                    removeHighlight(obj)
                    removeLabel(obj)
                end
            end
        end
        if Config.ESP.Hook then updateHookESP() end
    end
})

espTab:Toggle({
    Title = "木板 ESP",
    Value = false,
    Callback = function(state)
        Config.ESP.Pallet = state
        if state then startESP() else
            local map = getMap()
            if map then
                for _, obj in ipairs(map:GetDescendants()) do
                    if obj:IsA("Model") and obj.Name == "Palletwrong" then
                        removeHighlight(obj)
                        removeLabel(obj)
                    end
                end
            end
        end
    end
})

espTab:Toggle({
    Title = "窗户 ESP",
    Value = false,
    Callback = function(state)
        Config.ESP.Window = state
        if state then startESP() else
            local map = getMap()
            if map then
                for _, obj in ipairs(map:GetDescendants()) do
                    if obj:IsA("Model") and obj.Name == "Window" then
                        removeHighlight(obj)
                        removeLabel(obj)
                    end
                end
            end
        end
    end
})

espTab:Section({
    Title = "ESP其他设置",
    Box = true,
    Opened = true,
})

espTab:Toggle({
    Title = "显示距离",
    Value = true,
    Callback = function(state)
        Config.ESP.ShowDistance = state
        local playerRoot = getCharacterRootPart()
        if not playerRoot then return end

        for obj, gui in pairs(BillboardGuis) do
            if validateInstance(gui) then
                local textLabel = gui:FindFirstChild("TextLabel")
                if textLabel then
                    local rootPart = gui.Adornee
                    if rootPart and validateInstance(rootPart) then
                        local baseText = textLabel.Text:match("^(.-)\n") or textLabel.Text
                        if state then
                            local dist = (playerRoot.Position - rootPart.Position).Magnitude
                            textLabel.Text = string.format("%s\n%.0fm", baseText, dist)
                        else
                            textLabel.Text = baseText
                        end
                    end
                end
            end
        end
    end
})

-- ========== 视觉功能 ==========
espTab:Section({
    Title = "视觉设置",
    Box = true,
    Opened = true,
})

local Lighting = game:GetService("Lighting")
local Camera = Workspace.CurrentCamera

-- 保存原始值，关闭时还原
local VisualOriginal = {
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    FOV = Camera and Camera.FieldOfView or 70,
}

espTab:Toggle({
    Title = "全亮",
    Value = false,
    Callback = function(state)
        if state then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.GlobalShadows = false
        else
            Lighting.Ambient = VisualOriginal.Ambient
            Lighting.OutdoorAmbient = VisualOriginal.OutdoorAmbient
            Lighting.GlobalShadows = VisualOriginal.GlobalShadows
        end
    end
})

espTab:Toggle({
    Title = "去雾",
    Value = false,
    Callback = function(state)
        if state then
            Lighting.FogEnd = 100000
            Lighting.FogStart = 100000
        else
            Lighting.FogEnd = VisualOriginal.FogEnd
            Lighting.FogStart = VisualOriginal.FogStart
        end
    end
})

espTab:Slider({
    Title = "视野 FOV",
    Value = {
        Min = 70,
        Max = 120,
        Default = 70
    },
    Callback = function(value)
        local cam = Workspace.CurrentCamera
        if cam then
            cam.FieldOfView = value
        end
    end
})

-- 防致盲：监听致盲效果并移除
local AntiBlindEnabled = false
local AntiBlindConnection = nil

local function isBlindEffect(obj)
    if not obj or not obj:IsA("Instance") then return false end
    local name = obj.Name:lower()
    return name:find("blind")
        or name:find("flash")
        or name:find("致盲")
        or obj:IsA("ColorCorrectionEffect")
        or obj:IsA("BlurEffect")
end

local function removeBlindEffects()
    local cam = Workspace.CurrentCamera
    if not cam then return end
    for _, obj in ipairs(cam:GetChildren()) do
        if isBlindEffect(obj) then
            pcall(function() obj:Destroy() end)
        end
    end
    for _, obj in ipairs(Lighting:GetChildren()) do
        if isBlindEffect(obj) then
            pcall(function() obj:Destroy() end)
        end
    end
end

espTab:Toggle({
    Title = "防致盲",
    Value = false,
    Callback = function(state)
        AntiBlindEnabled = state
        if state then
            removeBlindEffects()
            AntiBlindConnection = trackConnection(
                Workspace.DescendantAdded:Connect(function(obj)
                    if AntiBlindEnabled and isBlindEffect(obj) then
                        task.defer(function()
                            pcall(function() obj:Destroy() end)
                        end)
                    end
                end)
            )
        else
            if AntiBlindConnection then
                AntiBlindConnection:Disconnect()
                AntiBlindConnection = nil
            end
        end
    end
})

-- ========== 发电机 ==========
dynTab:Section({
    Title = "发电机设置",
    Box = true,
    Opened = true,
})

local AutoGeneratorEnabled = false
local GeneratorMode = "great"

dynTab:Toggle({
    Title = "自动完成发电机",
    Value = false,
    Callback = function(state)
        AutoGeneratorEnabled = state
    end
})

dynTab:Dropdown({
    Title = "发电机模式",
    Values = {
        "快速",
        "慢速"
    },
    Value = "快速",
    Callback = function(option)
        if option == "快速" then
            GeneratorMode = "great"
        else
            GeneratorMode = "normal"
        end
    end
})

task.spawn(function()
    while true do
        task.wait(0.2)
        if AutoGeneratorEnabled then
            pcall(function()
                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                if not remotes then return end
                local genRemotes = remotes:FindFirstChild("Generator")
                if not genRemotes then return end
                local repairEvent = genRemotes:FindFirstChild("RepairEvent")
                local skillCheckEvent = genRemotes:FindFirstChild("SkillCheckResultEvent")
                if not repairEvent or not skillCheckEvent then return end

                local map = getMap()
                if not map then return end

                for _, obj in ipairs(map:GetDescendants()) do
                    if obj:IsA("Model") and obj.Name == "Generator" then
                        for _, point in ipairs(obj:GetChildren()) do
                            if point.Name:find("GeneratorPoint") then
                                repairEvent:FireServer(point, true)
                                local result = (GeneratorMode == "great") and "success" or "neutral"
                                local value  = (GeneratorMode == "great") and 1 or 0
                                skillCheckEvent:FireServer(result, value, obj, point)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ========== 自动攻击 ==========
autTab:Section({
    Title = "杀戮光环（低配版）",
    Box = true,
    Opened = true,
})

local AutoAttackEnabled = false
local AttackRange = 10
local AutoAttackConnection = nil
local lastAttackTime = 0
local ATTACK_COOLDOWN = 0.3

local function isKiller()
    return LocalPlayer.Team and LocalPlayer.Team.Name == "Killer"
end

local function isAlive(player)
    local char = player.Character
    if not char then return false end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    return humanoid.Health > 0
end

local function findClosestSurvivor()
    if not isKiller() then return nil, nil end
    local hrp = getCharacterRootPart()
    if not hrp then return nil, nil end

    local closestPlayer = nil
    local closestDist = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer
            and player.Team
            and player.Team.Name == "Survivors"
            and isAlive(player)
        then
            local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local dist = (targetHRP.Position - hrp.Position).Magnitude
                if dist < closestDist and dist <= AttackRange then
                    closestDist = dist
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer, closestDist
end

local function performAutoAttack()
    if not isKiller() then return end
    local target = findClosestSurvivor()
    if not target then return end

    safeCall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if not remotes then return end
        local attacks = remotes:FindFirstChild("Attacks")
        if not attacks then return end
        local basicAttack = attacks:FindFirstChild("BasicAttack")
        if basicAttack then
            basicAttack:FireServer(false)
        end
    end)
end

local function startAutoAttack()
    if AutoAttackConnection then return end
    if not isKiller() then
        warn("[zy暴力区] 当前不是杀手，无法启用自动攻击")
        return
    end
    AutoAttackConnection = trackConnection(RunService.Heartbeat:Connect(function()
        if not AutoAttackEnabled then return end
        if not isKiller() then return end   -- 中途换队/重生后自动停手
        local now = tick()
        if now - lastAttackTime < ATTACK_COOLDOWN then return end
        lastAttackTime = now
        performAutoAttack()
    end))
end

local function stopAutoAttack()
    if AutoAttackConnection then
        AutoAttackConnection:Disconnect()
        AutoAttackConnection = nil
    end
end

autTab:Toggle({
    Title = "自动攻击附近幸存者",
    Value = false,
    Callback = function(state)
        AutoAttackEnabled = state
        if state then
            startAutoAttack()
        else
            stopAutoAttack()
        end
    end
})

autTab:Slider({
    Title = "攻击范围",
    Value = {
        Min = 5,
        Max = 20,
        Default = 10
    },
    Callback = function(value)
        AttackRange = value
    end
})

-- ========== 技能自瞄（手机常驻版） ==========
local SkillAimbotEnabled = false

local function isEnemy(player)
    if player == LocalPlayer then return false end
    if not player.Team or not player.Character then return false end
    local myTeam = LocalPlayer.Team and LocalPlayer.Team.Name
    local enemyTeam = (myTeam == "Killer") and "Survivors" or "Killer"
    return player.Team.Name == enemyTeam
end

local function getSkillAimTarget()
    local cam = Workspace.CurrentCamera
    if not cam then return nil end
    local mousePos = game:GetService("UserInputService"):GetMouseLocation()
    local closest, closestDist = nil, 99999

    for _, player in ipairs(Players:GetPlayers()) do
        if isEnemy(player) and isAlive(player) then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local screenPos, onScreen = cam:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = hrp
                    end
                end
            end
        end
    end
    return closest
end

trackConnection(RunService.RenderStepped:Connect(function()
    if not SkillAimbotEnabled then return end
    local cam = Workspace.CurrentCamera
    if not cam then return end
    local target = getSkillAimTarget()
    if target then
        cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position)
    end
end))

autTab:Toggle({
    Title = "技能自瞄",
    Value = false,
    Callback = function(state)
        SkillAimbotEnabled = state
    end
})
