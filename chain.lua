local P = game:GetService("Players")
local RS = game:GetService("RunService")
local L = game:GetService("Lighting")
local W = game:GetService("Workspace")
local CG = game:GetService("CoreGui")
local Cam = W.CurrentCamera
local lp = P.LocalPlayer

local SansHub = loadstring(game:HttpGet("https://sanshub.cloud/raw/NL/web_loader.luau"))()
local UILib, Mod = SansHub:Load()
local Logger = UILib:CreateLogger()

local notifySound = Instance.new("Sound")
notifySound.SoundId = "rbxassetid://6895079853"
notifySound.Volume = 3
notifySound.PlayOnRemove = false
notifySound.Parent = CG

local errorSound = Instance.new("Sound")
errorSound.SoundId = "rbxassetid://7116952708"
errorSound.Volume = 3
errorSound.PlayOnRemove = false
errorSound.Parent = CG

local function Notify(icon, msg, dur, color)
    Logger.new(icon, msg, dur or 2, color)
    pcall(function() notifySound:Play() end)
end

local valuesFolder = W:WaitForChild("GameStuff"):WaitForChild("Values")
local aiFolder = W:WaitForChild("Misc"):WaitForChild("AI")

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "SansHubESP"
ESPFolder.Parent = CG

local ESPList = {}

local ESP = {}

function ESP:Add(config)
    local entity = config.Entity
    if not entity then return nil end
    local part = config.Part
    if not part then
        if entity:IsA("Player") then
            local char = entity.Character
            part = char and char:FindFirstChild("HumanoidRootPart")
        elseif entity:IsA("Model") then
            part = entity:FindFirstChild("HumanoidRootPart") or entity.PrimaryPart
            if not part then part = entity:FindFirstChildWhichIsA("BasePart", true) end
        elseif entity:IsA("BasePart") then
            part = entity
        end
    end
    if not part then return nil end
    local cfg = {
        Name = config.Name or entity.Name,
        Color = config.Color or Color3.fromRGB(255, 255, 255),
        Highlight = config.Highlight ~= false,
        Box = config.Box == true,
        Line = config.Line == true,
        Text = config.Text ~= false,
        Distance = config.Distance ~= false,
        Info = config.Info or nil,
        TextSize = config.TextSize or 14,
        AlwaysOnTop = config.AlwaysOnTop ~= false,
        StudsOffset = config.StudsOffset or Vector3.new(0, 3, 0),
        BillboardSize = config.BillboardSize or UDim2.new(0, 200, 0, 40),
    }
    local d = {
        Entity = entity, Part = part, Config = cfg, Enabled = true,
        HL = nil, Gui = nil, NL = nil, DL = nil, IL = nil, Box = nil, Line = nil,
    }
    d.Box = Drawing.new("Square")
    d.Box.Thickness = 1
    d.Box.Filled = false
    d.Box.Visible = false
    d.Line = Drawing.new("Line")
    d.Line.Thickness = 1
    d.Line.Visible = false
    if cfg.Highlight then
        local hlTarget = entity
        if entity:IsA("Player") and entity.Character then hlTarget = entity.Character end
        pcall(function() local old = hlTarget:FindFirstChildOfClass("Highlight") if old then old:Destroy() end end)
        local hl = Instance.new("Highlight")
        hl.FillColor = cfg.Color
        hl.OutlineColor = cfg.Color
        hl.FillTransparency = 0.6
        hl.OutlineTransparency = 0.1
        if cfg.AlwaysOnTop then hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop end
        hl.Parent = hlTarget
        d.HL = hl
    end
    local ap = part
    if entity:IsA("Player") and entity.Character then
        local hd = entity.Character:FindFirstChild("Head")
        if hd then ap = hd end
    end
    local gui = Instance.new("BillboardGui")
    gui.Size = cfg.BillboardSize
    gui.StudsOffset = cfg.StudsOffset
    gui.AlwaysOnTop = true
    gui.Adornee = ap
    gui.Parent = ESPFolder
    local nl = Instance.new("TextLabel")
    nl.Size = UDim2.new(1, 0, 0, cfg.TextSize + 4)
    nl.BackgroundTransparency = 1
    nl.Text = cfg.Name
    nl.TextColor3 = cfg.Color
    nl.TextStrokeTransparency = 0
    nl.TextSize = cfg.TextSize
    nl.Font = Enum.Font.SourceSansBold
    nl.Parent = gui
    local dl = Instance.new("TextLabel")
    dl.Size = UDim2.new(1, 0, 0, cfg.TextSize)
    dl.Position = UDim2.new(0, 0, 0, cfg.TextSize + 2)
    dl.BackgroundTransparency = 1
    dl.Text = "0m"
    dl.TextColor3 = cfg.Color
    dl.TextStrokeTransparency = 0
    dl.TextSize = cfg.TextSize - 2
    dl.Font = Enum.Font.SourceSans
    dl.Parent = gui
    local il = Instance.new("TextLabel")
    il.Size = UDim2.new(1, 0, 0, cfg.TextSize)
    il.Position = UDim2.new(0, 0, 0, cfg.TextSize * 2 + 2)
    il.BackgroundTransparency = 1
    il.Text = ""
    il.TextColor3 = Color3.new(1, 1, 1)
    il.TextStrokeTransparency = 0
    il.TextSize = cfg.TextSize - 2
    il.Font = Enum.Font.SourceSans
    il.Visible = false
    il.Parent = gui
    d.Gui = gui; d.NL = nl; d.DL = dl; d.IL = il
    local obj = {}
    function obj:SetText(t) cfg.Name = t if d.NL then d.NL.Text = t end end
    function obj:SetColor(c)
        cfg.Color = c
        if d.HL then d.HL.FillColor = c; d.HL.OutlineColor = c end
        if d.NL then d.NL.TextColor3 = c end
        if d.DL then d.DL.TextColor3 = c end
        if d.Box then d.Box.Color = c end
        if d.Line then d.Line.Color = c end
    end
    function obj:SetEnabled(v)
        d.Enabled = v
        if not v then
            if d.HL then d.HL.Enabled = false end
            if d.Gui then d.Gui.Enabled = false end
            if d.Box then d.Box.Visible = false end
            if d.Line then d.Line.Visible = false end
        end
    end
    function obj:SetInfo(t)
        cfg.Info = t
        if d.IL then
            if t and t ~= "" then d.IL.Text = t; d.IL.Visible = true
            else d.IL.Visible = false end
        end
    end
    function obj:SetPart(p) d.Part = p end
    function obj:SetConfig(key, val) cfg[key] = val end
    function obj:Remove()
        if d.HL then pcall(function() d.HL:Destroy() end) end
        if d.Gui then pcall(function() d.Gui:Destroy() end) end
        if d.Box then pcall(function() d.Box:Remove() end) end
        if d.Line then pcall(function() d.Line:Remove() end) end
        ESPList[d] = nil
    end
    ESPList[d] = true
    return obj
end

function ESP:RemoveAll()
    for d in pairs(ESPList) do
        if d.HL then pcall(function() d.HL:Destroy() end) end
        if d.Gui then pcall(function() d.Gui:Destroy() end) end
        if d.Box then pcall(function() d.Box:Remove() end) end
        if d.Line then pcall(function() d.Line:Remove() end) end
        ESPList[d] = nil
    end
end

function ESP:SetColor(c)
    for d in pairs(ESPList) do
        if d.Config then d.Config.Color = c end
        if d.HL then d.HL.FillColor = c; d.HL.OutlineColor = c end
        if d.NL then d.NL.TextColor3 = c end
        if d.DL then d.DL.TextColor3 = c end
        if d.Box then d.Box.Color = c end
        if d.Line then d.Line.Color = c end
    end
end

function ESP:GetObjects() return ESPList end

RS.RenderStepped:Connect(function()
    Cam = W.CurrentCamera
    local lc = lp.Character
    local lhrp = lc and lc:FindFirstChild("HumanoidRootPart")
    for d in pairs(ESPList) do
        local e = d.Entity
        local p = d.Part
        local c = d.Config
        if not e or not e.Parent then
            if d.HL then pcall(function() d.HL:Destroy() end) end
            if d.Gui then pcall(function() d.Gui:Destroy() end) end
            if d.Box then pcall(function() d.Box:Remove() end) end
            if d.Line then pcall(function() d.Line:Remove() end) end
            ESPList[d] = nil
        elseif not p or not p.Parent then
            if d.Gui then d.Gui.Enabled = false end
            if d.HL then d.HL.Enabled = false end
            if d.Box then d.Box.Visible = false end
            if d.Line then d.Line.Visible = false end
        else
            local alive = true
            if e:IsA("Player") then
                local hum = e.Character and e.Character:FindFirstChild("Humanoid")
                alive = hum and hum.Health > 0
            elseif e:IsA("Model") then
                local hum = e:FindFirstChild("Humanoid")
                if hum then alive = hum.Health > 0 end
            end
            if not d.Enabled or not alive then
                if d.HL then d.HL.Enabled = false end
                if d.Gui then d.Gui.Enabled = false end
                if d.Box then d.Box.Visible = false end
                if d.Line then d.Line.Visible = false end
            else
                if c.Highlight then
                    local hlTarget = e
                    if e:IsA("Player") and e.Character then hlTarget = e.Character end
                    if not d.HL then
                        pcall(function() local old = hlTarget:FindFirstChildOfClass("Highlight") if old then old:Destroy() end end)
                        local hl = Instance.new("Highlight")
                        hl.FillColor = c.Color
                        hl.OutlineColor = c.Color
                        hl.FillTransparency = 0.6
                        hl.OutlineTransparency = 0.1
                        if c.AlwaysOnTop then hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop end
                        hl.Parent = hlTarget
                        d.HL = hl
                    end
                    d.HL.Enabled = true
                    d.HL.FillColor = c.Color
                    d.HL.OutlineColor = c.Color
                else
                    if d.HL then d.HL.Enabled = false end
                end
                local dist = lhrp and math.floor((lhrp.Position - p.Position).Magnitude) or 0
                local sp, onScr = Cam:WorldToViewportPoint(p.Position)
                local sPos = Vector2.new(sp.X, sp.Y)
                if d.Gui then
                    d.Gui.Enabled = onScr and (c.Text or c.Distance)
                    d.NL.Visible = c.Text
                    d.NL.Text = c.Name
                    d.NL.TextColor3 = c.Color
                    d.NL.TextSize = c.TextSize
                    d.DL.Visible = c.Distance
                    d.DL.Text = tostring(dist) .. "m"
                    d.DL.TextColor3 = c.Color
                    d.DL.TextSize = c.TextSize - 2
                    d.DL.Position = UDim2.new(0, 0, 0, c.TextSize + 2)
                    if c.Info and c.Info ~= "" then
                        d.IL.Text = c.Info
                        d.IL.TextColor3 = c.Color
                        d.IL.TextSize = c.TextSize - 2
                        d.IL.Position = UDim2.new(0, 0, 0, c.TextSize * 2 + 2)
                        d.IL.Visible = true
                    else
                        d.IL.Visible = false
                    end
                end
                if c.Box and d.Box then
                    local cf, sz
                    local char = e:IsA("Player") and e.Character or e
                    if char and char:IsA("Model") then
                        local okBB, rcf, rsz = pcall(char.GetBoundingBox, char)
                        if okBB and rcf then cf, sz = rcf, rsz end
                    end
                    if not cf then cf = p.CFrame; sz = p.Size end
                    local cn = {
                        cf * CFrame.new(-sz.X/2, -sz.Y/2, -sz.Z/2),
                        cf * CFrame.new(sz.X/2, -sz.Y/2, -sz.Z/2),
                        cf * CFrame.new(sz.X/2, sz.Y/2, -sz.Z/2),
                        cf * CFrame.new(-sz.X/2, sz.Y/2, -sz.Z/2),
                        cf * CFrame.new(-sz.X/2, -sz.Y/2, sz.Z/2),
                        cf * CFrame.new(sz.X/2, -sz.Y/2, sz.Z/2),
                        cf * CFrame.new(sz.X/2, sz.Y/2, sz.Z/2),
                        cf * CFrame.new(-sz.X/2, sz.Y/2, sz.Z/2),
                    }
                    local x1, y1 = math.huge, math.huge
                    local x2, y2 = -math.huge, -math.huge
                    local boxVis = false
                    for _, cn2 in ipairs(cn) do
                        local s, o = Cam:WorldToViewportPoint(cn2.Position)
                        if o then boxVis = true; x1 = math.min(x1, s.X); y1 = math.min(y1, s.Y); x2 = math.max(x2, s.X); y2 = math.max(y2, s.Y) end
                    end
                    if boxVis then
                        d.Box.Position = Vector2.new(x1, y1)
                        d.Box.Size = Vector2.new(x2 - x1, y2 - y1)
                        d.Box.Color = c.Color
                        d.Box.Visible = true
                    else d.Box.Visible = false end
                elseif d.Box then d.Box.Visible = false end
                if c.Line and d.Line then
                    local fromPos
                    local localChar = lp.Character
                    local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
                    if localHRP then
                        local lsp = Cam:WorldToViewportPoint(localHRP.Position)
                        if lsp.Z > 0 then
                            fromPos = Vector2.new(lsp.X, lsp.Y)
                        end
                    end
                    if not fromPos then
                        local vp = Cam.ViewportSize
                        fromPos = Vector2.new(vp.X / 2, vp.Y)
                    end
                    d.Line.From = fromPos
                    d.Line.To = sPos
                    d.Line.Color = c.Color
                    d.Line.Visible = true
                elseif d.Line then d.Line.Visible = false end
            end
        end
    end
end)

