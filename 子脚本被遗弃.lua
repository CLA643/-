-- ==========================================
--  被遗弃脚本 - WindUI版
--  原脚本: 宇星辰 | 迁移: WindUI
-- ==========================================

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "子脚本┃被遗弃",
    Icon = "book-open",
    Author = "zy",
    Size = UDim2.fromOffset(620, 480),
    Theme = "Dark",
    Resizable = true,
})

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")
local workspace = game:GetService("Workspace")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- ==========================================
--  通用区
-- ==========================================
local GeneralTab = Window:Tab({ Title = "通用区", Icon = "home" })

-- ---------- 主要列表 ----------
local MainSection = GeneralTab:Section({ Title = "主要列表" })

-- 防眩晕
do
    local antiStunEnabled = false

    runService.RenderStepped:Connect(function()
        if antiStunEnabled then
            local Lighting = game:GetService("Lighting")
            for _, effect in pairs(Lighting:GetChildren()) do
                if effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or effect:IsA("DepthOfFieldEffect") then
                    effect.Enabled = false
                end
            end
            local camera = workspace.CurrentCamera
            if camera then
                for _, effect in pairs(camera:GetChildren()) do
                    if effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or effect:IsA("DepthOfFieldEffect") then
                        effect.Enabled = false
                    end
                end
            end
        end
    end)

    task.spawn(function()
        while task.wait() do
            if antiStunEnabled then
                pcall(function()
                    local playersFolder = workspace:FindFirstChild("Players")
                    if playersFolder then
                        local killersFolder = playersFolder:FindFirstChild("Killers")
                        if killersFolder then
                            for _, killerModel in ipairs(killersFolder:GetChildren()) do
                                local speedMults = killerModel:FindFirstChild("SpeedMultipliers")
                                if speedMults then
                                    local stun = speedMults:FindFirstChild("Stunned")
                                    if stun then stun.Value = 1 end
                                end
                            end
                        end
                        local survivorsFolder = playersFolder:FindFirstChild("Survivors")
                        if survivorsFolder then
                            for _, survModel in ipairs(survivorsFolder:GetChildren()) do
                                local speedMults = survModel:FindFirstChild("SpeedMultipliers")
                                if speedMults then
                                    local stun = speedMults:FindFirstChild("Stunned")
                                    if stun then stun.Value = 1 end
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)

    MainSection:Toggle({
        Title = "防眩晕",
        Callback = function(value)
            antiStunEnabled = value
        end
    })
end

-- ---------- 本地修改 ----------
local LocalSection = GeneralTab:Section({ Title = "本地修改" })

do
    local state = { noclip = false }
    local cachedParts = {}

    local function enableNoclip()
        if player.Character then
            for _, v in pairs(player.Character:GetChildren()) do
                if v:IsA("BasePart") then
                    cachedParts[v] = v
                    v.CanCollide = false
                end
            end
        end
    end

    local function disableNoclip()
        for _, v in pairs(cachedParts) do
            v.CanCollide = true
        end
    end

    task.spawn(function()
        while task.wait(0.1) do
            if state.noclip and player.Character then
                enableNoclip()
            elseif not state.noclip then
                disableNoclip()
            end
        end
    end)

    -- 飞行
    local flyState = { flying = false, speed = 50 }
    local flyObjects = { conn = nil, gyro = nil, vel = nil }

    local function startFly()
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid then return end

        humanoid.AutoRotate = false

        flyObjects.gyro = Instance.new("BodyGyro")
        flyObjects.gyro.P = 90000
        flyObjects.gyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyObjects.gyro.CFrame = root.CFrame
        flyObjects.gyro.Parent = root

        flyObjects.vel = Instance.new("BodyVelocity")
        flyObjects.vel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyObjects.vel.Velocity = Vector3.zero
        flyObjects.vel.Parent = root

        flyObjects.conn = runService.Heartbeat:Connect(function()
            local cam = workspace.CurrentCamera
            local look = cam.CFrame.LookVector
            local right = cam.CFrame.RightVector
            local moveDir = humanoid.MoveDirection

            local forward = moveDir:Dot(Vector3.new(look.X, 0, look.Z).Unit)
            local rightDot = moveDir:Dot(Vector3.new(right.X, 0, right.Z).Unit)
            local up = moveDir.Magnitude <= 0 and 0 or look.Y * forward

            local velocity = look * forward + right * rightDot
            local finalVel = Vector3.new(velocity.X, up, velocity.Z)
            if finalVel.Magnitude > 1 then finalVel = finalVel.Unit end

            flyObjects.vel.Velocity = finalVel * flyState.speed
            flyObjects.gyro.CFrame = CFrame.lookAt(root.Position, root.Position + look, cam.CFrame.UpVector)
        end)
    end

    local function stopFly()
        if flyObjects.conn then flyObjects.conn:Disconnect(); flyObjects.conn = nil end
        if flyObjects.gyro then flyObjects.gyro:Destroy(); flyObjects.gyro = nil end
        if flyObjects.vel then flyObjects.vel:Destroy(); flyObjects.vel = nil end
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.AutoRotate = true end
        end
    end

    LocalSection:Toggle({
        Title = "飞行",
        Callback = function(value)
            flyState.flying = value
            if value then startFly() else stopFly() end
        end
    })

    LocalSection:Slider({
        Title = "飞行速度",
        Value = { Min = 5, Max = 150, Default = 50 },
        Callback = function(value) flyState.speed = value end
    })

    -- 跳跃
    local jumpPower = 50
    LocalSection:Slider({
        Title = "跳跃力量值",
        Value = { Min = 0, Max = 150, Default = 50 },
        Callback = function(value) jumpPower = value end
    })

    LocalSection:Button({
        Title = "设置跳跃数值",
        Callback = function()
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.JumpPower = jumpPower
                char.Humanoid.UseJumpPower = true
            end
        end
    })

    LocalSection:Toggle({
        Title = "穿墙",
        Callback = function(value) state.noclip = value end
    })

    LocalSection:Button({
        Title = "自杀",
        Callback = function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.Health = 0
            end
        end
    })
end

-- ==========================================
--  透视区
-- ==========================================
local ESPTab = Window:Tab({ Title = "透视区", Icon = "eye" })
local ESPSection = ESPTab:Section({ Title = "ESP透视" })

do
    local killersESPToggle = false
    local survivorsESPToggle = false
    local generatorsEnabled = false

    local killersFolder = workspace:WaitForChild("Players"):WaitForChild("Killers")
    local survivorsFolder = workspace:WaitForChild("Players"):WaitForChild("Survivors")

    task.spawn(function()
        while task.wait(0.5) do
            if generatorsEnabled then
                pcall(function()
                    local gameMap = workspace:FindFirstChild("Map")
                    if gameMap and gameMap:FindFirstChild("Ingame") and gameMap.Ingame:FindFirstChild("Map") then
                        for _, v in pairs(gameMap.Ingame.Map:GetChildren()) do
                            if v.Name == "Generator" then
                                if not v:FindFirstChild("gen_esp") then
                                    local hl = Instance.new("Highlight", v)
                                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                    hl.Name = "gen_esp"
                                    hl.OutlineTransparency = 0
                                    hl.FillTransparency = 0.3
                                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                                    hl.FillColor = Color3.fromRGB(255, 255, 51)
                                end
                                if v:FindFirstChild("gen_esp") and v:FindFirstChild("Progress") then
                                    local progress = math.floor(v.Progress.Value)
                                    v.gen_esp.FillColor = (progress >= 100) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 51)
                                end
                            end
                        end
                    end
                end)
            else
                pcall(function()
                    local gameMap = workspace:FindFirstChild("Map")
                    if gameMap and gameMap:FindFirstChild("Ingame") and gameMap.Ingame:FindFirstChild("Map") then
                        for _, v in pairs(gameMap.Ingame.Map:GetChildren()) do
                            if v.Name == "Generator" then
                                if v:FindFirstChild("gen_esp") then v.gen_esp:Destroy() end
                            end
                        end
                    end
                end)
            end
        end
    end)

    local function attachESP(model, color)
        if model:FindFirstChild("ESP_Highlight") then return end
        local hl = Instance.new("Highlight")
        hl.Name = "ESP_Highlight"
        hl.FillTransparency = 1
        hl.OutlineTransparency = 0
        hl.OutlineColor = color
        hl.Adornee = model
        hl.Parent = model

        local head = model:FindFirstChild("Head") or model:FindFirstChildWhichIsA("BasePart")
        if head then
            local bb = Instance.new("BillboardGui")
            bb.Name = "ESP_NameBillboard"
            bb.Adornee = head
            bb.StudsOffset = Vector3.new(0, 3, 0)
            bb.AlwaysOnTop = true
            bb.Size = UDim2.new(0, 200, 0, 50)
            bb.Parent = model

            local label = Instance.new("TextLabel")
            label.Name = "NameLabel"
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = color
            label.TextStrokeTransparency = 0
            label.TextStrokeColor3 = Color3.new(0, 0, 0)
            label.TextSize = 12
            label.Font = Enum.Font.GothamBold
            label.Text = model:GetAttribute("ActorDisplayName") or model.Name
            label.Parent = bb
        end
    end

    local function scanFolder(folder, isKiller)
        for _, model in ipairs(folder:GetChildren()) do
            if model:IsA("Model") and model:FindFirstChildOfClass("Humanoid") then
                attachESP(model, isKiller and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 0))
            end
        end
    end

    task.spawn(function()
        while true do
            scanFolder(killersFolder, true)
            scanFolder(survivorsFolder, false)
            task.wait(5)
        end
    end)

    runService.RenderStepped:Connect(function()
        for _, data in pairs({
            { folder = killersFolder, toggle = killersESPToggle },
            { folder = survivorsFolder, toggle = survivorsESPToggle },
        }) do
            for _, model in ipairs(data.folder:GetChildren()) do
                local hl = model:FindFirstChild("ESP_Highlight")
                local bb = model:FindFirstChild("ESP_NameBillboard")
                if hl then hl.Enabled = data.toggle end
                if bb then bb.Enabled = data.toggle end
            end
        end
    end)

    ESPSection:Toggle({ Title = "杀手 ESP", Callback = function(v) killersESPToggle = v end })
    ESPSection:Toggle({ Title = "幸存者 ESP", Callback = function(v) survivorsESPToggle = v end })
    ESPSection:Toggle({ Title = "发电机 ESP", Callback = function(v) generatorsEnabled = v end })
end

-- ==========================================
--  体力区
-- ==========================================
local StaminaTab = Window:Tab({ Title = "体力区", Icon = "zap" })
local StaminaSection = StaminaTab:Section({ Title = "体力管理" })

do
    local SprintingModule = replicatedStorage:WaitForChild("Systems"):WaitForChild("Character"):WaitForChild("Game"):WaitForChild("Sprinting")
    local function GetModule() return require(SprintingModule) end

    local originalDefaults = {}
    local function CaptureDefaults()
        local m = GetModule()
        originalDefaults.MaxStamina = m.MaxStamina
        originalDefaults.StaminaGain = m.StaminaGain
        originalDefaults.StaminaLoss = m.StaminaLoss
        originalDefaults.SprintSpeed = m.SprintSpeed
    end
    CaptureDefaults()

    local StaminaSettings = { MaxStamina = 100, StaminaGain = 25, StaminaLoss = 10, SprintSpeed = 28, InfiniteGain = 9999 }
    local SettingToggles = { MaxStamina = false, StaminaGain = false, StaminaLoss = false, SprintSpeed = false }
    local infiniteStamina = false
    local infiniteConn = nil

    task.spawn(function()
        while true do
            local m = GetModule()
            for key, value in pairs(StaminaSettings) do
                if SettingToggles[key] then m[key] = value end
            end
            task.wait(0.5)
        end
    end)

    StaminaSection:Toggle({
        Title = "无限体力",
        Callback = function(state)
            infiniteStamina = state
            local Sprinting = GetModule()
            if state then
                Sprinting.StaminaLoss = 0
                Sprinting.StaminaGain = StaminaSettings.InfiniteGain or 9999
                if infiniteConn then infiniteConn:Disconnect() end
                infiniteConn = runService.Heartbeat:Connect(function()
                    if not infiniteStamina then return end
                    Sprinting.StaminaLoss = 0
                    Sprinting.StaminaGain = StaminaSettings.InfiniteGain or 9999
                end)
            else
                Sprinting.StaminaLoss = originalDefaults.StaminaLoss
                Sprinting.StaminaGain = originalDefaults.StaminaGain
                if infiniteConn then infiniteConn:Disconnect(); infiniteConn = nil end
            end
        end
    })

    StaminaSection:Toggle({ Title = "启用体力大小", Callback = function(v) SettingToggles.MaxStamina = v; if not v then GetModule().MaxStamina = originalDefaults.MaxStamina end end })
    StaminaSection:Slider({ Title = "体力大小", Value = { Min = 0, Max = 99999, Default = 100 }, Callback = function(v) StaminaSettings.MaxStamina = v end })
    StaminaSection:Toggle({ Title = "启用体力恢复", Callback = function(v) SettingToggles.StaminaGain = v; if not v then GetModule().StaminaGain = originalDefaults.StaminaGain end end })
    StaminaSection:Slider({ Title = "体力恢复", Value = { Min = 0, Max = 250, Default = 25 }, Callback = function(v) StaminaSettings.StaminaGain = v end })
    StaminaSection:Toggle({ Title = "启用体力消耗", Callback = function(v) SettingToggles.StaminaLoss = v; if not v then GetModule().StaminaLoss = originalDefaults.StaminaLoss end end })
    StaminaSection:Slider({ Title = "体力消耗", Value = { Min = 0, Max = 100, Default = 10 }, Callback = function(v) StaminaSettings.StaminaLoss = v end })
    StaminaSection:Toggle({ Title = "启用奔跑速度", Callback = function(v) SettingToggles.SprintSpeed = v; if not v then GetModule().SprintSpeed = originalDefaults.SprintSpeed end end })
    StaminaSection:Slider({ Title = "奔跑速度", Value = { Min = 0, Max = 200, Default = 28 }, Callback = function(v) StaminaSettings.SprintSpeed = v end })
end

-- ==========================================
--  物品区
-- ==========================================
local ItemTab = Window:Tab({ Title = "物品区", Icon = "package" })
local ItemSection = ItemTab:Section({ Title = "物品互动" })