task.spawn(function()
    local blueprints = lp:WaitForChild("PlayerStats"):WaitForChild("Blueprints")
    local bpDisplay = {
        CombatKnife = "战斗小刀",
        DoubleBarrel = "双管霰弹枪",
        M1911 = "M1911手枪",
        Machete = "砍刀",
        Deagle = "沙漠之鹰",
        SpellBook = "魔法书"
    }
    local blue = Color3.fromRGB(70, 130, 255)
    for _, name in ipairs({"CombatKnife", "DoubleBarrel", "M1911", "Machete", "Deagle", "SpellBook"}) do
        pcall(function()
            if blueprints:GetAttribute(name) ~= nil then
                blueprints:SetAttribute(name, true)
                Logger.new("check", bpDisplay[name] or name .. " 已解锁", 10, blue)
                pcall(function() notifySound:Play() end)
                task.wait(0.3)
            end
        end)
    end
    local pg = lp:WaitForChild("PlayerGui")
    local ingame = pg:WaitForChild("Ingame")
    local wb = ingame:WaitForChild("Workbench"):WaitForChild("MainFrame"):WaitForChild("Frame"):WaitForChild("Menu"):WaitForChild("Blueprints")
    local bpNames = {"Deagle", "CombatKnife", "DoubleBarrel", "M1911", "Machete", "SpellBook"}
    local function showBlueprints()
        for _, name in ipairs(bpNames) do
            pcall(function()
                local frame = wb:FindFirstChild(name)
                if frame then
                    frame.Visible = true
                    local lock = frame:FindFirstChild("LockGradient")
                    if lock then lock.Visible = false end
                end
            end)
        end
    end
    showBlueprints()
    wb.DescendantAdded:Connect(function(child)
        task.wait(0.1)
        showBlueprints()
    end)
end)

task.spawn(function()
    local saved = lp:WaitForChild("PlayerStats"):WaitForChild("SavedItems")
    for _, name in ipairs({"AK47"}) do
        pcall(function()
            if saved:GetAttribute(name) ~= nil then saved:SetAttribute(name, true) end
        end)
    end
end)

local Indicator = UILib:CreateIndicator()
local TimeIndicator = Indicator.new({ Name = "时间", Icon = 'clock', Color = 'White' })
local PowerIndicator = Indicator.new({ Name = "电力", Icon = 'zap', Color = 'White' })
local PseudoIndicator = Indicator.new({ Name = "伪无敌", Icon = 'person', Color = 'Red' })
TimeIndicator:SetRender(true)
PowerIndicator:SetRender(true)
PseudoIndicator:SetRender(true)
PowerIndicator:SetIconText("lightning-bolt")
PseudoIndicator:SetText("伪无敌")

local pseudoActive = false
local pseudoSeat = nil
local savedAutoStates = {}


task.spawn(function()
    while true do
        local t = valuesFolder:GetAttribute("RoundTime")
        local p = valuesFolder:GetAttribute("Power")
        if type(t) == "number" and t > 0 then
            TimeIndicator:SetText(tostring(math.floor(t)) .. "s")
            TimeIndicator:SetColor('White')
        else
            TimeIndicator:SetText("白天")
            TimeIndicator:SetColor('Green')
        end
        if type(p) == "number" then
            PowerIndicator:SetText(string.format("%.1f", p) .. "%")
            if p <= 10 then PowerIndicator:SetColor('Red') else PowerIndicator:SetColor('White') end
        end
        task.wait(0.5)
    end
end)

local Window = UILib:CreateWindow({
    Logo = UILib.GlobalLogo,
    Name = "NeverLose",
    Content = "",
    Size = UILib.Scales.Default,
    ConfigFolder = "NLConfig",
    Keybind = "Insert"
})

local Watermark = Window:Watermark()
Watermark:AddBlock("shield", "NeverLoser")
local wmUser = Watermark:AddBlock("user", lp.Name)
local wmFps = Watermark:AddBlock("activity", "60 FPS")
local wmPing = Watermark:AddBlock("chart-four-vertical-bars", "0 MS")

task.spawn(function()
    local thumb = ""
    pcall(function() thumb = game:GetService("Players"):GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48) end)
    if thumb ~= "" then wmUser:SetIcon(thumb) end
end)

local fpsCount = 0
local fpsLast = tick()
RS.Heartbeat:Connect(function()
    fpsCount = fpsCount + 1
    local now = tick()
    if now - fpsLast >= 1 then
        wmFps:SetText(fpsCount .. " FPS")
        fpsCount = 0
        fpsLast = now
    end
    pcall(function()
        wmPing:SetText(math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) .. " MS")
    end)
end)

local ESPTab = Window:AddTab({ Icon = 'eye', Name = "视觉", Type = "Double" })
local PlayerTab = Window:AddTab({ Icon = 'person', Name = "玩家", Type = "Double" })

local ESPSectionLeft = ESPTab:AddSection({ Name = "玩家 & chain", Position = 'left' })
local ESPSectionRight = ESPTab:AddSection({ Name = "区域 & 东西", Position = 'right' })
local PlayerSectionLeft = PlayerTab:AddSection({ Name = "能力", Position = 'left' })
local PlayerSectionRight = PlayerTab:AddSection({ Name = "光照", Position = 'right' })

local PlayerESPObjs = {}
local PlayerESPSettings = {
    Enabled = false,
    Highlight = true,
    Box = true,
    Text = true,
    Distance = true,
    Line = false,
    TextSize = 14,
    Color = Color3.fromRGB(0, 120, 255)
}

local function SetupPlayerESP(player)
    if player == lp then return end
    local function onCharacter(char)
        if not PlayerESPSettings.Enabled then return end
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if not hrp then return end
        if PlayerESPObjs[player] then PlayerESPObjs[player]:Remove() end
        PlayerESPObjs[player] = ESP:Add({
            Entity = player,
            Part = hrp,
            Name = player.Name,
            Color = PlayerESPSettings.Color,
            Highlight = PlayerESPSettings.Highlight,
            Box = PlayerESPSettings.Box,
            Line = PlayerESPSettings.Line,
            Text = PlayerESPSettings.Text,
            Distance = PlayerESPSettings.Distance,
            TextSize = PlayerESPSettings.TextSize,
            AlwaysOnTop = false,
        })
    end
    player.CharacterAdded:Connect(onCharacter)
    if player.Character then onCharacter(player.Character) end
end

local function UpdateAllPlayerESP(key, val) for _, obj in pairs(PlayerESPObjs) do obj:SetConfig(key, val) end end

local PlayerLabel = ESPSectionLeft:AddLabel('玩家', false)
PlayerLabel:AddToggle({
    Default = false,
    Flag = "PlayerESP",
    Callback = function(value)
        PlayerESPSettings.Enabled = value
        if value then
            for _, player in ipairs(P:GetPlayers()) do
                if player ~= lp then SetupPlayerESP(player) end
            end
        else
            for player, obj in pairs(PlayerESPObjs) do obj:Remove() end
            table.clear(PlayerESPObjs)
        end
    end,
})
PlayerLabel:AddColorPicker({
    Default = Color3.fromRGB(0, 120, 255),
    Flag = "PlayerColor",
    Callback = function(color)
        PlayerESPSettings.Color = color
        for _, obj in pairs(PlayerESPObjs) do obj:SetColor(color) end
    end,
})
local PlayerOption = PlayerLabel:AddOption(1)
PlayerOption:AddLabel("高亮"):AddToggle({ Default = true, Flag = "PlayerHighlight", Callback = function(v) PlayerESPSettings.Highlight = v; UpdateAllPlayerESP("Highlight", v) end })
PlayerOption:AddLabel("方框"):AddToggle({ Default = true, Flag = "PlayerBox", Callback = function(v) PlayerESPSettings.Box = v; UpdateAllPlayerESP("Box", v) end })
PlayerOption:AddLabel("名称"):AddToggle({ Default = true, Flag = "PlayerText", Callback = function(v) PlayerESPSettings.Text = v; UpdateAllPlayerESP("Text", v) end })
PlayerOption:AddLabel("距离"):AddToggle({ Default = true, Flag = "PlayerDistance", Callback = function(v) PlayerESPSettings.Distance = v; UpdateAllPlayerESP("Distance", v) end })
PlayerOption:AddLabel("线条"):AddToggle({ Default = false, Flag = "PlayerLine", Callback = function(v) PlayerESPSettings.Line = v; UpdateAllPlayerESP("Line", v) end })
PlayerOption:AddLabel("文字大小"):AddSlider({ Default = 14, Min = 8, Max = 24, Rounding = 0, Flag = "PlayerTextSize", Size = 110, Callback = function(v) PlayerESPSettings.TextSize = v; UpdateAllPlayerESP("TextSize", v) end })

P.PlayerAdded:Connect(function(p)
    if p ~= lp and PlayerESPSettings.Enabled then SetupPlayerESP(p) end
end)
P.PlayerRemoving:Connect(function(p)
    if PlayerESPObjs[p] then PlayerESPObjs[p]:Remove() PlayerESPObjs[p] = nil end
end)

local ChainESPObjs = {}
local ChainESPSettings = {
    Enabled = false,
    Highlight = true,
    Box = true,
    Text = true,
    Distance = true,
    Info = true,
    Line = true,
    TextSize = 14,
    Color = Color3.fromRGB(255, 21, 21)
}

local function CreateChainESP(entity)
    local hrp = entity:WaitForChild("HumanoidRootPart", 5)
    if not hrp then return end
    local head = entity:FindFirstChild("Head")
    local obj = ESP:Add({
        Entity = entity,
        Part = hrp,
        Name = entity.Name,
        Color = ChainESPSettings.Color,
        Highlight = ChainESPSettings.Highlight,
        Box = ChainESPSettings.Box,
        Line = ChainESPSettings.Line,
        Text = ChainESPSettings.Text,
        Distance = ChainESPSettings.Distance,
        TextSize = ChainESPSettings.TextSize,
        AlwaysOnTop = true,
        StudsOffset = Vector3.new(0, 3.5, 0),
        BillboardSize = UDim2.new(0, 300, 0, 60),
    })
    if obj then
        ChainESPObjs[entity] = obj
        entity.AncestryChanged:Connect(function(_, parent)
            if not parent then
                if ChainESPObjs[entity] then
                    ChainESPObjs[entity]:Remove()
                    ChainESPObjs[entity] = nil
                end
            end
        end)
    end
end

local function UpdateAllChainESP(key, val) for _, obj in pairs(ChainESPObjs) do obj:SetConfig(key, val) end end