do
    local teleportMedkitEnabled = false
    local medkitThread = nil

    ItemSection:Toggle({
        Title = "医疗包传送并互动",
        Callback = function(state)
            teleportMedkitEnabled = state
            if state then
                medkitThread = task.spawn(function()
                    while teleportMedkitEnabled and task.wait(0.5) do
                        local char = player.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            local hrp = char.HumanoidRootPart
                            local medkit = workspace:FindFirstChild("Map", true)
                            if medkit then
                                medkit = medkit:FindFirstChild("Ingame", true)
                                if medkit then
                                    medkit = medkit:FindFirstChild("Medkit", true)
                                    if medkit then
                                        local itemRoot = medkit:FindFirstChild("ItemRoot", true)
                                        if itemRoot then
                                            itemRoot.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 3
                                            local prompt = itemRoot:FindFirstChild("ProximityPrompt", true)
                                            if prompt then fireproximityprompt(prompt) end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            elseif medkitThread then task.cancel(medkitThread); medkitThread = nil end
        end
    })

    local teleportColaEnabled = false
    local colaThread = nil

    ItemSection:Toggle({
        Title = "可乐传送并互动",
        Callback = function(state)
            teleportColaEnabled = state
            if state then
                colaThread = task.spawn(function()
                    while teleportColaEnabled and task.wait(0.5) do
                        local char = player.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            local hrp = char.HumanoidRootPart
                            local cola = workspace:FindFirstChild("Map", true)
                            if cola then
                                cola = cola:FindFirstChild("Ingame", true)
                                if cola then
                                    cola = cola:FindFirstChild("BloxyCola", true)
                                    if cola then
                                        local itemRoot = cola:FindFirstChild("ItemRoot", true)
                                        if itemRoot then
                                            itemRoot.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 3
                                            local prompt = itemRoot:FindFirstChild("ProximityPrompt", true)
                                            if prompt then fireproximityprompt(prompt) end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            elseif colaThread then task.cancel(colaThread); colaThread = nil end
        end
    })

    local autoMedkitEnabled = false
    local autoMedkitThread = nil

    ItemSection:Toggle({
        Title = "自动互动医疗包",
        Callback = function(state)
            autoMedkitEnabled = state
            if state then
                autoMedkitThread = task.spawn(function()
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
                                        if prompt then fireproximityprompt(prompt) end
                                    end
                                end
                            end
                        end
                    end
                end)
            elseif autoMedkitThread then task.cancel(autoMedkitThread); autoMedkitThread = nil end
        end
    })

    local autoColaEnabled = false
    local autoColaThread = nil

    ItemSection:Toggle({
        Title = "自动互动可乐",
        Callback = function(state)
            autoColaEnabled = state
            if state then
                autoColaThread = task.spawn(function()
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
                                        if prompt then fireproximityprompt(prompt) end
                                    end
                                end
                            end
                        end
                    end
                end)
            elseif autoColaThread then task.cancel(autoColaThread); autoColaThread = nil end
        end
    })
end

-- ==========================================
--  发电机区
-- ==========================================
local GenTab = Window:Tab({ Title = "发电机", Icon = "cpu" })
local GenSection = GenTab:Section({ Title = "发电机系统" })

do
    local autoRepairActive = false
    local repairCheckInterval = 1.5

    local flow = { on = false, nodeDelay = 0, lineDelay = 0.4 }

    local function flowKey(n) return n.row .. "-" .. n.col end
    local function flowNeighbour(r1, c1, r2, c2)
        if r2 == r1 - 1 and c2 == c1 then return "up" end
        if r2 == r1 + 1 and c2 == c1 then return "down" end
        if r2 == r1 and c2 == c1 - 1 then return "left" end
        if r2 == r1 and c2 == c1 + 1 then return "right" end
        return false
    end

    local function flowOrder(path, endpoints)
        if not path or #path == 0 then return path end
        local lookup = {}
        for _, n in ipairs(path) do lookup[flowKey(n)] = n end
        local start
        for _, ep in ipairs(endpoints or {}) do
            for _, n in ipairs(path) do
                if n.row == ep.row and n.col == ep.col then
                    start = { row = ep.row, col = ep.col }
                    break
                end
            end
            if start then break end
        end
        if not start then
            for _, n in ipairs(path) do
                local nb = 0
                for _, d in ipairs({{-1,0},{1,0},{0,-1},{0,1}}) do
                    if lookup[(n.row+d[1]).."-"..(n.col+d[2])] then nb = nb + 1 end
                end
                if nb == 1 then start = { row = n.row, col = n.col }; break end
            end
        end
        if not start then start = { row = path[1].row, col = path[1].col } end
        local pool, ordered = {}, {}
        for _, n in ipairs(path) do pool[flowKey(n)] = { row = n.row, col = n.col } end
        local cur = start
        table.insert(ordered, { row = cur.row, col = cur.col })
        pool[flowKey(cur)] = nil
        while next(pool) do
            local moved = false
            for k, node in pairs(pool) do
                if flowNeighbour(cur.row, cur.col, node.row, node.col) then
                    table.insert(ordered, { row = node.row, col = node.col })
                    pool[k] = nil; cur = node; moved = true; break
                end
            end
            if not moved then break end
        end
        return ordered
    end

    local function flowSolve(puzzle)
        if not puzzle or not puzzle.Solution then return end
        local indices = {}
        for i = 1, #puzzle.Solution do indices[i] = i end
        for i = #indices, 2, -1 do
            local j = math.random(1, i)
            indices[i], indices[j] = indices[j], indices[i]
        end
        for _, ci in ipairs(indices) do
            local solution = puzzle.Solution[ci]
            if not solution then continue end
            local ordered = flowOrder(solution, puzzle.targetPairs[ci])
            if not ordered or #ordered == 0 then continue end
            puzzle.paths[ci] = {}
            for _, node in ipairs(ordered) do
                table.insert(puzzle.paths[ci], { row = node.row, col = node.col })
                puzzle:updateGui()
                task.wait(flow.nodeDelay)
            end
            task.wait(flow.lineDelay)
            puzzle:checkForWin()
        end
    end

    local hooked = false
    local function setupFlowHook()
        if hooked then return end
        local modFolder = replicatedStorage:FindFirstChild("Modules")
        local miniFolder = modFolder and modFolder:FindFirstChild("Minigames")
        local fgFolder = miniFolder and miniFolder:FindFirstChild("FlowGameManager")
        local fgModule = fgFolder and fgFolder:FindFirstChild("FlowGame")
        if fgModule then
            local ok, FG = pcall(require, fgModule)
            if ok and FG and FG.new then
                local orig = FG.new
                FG.new = function(...)
                    local p = orig(...)
                    if flow.on then
                        task.spawn(function() task.wait(0.3); flowSolve(p) end)
                    end
                    return p
                end
                hooked = true
            end
        end
    end

    GenSection:Toggle({ Title = "绘制修机", Callback = function(on) flow.on = on; if on and not hooked then setupFlowHook() end end })
    GenSection:Slider({ Title = "节点速度 (秒)", Value = { Min = 0, Max = 1, Default = 0 }, Rounding = 2, Callback = function(v) flow.nodeDelay = v end })
    GenSection:Slider({ Title = "线暂停 (秒)", Value = { Min = 0, Max = 1, Default = 0.4 }, Rounding = 2, Callback = function(v) flow.lineDelay = v end })

    GenSection:Toggle({
        Title = "自动修复发电机",
        Callback = function(value) autoRepairActive = value end
    })

    local function findNearestGenerator()
        local char = player.Character
        if not char then return nil end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        local generators = {}
        local map = workspace:FindFirstChild("Map")
        if map then
            local ingame = map:FindFirstChild("Ingame")
            if ingame then
                local mapFolder = ingame:FindFirstChild("Map")
                if mapFolder then
                    for _, obj in pairs(mapFolder:GetChildren()) do
                        if obj.Name == "Generator" then table.insert(generators, obj) end
                    end
                end
            end
        end
        local nearest, nearestDist = nil, math.huge
        for _, gen in pairs(generators) do
            local part = gen:FindFirstChildWhichIsA("BasePart")
            if part then
                local dist = (root.Position - part.Position).Magnitude
                if dist < nearestDist then nearest, nearestDist = gen, dist end
            end
        end
        return nearest
    end

    local function repairGenerator(generator)
        if not generator then return false end
        local remotes = generator:FindFirstChild("Remotes")
        if remotes then
            local re = remotes:FindFirstChild("RE")
            if re and re:IsA("RemoteEvent") then re:FireServer(); return true end
        end
        return false
    end

    task.spawn(function()
        while task.wait() do
            if autoRepairActive then
                local generator = findNearestGenerator()
                if generator then repairGenerator(generator); task.wait(repairCheckInterval) end
            end
            task.wait(0.1)
        end
    end)

    GenSection:Button({
        Title = "完成所有发电机",
        Callback = function()
            pcall(function()
                local gameMap = workspace:FindFirstChild("Map")
                if not (gameMap and gameMap:FindFirstChild("Ingame") and gameMap.Ingame:FindFirstChild("Map")) then return end
                for _, v in ipairs(gameMap.Ingame.Map:GetChildren()) do
                    if v.Name == "Generator" and v:FindFirstChild("Progress") and v.Progress.Value < 100 then
                        local positions = v:FindFirstChild("Positions")
                        if positions then
                            local center = positions:FindFirstChild("Center")
                            local right = positions:FindFirstChild("Right")
                            local left = positions:FindFirstChild("Left")
                            if center and right and left then
                                local function occupied(pos)
                                    local folder = workspace:FindFirstChild("Players")
                                    local survivors = folder and folder:FindFirstChild("Survivors")
                                    if not survivors then return false end
                                    for _, sv in ipairs(survivors:GetChildren()) do
                                        if sv ~= player and sv:FindFirstChild("HumanoidRootPart") then
                                            if (sv.HumanoidRootPart.Position - pos).Magnitude <= 6 then return true end
                                        end
                                    end
                                    return false
                                end
                                local cOcc = occupied(center.Position)
                                local rOcc = occupied(right.Position)
                                local lOcc = occupied(left.Position)
                                if not (cOcc and rOcc and lOcc) then
                                    local char = player.Character
                                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                                    if hrp then
                                        if not cOcc then hrp.CFrame = center.CFrame
                                        elseif not rOcc then hrp.CFrame = right.CFrame
                                        else hrp.CFrame = left.CFrame end
                                    end
                                    task.wait(0.2)
                                    local s2, r2 = pcall(function() return v.Remotes.RF:InvokeServer("Enter") end)
                                    if s2 and r2 == "fixing" then
                                        for _ = 1, 4 do
                                            if v.Progress.Value >= 100 then break end
                                            pcall(function() v.Remotes.RE:FireServer() end)
                                            task.wait(1.4)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    })
end

-- ==========================================
--  幸存者功能包
-- ==========================================
local SurvivorTab = Window:Tab({ Title = "幸存者功能", Icon = "user" })
local ChanceSection = SurvivorTab:Section({ Title = "机会" })
local TwoTimeSection = SurvivorTab:Section({ Title = "两次（背刺）" })
local VeronicaSection = SurvivorTab:Section({ Title = "维罗妮卡" })

-- 机会模块
do
    local CoinflipSettings = { Enabled = false, TargetCharge = 3 }
    local lastCoinflipTime = 0
    local coinflipCooldown = 2

    local function readCoinflipChargesText()
        local ok, txt = pcall(function()
            local mainUI = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("MainUI")
            if not mainUI then return nil end
            local abil = mainUI:FindFirstChild("AbilityContainer")
            if not abil then return nil end
            local coin = abil:FindFirstChild("Reroll")
            if not coin then return nil end
            local chargesLabel = coin:FindFirstChild("Charges")
            if not chargesLabel then return nil end
            return tostring(chargesLabel.Text)
        end)
        if ok then return txt end
        return nil
    end

    task.spawn(function()
        while true do
            task.wait(0.5)
            if not CoinflipSettings.Enabled then continue end
            local now = tick()
            if now - lastCoinflipTime < coinflipCooldown then continue end
            local isChance = false
            local playersFolder = workspace:FindFirstChild("Players")
            local survFolder = playersFolder and playersFolder:FindFirstChild("Survivors")
            if survFolder then
                for _, surv in ipairs(survFolder:GetChildren()) do
                    if surv:GetAttribute("Username") == player.Name and surv.Name == "Chance" then isChance = true; break end
                end
            end
            if not isChance then continue end
            local charges = tonumber(readCoinflipChargesText())
            if charges and charges < CoinflipSettings.TargetCharge then
                lastCoinflipTime = now
                pcall(function()
                    local args = { "UseActorAbility", { buffer.fromstring("\003\b\000\000\000CoinFlip") } }
                    replicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
                end)
            end
        end
    end)

    local ChanceAimbot = { Enabled = false, Prediction = false, Range = 100 }
    local oneShootAnims = {"73921036900313", "111384272984267", "90499469533503", "133491532453922"}

    local function isFlintlockVisible(char)
        if not char then return false end
        local tool = char:FindFirstChildOfClass("Tool")
        if tool and (string.lower(tool.Name):find("flintlock") or string.lower(tool.Name):find("revolver") or string.lower(tool.Name):find("gun")) then return true end
        local flint = char:FindFirstChild("Flintlock", true)
        if not flint then return false end
        if not (flint:IsA("BasePart") or flint:IsA("MeshPart") or flint:IsA("UnionOperation")) then
            flint = flint:FindFirstChildWhichIsA("BasePart", true)
            if not flint then return false end
        end
        return flint.Transparency < 1
    end

    local chanceKillersCache = {}
    task.spawn(function()
        while true do
            local playersFolder = workspace:FindFirstChild("Players")
            if playersFolder then
                local kFolder = playersFolder:FindFirstChild("Killers")
                if kFolder then
                    local list = {}
                    for _, k in ipairs(kFolder:GetChildren()) do
                        if k:GetAttribute("Username") then table.insert(list, k) end
                    end
                    chanceKillersCache = list
                end
            end
            task.wait(0.25)
        end
    end)

    local function isLocalPlayerChance()
        local char = player.Character
        if not char then return false end
        local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
        if not survivorsFolder then return false end
        for _, surv in ipairs(survivorsFolder:GetChildren()) do
            if surv == char and surv.Name == "Chance" then return true end
        end
        return false
    end

    local function isOneShootAnimating(char)
        if not char then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local animator = hum and hum:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                local id = tostring(track.Animation and track.Animation.AnimationId or ""):match("%d+")
                if id then
                    for _, animId in ipairs(oneShootAnims) do
                        if id == animId then return true end
                    end
                end
            end
        end
        return false
    end

    task.spawn(function()
        while true do
            task.wait(0.05)
            if not ChanceAimbot.Enabled then continue end
            local char = player.Character
            if not char then continue end
            if not isLocalPlayerChance() then continue end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then continue end
            local isShooting = isOneShootAnimating(char) or isFlintlockVisible(char)
            if not isShooting then continue end
            local target, shortestDist = nil, ChanceAimbot.Range
            for _, killer in ipairs(chanceKillersCache) do
                local kRoot = killer:FindFirstChild("HumanoidRootPart")
                if kRoot then
                    local dist = (kRoot.Position - root.Position).Magnitude
                    if dist <= shortestDist then shortestDist = dist; target = kRoot end
                end
            end
            if target then
                local targetPos = target.Position
                if ChanceAimbot.Prediction then
                    local velocity = target.Velocity or target.AssemblyLinearVelocity
                    if velocity then
                        local ping = 0
                        pcall(function() ping = player:GetNetworkPing() end)
                        local dist = (target.Position - root.Position).Magnitude
                        local totalDelay = ping + dist / 1000
                        local dropoff = math.clamp(dist / ChanceAimbot.Range, 0.1, 1)
                        local distanceBoost = 1 + (dist / ChanceAimbot.Range) * 0.25
                        local predictionFactor = totalDelay * 1.2 * dropoff * distanceBoost
                        targetPos = targetPos + (velocity * predictionFactor)
                    end
                end
                root.CFrame = CFrame.lookAt(root.Position, Vector3.new(targetPos.X, root.Position.Y, targetPos.Z))
            end
        end
    end)

    ChanceSection:Toggle({ Title = "启用机会射击自瞄", Callback = function(v) ChanceAimbot.Enabled = v end })
    ChanceSection:Toggle({ Title = "瞄准预测", Callback = function(v) ChanceAimbot.Prediction = v end })
    ChanceSection:Slider({ Title = "射击半径", Value = { Min = 20, Max = 1000, Default = 100 }, Callback = function(v) ChanceAimbot.Range = v end })
    ChanceSection:Divider()
    ChanceSection:Toggle({ Title = "自动抛硬币翻转", Callback = function(v) CoinflipSettings.Enabled = v end })
    ChanceSection:Dropdown({ Title = "硬币充能层数", Values = {"1", "2", "3"}, Default = "3", Callback = function(val) CoinflipSettings.TargetCharge = tonumber(val) end })
end

-- 两次背刺模块
do
    local DEFAULT_PROXIMITY = 8
    local DEFAULT_DURATION = 0.45
    local BEHIND_DISTANCE = 3.5
    local CHECK_INTERVAL = 0.05
    local COOLDOWN = 5
    local LERP_SPEED = 0.55
    local BEHIND_CONE_DEGREES = 70
    local REMOTE_FIRE_DELAY = 0.0
    local AIM_SNAP_DELAY = 0.25
    local DEBUG_LINE = true
    local enabled = false
    local daggerEnabled = false
    local rangeMode = "Behind"
    local backstabType = "Lerp"
    local proximity = DEFAULT_PROXIMITY
    local lastTrigger = 0
    local aimRefCount = 0
    local debugBeam = nil

    local function getCharacter() return player.Character or player.CharacterAdded:Wait() end

    local function getDaggerButton()
        local pg = player:FindFirstChild("PlayerGui")
        if not pg then return nil end
        local mainUI = pg:FindFirstChild("MainUI")
        if not mainUI then return nil end
        local container = mainUI:FindFirstChild("AbilityContainer")
        if not container then return nil end
        return container:FindFirstChild("Dagger")
    end

    local function getDaggerCooldown()
        local btn = getDaggerButton()
        if not btn then return nil end
        return btn:FindFirstChild("CooldownTime") or btn:FindFirstChild("Cooldown") or btn:FindFirstChildWhichIsA("NumberValue") or btn:FindFirstChildWhichIsA("StringValue") or btn:FindFirstChild("CooldownLabel") or btn:FindFirstChild("Timer") or btn:FindFirstChild("CD")
    end

    local function readCooldownValue(cdObj)
        if not cdObj then return nil end
        if cdObj:IsA("NumberValue") then return cdObj.Value end
        if cdObj:IsA("StringValue") then return tonumber(cdObj.Value) end
        if cdObj:IsA("TextLabel") or cdObj:IsA("TextBox") then return tonumber(cdObj.Text) end
        if type(cdObj.Value) == "number" then return cdObj.Value end
        if type(cdObj.Value) == "string" then return tonumber(cdObj.Value) end
        if cdObj.Text ~= nil then return tonumber(cdObj.Text) end
        return nil
    end

    local function getKillersFolder()
        local playersFolder = workspace:FindFirstChild("Players")
        if not playersFolder then return nil end
        return playersFolder:FindFirstChild("Killers")
    end

    local function isValidKillerModel(model)
        if not model then return false end
        local hrp = model:FindFirstChild("HumanoidRootPart")
        local humanoid = model:FindFirstChildWhichIsA("Humanoid")
        return hrp and humanoid and humanoid.Health and humanoid.Health > 0
    end

    local function tryActivateButton(btn)
        if not btn then return false end
        pcall(function() if btn.Activate then btn:Activate() end end)
        local ok, conns = pcall(function()
            if type(getconnections) == "function" and btn.MouseButton1Click then return getconnections(btn.MouseButton1Click) end
            return nil
        end)
        if ok and conns then
            for _, conn in ipairs(conns) do
                pcall(function()
                    if conn.Function then conn.Function()
                    elseif conn.func then conn.func()
                    elseif conn.Fire then conn.Fire() end
                end)
            end
        end
        pcall(function() if btn.Activated then btn.Activated:Fire() end end)
        return true
    end

    local function setAutoRotate(value)
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if hum then pcall(function() hum.AutoRotate = value end) end
    end

    local function isPlayerBehindKiller(hrp, khrp, dist)
        if dist > proximity or dist < 0.01 then return false end
        local toPlayer = (hrp.Position - khrp.Position).Unit
        local killerBack = -khrp.CFrame.LookVector
        local dot = toPlayer:Dot(killerBack)
        local threshold = math.cos(math.rad(BEHIND_CONE_DEGREES))
        return dot >= threshold
    end

    local function removeDebugLine()
        if debugBeam then pcall(function() debugBeam:Destroy() end); debugBeam = nil end
    end

    local function drawDebugLine(hrp, khrp, isValid)
        if not DEBUG_LINE then removeDebugLine(); return end
        pcall(function()
            local att0 = hrp:FindFirstChild("__BSAtt0") or Instance.new("Attachment", hrp)
            att0.Name = "__BSAtt0"
            att0.Position = Vector3.zero
            local att1 = khrp:FindFirstChild("__BSAtt1") or Instance.new("Attachment", khrp)
            att1.Name = "__BSAtt1"
            att1.Position = Vector3.zero
            if not debugBeam then
                local b = Instance.new("Beam")
                b.Name = "__BSBeam"
                b.Attachment0 = att0
                b.Attachment1 = att1
                b.FaceCamera = true
                b.Width0 = 0.08
                b.Width1 = 0.08
                b.Segments = 1
                b.LightEmission = 1
                b.LightInfluence = 0
                b.Parent = hrp
                debugBeam = b
            end
            debugBeam.Attachment0 = att0
            debugBeam.Attachment1 = att1
            debugBeam.Color = isValid and ColorSequence.new(Color3.fromRGB(50, 220, 100)) or ColorSequence.new(Color3.fromRGB(220, 80, 60))
        end)
    end

    local function activateForKiller(killerModel, duration)
        if not killerModel then return end
        local char = getCharacter()
        local humanoid = char and char:FindFirstChildWhichIsA("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local khrp = killerModel:FindFirstChild("HumanoidRootPart")
        if not humanoid or not hrp or not khrp then return end
        aimRefCount = aimRefCount + 1
        if aimRefCount == 1 then pcall(function() humanoid.AutoRotate = false end) end
        local function finishAiming()
            aimRefCount = math.max(0, aimRefCount - 1)
            if aimRefCount == 0 then setAutoRotate(true) end
        end
        local function computeBehindCFrame()
            local kCF = khrp.CFrame
            local behindPos = kCF.Position - (kCF.LookVector.Unit * BEHIND_DISTANCE)
            behindPos = Vector3.new(behindPos.X, kCF.Position.Y, behindPos.Z)
            return CFrame.new(behindPos, behindPos + kCF.LookVector.Unit)
        end
        if backstabType == "Lerp" then
            local t0 = os.clock()
            local conn
            conn = runService.Heartbeat:Connect(function()
                if os.clock() - t0 >= duration then conn:Disconnect(); finishAiming(); return end
                if khrp and hrp then hrp.CFrame = hrp.CFrame:Lerp(computeBehindCFrame(), LERP_SPEED) end
            end)
        elseif backstabType == "Teleport" then
            pcall(function() hrp.CFrame = computeBehindCFrame() end)
            task.delay(duration, finishAiming)
        elseif backstabType == "Aim" then
            local t0 = os.clock()
            local conn
            conn = runService.Heartbeat:Connect(function()
                if os.clock() - t0 >= duration then conn:Disconnect(); finishAiming(); return end
                if khrp and hrp then
                    local stabTarget = khrp.Position + khrp.CFrame.LookVector * 2
                    local aimPos = Vector3.new(stabTarget.X, hrp.Position.Y, stabTarget.Z)
                    hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(hrp.Position, aimPos), LERP_SPEED * 1.8)
                end
            end)
        end
    end

    task.spawn(function()
        while true do
            task.wait(CHECK_INTERVAL)
            if not enabled then continue end
            local killersFolder = getKillersFolder()
            if not killersFolder then continue end
            local char = getCharacter()
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end
            local triggered = false
            for _, killer in pairs(killersFolder:GetChildren()) do
                if triggered then break end
                if not isValidKillerModel(killer) then continue end
                local khrp = killer:FindFirstChild("HumanoidRootPart")
                local dist = (khrp.Position - hrp.Position).Magnitude
                if dist <= proximity then
                    local valid = isPlayerBehindKiller(hrp, khrp, dist)
                    drawDebugLine(hrp, khrp, valid)
                    if valid and rangeMode ~= "Around" and os.clock() - lastTrigger >= COOLDOWN then
                        local cdNum = readCooldownValue(getDaggerCooldown())
                        if not (cdNum and cdNum > 0.1) then
                            lastTrigger = os.clock()
                            triggered = true
                            task.spawn(function()
                                activateForKiller(killer, DEFAULT_DURATION)
                                if REMOTE_FIRE_DELAY > 0 then task.wait(REMOTE_FIRE_DELAY) end
                                if daggerEnabled then tryActivateButton(getDaggerButton()) end
                                if AIM_SNAP_DELAY > 0 then
                                    task.wait(AIM_SNAP_DELAY)
                                    local khrp2 = killer:FindFirstChild("HumanoidRootPart")
                                    local char2 = getCharacter()
                                    local hrp2 = char2 and char2:FindFirstChild("HumanoidRootPart")
                                    if khrp2 and hrp2 then
                                        local behindPos = khrp2.CFrame.Position - (khrp2.CFrame.LookVector.Unit * BEHIND_DISTANCE)
                                        behindPos = Vector3.new(behindPos.X, hrp2.Position.Y, behindPos.Z)
                                        hrp2.CFrame = CFrame.new(behindPos, behindPos + khrp2.CFrame.LookVector.Unit)
                                    end
                                end
                            end)
                        end
                    end
                elseif DEBUG_LINE then
                    removeDebugLine()
                end
                if rangeMode == "Around" and dist <= proximity and os.clock() - lastTrigger >= COOLDOWN and not triggered then
                    local cdNum = readCooldownValue(getDaggerCooldown())
                    if not (cdNum and cdNum > 0.1) then
                        lastTrigger = os.clock()
                        triggered = true
                        task.spawn(function()
                            activateForKiller(killer, DEFAULT_DURATION)
                            if REMOTE_FIRE_DELAY > 0 then task.wait(REMOTE_FIRE_DELAY) end
                            if daggerEnabled then tryActivateButton(getDaggerButton()) end
                        end)
                    end
                end
            end
            if not triggered then removeDebugLine() end
        end
    end)

    TwoTimeSection:Toggle({ Title = "自动背刺", Callback = function(state) enabled = state end })
    TwoTimeSection:Toggle({ Title = "背刺时自动攻击", Callback = function(state) daggerEnabled = state end })
    TwoTimeSection:Toggle({ Title = "调试射线", Default = true, Callback = function(state) DEBUG_LINE = state; if not state then removeDebugLine() end end })
    TwoTimeSection:Dropdown({ Title = "背刺类型", Values = { "缓动位移", "瞬移", "锁定瞄准" }, Default = "缓动位移", Callback = function(value)
        if value == "缓动位移" then backstabType = "Lerp"
        elseif value == "瞬移" then backstabType = "Teleport"
        elseif value == "锁定瞄准" then backstabType = "Aim" end
    end })
    TwoTimeSection:Dropdown({ Title = "范围模式", Values = { "全范围", "背后" }, Default = "背后", Callback = function(value)
        if value == "全范围" then rangeMode = "Around" else rangeMode = "Behind" end
    end })
    TwoTimeSection:Slider({ Title = "检测范围", Value = { Min = 1, Max = 30, Default = DEFAULT_PROXIMITY }, Callback = function(value) proximity = value end })
    TwoTimeSection:Slider({ Title = "背后瞬移距离", Value = { Min = 0.5, Max = 10, Default = BEHIND_DISTANCE }, Callback = function(value) BEHIND_DISTANCE = value end })
    TwoTimeSection:Slider({ Title = "背后判定锥角", Value = { Min = 10, Max = 180, Default = BEHIND_CONE_DEGREES }, Callback = function(value) BEHIND_CONE_DEGREES = value end })
    TwoTimeSection:Slider({ Title = "远程触发延迟", Value = { Min = 0, Max = 0.5, Default = REMOTE_FIRE_DELAY }, Callback = function(value) REMOTE_FIRE_DELAY = value end })
    TwoTimeSection:Slider({ Title = "瞄准硬锁定延迟", Value = { Min = 0, Max = 0.3, Default = AIM_SNAP_DELAY }, Callback = function(value) AIM_SNAP_DELAY = value end })
end

-- 维罗妮卡模块
do
    local VeronicaSk8Control = false
    local veronicaSk8Anims = { "130352140726486", "122542233810574", "117058860640843", "123803922491274" }
    local controlChargeActive = false
    local overrideConnection = nil
    local savedHumanoidState = {}
    local hasEverEnabledShiftlock = false

    local function getHumanoid()
        if not player or not player.Character then return nil end
        return player.Character:FindFirstChildOfClass("Humanoid")
    end

    local function saveHumState(hum)
        if not hum or savedHumanoidState[hum] then return end
        local s = {}
        pcall(function()
            s.WalkSpeed = hum.WalkSpeed
            local ok, _ = pcall(function() s.JumpPower = hum.JumpPower end)
            if not ok then pcall(function() s.JumpPower = hum.JumpHeight end) end
            local ok2, ar = pcall(function() return hum.AutoRotate end)
            if ok2 then s.AutoRotate = ar end
            s.PlatformStand = hum.PlatformStand
        end)
        savedHumanoidState[hum] = s
    end

    local function restoreHumState(hum)
        if not hum then return end
        local s = savedHumanoidState[hum]
        if not s then return end
        pcall(function()
            if s.WalkSpeed ~= nil then hum.WalkSpeed = s.WalkSpeed end
            if s.JumpPower ~= nil then
                local ok, _ = pcall(function() hum.JumpPower = s.JumpPower end)
                if not ok then pcall(function() hum.JumpHeight = s.JumpPower end) end
            end
            if s.AutoRotate ~= nil then pcall(function() hum.AutoRotate = s.AutoRotate end) end
            if s.PlatformStand ~= nil then hum.PlatformStand = s.PlatformStand end
        end)
        savedHumanoidState[hum] = nil
    end

    local function startOverride()
        if controlChargeActive then return end
        local hum = getHumanoid()
        if not hum then return end
        controlChargeActive = true
        saveHumState(hum)
        pcall(function() hum.WalkSpeed = 60; hum.AutoRotate = false end)
        overrideConnection = runService.RenderStepped:Connect(function()
            local humanoid = getHumanoid()
            local rootPart = humanoid and humanoid.Parent and humanoid.Parent:FindFirstChild("HumanoidRootPart")
            if not humanoid or not rootPart then return end
            pcall(function() humanoid.WalkSpeed = 60; humanoid.AutoRotate = false end)
            local cam = workspace.CurrentCamera
            if cam then
                local lookVec = cam.CFrame.LookVector
                local flat = Vector3.new(lookVec.X, 0, lookVec.Z)
                if flat.Magnitude > 0.01 then rootPart.CFrame = CFrame.new(rootPart.Position, rootPart.Position + flat.Unit) end
            end
            local direction = rootPart.CFrame.LookVector
            local horizontal = Vector3.new(direction.X, 0, direction.Z)
            if horizontal.Magnitude > 0 then humanoid:Move(horizontal.Unit) else humanoid:Move(Vector3.new(0, 0, 0)) end
        end)
    end

    local function stopOverride()
        if not controlChargeActive then return end
        controlChargeActive = false
        if overrideConnection then pcall(function() overrideConnection:Disconnect() end); overrideConnection = nil end
        local hum = getHumanoid()
        if hum then pcall(function() restoreHumState(hum); hum:Move(Vector3.new(0, 0, 0)) end) end
    end

    local function detectChargeAnimation()
        local hum = getHumanoid()
        if not hum then return false end
        for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
            local ok, animId = pcall(function() return tostring(track.Animation and track.Animation.AnimationId or ""):match("%d+") end)
            if ok and animId and animId ~= "" then
                for _, id in ipairs(veronicaSk8Anims) do
                    if animId == id then return true end
                end
            end
        end
        return false
    end

    runService.RenderStepped:Connect(function()
        if not VeronicaSk8Control then
            if controlChargeActive then stopOverride() end
            return
        end
        local hum = getHumanoid()
        if not hum then
            if controlChargeActive then stopOverride() end
            return
        end
        local isCharging = detectChargeAnimation()
        local isCurrentlyShiftlock = (userInput.MouseBehavior == Enum.MouseBehavior.LockCenter) or userInput:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        if isCurrentlyShiftlock then hasEverEnabledShiftlock = true end
        local isShiftlockActive = hasEverEnabledShiftlock or isCurrentlyShiftlock
        if isCharging and isShiftlockActive then
            if not controlChargeActive then startOverride() end
        else
            if controlChargeActive then stopOverride() end
        end
    end)

    player.CharacterAdded:Connect(function()
        if controlChargeActive then stopOverride() end
        hasEverEnabledShiftlock = false
    end)

    VeronicaSection:Toggle({ Title = "启用滑板控制", Callback = function(state) VeronicaSk8Control = state end })
end

-- ==========================================
--  杀手功能包
-- ==========================================
local KillerTab = Window:Tab({ Title = "杀手功能", Icon = "sword" })
local HitboxSection = KillerTab:Section({ Title = "碰撞箱扩展" })
local DashSection = KillerTab:Section({ Title = "汽车拐弯" })
local AimbotSection = KillerTab:Section({ Title = "自瞄" })
local ABSection = KillerTab:Section({ Title = "防背刺" })
local KillAllSection = KillerTab:Section({ Title = "杀死全部人" })
local SuctionSection = KillerTab:Section({ Title = "吸力" })

-- 碰撞箱扩展
do
    local hitboxExtender = { enabled = false, range = 10 }
    local function studsToPower(studs) return studs * 6 end

    task.spawn(function()
        while true do
            runService.Heartbeat:Wait()
            if hitboxExtender.enabled then
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then continue end
                local myHitboxDetected = false
                local hitboxesFolder = workspace:FindFirstChild("Hitboxes")
                local myUsername = char:GetAttribute("Username") or player.Name
                local myHitboxName = myUsername .. "Hitbox"
                if hitboxesFolder and char then
                    for _, part in ipairs(hitboxesFolder:GetChildren()) do
                        if part.Name == myHitboxName then
                            if hrp and (part.Position - hrp.Position).Magnitude <= 15 then myHitboxDetected = true end
                            break
                        end
                    end
                end
                if myHitboxDetected and char and hrp and hrp.Parent then
                    local velocity = hrp.AssemblyLinearVelocity
                    if velocity.Magnitude > 0.5 then
                        local distance = studsToPower(hitboxExtender.range)
                        local moveDir = velocity.Magnitude > 0 and velocity.Unit or hrp.CFrame.LookVector
                        local newVelocity = velocity + (moveDir * distance)
                        hrp.AssemblyLinearVelocity = Vector3.new(newVelocity.X, velocity.Y, newVelocity.Z)
                        runService.RenderStepped:Wait()
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            player.Character.HumanoidRootPart.AssemblyLinearVelocity = velocity
                        end
                    end
                end
            end
        end
    end)

    HitboxSection:Toggle({ Title = "启用碰撞箱扩展", Callback = function(v) hitboxExtender.enabled = v end })
    HitboxSection:Slider({ Title = "碰撞箱长度", Value = { Min = 0, Max = 50, Default = 10 }, Callback = function(v) hitboxExtender.range = math.floor(v) end })
end

-- 汽车拐弯
do
    local Camera = workspace.CurrentCamera
    local dashTurn = { sixer = false, coolkid = false, noli = false, noliActive = false, noliOrigWalkSpeed = nil, noliConn = nil }

    local function getCameraInputDir()
        local cf = Camera.CFrame
        local camFwd = Vector3.new(cf.LookVector.X, 0, cf.LookVector.Z)
        local camRight = Vector3.new(cf.RightVector.X, 0, cf.RightVector.Z)
        local x, z = 0, 0
        if userInput:IsKeyDown(Enum.KeyCode.W) or userInput:IsKeyDown(Enum.KeyCode.Up) then z = z - 1 end
        if userInput:IsKeyDown(Enum.KeyCode.S) or userInput:IsKeyDown(Enum.KeyCode.Down) then z = z + 1 end
        if userInput:IsKeyDown(Enum.KeyCode.A) or userInput:IsKeyDown(Enum.KeyCode.Left) then x = x - 1 end
        if userInput:IsKeyDown(Enum.KeyCode.D) or userInput:IsKeyDown(Enum.KeyCode.Right) then x = x + 1 end
        local dir = camFwd * -z + camRight * x
        if dir.Magnitude > 0.01 then return dir.Unit end
        if camFwd.Magnitude > 0.01 then return camFwd.Unit end
        return Vector3.new(0, 0, -1)
    end

    local function sixerAirStrafeStep()
        if not dashTurn.sixer then return end
        local char = player.Character
        if not char then return end
        if char:GetAttribute("PursuitState") ~= "Dashing" then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if hum.FloorMaterial ~= Enum.Material.Air then return end
        local flat = Camera.CFrame.LookVector * Vector3.new(1, 0, 1)
        if flat.Magnitude < 0.01 then return end
        flat = flat.Unit
        local vel = hrp.AssemblyLinearVelocity
        local hVel = Vector3.new(vel.X, 0, vel.Z)
        local hSpeed = hVel.Magnitude
        if hSpeed < 0.1 then return end
        local newH = hVel:Lerp(flat * hSpeed, 1)
        hrp.AssemblyLinearVelocity = Vector3.new(newH.X, vel.Y, newH.Z)
    end

    local function coolkidDashTurnStep(dt)
        if not dashTurn.coolkid then return end
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hrp then return end
        if char:GetAttribute("FootstepsMuted") ~= true then return end
        local dir = getCameraInputDir()
        local lv = hrp:FindFirstChildWhichIsA("LinearVelocity")
        if lv then lv.LineDirection = dir end
        if dir.Magnitude > 0.01 then
            local targetRot = CFrame.new(hrp.Position, hrp.Position + dir).Rotation
            hrp.CFrame = CFrame.new(hrp.Position) * hrp.CFrame.Rotation:Lerp(targetRot, math.min(dt * 16, 1))
        end
    end

    local function noliStartOverride()
        if dashTurn.noliActive then return end
        dashTurn.noliActive = true
        dashTurn.noliConn = runService.RenderStepped:Connect(function()
            if not dashTurn.noli then noliStopOverride(); return end
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not hum or not root then return end
            if not dashTurn.noliOrigWalkSpeed then dashTurn.noliOrigWalkSpeed = hum.WalkSpeed end
            hum.WalkSpeed = 60
            hum.AutoRotate = false
            local horiz = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
            if horiz.Magnitude > 0 then hum:Move(horiz.Unit) end
        end)
    end

    local function noliStopOverride()
        if not dashTurn.noliActive then return end
        dashTurn.noliActive = false
        if dashTurn.noliConn then dashTurn.noliConn:Disconnect(); dashTurn.noliConn = nil end
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = dashTurn.noliOrigWalkSpeed or 16
            hum.AutoRotate = true
            pcall(function() hum:Move(Vector3.new(0, 0, 0)) end)
        end
        dashTurn.noliOrigWalkSpeed = nil
    end

    runService:BindToRenderStep("SixerAirStrafe", Enum.RenderPriority.Character.Value + 2, sixerAirStrafeStep)

    local coolkidConn = nil
    local function updateCoolkidDash()
        if coolkidConn then coolkidConn:Disconnect() end
        coolkidConn = runService.RenderStepped:Connect(function(dt) coolkidDashTurnStep(dt) end)
    end
    updateCoolkidDash()

    player.CharacterAdded:Connect(function() noliStopOverride() end)

    runService.RenderStepped:Connect(function()
        if not dashTurn.noli then
            if dashTurn.noliActive then noliStopOverride() end
            return
        end
        local char = player.Character
        if not char then return end
        if char:GetAttribute("VoidRushState") == "Dashing" then noliStartOverride() else noliStopOverride() end
    end)

    DashSection:Toggle({ Title = "访客666 - 空中控制", Callback = function(state) dashTurn.sixer = state end })
    DashSection:Toggle({ Title = "酷小孩 - 冲刺控制", Callback = function(state) dashTurn.coolkid = state end })
    DashSection:Toggle({ Title = "诺利 - 冲刺控制", Callback = function(state) dashTurn.noli = state; if not state then noliStopOverride() end end })
end

-- 自瞄
do
    local aim = { on = false, cooldown = 0.3, lockTime = 0.4, maxDist = 30, smooth = 0.35, targeting = false, target = nil, deathConn = nil, autoRotate = nil, lastFired = 0, hum = nil, hrp = nil, cache = {}, cacheTime = 0, cacheLife = 0.5 }

    local function aimIsKiller()
        local char = player.Character
        if not char then return false end
        local killersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
        return killersFolder and char:IsDescendantOf(killersFolder)
    end

    local function aimRefreshChar(ch)
        aim.hum = ch and ch:FindFirstChildOfClass("Humanoid")
        aim.hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    end

    local function aimRefreshTargets()
        local now = tick()
        if now - aim.cacheTime < aim.cacheLife then return end
        aim.cacheTime = now
        aim.cache = {}
        local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
        if not survivorsFolder then return end
        for _, model in ipairs(survivorsFolder:GetChildren()) do
            if model ~= player.Character and model:IsA("Model") then
                local h = model:FindFirstChildOfClass("Humanoid")
                local r = model:FindFirstChild("HumanoidRootPart")
                if h and r and h.Health > 0 then table.insert(aim.cache, r) end
            end
        end
    end

    local function aimNearest()
        aimRefreshTargets()
        if not aim.hrp or #aim.cache == 0 then return nil end
        local best, bestDist = nil, math.huge
        for _, r in ipairs(aim.cache) do
            local d = (r.Position - aim.hrp.Position).Magnitude
            if d < bestDist and d <= aim.maxDist then bestDist = d; best = r end
        end
        return best
    end

    local function aimUnlock()
        if not aim.targeting then return end
        if aim.deathConn then aim.deathConn:Disconnect(); aim.deathConn = nil end
        if aim.autoRotate ~= nil and aim.hum then aim.hum.AutoRotate = aim.autoRotate end
        aim.targeting = false
        aim.target = nil
    end

    local function aimLock(rootPart)
        if not rootPart or not rootPart.Parent or not aim.hum or not aim.hrp then return end
        if aim.targeting and aim.target == rootPart then return end
        aimUnlock()
        aim.target = rootPart
        aim.targeting = true
        aim.autoRotate = aim.hum.AutoRotate
        aim.hum.AutoRotate = false
        local targetHumanoid = rootPart.Parent:FindFirstChildOfClass("Humanoid")
        if targetHumanoid then aim.deathConn = targetHumanoid.Died:Connect(aimUnlock) end
        task.delay(aim.lockTime, function() if aim.target == rootPart then aimUnlock() end end)
    end

    local function setupAimbotTrigger()
        local remote = replicatedStorage:FindFirstChild("Modules") and replicatedStorage.Modules:FindFirstChild("Network") and replicatedStorage.Modules.Network:FindFirstChild("Network") and replicatedStorage.Modules.Network.Network:FindFirstChild("RemoteEvent")
        if not remote then return end
        remote.OnClientEvent:Connect(function(...)
            if not aim.on then return end
            local args = {...}
            if type(args[1]) ~= "string" then return end
            local abilityName = args[1]
            if abilityName:match("Ability") or abilityName:match("[QER]") or abilityName == "Slash" or abilityName == "Dagger" or abilityName == "Charge" or abilityName == "Stab" or abilityName == "Punch" then
                if tick() - aim.lastFired < aim.cooldown then return end
                aim.lastFired = tick()
                if aimIsKiller() then
                    local target = aimNearest()
                    if target then aimLock(target) end
                end
            end
        end)
    end

    player.CharacterAdded:Connect(function(ch) task.wait(0.5); aimRefreshChar(ch) end)
    if player.Character then aimRefreshChar(player.Character) end

    runService.RenderStepped:Connect(function()
        if not aim.on or not aim.targeting or not aim.hrp or not aim.target then return end
        if not aim.target.Parent then aimUnlock(); return end
        local targetHumanoid = aim.target.Parent:FindFirstChildOfClass("Humanoid")
        if not targetHumanoid or targetHumanoid.Health <= 0 then aimUnlock(); return end
        local flat = Vector3.new(aim.target.Position.X - aim.hrp.Position.X, 0, aim.target.Position.Z - aim.hrp.Position.Z).Unit
        if flat.Magnitude > 0 then aim.hrp.CFrame = aim.hrp.CFrame:Lerp(CFrame.new(aim.hrp.Position, aim.hrp.Position + flat), aim.smooth) end
    end)

    setupAimbotTrigger()

    AimbotSection:Toggle({ Title = "使用自瞄", Callback = function(state) aim.on = state; if not state then aimUnlock() end end })
    AimbotSection:Slider({ Title = "冷却时间 (秒)", Value = { Min = 0.1, Max = 2.0, Default = 0.3 }, Rounding = 1, Callback = function(val) aim.cooldown = val end })
    AimbotSection:Slider({ Title = "锁定时间 (秒)", Value = { Min = 0.1, Max = 3.0, Default = 0.4 }, Rounding = 1, Callback = function(val) aim.lockTime = val end })
    AimbotSection:Slider({ Title = "最大距离", Value = { Min = 5, Max = 100, Default = 30 }, Callback = function(val) aim.maxDist = val end })
    AimbotSection:Slider({ Title = "旋转平滑度", Value = { Min = 0.05, Max = 1.0, Default = 0.35 }, Rounding = 2, Callback = function(val) aim.smooth = val end })
end

-- 防背刺
do
    local abs = { on = false, range = 40, duration = 1.5, locked = false, soundConn = nil, scanThread = nil, rings = {} }
    local absTriggerSounds = { ["86710781315432"] = true, ["99820161736138"] = true }

    local function absAddRing(model)
        pcall(function()
            local hrp = model:FindFirstChild("HumanoidRootPart")
            if not hrp or abs.rings[model] then return end
            local ring = Instance.new("Part")
            ring.Name = "AbsRing"
            ring.Shape = Enum.PartType.Cylinder
            ring.Size = Vector3.new(0.1, abs.range * 2, abs.range * 2)
            ring.Color = Color3.fromRGB(220, 50, 50)
            ring.Material = Enum.Material.ForceField
            ring.Transparency = 0.5
            ring.CanCollide = false
            ring.CanTouch = false
            ring.CFrame = hrp.CFrame * CFrame.Angles(0, 0, math.rad(90))
            ring.Parent = hrp
            local w = Instance.new("WeldConstraint")
            w.Part0 = hrp
            w.Part1 = ring
            w.Parent = ring
            abs.rings[model] = ring
        end)
    end

    local function absRemoveRing(model)
        pcall(function()
            local r = abs.rings[model]
            if r then r:Destroy() end
            abs.rings[model] = nil
        end)
    end

    local function absResizeRings()
        pcall(function()
            for _, r in pairs(abs.rings) do
                if r and r.Parent then r.Size = Vector3.new(0.1, abs.range * 2, abs.range * 2) end
            end
        end)
    end

    local function absCleanRings()
        pcall(function() for m in pairs(abs.rings) do absRemoveRing(m) end end)
    end

    local function absFindTwoTime()
        local players = workspace:FindFirstChild("Players")
        if not players then return nil end
        for _, folder in ipairs(players:GetChildren()) do
            local tt = folder:FindFirstChild("TwoTime")
            if tt then return tt end
        end
        return nil
    end

    local function absTrigger()
        pcall(function()
            if abs.locked then return end
            local ch = player.Character
            local myRoot = ch and ch:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            local ttModel = absFindTwoTime()
            if not ttModel then return end
            local ttRoot = ttModel:FindFirstChild("HumanoidRootPart")
            if not ttRoot then return end
            if (myRoot.Position - ttRoot.Position).Magnitude > abs.range then return end
            abs.locked = true
            task.spawn(function()
                local deadline = tick() + abs.duration
                while tick() < deadline do
                    if not abs.on then break end
                    local ch2 = player.Character
                    local r2 = ch2 and ch2:FindFirstChild("HumanoidRootPart")
                    if not r2 or not ttRoot.Parent then break end
                    r2.CFrame = CFrame.lookAt(r2.Position, Vector3.new(ttRoot.Position.X, r2.Position.Y, ttRoot.Position.Z))
                    runService.RenderStepped:Wait()
                end
                abs.locked = false
            end)
        end)
    end

    local function absHookSounds()
        pcall(function()
            if abs.soundConn then abs.soundConn:Disconnect(); abs.soundConn = nil end
            local function checkSound(obj)
                if not abs.on or not obj:IsA("Sound") then return end
                local id = obj.SoundId:match("%d+")
                if id and absTriggerSounds[id] then absTrigger() end
            end
            abs.soundConn = workspace.DescendantAdded:Connect(function(obj)
                if obj:IsA("Sound") then
                    checkSound(obj)
                    obj:GetPropertyChangedSignal("SoundId"):Connect(function() checkSound(obj) end)
                end
            end)
        end)
    end

    local function absStartScan()
        if abs.scanThread then return end
        abs.scanThread = task.spawn(function()
            while abs.on do
                pcall(function()
                    local players = workspace:FindFirstChild("Players")
                    if players then
                        for _, folder in ipairs(players:GetChildren()) do
                            for _, model in ipairs(folder:GetChildren()) do
                                if model.Name == "TwoTime" then absAddRing(model) end
                            end
                        end
                    end
                    for m in pairs(abs.rings) do
                        if not m.Parent then absRemoveRing(m) end
                    end
                end)
                task.wait(1)
            end
            abs.scanThread = nil
        end)
    end

    local function absStart() pcall(function() absHookSounds(); absStartScan() end) end

    local function absStop()
        pcall(function()
            abs.on = false
            if abs.soundConn then abs.soundConn:Disconnect(); abs.soundConn = nil end
            if abs.scanThread then task.cancel(abs.scanThread); abs.scanThread = nil end
            absCleanRings()
            abs.locked = false
        end)
    end

    player.CharacterAdded:Connect(function()
        pcall(function() abs.locked = false; if abs.on then absStart() end end)
    end)

    ABSection:Toggle({ Title = "启用防背刺", Callback = function(state) pcall(function() abs.on = state; if state then absStart() else absStop() end end) end })
    ABSection:Slider({ Title = "检测范围", Value = { Min = 10, Max = 120, Default = 40 }, Callback = function(value) pcall(function() abs.range = value; absResizeRings() end) end })
    ABSection:Slider({ Title = "注视时间", Value = { Min = 0.3, Max = 5.0, Default = 1.5 }, Callback = function(value) pcall(function() abs.duration = value end) end })
end

-- 杀死全部人
do
    local killAll = { active = false, fly = false, teleport = false, flying = false, flySpeed = 50, currentTarget = nil, conn = nil, flightConn = nil, gyro = nil, vel = nil }

    local function startFly()
        if killAll.flying then return end
        killAll.flying = true
        local char = player.Character or player.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.AutoRotate = false
            killAll.gyro = Instance.new("BodyGyro")
            killAll.gyro.P = 90000
            killAll.gyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            killAll.gyro.CFrame = root.CFrame
            killAll.gyro.Parent = root
            killAll.vel = Instance.new("BodyVelocity")
            killAll.vel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            killAll.vel.Velocity = Vector3.zero
            killAll.vel.Parent = root
            killAll.flightConn = runService.Heartbeat:Connect(function()
                local cam = workspace.CurrentCamera
                local look = cam.CFrame.LookVector
                local right = cam.CFrame.RightVector
                local moveDir = humanoid.MoveDirection
                local forward = moveDir:Dot(Vector3.new(look.X, 0, look.Z).Unit)
                local rightDot = moveDir:Dot(Vector3.new(right.X, 0, right.Z).Unit)
                local up = moveDir.Magnitude <= 0 and 0 or look.Y * forward
                local velocity = look * forward + right * rightDot
                local finalVel = Vector3.new(velocity.X, up, velocity.Z)
                if finalVel.Magnitude > 1 then finalVel = finalVel.Unit end
                killAll.vel.Velocity = finalVel * killAll.flySpeed
                killAll.gyro.CFrame = CFrame.lookAt(root.Position, root.Position + look, cam.CFrame.UpVector)
            end)
        end
    end

    local function stopFly()
        if killAll.flying then
            killAll.flying = false
            if killAll.flightConn then killAll.flightConn:Disconnect(); killAll.flightConn = nil end
            if killAll.gyro then killAll.gyro:Destroy(); killAll.gyro = nil end
            if killAll.vel then killAll.vel:Destroy(); killAll.vel = nil end
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.AutoRotate = true end
            end
        end
    end

    local function getNearestSurvivor()
        local char = player.Character
        if not char then return nil end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        local survivors = workspace.Players:FindFirstChild("Survivors")
        if not survivors then return nil end
        local bestDist, bestTarget = math.huge, nil
        for _, model in ipairs(survivors:GetChildren()) do
            if model:IsA("Model") and model:FindFirstChild("Humanoid") and model.Humanoid.Health > 0 then
                local root = model:FindFirstChild("HumanoidRootPart")
                if root then
                    local dist = (root.Position - hrp.Position).Magnitude
                    if dist < bestDist then bestTarget = model; bestDist = dist end
                end
            end
        end
        return bestTarget
    end

    local function moveToTarget(target)
        if target and target:FindFirstChild("HumanoidRootPart") then
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local targetRoot = target.HumanoidRootPart
                    if killAll.teleport then
                        local look = targetRoot.CFrame.LookVector
                        local pos = targetRoot.Position - look * 2.7 + Vector3.new(0, 1.5, 0)
                        hrp.CFrame = CFrame.new(pos)
                        hrp.CFrame = CFrame.lookAt(pos, targetRoot.Position)
                    elseif killAll.fly then
                        if not killAll.flying then startFly() end
                        local unit = (targetRoot.Position - hrp.Position).Unit
                        char.Humanoid:MoveTo(hrp.Position + unit * 10)
                    else
                        char.Humanoid:MoveTo(targetRoot.Position)
                    end
                end
            end
        end
    end

    local function startKillAll()
        if not killAll.active then
            killAll.active = true
            killAll.conn = runService.Heartbeat:Connect(function()
                if killAll.active then
                    if killAll.currentTarget and (not killAll.currentTarget.Parent or not killAll.currentTarget:FindFirstChild("Humanoid") or killAll.currentTarget.Humanoid.Health <= 0) then
                        killAll.currentTarget = nil
                    end
                    if not killAll.currentTarget then
                        killAll.currentTarget = getNearestSurvivor()
                        if not killAll.currentTarget then return end
                    end
                    moveToTarget(killAll.currentTarget)
                end
            end)
        end
    end

    local function stopKillAll()
        if killAll.active then
            killAll.active = false
            if killAll.conn then pcall(function() killAll.conn:Disconnect() end); killAll.conn = nil end
            killAll.currentTarget = nil
            local char = player.Character
            if char and char:FindFirstChildOfClass("Humanoid") then pcall(function() char.Humanoid:MoveTo(char.HumanoidRootPart.Position) end) end
            if killAll.flying then stopFly() end
        end
    end

    KillAllSection:Toggle({ Title = "击杀模式", Callback = function(val) if val then startKillAll() else stopKillAll() end end })
    KillAllSection:Toggle({ Title = "传送模式", Callback = function(val) killAll.teleport = val; if val then killAll.fly = false end end })
    KillAllSection:Button({ Title = "切换目标", Callback = function() killAll.currentTarget = getNearestSurvivor() end })

    player.CharacterAdded:Connect(function() if killAll.active then stopKillAll() end end)
end

-- 吸力
do
    local suction = { enabled = false, strength = 50, maxDist = 100, cache = {}, cacheTime = 0, cacheLife = 0.3, conn = nil }

    local function isKiller()
        local char = player.Character
        if not char then return false end
        local killers = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
        return killers and char:IsDescendantOf(killers)
    end

    local function getNearestSurvivor()
        local now = tick()
        if now - suction.cacheTime < suction.cacheLife and suction.cache.target and suction.cache.target.Parent then return suction.cache.target end
        suction.cacheTime = now
        suction.cache = {}
        local survivors = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
        if not survivors then return nil end
        local char = player.Character
        if not char then return nil end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        local best, bestDist = nil, math.huge
        for _, model in ipairs(survivors:GetChildren()) do
            if model ~= char and model:IsA("Model") then
                local hum = model:FindFirstChildOfClass("Humanoid")
                local root = model:FindFirstChild("HumanoidRootPart")
                if hum and root and hum.Health > 0 then
                    local d = (root.Position - hrp.Position).Magnitude
                    if d < bestDist and d <= suction.maxDist then bestDist = d; best = root end
                end
            end
        end
        suction.cache.target = best
        return best
    end

    local function pushToTarget(targetRoot)
        if not targetRoot or not targetRoot.Parent then return end
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local direction = (targetRoot.Position - hrp.Position)
        if direction.Magnitude < 0.1 then return end
        direction = direction.Unit
        local currentVel = hrp.AssemblyLinearVelocity
        local pushForce = direction * suction.strength
        hrp.AssemblyLinearVelocity = currentVel:Lerp(currentVel + pushForce, 0.3)
    end

    local function startSuction()
        if suction.conn then return end
        suction.conn = runService.RenderStepped:Connect(function()
            if not suction.enabled then return end
            if not isKiller() then return end
            local target = getNearestSurvivor()
            if target then pushToTarget(target) end
        end)
    end

    local function stopSuction()
        if suction.conn then suction.conn:Disconnect(); suction.conn = nil end
        suction.cache = {}
    end

    SuctionSection:Toggle({ Title = "冲向幸存者", Callback = function(state) suction.enabled = state; if state then startSuction() else stopSuction() end end })
    SuctionSection:Slider({ Title = "吸力强度", Value = { Min = 5, Max = 100, Default = 50 }, Callback = function(v) suction.strength = v end })
    SuctionSection:Slider({ Title = "最大搜索距离", Value = { Min = 20, Max = 200, Default = 100 }, Callback = function(v) suction.maxDist = v end })

    player.CharacterAdded:Connect(function() if suction.enabled then stopSuction(); startSuction() end end)
end

-- ==========================================
--  综合功能
-- ==========================================
local MiscTab = Window:Tab({ Title = "综合功能", Icon = "settings" })
local MiscSection = MiscTab:Section({ Title = "其他功能" })

-- 吸血鬼自动挣脱
do
    local AutoEscapeEnabled = false
    local EscapeCooldown = 0.5

    MiscSection:Toggle({ Title = "吸血鬼自动挣脱", Callback = function(state) AutoEscapeEnabled = state end })
    MiscSection:Slider({ Title = "挣脱间隔", Value = { Min = 0.1, Max = 1.5, Default = 0.5 }, Rounding = 1, Callback = function(val) EscapeCooldown = val end })

    local function setupQTEListener()
        local playerGui = player:FindFirstChild("PlayerGui")
        if not playerGui then return end
        local tempUI = playerGui:FindFirstChild("TemporaryUI")
        if not tempUI then
            playerGui.ChildAdded:Connect(function(child) if child.Name == "TemporaryUI" then setupQTEListener() end end)
            return
        end
        tempUI.ChildAdded:Connect(function(uiElement)
            if uiElement.Name:upper() == "QTE" and uiElement:FindFirstChildOfClass("UIAspectRatioConstraint") then
                task.spawn(function()
                    while uiElement and uiElement.Visible and AutoEscapeEnabled do
                        local cooldown = EscapeCooldown
                        local halfRange = cooldown * 0.2
                        local waitTime = math.random() * (cooldown + halfRange - (cooldown - halfRange)) + (cooldown - halfRange)
                        task.wait(waitTime)
                        if not AutoEscapeEnabled then break end
                        local playersFolder = workspace:FindFirstChild("Players")
                        if playersFolder then
                            local killersFolder = playersFolder:FindFirstChild("Killers")
                            if killersFolder then
                                for _, killer in ipairs(killersFolder:GetChildren()) do
                                    if killer.Name:lower() == "nosferatu" then
                                        local killerPlayer = game.Players:GetPlayerFromCharacter(killer)
                                        if killerPlayer then
                                            local network = replicatedStorage:FindFirstChild("Modules")
                                            if network then
                                                network = network:FindFirstChild("Network")
                                                if network then
                                                    network = network:FindFirstChild("Network")
                                                    if network then
                                                        local remoteEvent = network:FindFirstChild("RemoteEvent")
                                                        if remoteEvent then remoteEvent:FireServer(killerPlayer.Name .. "NosHookQTE", {true}) end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end

    task.spawn(function()
        if player:FindFirstChild("PlayerGui") then
            local tempUI = player.PlayerGui:FindFirstChild("TemporaryUI")
            if tempUI then setupQTEListener()
            else player.PlayerGui.ChildAdded:Connect(function(child) if child.Name == "TemporaryUI" then setupQTEListener() end end) end
        end
    end)
end

-- 禁用约翰.多脚气伤害
do
    local DisableToxicTrails = false
    local InGame = nil

    local function HandleDisableToxicTrails(Value)
        if not InGame then return end
        for _, child in ipairs(InGame:GetChildren()) do
            if child:IsA("Folder") and (child.Name):find("JohnDoeTrail") then
                for _, part in ipairs(child:GetChildren()) do
                    if part:IsA("BasePart") then part.CanTouch = not Value end
                end
                if not child:GetAttribute("Checked") then
                    child:SetAttribute("Checked", true)
                    child.ChildAdded:Connect(function(newPart) if newPart:IsA("BasePart") then newPart.CanTouch = not DisableToxicTrails end end)
                end
            end
        end
    end

    local function UpdateInGame()
        local map = workspace:FindFirstChild("Map")
        if map then InGame = map:FindFirstChild("Ingame") else InGame = nil end
    end

    workspace.ChildAdded:Connect(function(child)
        if child.Name == "Map" then
            task.wait(0.5)
            UpdateInGame()
            if DisableToxicTrails then HandleDisableToxicTrails(true) end
        end
    end)

    task.spawn(function()
        UpdateInGame()
        if DisableToxicTrails then HandleDisableToxicTrails(true) end
    end)

    MiscSection:Toggle({
        Title = "禁用约翰.多脚气伤害",
        Callback = function(state)
            DisableToxicTrails = state
            UpdateInGame()
            HandleDisableToxicTrails(state)
        end
    })
end

-- 禁用约翰.多脚印伤害
do
    local DisableFootprints = false
    local InGame = nil

    local function HandleDisableFootprints(Value)
        if not InGame then return end
        for _, child in ipairs(InGame:GetChildren()) do
            if child:IsA("Folder") and (child.Name):find("Shadows") then
                for _, part in ipairs(child:GetChildren()) do
                    if part:IsA("BasePart") then part.CanTouch = not Value end
                end
                if not child:GetAttribute("Checked") then
                    child:SetAttribute("Checked", true)
                    child.ChildAdded:Connect(function(newPart) if newPart:IsA("BasePart") then newPart.CanTouch = not DisableFootprints end end)
                end
            end
        end
    end

    local function UpdateInGame()
        local map = workspace:FindFirstChild("Map")
        if map then InGame = map:FindFirstChild("Ingame") else InGame = nil end
    end

    workspace.ChildAdded:Connect(function(child)
        if child.Name == "Map" then
            task.wait(0.5)
            UpdateInGame()
            if DisableFootprints then HandleDisableFootprints(true) end
        end
    end)

    task.spawn(function()
        UpdateInGame()
        if DisableFootprints then HandleDisableFootprints(true) end
    end)

    MiscSection:Toggle({
        Title = "禁用约翰.多脚印大规模伤害",
        Callback = function(state)
            DisableFootprints = state
            UpdateInGame()
            HandleDisableFootprints(state)
        end
    })
end

-- 禁用杀手墙
do
    local DisableKillerWallsEnabled = false
    local GameMap = nil

    local function HandleDisableKillerWalls(Value, Tween)
        if not GameMap then return end
        local KillerDoorsFolder = GameMap:FindFirstChild("KillerDoors", true) or GameMap:FindFirstChild("Killer Doors", true)
        if not KillerDoorsFolder then return end
        for _, v in ipairs(KillerDoorsFolder:GetChildren()) do
            if v:IsA("BasePart") then
                if math.min(v.Size.X, v.Size.Z) > 5 then continue end
                v.CanTouch = true
                if v:GetAttribute("OriginalCanCollide") == nil then
                    v:SetAttribute("OriginalCanCollide", v.CanCollide)
                end
                v.CanCollide = v:GetAttribute("OriginalCanCollide") ~= false and not Value or false
            end
        end
    end

    local function UpdateGameMap()
        local map = workspace:FindFirstChild("Map")
        if map then
            local ingame = map:FindFirstChild("Ingame")
            if ingame then GameMap = ingame:FindFirstChild("Map") or map else GameMap = map end
        end
    end

    workspace.ChildAdded:Connect(function(child)
        if child.Name == "Map" then
            task.wait(1)
            UpdateGameMap()
            if DisableKillerWallsEnabled then HandleDisableKillerWalls(true, false) end
        end
    end)

    task.spawn(function()
        UpdateGameMap()
        if DisableKillerWallsEnabled then HandleDisableKillerWalls(true, false) end
    end)

    MiscSection:Toggle({
        Title = "禁用杀手墙",
        Callback = function(state)
            DisableKillerWallsEnabled = state
            UpdateGameMap()
            HandleDisableKillerWalls(state, false)
        end
    })
end

-- ==========================================
--  娱乐区
-- ==========================================
local FunTab = Window:Tab({ Title = "娱乐区", Icon = "gamepad-2" })
local FunSection = FunTab:Section({ Title = "娱乐功能" })

FunSection:Toggle({
    Title = "坐下",
    Callback = function(state)
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character:FindFirstChildOfClass("Humanoid").Sit = state
        end
    end
})

-- 刷新（原地复活）
do
    local refreshEnabled = false
    local deathPosition = nil

    local function onDied()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            deathPosition = player.Character.HumanoidRootPart.CFrame
        end
    end

    local function onCharacterAdded(newChar)
        if refreshEnabled and deathPosition then newChar:WaitForChild("HumanoidRootPart").CFrame = deathPosition end
    end

    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then player.Character.Humanoid.Died:Connect(onDied) end
    player.CharacterAdded:Connect(function(char) char:WaitForChild("Humanoid").Died:Connect(onDied) end)

    FunSection:Toggle({ Title = "刷新（死亡后原地复活）", Callback = function(state) refreshEnabled = state end })
end

-- 漂浮
do
    local swimEnabled = false
    local oldGravity = workspace.Gravity
    local swimHeartbeat = nil
    local gravResetConn = nil

    local function stopSwim()
        if swimHeartbeat then swimHeartbeat:Disconnect(); swimHeartbeat = nil end
        if gravResetConn then gravResetConn:Disconnect(); gravResetConn = nil end
        workspace.Gravity = oldGravity
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            for _, state in ipairs(Enum.HumanoidStateType:GetEnumItems()) do
                if state ~= Enum.HumanoidStateType.None then hum:SetStateEnabled(state, true) end
            end
        end
    end

    FunSection:Toggle({
        Title = "漂浮",
        Callback = function(state)
            if state then
                if not player.Character then return end
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if not hum then return end
                swimEnabled = true
                oldGravity = workspace.Gravity
                workspace.Gravity = 0
                gravResetConn = hum.Died:Connect(function() workspace.Gravity = oldGravity end)
                for _, s in ipairs(Enum.HumanoidStateType:GetEnumItems()) do
                    if s ~= Enum.HumanoidStateType.None and s ~= Enum.HumanoidStateType.Swimming then
                        hum:SetStateEnabled(s, false)
                    end
                end
                hum:ChangeState(Enum.HumanoidStateType.Swimming)
                swimHeartbeat = runService.Heartbeat:Connect(function()
                    pcall(function()
                        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                        if hrp and hum then
                            if hum.MoveDirection == Vector3.new() and not userInput:IsKeyDown(Enum.KeyCode.Space) then
                                hrp.Velocity = Vector3.new()
                            end
                        end
                    end)
                end)
            else
                stopSwim()
            end
        end
    })

    player.CharacterAdded:Connect(function() if swimEnabled then swimEnabled = false; stopSwim() end end)
end

FunSection:Button({
    Title = "变成药丸宝宝",
    Callback = function()
        local character = player.Character or player.CharacterAdded:Wait()
        if character then
            repeat task.wait() until character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid")
            local limbs = {"Left Arm", "Right Arm", "Left Leg", "Right Leg"}
            for _, limb in ipairs(limbs) do
                local part = character:FindFirstChild(limb)
                if part then part:Destroy() end
            end
            local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
            if torso then
                local mesh = torso:FindFirstChildOfClass("SpecialMesh")
                if not mesh then mesh = Instance.new("SpecialMesh", torso) end
                mesh.MeshId = "rbxasset://fonts/head.mesh"
                mesh.Scale = Vector3.new(1.4, 1.8, 1.4)
            end
        end
    end
})

FunSection:Button({
    Title = "滑铲按钮",
    Callback = function()
        local pg = player:WaitForChild("PlayerGui")
        local screenGui = pg:FindFirstChild("ScreenGui")
        if not screenGui then
            screenGui = Instance.new("ScreenGui")
            screenGui.Name = "ScreenGui"
            screenGui.Parent = pg
        end
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 100, 0, 40)
        btn.Position = UDim2.new(0.5, -50, 0.5, -20)
        btn.Text = "滑铲"
        btn.BackgroundColor3 = Color3.fromRGB(0, 119, 255)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        btn.BorderSizePixel = 0
        btn.Parent = screenGui
        btn.Draggable = true
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = btn

        btn.MouseButton1Click:Connect(function()
            local char = player.Character or player.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            local hum = char:WaitForChild("Humanoid")
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://182749109"
            local track = hum:LoadAnimation(anim)
            track:Play()
            local tween = game:GetService("TweenService"):Create(hrp, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                CFrame = hrp.CFrame * CFrame.new(0, 0, -20)
            })
            tween:Play()
            tween.Completed:Connect(function() track:Stop() end)
        end)
    end
})

-- 权限设置
local PermSection = FunTab:Section({ Title = "权限设置" })

PermSection:Button({
    Title = "解锁全部角色和皮肤",
    Callback = function()
        task.spawn(function()
            local purchased = player:WaitForChild("PlayerData"):WaitForChild("Purchased")
            local killersFolder = purchased:FindFirstChild("Killers") or Instance.new("Folder", purchased)
            killersFolder.Name = "Killers"
            local survivorsFolder = purchased:FindFirstChild("Survivors") or Instance.new("Folder", purchased)
            survivorsFolder.Name = "Survivors"
            local skinsFolder = purchased:FindFirstChild("Skins") or Instance.new("Folder", purchased)
            skinsFolder.Name = "Skins"
            for _, killer in ipairs(replicatedStorage:WaitForChild("Assets"):WaitForChild("Killers"):GetChildren()) do
                if not killersFolder:FindFirstChild(killer.Name) then Instance.new("StringValue", killersFolder).Name = killer.Name end
            end
            for _, survivor in ipairs(replicatedStorage:WaitForChild("Assets"):WaitForChild("Survivors"):GetChildren()) do
                if not survivorsFolder:FindFirstChild(survivor.Name) then Instance.new("StringValue", survivorsFolder).Name = survivor.Name end
            end
            local skinsRoot = replicatedStorage:WaitForChild("Assets"):WaitForChild("Skins")
            for _, skin in ipairs(skinsRoot:GetDescendants()) do
                if (skin:IsA("Folder") or skin:IsA("Model")) and not skinsFolder:FindFirstChild(skin.Name) then
                    Instance.new("StringValue", skinsFolder).Name = skin.Name
                end
            end
        end)
    end
})

PermSection:Button({
    Title = "解锁所有动作",
    Callback = function()
        task.spawn(function()
            local purchased = player:WaitForChild("PlayerData"):WaitForChild("Purchased")
            local emotesFolder = purchased:FindFirstChild("Emotes") or Instance.new("Folder", purchased)
            emotesFolder.Name = "Emotes"
            local emotesAssets = replicatedStorage:WaitForChild("Assets"):WaitForChild("Emotes")
            for _, module in ipairs(emotesAssets:GetDescendants()) do
                if module:IsA("ModuleScript") and not emotesFolder:FindFirstChild(module.Name) then
                    Instance.new("StringValue", emotesFolder).Name = module.Name
                end
            end
        end)
    end
})

PermSection:Button({
    Title = "解锁VIP权限",
    Callback = function()
        player:SetAttribute("VIP", true)
        local pData = player:WaitForChild("PlayerData")
        local vVal = pData:FindFirstChild("VIP")
        if not vVal then
            vVal = Instance.new("BoolValue")
            vVal.Name = "VIP"
            vVal.Parent = pData
        end
        vVal.Value = true
    end
})

-- 修改系统
local StatSection = FunTab:Section({ Title = "修改系统" })

local statsFields = {
    Money = "钱",
    NetWorth = "净资产",
    KillerChance = "杀手几率",
    TimePlayed = "游玩时间",
    KillerWins = "杀手胜利",
    Kills = "击杀数",
    SurvivorWins = "幸存者胜利",
    ObjectivesCompleted = "任务完成数"
}

for statName, displayName in pairs(statsFields) do
    StatSection:Input({
        Title = "设置 " .. displayName,
        Placeholder = "输入数值",
        Callback = function(value)
            pcall(function()
                local stats = player:FindFirstChild("PlayerData") and player.PlayerData:FindFirstChild("Stats")
                if not stats then return end
                local statObj = stats:FindFirstChild(statName, true)
                if statObj and (statObj:IsA("NumberValue") or statObj:IsA("IntValue") or statObj:IsA("FloatValue")) then
                    local num = tonumber(value)
                    if num then statObj.Value = num end
                end
            end)
        end
    })
end

-- ==========================================
--  作者识别标签
-- ==========================================
local AUTHOR_USERNAME = "TornadoOmegaZMeteor2"
local AUTHOR_DISPLAY = "脚本作者"

do
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer

    local function isAuthor(p)
        return p.Name:lower() == AUTHOR_USERNAME:lower()
    end

    local function attachAuthorTag(character)
        if character:FindFirstChild("AuthorTag") then return end
        local head = character:FindFirstChild("Head") or character:FindFirstChildWhichIsA("BasePart")
        if not head then return end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "AuthorTag"
        billboard.Adornee = head
        billboard.StudsOffset = Vector3.new(0, 3.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 220, 0, 60)
        billboard.Parent = character

        local label = Instance.new("TextLabel")
        label.Name = "MainLabel"
        label.Size = UDim2.new(1, 0, 0, 30)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 215, 0)
        label.TextStrokeTransparency = 0
        label.TextStrokeColor3 = Color3.new(0, 0, 0)
        label.TextSize = 18
        label.Font = Enum.Font.GothamBold
        label.Text = "👑 " .. AUTHOR_DISPLAY
        label.Parent = billboard

        local subLabel = Instance.new("TextLabel")
        subLabel.Name = "SubLabel"
        subLabel.Size = UDim2.new(1, 0, 0, 20)
        subLabel.Position = UDim2.new(0, 0, 0, 28)
        subLabel.BackgroundTransparency = 1
        subLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        subLabel.TextStrokeTransparency = 0
        subLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        subLabel.TextSize = 13
        subLabel.Font = Enum.Font.Gotham
        subLabel.Text = "@" .. AUTHOR_USERNAME
        subLabel.Parent = billboard

        local highlight = Instance.new("Highlight")
        highlight.Name = "AuthorHighlight"
        highlight.FillTransparency = 1
        highlight.OutlineTransparency = 0
        highlight.OutlineColor = Color3.fromRGB(255, 215, 0)
        highlight.Adornee = character
        highlight.Parent = character
    end

    local function checkPlayer(p)
        if isAuthor(p) and p ~= localPlayer then
            if p.Character then attachAuthorTag(p.Character) end
            p.CharacterAdded:Connect(function(char) task.wait(0.5); attachAuthorTag(char) end)
        end
    end

    for _, p in ipairs(Players:GetPlayers()) do checkPlayer(p) end
    Players.PlayerAdded:Connect(function(p) checkPlayer(p) end)

    print("✅ 作者识别标签已加载 | 作者: " .. AUTHOR_USERNAME)
end

-- ==========================================
--  最终加载完成
-- ==========================================
task.wait(0.5)

game.StarterGui:SetCore("SendNotification", {
    Title = "✅ 加载完成",
    Text = "被遗弃脚本 WindUI版 | 作者: " .. AUTHOR_USERNAME,
    Duration = 3
})

print("✅ 被遗弃脚本 WindUI版 已完全加载")
print("📦 包含: 通用区 | 透视区 | 体力区 | 物品区 | 发电机 | 幸存者 | 杀手 | 综合 | 娱乐")
print("👑 作者识别: " .. AUTHOR_USERNAME)