local ChainLabel = ESPSectionLeft:AddLabel('chain', false)
ChainLabel:AddToggle({
    Default = false,
    Flag = "ChainESP",
    Callback = function(value)
        ChainESPSettings.Enabled = value
        if value then
            for _, c in ipairs(aiFolder:GetChildren()) do
                if c:IsA("Model") and c:FindFirstChild("Humanoid") then
                    CreateChainESP(c)
                end
            end
        else
            for entity, obj in pairs(ChainESPObjs) do obj:Remove() end
            table.clear(ChainESPObjs)
        end
    end,
})
ChainLabel:AddColorPicker({
    Default = Color3.fromRGB(255, 21, 21),
    Flag = "ChainColor",
    Callback = function(color)
        ChainESPSettings.Color = color
        for _, obj in pairs(ChainESPObjs) do obj:SetColor(color) end
    end,
})
local ChainOption = ChainLabel:AddOption(1)
ChainOption:AddLabel("高亮"):AddToggle({ Default = true, Flag = "ChainHighlight", Callback = function(v) ChainESPSettings.Highlight = v; UpdateAllChainESP("Highlight", v) end })
ChainOption:AddLabel("方框"):AddToggle({ Default = true, Flag = "ChainBox", Callback = function(v) ChainESPSettings.Box = v; UpdateAllChainESP("Box", v) end })
ChainOption:AddLabel("名称"):AddToggle({ Default = true, Flag = "ChainText", Callback = function(v) ChainESPSettings.Text = v; UpdateAllChainESP("Text", v) end })
ChainOption:AddLabel("距离"):AddToggle({ Default = true, Flag = "ChainDistance", Callback = function(v) ChainESPSettings.Distance = v; UpdateAllChainESP("Distance", v) end })
ChainOption:AddLabel("线条"):AddToggle({ Default = true, Flag = "ChainLine", Callback = function(v) ChainESPSettings.Line = v; UpdateAllChainESP("Line", v) end })
ChainOption:AddLabel("信息"):AddToggle({ Default = true, Flag = "ChainInfo", Callback = function(v) ChainESPSettings.Info = v end })
ChainOption:AddLabel("文字大小"):AddSlider({ Default = 14, Min = 8, Max = 24, Rounding = 0, Flag = "ChainTextSize", Size = 110, Callback = function(v) ChainESPSettings.TextSize = v; UpdateAllChainESP("TextSize", v) end })

aiFolder.ChildAdded:Connect(function(inst)
    if ChainESPSettings.Enabled and inst:IsA("Model") and inst:FindFirstChild("Humanoid") then
        task.spawn(function()
            inst:WaitForChild("HumanoidRootPart", 10)
            if inst.Parent then CreateChainESP(inst) end
        end)
    end
end)

task.spawn(function()
    while true do
        if ChainESPSettings.Enabled and ChainESPSettings.Info then
            for entity, obj in pairs(ChainESPObjs) do
                if entity and entity.Parent then
                    local attrs = entity:GetAttributes()
                    obj:SetInfo(string.format("怒气: %.1f | 窒息: %.1f%% | 重击: %.1f", attrs.Anger or 0, attrs.ChokeMeter or 0, attrs.Burst or 0))
                end
            end
        end
        task.wait(0.5)
    end
end)

local ScrapESPSettings = {
    Enabled = false,
    Highlight = true,
    Box = true,
    Text = true,
    Distance = true,
    Line = false,
    TextSize = 14,
    Color = Color3.fromRGB(255, 200, 0)
}

local ScrapESPObjs = {}
local ScrapFolder = W.Misc.Zones.LootingItems:WaitForChild("Scrap")

local ScrapPickupIndicator = Indicator.new({ Name = "", Icon = 'check', Color = 'Green' })
ScrapPickupIndicator:SetRender(true)
local ScrapCountdownActive = false

local function getScrapNum()
    local ok, result = pcall(function()
        local label = lp.PlayerGui.Ingame.Deconstructor.MainFrame.Frame.CurrentScrap
        local num = label.Text:match("%d+")
        if num then return tonumber(num) end
    end)
    if ok and result then return result end
    return nil
end

task.spawn(function()
    local lastScrap = getScrapNum() or 0
    local atMax = lastScrap >= 1000
    while true do
        local curScrap = getScrapNum()
        if curScrap and curScrap > lastScrap then
            ScrapCountdownActive = true
            ScrapPickupIndicator:SetColor('Red')
            ScrapPickupIndicator:SetIconText("xmark")
            for i = 6, 1, -1 do
                ScrapPickupIndicator:SetText(tostring(i))
                task.wait(1)
            end
            task.wait(0.5)
            ScrapCountdownActive = false
            ScrapPickupIndicator:SetColor('Green')
            ScrapPickupIndicator:SetIconText("check")
            if curScrap >= 1000 then
                ScrapPickupIndicator:SetText("ScrapMax")
                atMax = true
            else
                ScrapPickupIndicator:SetText("")
                atMax = false
            end
            lastScrap = curScrap
        elseif curScrap and atMax and curScrap < 1000 then
            ScrapPickupIndicator:SetText("")
            atMax = false
            lastScrap = curScrap
        elseif curScrap and curScrap >= 1000 and not atMax then
            ScrapPickupIndicator:SetText("ScrapMax")
            atMax = true
            lastScrap = curScrap
        elseif curScrap then
            lastScrap = curScrap
        end
        task.wait(0.5)
    end
end)

local function CreateScrapESP(scrapModel)
    if ScrapESPObjs[scrapModel] then return end
    local pivot = scrapModel:GetPivot()
    local _, bbsize = scrapModel:GetBoundingBox()

    local anchorPart = Instance.new("Part")
    anchorPart.Anchored = true
    anchorPart.CanCollide = false
    anchorPart.CanTouch = false
    anchorPart.CanQuery = false
    anchorPart.Transparency = 1
    anchorPart.Size = bbsize
    anchorPart.CFrame = pivot
    anchorPart.Parent = W

    local obj = ESP:Add({
        Entity = scrapModel,
        Part = anchorPart,
        Name = "废品",
        Color = ScrapESPSettings.Color,
        Highlight = ScrapESPSettings.Highlight,
        Box = ScrapESPSettings.Box,
        Line = ScrapESPSettings.Line,
        Text = ScrapESPSettings.Text,
        Distance = ScrapESPSettings.Distance,
        TextSize = ScrapESPSettings.TextSize,
        AlwaysOnTop = true,
        StudsOffset = Vector3.new(0, 2.5, 0),
    })
    if not obj then anchorPart:Destroy() return end

    local data = { Obj = obj, Part = anchorPart, Available = false }
    ScrapESPObjs[scrapModel] = data

    local vals = scrapModel:FindFirstChild("Values")
    if vals then
        data.Available = vals:GetAttribute("Available") == true
        obj:SetEnabled(data.Available)
        vals:GetAttributeChangedSignal("Available"):Connect(function()
            data.Available = vals:GetAttribute("Available") == true
            obj:SetEnabled(data.Available)
        end)
    end

    scrapModel.AncestryChanged:Connect(function(_, parent)
        if not parent then
            if ScrapESPObjs[scrapModel] then
                ScrapESPObjs[scrapModel].Obj:Remove()
                ScrapESPObjs[scrapModel].Part:Destroy()
                ScrapESPObjs[scrapModel] = nil
            end
        end
    end)
end

local function UpdateAllScrapESP(key, val) for _, data in pairs(ScrapESPObjs) do data.Obj:SetConfig(key, val) end end

local AreaESPObjs = {}
local AreaESPSettings = {
    PowerStation = false,
    WareHouse = false,
    Workshop = false,
    Highlight = true,
    Box = true,
    Text = true,
    Distance = true,
    Line = false,
    TextSize = 14,
    Color = Color3.fromRGB(255, 255, 0)
}
local GameSections = W:WaitForChild("GameStuff"):WaitForChild("GameSections")

local function CreateAreaESP(areaModel, name)
    if AreaESPObjs[areaModel] then return end
    local pivot = areaModel:GetPivot()
    local _, bbsize = areaModel:GetBoundingBox()
    local anchorPart = Instance.new("Part")
    anchorPart.Anchored = true
    anchorPart.CanCollide = false
    anchorPart.CanTouch = false
    anchorPart.CanQuery = false
    anchorPart.Transparency = 1
    anchorPart.Size = bbsize
    anchorPart.CFrame = pivot
    anchorPart.Parent = W
    local obj = ESP:Add({
        Entity = areaModel,
        Part = anchorPart,
        Name = name,
        Color = AreaESPSettings.Color,
        Highlight = AreaESPSettings.Highlight,
        Box = AreaESPSettings.Box,
        Line = AreaESPSettings.Line,
        Text = AreaESPSettings.Text,
        Distance = AreaESPSettings.Distance,
        TextSize = AreaESPSettings.TextSize,
        AlwaysOnTop = true,
        StudsOffset = Vector3.new(0, 5, 0),
        BillboardSize = UDim2.new(0, 300, 0, 50),
    })
    if not obj then anchorPart:Destroy() return end
    AreaESPObjs[areaModel] = { Obj = obj, Part = anchorPart, Name = name }
end

local function RemoveAreaESP(areaModel)
    if AreaESPObjs[areaModel] then
        AreaESPObjs[areaModel].Obj:Remove()
        AreaESPObjs[areaModel].Part:Destroy()
        AreaESPObjs[areaModel] = nil
    end
end

local function ToggleAreaESP(areaName, enabled)
    local model = GameSections:FindFirstChild(areaName)
    if not model then return end
    local nameMap = { POWERSTATION = "发电站", WareHouse = "仓库", Workshop = "工作区" }
    if enabled then
        CreateAreaESP(model, nameMap[areaName] or areaName)
    else
        RemoveAreaESP(model)
    end
end

local function UpdateAllAreaESP(key, val)
    for _, data in pairs(AreaESPObjs) do data.Obj:SetConfig(key, val) end
end

local PowerLabel = ESPSectionRight:AddLabel('发电站', false)
PowerLabel:AddToggle({
    Default = false,
    Flag = "PowerStationESP",
    Callback = function(v)
        AreaESPSettings.PowerStation = v
        ToggleAreaESP("POWERSTATION", v)
    end,
})
PowerLabel:AddColorPicker({
    Default = Color3.fromRGB(255, 255, 0),
    Flag = "PowerStationColor",
    Callback = function(color)
        AreaESPSettings.Color = color
        local model = GameSections:FindFirstChild("POWERSTATION")
        if model and AreaESPObjs[model] then AreaESPObjs[model].Obj:SetColor(color) end
    end,
})
local PowerOption = PowerLabel:AddOption(1)
PowerOption:AddLabel("高亮"):AddToggle({ Default = true, Flag = "PowerHighlight", Callback = function(v) AreaESPSettings.Highlight = v; UpdateAllAreaESP("Highlight", v) end })
PowerOption:AddLabel("方框"):AddToggle({ Default = true, Flag = "PowerBox", Callback = function(v) AreaESPSettings.Box = v; UpdateAllAreaESP("Box", v) end })
PowerOption:AddLabel("名称"):AddToggle({ Default = true, Flag = "PowerText", Callback = function(v) AreaESPSettings.Text = v; UpdateAllAreaESP("Text", v) end })
PowerOption:AddLabel("距离"):AddToggle({ Default = true, Flag = "PowerDistance", Callback = function(v) AreaESPSettings.Distance = v; UpdateAllAreaESP("Distance", v) end })
PowerOption:AddLabel("线条"):AddToggle({ Default = false, Flag = "PowerLine", Callback = function(v) AreaESPSettings.Line = v; UpdateAllAreaESP("Line", v) end })
PowerOption:AddLabel("文字大小"):AddSlider({ Default = 14, Min = 8, Max = 24, Rounding = 0, Flag = "PowerTextSize", Size = 110, Callback = function(v) AreaESPSettings.TextSize = v; UpdateAllAreaESP("TextSize", v) end })

local WareHouseLabel = ESPSectionRight:AddLabel('仓库', false)
WareHouseLabel:AddToggle({
    Default = false,
    Flag = "WareHouseESP",
    Callback = function(v)
        AreaESPSettings.WareHouse = v
        ToggleAreaESP("WareHouse", v)
    end,
})
WareHouseLabel:AddColorPicker({
    Default = Color3.fromRGB(255, 255, 0),
    Flag = "WareHouseColor",
    Callback = function(color)
        AreaESPSettings.Color = color
        local model = GameSections:FindFirstChild("WareHouse")
        if model and AreaESPObjs[model] then AreaESPObjs[model].Obj:SetColor(color) end
    end,
})
local WareHouseOption = WareHouseLabel:AddOption(1)
WareHouseOption:AddLabel("高亮"):AddToggle({ Default = true, Flag = "WareHouseHighlight", Callback = function(v) AreaESPSettings.Highlight = v; UpdateAllAreaESP("Highlight", v) end })
WareHouseOption:AddLabel("方框"):AddToggle({ Default = true, Flag = "WareHouseBox", Callback = function(v) AreaESPSettings.Box = v; UpdateAllAreaESP("Box", v) end })
WareHouseOption:AddLabel("名称"):AddToggle({ Default = true, Flag = "WareHouseText", Callback = function(v) AreaESPSettings.Text = v; UpdateAllAreaESP("Text", v) end })
WareHouseOption:AddLabel("距离"):AddToggle({ Default = true, Flag = "WareHouseDistance", Callback = function(v) AreaESPSettings.Distance = v; UpdateAllAreaESP("Distance", v) end })
WareHouseOption:AddLabel("线条"):AddToggle({ Default = false, Flag = "WareHouseLine", Callback = function(v) AreaESPSettings.Line = v; UpdateAllAreaESP("Line", v) end })
WareHouseOption:AddLabel("文字大小"):AddSlider({ Default = 14, Min = 8, Max = 24, Rounding = 0, Flag = "WareHouseTextSize", Size = 110, Callback = function(v) AreaESPSettings.TextSize = v; UpdateAllAreaESP("TextSize", v) end })

local WorkshopLabel = ESPSectionRight:AddLabel('工作区', false)
WorkshopLabel:AddToggle({
    Default = false,
    Flag = "WorkshopESP",
    Callback = function(v)
        AreaESPSettings.Workshop = v
        ToggleAreaESP("Workshop", v)
    end,
})
WorkshopLabel:AddColorPicker({
    Default = Color3.fromRGB(255, 255, 0),
    Flag = "WorkshopColor",
    Callback = function(color)
        AreaESPSettings.Color = color
        local model = GameSections:FindFirstChild("Workshop")
        if model and AreaESPObjs[model] then AreaESPObjs[model].Obj:SetColor(color) end
    end,
})
local WorkshopOption = WorkshopLabel:AddOption(1)
WorkshopOption:AddLabel("高亮"):AddToggle({ Default = true, Flag = "WorkshopHighlight", Callback = function(v) AreaESPSettings.Highlight = v; UpdateAllAreaESP("Highlight", v) end })
WorkshopOption:AddLabel("方框"):AddToggle({ Default = true, Flag = "WorkshopBox", Callback = function(v) AreaESPSettings.Box = v; UpdateAllAreaESP("Box", v) end })
WorkshopOption:AddLabel("名称"):AddToggle({ Default = true, Flag = "WorkshopText", Callback = function(v) AreaESPSettings.Text = v; UpdateAllAreaESP("Text", v) end })
WorkshopOption:AddLabel("距离"):AddToggle({ Default = true, Flag = "WorkshopDistance", Callback = function(v) AreaESPSettings.Distance = v; UpdateAllAreaESP("Distance", v) end })
WorkshopOption:AddLabel("线条"):AddToggle({ Default = false, Flag = "WorkshopLine", Callback = function(v) AreaESPSettings.Line = v; UpdateAllAreaESP("Line", v) end })
WorkshopOption:AddLabel("文字大小"):AddSlider({ Default = 14, Min = 8, Max = 24, Rounding = 0, Flag = "WorkshopTextSize", Size = 110, Callback = function(v) AreaESPSettings.TextSize = v; UpdateAllAreaESP("TextSize", v) end })

local ScrapLabel = ESPSectionRight:AddLabel('废品', false)
ScrapLabel:AddToggle({
    Default = false,
    Flag = "ScrapESP",
    Callback = function(value)
        ScrapESPSettings.Enabled = value
        if value then
            for _, scrap in ipairs(ScrapFolder:GetChildren()) do
                if scrap:IsA("Model") and scrap:GetAttribute("Scrap") ~= nil then
                    CreateScrapESP(scrap)
                end
            end
        else
            for model, data in pairs(ScrapESPObjs) do
                data.Obj:Remove()
                data.Part:Destroy()
            end
            ScrapESPObjs = {}
        end
    end,
})
ScrapLabel:AddColorPicker({
    Default = Color3.fromRGB(255, 200, 0),
    Flag = "ScrapColor",
    Callback = function(color)
        ScrapESPSettings.Color = color
        for _, data in pairs(ScrapESPObjs) do data.Obj:SetColor(color) end
    end,
})
local ScrapOption = ScrapLabel:AddOption(1)
ScrapOption:AddLabel("高亮"):AddToggle({ Default = true, Flag = "ScrapHighlight", Callback = function(v) ScrapESPSettings.Highlight = v; UpdateAllScrapESP("Highlight", v) end })
ScrapOption:AddLabel("方框"):AddToggle({ Default = true, Flag = "ScrapBox", Callback = function(v) ScrapESPSettings.Box = v; UpdateAllScrapESP("Box", v) end })
ScrapOption:AddLabel("名称"):AddToggle({ Default = true, Flag = "ScrapText", Callback = function(v) ScrapESPSettings.Text = v; UpdateAllScrapESP("Text", v) end })
ScrapOption:AddLabel("距离"):AddToggle({ Default = true, Flag = "ScrapDistance", Callback = function(v) ScrapESPSettings.Distance = v; UpdateAllScrapESP("Distance", v) end })
ScrapOption:AddLabel("线条"):AddToggle({ Default = false, Flag = "ScrapLine", Callback = function(v) ScrapESPSettings.Line = v; UpdateAllScrapESP("Line", v) end })
ScrapOption:AddLabel("文字大小"):AddSlider({ Default = 14, Min = 8, Max = 24, Rounding = 0, Flag = "ScrapTextSize", Size = 110, Callback = function(v) ScrapESPSettings.TextSize = v; UpdateAllScrapESP("TextSize", v) end })

ScrapFolder.ChildAdded:Connect(function(inst)
    if ScrapESPSettings.Enabled and inst:IsA("Model") and inst:GetAttribute("Scrap") ~= nil then
        CreateScrapESP(inst)
    end
end)

ScrapFolder.ChildRemoved:Connect(function(inst)
    if ScrapESPObjs[inst] then
        ScrapESPObjs[inst].Obj:Remove()
        ScrapESPObjs[inst].Part:Destroy()
        ScrapESPObjs[inst] = nil
    end
end)

local AirDropESPEnabled = false
local AirDropESPObj = nil
local AirDropNotifier = nil
local AirDropConn = nil
local AirDropESPSettings = {
    Highlight = true,
    Box = true,
    Line = true,
    Text = true,
    Distance = true,
    TextSize = 14,
    Color = Color3.fromRGB(170, 0, 255),
}

local function OnAirDropHeli(heli)
    if not heli:IsA("Model") then return end
    if not AirDropESPEnabled then return end
    local airdrop = heli:FindFirstChildWhichIsA("Model", true) or heli
    Notify("parachute", "空投已出现", 5)
    if AirDropESPObj then AirDropESPObj:Remove() end
    AirDropESPObj = ESP:Add({
        Entity = airdrop,
        Name = "空投",
        Color = AirDropESPSettings.Color,
        Highlight = AirDropESPSettings.Highlight,
        Box = AirDropESPSettings.Box,
        Line = AirDropESPSettings.Line,
        Text = AirDropESPSettings.Text,
        Distance = AirDropESPSettings.Distance,
        TextSize = AirDropESPSettings.TextSize,
        AlwaysOnTop = true,
        StudsOffset = Vector3.new(0, 5, 0),
    })
    heli.AncestryChanged:Connect(function(_, parent)
        if not parent then
            if AirDropESPObj then AirDropESPObj:Remove(); AirDropESPObj = nil end
        end
    end)
end

local function EnableAirDropESP()
    if AirDropConn then return end
    task.spawn(function()
        local folder = nil
        while not folder do
            folder = GameSections:FindFirstChild("AirDrops")
            task.wait(1)
        end
        for _, v in ipairs(folder:GetChildren()) do
            if v.Name == "AirDropHeli" then OnAirDropHeli(v) end
        end
        AirDropConn = folder.ChildAdded:Connect(function(inst)
            if inst.Name == "AirDropHeli" then
                OnAirDropHeli(inst)
            end
        end)
    end)
end

local function DisableAirDropESP()
    if AirDropConn then AirDropConn:Disconnect(); AirDropConn = nil end
    if AirDropESPObj then AirDropESPObj:Remove(); AirDropESPObj = nil end
end

local AirDropLabel = ESPSectionRight:AddLabel('空投', false)
AirDropLabel:AddToggle({
    Default = false,
    Flag = "AirDropESP",
    Callback = function(v)
        AirDropESPEnabled = v
        if v then
            EnableAirDropESP()
        else
            DisableAirDropESP()
        end
    end,
})
AirDropLabel:AddColorPicker({
    Default = Color3.fromRGB(170, 0, 255),
    Flag = "AirDropColor",
    Callback = function(color)
        AirDropESPSettings.Color = color
        if AirDropESPObj then AirDropESPObj:SetColor(color) end
    end,
})
local AirDropOption = AirDropLabel:AddOption(1)
AirDropOption:AddLabel("高亮"):AddToggle({ Default = true, Flag = "AirDropHighlight", Callback = function(v) AirDropESPSettings.Highlight = v; if AirDropESPObj then AirDropESPObj:SetConfig("Highlight", v) end end })
AirDropOption:AddLabel("方框"):AddToggle({ Default = true, Flag = "AirDropBox", Callback = function(v) AirDropESPSettings.Box = v; if AirDropESPObj then AirDropESPObj:SetConfig("Box", v) end end })
AirDropOption:AddLabel("名称"):AddToggle({ Default = true, Flag = "AirDropText", Callback = function(v) AirDropESPSettings.Text = v; if AirDropESPObj then AirDropESPObj:SetConfig("Text", v) end end })
AirDropOption:AddLabel("距离"):AddToggle({ Default = true, Flag = "AirDropDistance", Callback = function(v) AirDropESPSettings.Distance = v; if AirDropESPObj then AirDropESPObj:SetConfig("Distance", v) end end })
AirDropOption:AddLabel("线条"):AddToggle({ Default = true, Flag = "AirDropLine", Callback = function(v) AirDropESPSettings.Line = v; if AirDropESPObj then AirDropESPObj:SetConfig("Line", v) end end })
AirDropOption:AddLabel("文字大小"):AddSlider({ Default = 14, Min = 8, Max = 24, Rounding = 0, Flag = "AirDropTextSize", Size = 110, Callback = function(v) AirDropESPSettings.TextSize = v; if AirDropESPObj then AirDropESPObj:SetConfig("TextSize", v) end end })

local AutoCollectSettings = { Enabled = false, Range = 50, Teleport = false }
local AutoCollectLabel = PlayerSectionLeft:AddLabel('自动收集废料', false)
AutoCollectLabel:AddToggle({ Default = false, Flag = "AutoCollect", Callback = function(v)
    if pseudoActive and v then
        pcall(function() UILib.Flags["AutoCollect"]:SetValue(false) end)
        Notify("xmark", "伪无敌期间无法开启自动收集废料", 3)
        return
    end
    AutoCollectSettings.Enabled = v
    if v then task.spawn(function()
        while AutoCollectSettings.Enabled do
            if not ScrapCountdownActive then
                local char = lp.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, scrap in ipairs(ScrapFolder:GetChildren()) do
                        if not AutoCollectSettings.Enabled then break end
                        if scrap:IsA("Model") and scrap:GetAttribute("Scrap") ~= nil then
                            local vals = scrap:FindFirstChild("Values")
                            if vals and vals:GetAttribute("Available") == true then
                                local dist = (hrp.Position - scrap:GetPivot().Position).Magnitude
                                if dist <= AutoCollectSettings.Range then
                                    local prompt = scrap:FindFirstChildWhichIsA("ProximityPrompt", true)
                                    if prompt then
                                        if AutoCollectSettings.Teleport then
                                            local savedCF = hrp.CFrame
                                            char:PivotTo(scrap:GetPivot() * CFrame.new(0, 3, 0))
                                            task.wait(0.2)
                                            fireproximityprompt(prompt)
                                            task.wait(0.2)
                                            char:PivotTo(savedCF)
                                        else
                                            fireproximityprompt(prompt)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            task.wait(0.2)
        end
    end) end
end })
local AutoCollectOption = AutoCollectLabel:AddOption(1)
AutoCollectOption:AddLabel("范围"):AddSlider({ Default = 50, Min = 10, Max = 200, Rounding = 0, Flag = "CollectRange", Size = 110, Callback = function(v) AutoCollectSettings.Range = v end })
AutoCollectOption:AddLabel("传送收集"):AddToggle({ Default = false, Flag = "CollectTeleport", Callback = function(v) AutoCollectSettings.Teleport = v end })

local faceChainActive = false
local FaceChainLabel = PlayerSectionLeft:AddLabel('面向chain', false)
FaceChainLabel:AddToggle({ Default = false, Flag = "FaceChain", Callback = function(v)
    faceChainActive = v
    if v then task.spawn(function()
        while faceChainActive do
            pcall(function()
                local char = lp.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local nearest, nearDist = nil, math.huge
                    for _, chain in ipairs(aiFolder:GetChildren()) do
                        if chain:IsA("Model") then
                            local cHRP = chain:FindFirstChild("HumanoidRootPart")
                            local cHum = chain:FindFirstChild("Humanoid")
                            if cHRP and cHum and cHum.Health > 0 then
                                local dist = (hrp.Position - cHRP.Position).Magnitude
                                if dist < nearDist then nearDist = dist; nearest = cHRP end
                            end
                        end
                    end
                    if nearest then
                        Cam.CFrame = CFrame.lookAt(Cam.CFrame.Position, nearest.Position)
                    end
                end
            end)
            task.wait(0.03)
        end
    end) end
end })
local FaceChainKeybind = FaceChainLabel:AddKeybind({ Default = nil, Flag = "FaceChainKey" })

local cAlert = { Active = false, Notify = true, Dodge = false, ShowRing = true, RingRotating = true, RingColor = Color3.fromRGB(255, 50, 50) }
local chainAlertAnims = {
    ["rbxassetid://11545349261"] = "连击1",
    ["rbxassetid://14123467583"] = "连击2",
    ["rbxassetid://14101304975"] = "连击3",
    ["rbxassetid://14101956641"] = "背后攻击",
    ["rbxassetid://15943264089"] = "蓄力斩击",
    ["rbxassetid://14401168075"] = "蓄力冲锋",
    ["rbxassetid://14875631059"] = "范围攻击",
    ["rbxassetid://11987922371"] = "闪避",
    ["rbxassetid://14255769487"] = "破门",
    ["rbxassetid://15408077041"] = "倒地处决1",
    ["rbxassetid://15409393739"] = "倒地处决2",
    ["rbxassetid://11442109170"] = "警觉",
    ["rbxassetid://123029648649398"] = "空洞警觉",
    ["rbxassetid://78440647847406"] = "蓄力",
    ["rbxassetid://88813113168837"] = "蓄力跳斩",
    ["rbxassetid://135099305543293"] = "暴怒",
    ["rbxassetid://140464711815827"] = "暴怒反击",
    ["rbxassetid://16214202640"] = "突刺",
}
local chainStateAnims = {
    ["rbxassetid://11442109170"] = true,
    ["rbxassetid://123029648649398"] = true,
    ["rbxassetid://135099305543293"] = true,
}
local chainAlertSounds = {
    ["CurbStomp1"] = "踩踏反击",
    ["CurbStomp2"] = "踩踏反击",
    ["Charging"] = "蓄力",
    ["ChainsawSwing"] = "电锯挥砍",
    ["ChainsawCharge"] = "电锯蓄力",
    ["ChainsawSpot"] = "电锯突刺",
    ["ChokeSwing"] = "突刺",
}
local chainAlertConns = {}

local dangerSound = Instance.new("Sound")
dangerSound.SoundId = "rbxassetid://6518811702"
dangerSound.Volume = 5
dangerSound.Parent = CG

local chainRings = {}
local chainRingConn = nil
local RING_RADIUS = 55
local RING_EXTRA = 0
local RING_POINTS = 36
local WALL_HEIGHT = 50
local ringRotAngle = 0
local activeDodgeChains = {}

local function clearChainRings()
    for _, d in ipairs(chainRings) do
        for _, p in ipairs(d.Balls) do pcall(function() p:Destroy() end) end
        for _, p in ipairs(d.Walls) do pcall(function() p:Destroy() end) end
    end
    chainRings = {}
    activeDodgeChains = {}
    if chainRingConn then chainRingConn:Disconnect(); chainRingConn = nil end
end

local function makeRingParts()
    local data = { Balls = {}, Walls = {} }
    for i = 1, RING_POINTS do
        local b = Instance.new("Part")
        b.Size = Vector3.new(0.5, 0.5, 0.5)
        b.Shape = Enum.PartType.Ball
        b.Anchored = true
        b.CanCollide = false
        b.Material = Enum.Material.Neon
        b.Color = cAlert.RingColor
        b.Transparency = cAlert.ShowRing and 0.3 or 1
        b.Parent = W
        table.insert(data.Balls, b)
    end
    for i = 1, RING_POINTS do
        local wallAngle = (i / RING_POINTS) * math.pi * 2
        local nextAngle = ((i + 1) / RING_POINTS) * math.pi * 2
        local chord = 2 * (RING_RADIUS + RING_EXTRA) * math.sin(math.pi / RING_POINTS)
        local w = Instance.new("Part")
        w.Size = Vector3.new(chord + 0.2, WALL_HEIGHT, 1)
        w.Anchored = true
        w.CanCollide = true
        w.Material = Enum.Material.ForceField
        w.Color = cAlert.RingColor
        w.Transparency = cAlert.ShowRing and 0.75 or 1
        w.Parent = W
        table.insert(data.Walls, w)
    end
    return data
end

local function createChainRings()
    clearChainRings()
    for _, chain in ipairs(aiFolder:GetChildren()) do
        if chain:IsA("Model") then
            table.insert(chainRings, {Chain = chain, Parts = makeRingParts()})
        end
    end
    ringRotAngle = 0
    chainRingConn = RS.RenderStepped:Connect(function(dt)
        if cAlert.RingRotating then ringRotAngle = ringRotAngle + dt * 0.5 end
        local toRemove = {}
        for idx, d in ipairs(chainRings) do
            local chain = d.Chain
            if not chain or not chain.Parent then
                for _, p in ipairs(d.Parts.Balls) do pcall(function() p:Destroy() end) end
                for _, p in ipairs(d.Parts.Walls) do pcall(function() p:Destroy() end) end
                activeDodgeChains[chain] = nil
                table.insert(toRemove, idx)
            else
                local hrp = chain:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local ok, pos = pcall(function() return hrp.Position end)
                    if ok and pos then
                    local radius = (RING_RADIUS or 55) + (RING_EXTRA or 0)
                    local dodgeStart = activeDodgeChains[chain]
                    local inAlert = dodgeStart and (tick() - dodgeStart < 5)
                    for i, b in ipairs(d.Parts.Balls) do
                        local angle = (i / RING_POINTS) * math.pi * 2 + ringRotAngle
                        b.Position = Vector3.new(
                            pos.X + math.cos(angle) * radius,
                            pos.Y - 2.5,
                            pos.Z + math.sin(angle) * radius
                        )
                        b.Color = cAlert.RingColor
                        b.Transparency = cAlert.ShowRing and 0.3 or 1
                    end
                    for i, w in ipairs(d.Parts.Walls) do
                        local angle = (i / RING_POINTS) * math.pi * 2 + ringRotAngle
                        w.Position = Vector3.new(
                            pos.X + math.cos(angle) * radius,
                            pos.Y + WALL_HEIGHT / 2 - 15,
                            pos.Z + math.sin(angle) * radius
                        )
                        w.CFrame = CFrame.new(w.Position, Vector3.new(pos.X, w.Position.Y, pos.Z))
                        w.Color = cAlert.RingColor
                        if inAlert then
                            w.Transparency = 0.75
                            w.CanCollide = true
                        else
                            w.Transparency = 1
                            w.CanCollide = false
                        end
                    end
                    if inAlert and cAlert.Dodge then
                        local char = lp.Character
                        local myHRP = char and char:FindFirstChild("HumanoidRootPart")
                        if myHRP then
                            local dx = myHRP.Position.X - pos.X
                            local dz = myHRP.Position.Z - pos.Z
                            local dist = math.sqrt(dx * dx + dz * dz)
                            if dist < radius then
                                local dir = Vector3.new(dx, 0, dz).Unit
                                myHRP.CFrame = CFrame.new(pos + dir * (radius + 3), pos)
                            end
                        end
                    end
                    end
                end
            end
        end
        for i = #toRemove, 1, -1 do table.remove(chainRings, toRemove[i]) end
    end)
end

local function triggerChainAlert(chain, skillName)
    if cAlert.Notify then
        Notify("warning", chain.Name .. " 使用 " .. skillName, 2, Color3.fromRGB(255, 0, 0))
        pcall(function() dangerSound:Play() end)
    end
    activeDodgeChains[chain] = tick()
    if cAlert.Dodge then
        local char = lp.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local chainHRP = chain:FindFirstChild("HumanoidRootPart")
        if hrp and chainHRP then
            local pos = chainHRP.Position
            local radius = RING_RADIUS + RING_EXTRA
            local dx = hrp.Position.X - pos.X
            local dz = hrp.Position.Z - pos.Z
            local dist = math.sqrt(dx * dx + dz * dz)
            if dist < radius then
                local dir = Vector3.new(dx, 0, dz).Unit
                hrp.CFrame = CFrame.new(pos + dir * (radius + 3), pos)
            end
        end
    end
end

local function hookChainAnim(chain)
    if not chain:IsA("Model") then return end
    local isInState = false
    local hum = chain:FindFirstChild("Humanoid")
    local animator = hum and hum:FindFirstChild("Animator")
    if not animator then
        local h = chain:WaitForChild("Humanoid", 5)
        if h then h:WaitForChild("Animator", 5) end
        animator = h and h:FindFirstChild("Animator")
    end
    if animator then
        table.insert(chainAlertConns, animator.AnimationPlayed:Connect(function(track)
            local animId = track.Animation and track.Animation.AnimationId or ""
            local cleanId = animId:match("%d+")
            local fullId = "rbxassetid://" .. (cleanId or "")
            local skillName = chainAlertAnims[fullId]
            if skillName then
                if chainStateAnims[fullId] then
                    isInState = true
                    Notify("info", chain.Name .. " 状态: " .. skillName, 2)
                    track.Stopped:Connect(function() isInState = false end)
                else
                    triggerChainAlert(chain, skillName)
                    track.Stopped:Connect(function() activeDodgeChains[chain] = nil end)
                end
            end
        end))
    end
    for _, desc in ipairs(chain:GetDescendants()) do
        if desc:IsA("Sound") and chainAlertSounds[desc.Name] then
            table.insert(chainAlertConns, desc.Played:Connect(function()
                if not isInState then
                    triggerChainAlert(chain, chainAlertSounds[desc.Name])
                end
            end))
        end
    end
end

local function setupChainAlert()
    for _, conn in ipairs(chainAlertConns) do conn:Disconnect() end
    chainAlertConns = {}
    for _, chain in ipairs(aiFolder:GetChildren()) do hookChainAnim(chain) end
    table.insert(chainAlertConns, aiFolder.ChildAdded:Connect(function(child)
        if cAlert.Active then
            hookChainAnim(child)
            if child:IsA("Model") then
                table.insert(chainRings, {Chain = child, Parts = makeRingParts()})
            end
        end
    end))
end

local ChainAlertLabel = PlayerSectionLeft:AddLabel('chain技能预警', false)
ChainAlertLabel:AddToggle({ Default = false, Flag = "ChainAlert", Callback = function(v)
    cAlert.Active = v
    if v then
        setupChainAlert()
        createChainRings()
    else
        for _, conn in ipairs(chainAlertConns) do conn:Disconnect() end
        chainAlertConns = {}
        clearChainRings()
    end
end })
local ChainAlertOption = ChainAlertLabel:AddOption(1)
ChainAlertOption:AddLabel("通知"):AddToggle({ Default = true, Flag = "ChainAlertNotify", Callback = function(v) cAlert.Notify = v end })
ChainAlertOption:AddLabel("自动躲避"):AddToggle({ Default = false, Flag = "ChainAlertDodge", Callback = function(v)
    if pseudoActive and v then
        pcall(function() UILib.Flags["ChainAlertDodge"]:SetValue(false) end)
        Notify("xmark", "伪无敌期间无法开启自动躲避", 3)
        return
    end
    cAlert.Dodge = v
end })
ChainAlertOption:AddLabel("显示圈环"):AddToggle({ Default = true, Flag = "ChainAlertShowRing", Callback = function(v) cAlert.ShowRing = v end })
ChainAlertOption:AddLabel("圈环旋转"):AddToggle({ Default = true, Flag = "ChainAlertRingRot", Callback = function(v) cAlert.RingRotating = v end })
ChainAlertOption:AddLabel("圈环颜色"):AddColorPicker({ Default = Color3.fromRGB(255, 50, 50), Flag = "ChainAlertRingColor", Callback = function(v) cAlert.RingColor = v end })
ChainAlertOption:AddLabel("圈环扩大"):AddSlider({ Default = 0, Min = 0, Max = 50, Flag = "ChainAlertRingExtra", Callback = function(v) RING_EXTRA = v end })

local autoQTEActive = false
local qteConns = {}
local QTEFrames = {"QTE", "QTEXSaw", "QTEToma"}
local MechanicsFrame = lp.PlayerGui:WaitForChild("Ingame"):WaitForChild("MechanicsFrame")

local KeyCodeMap = {
    A=0x41, B=0x42, C=0x43, D=0x44, E=0x45, F=0x46, G=0x47, H=0x48,
    I=0x49, J=0x4A, K=0x4B, L=0x4C, M=0x4D, N=0x4E, O=0x4F, P=0x50,
    Q=0x51, R=0x52, S=0x53, T=0x54, U=0x55, V=0x56, W=0x57, X=0x58,
    Y=0x59, Z=0x5A, Space=0x20,
}

local function tryFireQTE(frame)
    local ib = frame:FindFirstChild("ImageButton")
    local pc = ib and ib:FindFirstChild("PC")
    local keyName = pc and pc.Text or ""
    pcall(function()
        if ib then
            for _, conn in pairs(getconnections(ib.MouseButton1Click)) do
                conn:Fire()
            end
            for _, conn in pairs(getconnections(ib.Activated)) do
                conn:Fire()
            end
        end
    end)
    pcall(function()
        local ek = Enum.KeyCode[keyName]
        if ek then
            for _, conn in pairs(getconnections(UIS.InputBegan)) do
                conn:Fire({KeyCode = ek, UserInputType = Enum.UserInputType.Keyboard})
            end
        end
    end)
    pcall(function()
        local code = KeyCodeMap[keyName]
        if code and keypress then
            keypress(code)
            task.wait(0.05)
            keyrelease(code)
        end
    end)
end

local function setupQTE(frame)
    if not frame then return end
    table.insert(qteConns, frame:GetPropertyChangedSignal("Visible"):Connect(function()
        if autoQTEActive and frame.Visible then
            tryFireQTE(frame)
        end
    end))
    if frame.Visible and autoQTEActive then
        tryFireQTE(frame)
    end
end

local AutoQTELabel = PlayerSectionLeft:AddLabel('自动QTE', false)
AutoQTELabel:AddToggle({ Default = false, Flag = "AutoQTE", Callback = function(v)
    autoQTEActive = v
    for _, conn in ipairs(qteConns) do conn:Disconnect() end
    qteConns = {}
    if v then
        for _, name in ipairs(QTEFrames) do
            setupQTE(MechanicsFrame:FindFirstChild(name))
        end
    end
end })

local staminaActive = false
local StaminaLabel = PlayerSectionLeft:AddLabel('无限体力', false)
StaminaLabel:AddToggle({ Default = false, Flag = "InfStamina", Callback = function(v)
    staminaActive = v
    if v then task.spawn(function() while staminaActive do pcall(function() lp.Character.Stats.Stamina.Value = 100 end) task.wait(0.5) end end) end
end })

local combatStaminaActive = false
local CombatStaminaLabel = PlayerSectionLeft:AddLabel('无限战斗体力', false)
CombatStaminaLabel:AddToggle({ Default = false, Flag = "InfCombatStamina", Callback = function(v)
    combatStaminaActive = v
    if v then task.spawn(function() while combatStaminaActive do pcall(function() lp.Character.Stats.CombatStamina.Value = 100 end) task.wait(0.5) end end) end
end })

local clashActive = false
local ClashLabel = PlayerSectionLeft:AddLabel('自动赢进度条对决', false)
ClashLabel:AddToggle({ Default = false, Flag = "AutoWinClash", Callback = function(v)
    clashActive = v
    if v then task.spawn(function() while clashActive do pcall(function() lp.Character.Stats.ClashStrength.Value = 100 end) task.wait(0.005) end end) end
end })

local gasActive = false
local GasLabel = PlayerSectionLeft:AddLabel('无限电锯燃料', false)
GasLabel:AddToggle({ Default = false, Flag = "InfGas", Callback = function(v)
    gasActive = v
    if v then task.spawn(function() while gasActive do pcall(function()
        local c = lp.Character
        if c and c:FindFirstChild("Items") and c.Items:FindFirstChild("XSaw") then c.Items.XSaw:SetAttribute("Gas", 100) end
    end) task.wait(0.01) end end) end
end })

local autoPowerActive = false
local POWERSTATION_CF = CFrame.new(-208.299744, -110.604126, -120.227615, 0.994857252, -4.01115097e-09, 0.101287208, 1.21101742e-08, 1, -7.9346087e-08, -0.101287208, 8.01646323e-08, 0.994857252)

local function fireInteract(model)
    local pp = model:FindFirstChildWhichIsA("ProximityPrompt", true)
    if pp then fireproximityprompt(pp) return true end
    local cd = model:FindFirstChildWhichIsA("ClickDetector", true)
    if cd then fireclickdetector(cd) return true end
    return false
end

local AutoPowerLabel = PlayerSectionLeft:AddLabel('自动发电站', false)
AutoPowerLabel:AddToggle({ Default = false, Flag = "AutoPower", Callback = function(v)
    if pseudoActive and v then
        pcall(function() UILib.Flags["AutoPower"]:SetValue(false) end)
        Notify("xmark", "伪无敌期间无法开启自动发电站", 3)
        return
    end
    autoPowerActive = v
    if v then task.spawn(function()
        while autoPowerActive do
            pcall(function()
                local power = valuesFolder:GetAttribute("Power")
                if type(power) == "number" and power <= 0 then
                    local char = lp.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    local station = GameSections:FindFirstChild("POWERSTATION")
                    if hrp and station then
                        local savedCF = hrp.CFrame
                        hrp.CFrame = POWERSTATION_CF
                        task.wait(0.2)
                        local startTime = tick()
                        while autoPowerActive and tick() - startTime < 60 do
                            local curPower = valuesFolder:GetAttribute("Power")
                            if type(curPower) == "number" and curPower > 0 then break end
                            local c = lp.Character
                            local h = c and c:FindFirstChild("HumanoidRootPart")
                            if h then h.CFrame = POWERSTATION_CF end
                            pcall(function()
                                local alertUI = GameSections.POWERSTATION:FindFirstChild("AlertUI")
                                if alertUI then
                                    local gui = alertUI:FindFirstChild("GUI")
                                    if gui and not gui.Enabled then
                                        fireInteract(station)
                                    end
                                end
                            end)
                            task.wait(0.03)
                        end
                        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                            lp.Character.HumanoidRootPart.CFrame = savedCF
                        end
                    end
                end
            end)
            task.wait(0.5)
        end
    end) end
end })

local blue = Color3.fromRGB(70, 130, 255)

local function togglePseudoInvincible()
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local torso = char and (char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
    if not hrp or not torso then
        Notify("xmark", "角色未就绪", 2)
        return
    end

    pseudoActive = not pseudoActive

    if pseudoActive then
        local blackGui = Instance.new("ScreenGui")
        blackGui.Name = "_BlackScreen"
        blackGui.IgnoreGuiInset = true
        blackGui.DisplayOrder = 999
        blackGui.Parent = lp.PlayerGui
        local blackFrame = Instance.new("Frame")
        blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
        blackFrame.Size = UDim2.new(1, 0, 1, 0)
        blackFrame.BorderSizePixel = 0
        blackFrame.Parent = blackGui

        local savedpos = hrp.CFrame
        hrp.CFrame = CFrame.new(-25.95, 84, 3537.55)
        task.wait(0.15)
        local seat = Instance.new("Seat")
        seat.Name = ""
        seat.Anchored = false
        seat.CanCollide = false
        seat.Transparency = 1
        seat.Position = Vector3.new(95, 84, 37.55)
        seat.Parent = workspace
        local weld = Instance.new("Weld")
        weld.Part0 = seat
        weld.Part1 = torso
        weld.Parent = seat
        task.wait()
        seat.CFrame = savedpos
        pseudoSeat = seat

        task.wait(0.5)
        blackGui:Destroy()

        savedAutoStates = {}
        if autoPowerActive then
            savedAutoStates.autoPower = true
            pcall(function() UILib.Flags["AutoPower"]:SetValue(false) end)
            Notify("xmark", "自动发电站已自动关闭", 3)
            task.wait(0.2)
        end
        if cAlert.Dodge then
            savedAutoStates.dodge = true
            pcall(function() UILib.Flags["ChainAlertDodge"]:SetValue(false) end)
            Notify("xmark", "自动躲避已自动关闭", 3)
            task.wait(0.2)
        end
        if AutoCollectSettings.Enabled then
            savedAutoStates.autoCollect = true
            pcall(function() UILib.Flags["AutoCollect"]:SetValue(false) end)
            Notify("xmark", "自动收集废料已自动关闭", 3)
        end

        PseudoIndicator:SetColor('Green')
    else
        local blackGui = Instance.new("ScreenGui")
        blackGui.Name = "_BlackScreen"
        blackGui.IgnoreGuiInset = true
        blackGui.DisplayOrder = 999
        blackGui.Parent = lp.PlayerGui
        local blackFrame = Instance.new("Frame")
        blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
        blackFrame.Size = UDim2.new(1, 0, 1, 0)
        blackFrame.BorderSizePixel = 0
        blackFrame.Parent = blackGui

        if pseudoSeat then
            pseudoSeat:Destroy()
            pseudoSeat = nil
        end

        task.wait(0.5)
        blackGui:Destroy()

        if savedAutoStates.autoPower then
            pcall(function() UILib.Flags["AutoPower"]:SetValue(true) end)
            Notify("check", "自动发电站已自动开启", 3)
            task.wait(0.2)
        end
        if savedAutoStates.dodge then
            pcall(function() UILib.Flags["ChainAlertDodge"]:SetValue(true) end)
            Notify("check", "自动躲避已自动开启", 3)
            task.wait(0.2)
        end
        if savedAutoStates.autoCollect then
            pcall(function() UILib.Flags["AutoCollect"]:SetValue(true) end)
            Notify("check", "自动收集废料已自动开启", 3)
        end
        savedAutoStates = {}

        PseudoIndicator:SetColor('Red')
    end
end

local PseudoLabel = PlayerSectionLeft:AddLabel('伪无敌', false)
PseudoLabel:AddToggle({ Default = false, Flag = "PseudoInvincible", Callback = function(v)
    if v ~= pseudoActive then
        togglePseudoInvincible()
    end
end })
local PseudoKeybind = PseudoLabel:AddKeybind({ Default = nil, Flag = "PseudoKey" })

local CharacterSection = PlayerTab:AddSection({ Name = "人物", Position = 'left' })

local tpwalk = { Active = false, Speed = 1, Conn = nil, CharConn = nil }

local function startTPWalk()
    if tpwalk.Conn then tpwalk.Conn:Disconnect() end
    tpwalk.Conn = RS.RenderStepped:Connect(function(delta)
        if not tpwalk.Active then return end
        local char = lp.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if not hrp or not hum then return end
        if hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + hum.MoveDirection * tpwalk.Speed * delta * 16
        end
    end)
end

local function setupTPWalk()
    if tpwalk.CharConn then tpwalk.CharConn:Disconnect() end
    tpwalk.CharConn = lp.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if tpwalk.Active then startTPWalk() end
    end)
    if tpwalk.Active then startTPWalk() end
end

local TPWalkLabel = CharacterSection:AddLabel('速度', false)
TPWalkLabel:AddToggle({ Default = false, Flag = "TPWalk", Callback = function(v)
    tpwalk.Active = v
    if v then
        setupTPWalk()
    else
        if tpwalk.Conn then tpwalk.Conn:Disconnect() tpwalk.Conn = nil end
        if tpwalk.CharConn then tpwalk.CharConn:Disconnect() tpwalk.CharConn = nil end
    end
end })
local TPWalkOption = TPWalkLabel:AddOption(1)
TPWalkOption:AddLabel("速度"):AddSlider({ Default = 1, Min = 1, Max = 10, Rounding = 1, Flag = "TPWalkSpeed", Size = 110, Callback = function(v) tpwalk.Speed = v end })
local TPWalkKeybind = TPWalkOption:AddLabel("快捷键"):AddKeybind({ Default = nil, Flag = "TPWalkKey" })

local noclipActive = false
local noclipConn = nil
local NoclipLabel = CharacterSection:AddLabel('穿墙', false)
NoclipLabel:AddToggle({ Default = false, Flag = "Noclip", Callback = function(v)
    noclipActive = v
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    if v then
        noclipConn = RS.Stepped:Connect(function()
            local char = lp.Character
            if not char then return end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    end
end })
local NoclipOption = NoclipLabel:AddOption(1)
local NoclipKeybind = NoclipOption:AddLabel("快捷键"):AddKeybind({ Default = nil, Flag = "NoclipKey" })

local tp3 = { Active = false, CamLock = false, CamLockConn = nil, Conn = nil, CharConn = nil, SavedMax = nil, SavedMin = nil }

local function enforceThirdPerson()
    if tp3.Conn then tp3.Conn:Disconnect() end
    tp3.Conn = RS.RenderStepped:Connect(function()
        if not tp3.Active then return end
        pcall(function()
            if lp.CameraMode ~= Enum.CameraMode.Classic then lp.CameraMode = Enum.CameraMode.Classic end
            if lp.CameraMaxZoomDistance ~= 20 then lp.CameraMaxZoomDistance = 20 end
            if lp.CameraMinZoomDistance ~= 5 then lp.CameraMinZoomDistance = 5 end
        end)
    end)
    if tp3.CharConn then tp3.CharConn:Disconnect() end
    tp3.CharConn = lp.CharacterAdded:Connect(function()
        task.wait(0.5)
        if tp3.Active then
            pcall(function()
                lp.CameraMode = Enum.CameraMode.Classic
                lp.CameraMaxZoomDistance = 20
                lp.CameraMinZoomDistance = 5
            end)
        end
    end)
end

local function updateCameraLock()
    if tp3.CamLockConn then tp3.CamLockConn:Disconnect(); tp3.CamLockConn = nil end
    if tp3.Active and tp3.CamLock then
        tp3.CamLockConn = RS.RenderStepped:Connect(function()
            local char = lp.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChild("Humanoid")
            if hrp and hum then
                local camCF = Cam.CFrame
                local lookDir = camCF.LookVector
                hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(lookDir.X, 0, lookDir.Z))
            end
        end)
    end
end

local ThirdPersonLabel = CharacterSection:AddLabel('第三人称', false)
ThirdPersonLabel:AddToggle({ Default = false, Flag = "ThirdPerson", Callback = function(v)
    tp3.Active = v
    if v then
        tp3.SavedMax = lp.CameraMaxZoomDistance
        tp3.SavedMin = lp.CameraMinZoomDistance
        enforceThirdPerson()
    else
        if tp3.Conn then tp3.Conn:Disconnect() tp3.Conn = nil end
        if tp3.CharConn then tp3.CharConn:Disconnect() tp3.CharConn = nil end
        pcall(function()
            lp.CameraMode = Enum.CameraMode.LockFirstPerson
            if tp3.SavedMax then lp.CameraMaxZoomDistance = tp3.SavedMax end
            if tp3.SavedMin then lp.CameraMinZoomDistance = tp3.SavedMin end
        end)
    end
    updateCameraLock()
end })
local ThirdPersonOption = ThirdPersonLabel:AddOption(1)
ThirdPersonOption:AddLabel("镜头锁定"):AddToggle({ Default = false, Flag = "CameraLock", Callback = function(v)
    tp3.CamLock = v
    updateCameraLock()
end })
local ThirdPersonKeybind = ThirdPersonOption:AddLabel("快捷键"):AddKeybind({ Default = nil, Flag = "ThirdPersonKey" })

local nofogConns = {}
local nofogSaved = {}
local NoFogLabel = PlayerSectionRight:AddLabel('去雾', false)
NoFogLabel:AddToggle({
    Default = false,
    Flag = "NoFog",
    Callback = function(v)
        for _, conn in ipairs(nofogConns) do conn:Disconnect() end
        nofogConns = {}
        if v then
            nofogSaved.FogEnd = L.FogEnd
            nofogSaved.Atmospheres = {}
            L.FogEnd = 100000
            table.insert(nofogConns, L:GetPropertyChangedSignal("FogEnd"):Connect(function()
                L.FogEnd = 100000
            end))
            for _, atm in ipairs(L:GetDescendants()) do
                if atm:IsA("Atmosphere") then
                    nofogSaved.Atmospheres[atm] = atm.Density
                    atm.Density = 0
                    table.insert(nofogConns, atm:GetPropertyChangedSignal("Density"):Connect(function()
                        atm.Density = 0
                    end))
                end
            end
            table.insert(nofogConns, L.DescendantAdded:Connect(function(v)
                if v:IsA("Atmosphere") then
                    nofogSaved.Atmospheres[v] = v.Density
                    v.Density = 0
                    table.insert(nofogConns, v:GetPropertyChangedSignal("Density"):Connect(function()
                        v.Density = 0
                    end))
                end
            end))
        else
            if nofogSaved.FogEnd then L.FogEnd = nofogSaved.FogEnd end
            for atm, density in pairs(nofogSaved.Atmospheres or {}) do
                pcall(function() atm.Density = density end)
            end
            nofogSaved = {}
        end
    end,
})

local fullbrightConn = nil
local fullbrightSaved = nil
local FullbrightLabel = PlayerSectionRight:AddLabel('全亮', false)
FullbrightLabel:AddToggle({
    Default = false,
    Flag = "Fullbright",
    Callback = function(v)
        if fullbrightConn then fullbrightConn:Disconnect() fullbrightConn = nil end
        if v then
            fullbrightSaved = {
                Brightness = L.Brightness,
                ClockTime = L.ClockTime,
                FogEnd = L.FogEnd,
                GlobalShadows = L.GlobalShadows,
                OutdoorAmbient = L.OutdoorAmbient,
            }
            local function fb()
                L.Brightness = 2
                L.ClockTime = 14
                L.FogEnd = 100000
                L.GlobalShadows = false
                L.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            end
            fb()
            fullbrightConn = RS.RenderStepped:Connect(fb)
        else
            if fullbrightSaved then
                L.Brightness = fullbrightSaved.Brightness
                L.ClockTime = fullbrightSaved.ClockTime
                L.FogEnd = fullbrightSaved.FogEnd
                L.GlobalShadows = fullbrightSaved.GlobalShadows
                L.OutdoorAmbient = fullbrightSaved.OutdoorAmbient
                fullbrightSaved = nil
            end
        end
    end,
})

local RemoteSection = PlayerTab:AddSection({ Name = "远程", Position = 'right' })

local RemoteGUIs = { Shop = false, Deconstructor = false, Workbench = false }
local UIS = game:GetService("UserInputService")
local Mouse = lp:GetMouse()

local function UpdateMouseLock()
    local anyActive = RemoteGUIs.Shop or RemoteGUIs.Deconstructor or RemoteGUIs.Workbench
    local uiVisible = Window and Window.Signal and Window.Signal:GetValue()
    if anyActive or uiVisible then
        UIS.MouseBehavior = Enum.MouseBehavior.Default
        UIS.MouseIconEnabled = true
        Mouse.Icon = ""
    end
end

local function isDaytime()
    local t = valuesFolder:GetAttribute("RoundTime")
    return not (type(t) == "number" and t > 0)
end

local function SetRemoteGui(name, visible)
    if visible and name == "Shop" and not isDaytime() then
        Logger.new("xmark", "商店只能在白天打开", 2)
        pcall(function() errorSound:Play() end)
        return false
    end
    RemoteGUIs[name] = visible
    local sg = lp.PlayerGui:FindFirstChild("Ingame")
    if sg then local gui = sg:FindFirstChild(name) if gui then gui.Visible = visible end end
    UpdateMouseLock()
    return true
end

local ShopGuiLabel = RemoteSection:AddLabel('商店界面', false)
ShopGuiLabel:AddToggle({ Default = false, Flag = "ShopGui", Callback = function(v)
    if v and not isDaytime() then
        Logger.new("xmark", "商店只能在白天打开", 2)
        pcall(function() errorSound:Play() end)
        return
    end
    SetRemoteGui("Shop", v)
end })
local ShopKeybind = ShopGuiLabel:AddKeybind({ Default = nil, Flag = "ShopGuiKey" })

local DeconGuiLabel = RemoteSection:AddLabel('分解器界面', false)
DeconGuiLabel:AddToggle({ Default = false, Flag = "DeconGui", Callback = function(v) SetRemoteGui("Deconstructor", v) end })
local DeconKeybind = DeconGuiLabel:AddKeybind({ Default = nil, Flag = "DeconGuiKey" })

local WorkbenchGuiLabel = RemoteSection:AddLabel('工作台界面', false)
WorkbenchGuiLabel:AddToggle({ Default = false, Flag = "WorkbenchGui", Callback = function(v) SetRemoteGui("Workbench", v) end })
local WorkbenchKeybind = WorkbenchGuiLabel:AddKeybind({ Default = nil, Flag = "WorkbenchGuiKey" })

task.spawn(function()
    local BadgeService = game:GetService("BadgeService")
    local old
    old = hookfunction(BadgeService.UserHasBadgeAsync, function(self, userId, badgeId)
        if badgeId == 1224768178420330 then
            return true
        end
        return old(self, userId, badgeId)
    end)
    Notify("check", "AK47购买徽章以绕过", 10, Color3.fromRGB(170, 0, 255))
end)

local AmmoSection = PlayerTab:AddSection({ Name = "枪械", Position = 'right' })
local infAmmoActive = false
local ammoConns = {}

local gunMax = {AK47 = 20, Deagle = 7, DoubleBarrel = 2, M1911 = 7}

local origSyncFunc = nil

local function setupAmmoHooks()
    for _, c in ipairs(ammoConns) do pcall(function() c:Disconnect() end) end
    ammoConns = {}

    local char = lp.Character
    if not char then return end
    local items = char:FindFirstChild("Items")
    if not items then return end
    local ch = char:FindFirstChild("CharacterHandler")
    if not ch then return end
    local remotes = ch:FindFirstChild("Contents") and ch.Contents:FindFirstChild("Remotes")
    if not remotes then return end
    local interact = remotes:FindFirstChild("Interact")
    if not interact then return end

    local conns = getconnections(interact.OnClientEvent)
    if conns and #conns > 0 then
        local origConn = conns[1]
        origSyncFunc = origConn.Function
        origConn:Disable()
        local newConn = interact.OnClientEvent:Connect(function(action, gunName, ammoData)
            if infAmmoActive and action == "Sync" and gunMax[gunName] then
                ammoData = {gunMax[gunName], 999}
            end
            pcall(origSyncFunc, action, gunName, ammoData)
        end)
        table.insert(ammoConns, newConn)
    end

    for gunName, maxAmmo in pairs(gunMax) do
        local gun = items:FindFirstChild(gunName)
        if gun then
            local c1 = gun:GetAttributeChangedSignal("Ammo"):Connect(function()
                if not infAmmoActive then return end
                local val = gun:GetAttribute("Ammo")
                if val and val < maxAmmo then
                    gun:SetAttribute("Ammo", maxAmmo)
                end
            end)
            local c2 = gun:GetAttributeChangedSignal("Reserve"):Connect(function()
                if not infAmmoActive then return end
                local val = gun:GetAttribute("Reserve")
                if val and val < 999 then
                    gun:SetAttribute("Reserve", 999)
                end
            end)
            table.insert(ammoConns, c1)
            table.insert(ammoConns, c2)
            gun:SetAttribute("Ammo", maxAmmo)
            gun:SetAttribute("Reserve", 999)
        end
    end

    pcall(function()
        local playerGui = lp:FindFirstChild("PlayerGui")
        local ingame = playerGui and playerGui:FindFirstChild("Ingame")
        local mechanics = ingame and ingame:FindFirstChild("MechanicsFrame")
        local gunUI = mechanics and mechanics:FindFirstChild("GunUI")
        if gunUI then
            local ammoText = gunUI:FindFirstChild("Ammo")
            local reserveText = gunUI:FindFirstChild("AmmoInStore")
            if ammoText then
                local c = ammoText:GetPropertyChangedSignal("Text"):Connect(function()
                    if not infAmmoActive then return end
                    for gunName, maxAmmo in pairs(gunMax) do
                        local gun = items:FindFirstChild(gunName)
                        if gun and gun:GetAttribute("Equipped") then
                            ammoText.Text = tostring(maxAmmo)
                            return
                        end
                    end
                end)
                table.insert(ammoConns, c)
            end
            if reserveText then
                local c = reserveText:GetPropertyChangedSignal("Text"):Connect(function()
                    if not infAmmoActive then return end
                    reserveText.Text = "999"
                end)
                table.insert(ammoConns, c)
            end
        end
    end)
end

local AmmoLabel = AmmoSection:AddLabel('无限弹药', false)
AmmoLabel:AddToggle({ Default = false, Flag = "InfAmmo", Callback = function(v)
    infAmmoActive = v
    if v then
        setupAmmoHooks()
        task.spawn(function()
            while infAmmoActive do
                pcall(function()
                    local char = lp.Character
                    local items = char and char:FindFirstChild("Items")
                    if items then
                        for gunName, maxAmmo in pairs(gunMax) do
                            local gun = items:FindFirstChild(gunName)
                            if gun then
                                gun:SetAttribute("Ammo", maxAmmo)
                                gun:SetAttribute("Reserve", 999)
                            end
                            if origSyncFunc then
                                pcall(origSyncFunc, "Sync", gunName, {maxAmmo, 999})
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    else
        for _, c in ipairs(ammoConns) do pcall(function() c:Disconnect() end) end
        ammoConns = {}
    end
end })
local AmmoKeybind = AmmoLabel:AddKeybind({ Default = nil, Flag = "AmmoKey" })

lp.CharacterAdded:Connect(function()
    if infAmmoActive then
        task.wait(1)
        setupAmmoHooks()
    end
    if noRecoilActive then
        task.wait(1)
        noRecoilHooked = false
        hookRecoil()
    end
end)

local bullet = { TrackActive = false, Simulate = nil, TrailActive = false, TrailColor = Color3.fromRGB(0, 120, 255), TrailLinger = 0.5 }

local function getNearestEnemyPos()
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local nearDist = math.huge
    local nearPos = nil
    for _, chain in ipairs(aiFolder:GetChildren()) do
        if chain:IsA("Model") then
            local cHRP = chain:FindFirstChild("HumanoidRootPart")
            local cHum = chain:FindFirstChild("Humanoid")
            if cHRP and cHum and cHum.Health > 0 then
                local dist = (hrp.Position - cHRP.Position).Magnitude
                if dist < nearDist then
                    nearDist = dist
                    nearPos = cHRP.Position
                end
            end
        end
    end
    return nearPos
end

local function createBulletTrail(from, to)
    local linger = bullet.TrailLinger or 0.5
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.Material = Enum.Material.Neon
    part.Color = bullet.TrailColor
    part.Size = Vector3.new(0.05, 0.05, (to - from).Magnitude)
    part.CFrame = CFrame.new(from, to) * CFrame.new(0, 0, -part.Size.Z / 2)
    part.Transparency = 0
    part.Parent = W
    task.spawn(function()
        local steps = 20
        local stepTime = linger / steps
        for i = 1, steps do
            task.wait(stepTime)
            part.Transparency = i / steps
        end
        part:Destroy()
    end)
end

local function setupBulletTrack()
    local PH = require(game:GetService("ReplicatedStorage").GameStuff.Modules.ProjectileHandler)
    if not PH or not PH.SimulateProjectile then return false end
    bullet.Simulate = PH.SimulateProjectile
    local hookFunc = function(self, p135, p136, p137, p138, p139, p140, p141, p142, p143, p144, p145, p146)
        if bullet.TrackActive and p138 and p139 then
            local enemyPos = getNearestEnemyPos()
            if enemyPos then
                local firePos = p139.WorldPosition
                if bullet.TrailActive then
                    createBulletTrail(firePos, enemyPos)
                end
                local newDir = (enemyPos - firePos).Unit
                local newDirs = {}
                for i = 1, #p138 do
                    newDirs[i] = newDir
                end
                p138 = newDirs
            end
        end
        return bullet.Simulate(self, p135, p136, p137, p138, p139, p140, p141, p142, p143, p144, p145, p146)
    end
    if newcclosure then
        PH.SimulateProjectile = newcclosure(hookFunc)
    else
        PH.SimulateProjectile = hookFunc
    end
    return true
end

local BulletLabel = AmmoSection:AddLabel('子弹追踪', false)
BulletLabel:AddToggle({ Default = false, Flag = "BulletTrack", Callback = function(v)
    bullet.TrackActive = v
    if v then
        if not bullet.Simulate then
            local ok = setupBulletTrack()
            if not ok then
                bullet.TrackActive = false
                return
            end
        end
    else
        if bullet.Simulate then
            local PH = require(game:GetService("ReplicatedStorage").GameStuff.Modules.ProjectileHandler)
            PH.SimulateProjectile = bullet.Simulate
            bullet.Simulate = nil
        end
    end
end })
local BulletKeybind = BulletLabel:AddKeybind({ Default = nil, Flag = "BulletTrackKey" })
local BulletOption = BulletLabel:AddOption(1)
BulletOption:AddLabel("轨迹显示"):AddToggle({ Default = false, Flag = "BulletTrail", Callback = function(v) bullet.TrailActive = v end })
BulletOption:AddLabel("轨迹颜色"):AddColorPicker({ Default = Color3.fromRGB(0, 120, 255), Flag = "BulletTrailColor", Callback = function(v) bullet.TrailColor = v end })
BulletOption:AddLabel("滞留时间"):AddSlider({ Default = 0.5, Min = 0.1, Max = 3, Rounding = 2, Flag = "BulletTrailLinger", Callback = function(v) bullet.TrailLinger = v end })

local noRecoilActive = false
local noRecoilHooked = false
local noRecoilTable = nil
local noRecoilOrig = {}
local function hookRecoil()
    if noRecoilHooked then return end
    pcall(function()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "AKRecoil") then
                noRecoilTable = v
                for _, fname in ipairs({"AKRecoil", "DeagleRecoil", "M1911Recoil", "DBRecoil", "CamShake1", "Shake"}) do
                    if rawget(v, fname) and type(rawget(v, fname)) == "function" then
                        noRecoilOrig[fname] = rawget(v, fname)
                        rawset(v, fname, function() end)
                    end
                end
                noRecoilHooked = true
                break
            end
        end
    end)
end

local function restoreRecoil()
    if not noRecoilTable then return end
    pcall(function()
        for fname, orig in pairs(noRecoilOrig) do
            rawset(noRecoilTable, fname, orig)
        end
        noRecoilOrig = {}
        noRecoilHooked = false
        noRecoilTable = nil
    end)
end

local NoRecoilLabel = AmmoSection:AddLabel('无后坐力', false)
NoRecoilLabel:AddToggle({ Default = false, Flag = "NoRecoil", Callback = function(v)
    noRecoilActive = v
    if v then hookRecoil() else restoreRecoil() end
end })
local NoRecoilKeybind = NoRecoilLabel:AddKeybind({ Default = nil, Flag = "NoRecoilKey" })

UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    local key = input.KeyCode.Name
    local shopKey = ShopKeybind:GetValue()
    local deconKey = DeconKeybind:GetValue()
    local wbKey = WorkbenchKeybind:GetValue()
    local fcKey = FaceChainKeybind:GetValue()
    local tpKey = TPWalkKeybind:GetValue()
    local tp3Key = ThirdPersonKeybind:GetValue()
    local ncKey = NoclipKeybind:GetValue()
    local nrKey = NoRecoilKeybind:GetValue()
    local psKey = PseudoKeybind and PseudoKeybind:GetValue()
    local ammoKey = AmmoKeybind:GetValue()
    local bulletKey = BulletKeybind:GetValue()
    if ammoKey and key == ammoKey then
        local toggle = UILib.Flags["InfAmmo"]
        if toggle then
            local v = not toggle:GetValue()
            toggle:SetValue(v)
            Notify(v and "check" or "xmark", "无限弹药 " .. (v and "开启" or "关闭"), 2)
        end
    elseif bulletKey and key == bulletKey then
        local toggle = UILib.Flags["BulletTrack"]
        if toggle then
            local v = not toggle:GetValue()
            toggle:SetValue(v)
            Notify(v and "check" or "xmark", "子弹追踪 " .. (v and "开启" or "关闭"), 2)
        end
    elseif nrKey and key == nrKey then
        local toggle = UILib.Flags["NoRecoil"]
        if toggle then
            local v = not toggle:GetValue()
            toggle:SetValue(v)
            Notify(v and "check" or "xmark", "无后坐力 " .. (v and "开启" or "关闭"), 2)
        end
    elseif shopKey and key == shopKey then
        if not RemoteGUIs.Shop and not isDaytime() then
            Logger.new("xmark", "商店只能在白天打开", 2)
            pcall(function() errorSound:Play() end)
        else
            RemoteGUIs.Shop = not RemoteGUIs.Shop
            SetRemoteGui("Shop", RemoteGUIs.Shop)
            Notify(RemoteGUIs.Shop and "check" or "xmark", "商店界面 " .. (RemoteGUIs.Shop and "开启" or "关闭"), 2)
        end
    elseif deconKey and key == deconKey then
        RemoteGUIs.Deconstructor = not RemoteGUIs.Deconstructor
        SetRemoteGui("Deconstructor", RemoteGUIs.Deconstructor)
        Notify(RemoteGUIs.Deconstructor and "check" or "xmark", "分解界面 " .. (RemoteGUIs.Deconstructor and "开启" or "关闭"), 2)
    elseif wbKey and key == wbKey then
        RemoteGUIs.Workbench = not RemoteGUIs.Workbench
        SetRemoteGui("Workbench", RemoteGUIs.Workbench)
        Notify(RemoteGUIs.Workbench and "check" or "xmark", "工作台界面 " .. (RemoteGUIs.Workbench and "开启" or "关闭"), 2)
    elseif fcKey and key == fcKey then
        faceChainActive = not faceChainActive
        Notify(faceChainActive and "check" or "xmark", "面向chain " .. (faceChainActive and "开启" or "关闭"), 2)
        if faceChainActive then task.spawn(function()
            while faceChainActive do
                pcall(function()
                    local char = lp.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local nearest, nearDist = nil, math.huge
                        for _, chain in ipairs(aiFolder:GetChildren()) do
                            if chain:IsA("Model") then
                                local cHRP = chain:FindFirstChild("HumanoidRootPart")
                                local cHum = chain:FindFirstChild("Humanoid")
                                if cHRP and cHum and cHum.Health > 0 then
                                    local dist = (hrp.Position - cHRP.Position).Magnitude
                                    if dist < nearDist then nearDist = dist; nearest = cHRP end
                                end
                            end
                        end
                        if nearest then
                            Cam.CFrame = CFrame.lookAt(Cam.CFrame.Position, nearest.Position)
                        end
                    end
                end)
                task.wait(0.03)
            end
        end) end
    elseif tpKey and key == tpKey then
        tpwalk.Active = not tpwalk.Active
        Notify(tpwalk.Active and "check" or "xmark", "速度 " .. (tpwalk.Active and "开启" or "关闭"), 2)
        if tpwalk.Active then
            setupTPWalk()
        else
            if tpwalk.Conn then tpwalk.Conn:Disconnect() tpwalk.Conn = nil end
            if tpwalk.CharConn then tpwalk.CharConn:Disconnect() tpwalk.CharConn = nil end
        end
    elseif tp3Key and key == tp3Key then
        tp3.Active = not tp3.Active
        Notify(tp3.Active and "check" or "xmark", "第三人称 " .. (tp3.Active and "开启" or "关闭"), 2)
        if tp3.Active then
            tp3.SavedMax = lp.CameraMaxZoomDistance
            tp3.SavedMin = lp.CameraMinZoomDistance
            enforceThirdPerson()
        else
            if tp3.Conn then tp3.Conn:Disconnect() tp3.Conn = nil end
            if tp3.CharConn then tp3.CharConn:Disconnect() tp3.CharConn = nil end
            pcall(function()
                lp.CameraMode = Enum.CameraMode.LockFirstPerson
                if tp3.SavedMax then lp.CameraMaxZoomDistance = tp3.SavedMax end
                if tp3.SavedMin then lp.CameraMinZoomDistance = tp3.SavedMin end
            end)
        end
    elseif ncKey and key == ncKey then
        noclipActive = not noclipActive
        Notify(noclipActive and "check" or "xmark", "穿墙 " .. (noclipActive and "开启" or "关闭"), 2)
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
        if noclipActive then
            noclipConn = RS.Stepped:Connect(function()
                local char = lp.Character
                if not char then return end
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        end
    elseif psKey and key == psKey then
        togglePseudoInvincible()
    end
end)

task.spawn(function()
    while true do
        local anyActive = RemoteGUIs.Shop or RemoteGUIs.Deconstructor or RemoteGUIs.Workbench
        local uiVisible = Window and Window.Signal and Window.Signal:GetValue()
        if anyActive or uiVisible then
            UIS.MouseBehavior = Enum.MouseBehavior.Default
            UIS.MouseIconEnabled = true
            Mouse.Icon = ""
        end
        task.wait(0.1)
    end
end)



