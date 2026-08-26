-- ============================================================
--  恶魔学脚本 V2.0 · 完整整合版（UI + 功能）
--  作者：zy
--  使用方式：直接运行此脚本，无需额外加载其他文件
-- ============================================================

-- ============================================================
--  第一部分：UI界面
-- ============================================================
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- 防止重复创建
if _G.DemonologyUI then _G.DemonologyUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DemonologyUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false
_G.DemonologyUI = ScreenGui

-- 颜色配置
local Colors = {
    Bg = Color3.fromRGB(10, 10, 12),
    BgLight = Color3.fromRGB(20, 20, 25),
    Border = Color3.fromRGB(60, 60, 70),
    Primary = Color3.fromRGB(180, 130, 255),
    PrimaryDark = Color3.fromRGB(120, 80, 200),
    Text = Color3.fromRGB(230, 230, 240),
    TextDim = Color3.fromRGB(150, 150, 170),
    Success = Color3.fromRGB(0, 255, 150),
    Danger = Color3.fromRGB(255, 70, 70),
    Warning = Color3.fromRGB(255, 200, 50),
}

-- 主窗口
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 580)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -290)
MainFrame.BackgroundColor3 = Colors.Bg
MainFrame.BackgroundTransparency = 0.08
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Colors.Border
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

-- 标题栏
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 44)
TitleBar.BackgroundColor3 = Colors.BgLight
TitleBar.BackgroundTransparency = 0.5
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 14)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.6, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.Text = "👻 恶魔学 · V2.0"
TitleLabel.TextColor3 = Colors.Text
TitleLabel.TextScaled = true
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = TitleBar

-- 锁定按钮
local LockBtn = Instance.new("TextButton")
LockBtn.Name = "LockBtn"
LockBtn.Size = UDim2.new(0, 30, 0, 30)
LockBtn.Position = UDim2.new(1, -80, 0, 7)
LockBtn.Text = "🔓"
LockBtn.TextColor3 = Colors.Text
LockBtn.TextScaled = true
LockBtn.BackgroundColor3 = Colors.Border
LockBtn.BackgroundTransparency = 0.6
LockBtn.BorderSizePixel = 0
LockBtn.Parent = TitleBar
local LockCorner = Instance.new("UICorner")
LockCorner.CornerRadius = UDim.new(1, 0)
LockCorner.Parent = LockBtn

-- 关闭按钮
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -44, 0, 7)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Colors.Text
CloseBtn.TextScaled = true
CloseBtn.BackgroundColor3 = Colors.Danger
CloseBtn.BackgroundTransparency = 0.7
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

-- 拖动逻辑
local isDraggable = true
local dragging = false
local dragInput, dragStart, startPos

LockBtn.MouseButton1Click:Connect(function()
    isDraggable = not isDraggable
    LockBtn.Text = isDraggable and "🔓" or "🔒"
    LockBtn.BackgroundColor3 = isDraggable and Colors.Border or Colors.Primary
end)

TitleBar.InputBegan:Connect(function(input)
    if not isDraggable then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    _G.DemonologyUI = nil
end)

-- 信息面板
local InfoPanel = Instance.new("Frame")
InfoPanel.Name = "InfoPanel"
InfoPanel.Size = UDim2.new(1, -24, 0, 60)
InfoPanel.Position = UDim2.new(0, 12, 0, 52)
InfoPanel.BackgroundColor3 = Colors.BgLight
InfoPanel.BackgroundTransparency = 0.6
InfoPanel.BorderSizePixel = 1
InfoPanel.BorderColor3 = Colors.Border
InfoPanel.Parent = MainFrame
local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 10)
InfoCorner.Parent = InfoPanel

local GhostLabel = Instance.new("TextLabel")
GhostLabel.Name = "GhostLabel"
GhostLabel.Size = UDim2.new(0.5, -10, 0.45, 0)
GhostLabel.Position = UDim2.new(0, 10, 0, 6)
GhostLabel.Text = "👻 鬼魂: 未识别"
GhostLabel.TextColor3 = Colors.TextDim
GhostLabel.TextScaled = true
GhostLabel.TextXAlignment = Enum.TextXAlignment.Left
GhostLabel.BackgroundTransparency = 1
GhostLabel.Font = Enum.Font.Gotham
GhostLabel.Parent = InfoPanel

local StatusDot = Instance.new("Frame")
StatusDot.Name = "StatusDot"
StatusDot.Size = UDim2.new(0, 10, 0, 10)
StatusDot.Position = UDim2.new(0.5, -5, 0.45, -5)
StatusDot.BackgroundColor3 = Colors.Success
StatusDot.BorderSizePixel = 0
StatusDot.Parent = InfoPanel
local DotCorner = Instance.new("UICorner")
DotCorner.CornerRadius = UDim.new(1, 0)
DotCorner.Parent = StatusDot

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(0.5, -10, 0.45, 0)
StatusLabel.Position = UDim2.new(0.5, 10, 0, 6)
StatusLabel.Text = "🟢 安全"
StatusLabel.TextColor3 = Colors.Success
StatusLabel.TextScaled = true
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = InfoPanel

local EvidenceLabel = Instance.new("TextLabel")
EvidenceLabel.Name = "EvidenceLabel"
EvidenceLabel.Size = UDim2.new(1, -20, 0.45, 0)
EvidenceLabel.Position = UDim2.new(0, 10, 0, 32)
EvidenceLabel.Text = "📋 证据: 无"
EvidenceLabel.TextColor3 = Colors.TextDim
EvidenceLabel.TextScaled = true
EvidenceLabel.TextXAlignment = Enum.TextXAlignment.Left
EvidenceLabel.BackgroundTransparency = 1
EvidenceLabel.Font = Enum.Font.Gotham
EvidenceLabel.Parent = InfoPanel

-- 功能开关区
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Name = "ScrollContainer"
ScrollContainer.Size = UDim2.new(1, 0, 0, 280)
ScrollContainer.Position = UDim2.new(0, 0, 0, 120)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.BorderSizePixel = 0
ScrollContainer.ScrollBarThickness = 3
ScrollContainer.ScrollBarImageColor3 = Colors.Primary
ScrollContainer.Parent = MainFrame

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, 0, 0, 0)
Content.BackgroundTransparency = 1
Content.Parent = ScrollContainer

-- 创建开关函数
local function createToggle(parent, yPos, labelText, configKey, defaultState)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Text = labelText
    label.TextColor3 = Colors.Text
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 44, 0, 22)
    toggleBg.Position = UDim2.new(1, -54, 0.5, -11)
    toggleBg.BackgroundColor3 = Colors.Border
    toggleBg.BackgroundTransparency = 0.4
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = frame
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBg
    
    local toggleDot = Instance.new("Frame")
    toggleDot.Size = UDim2.new(0, 16, 0, 16)
    toggleDot.Position = UDim2.new(0, 3, 0.5, -8)
    toggleDot.BackgroundColor3 = Color3.fromRGB(100, 100, 110)
    toggleDot.BorderSizePixel = 0
    toggleDot.Parent = toggleBg
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = toggleDot
    
    local isOn = defaultState
    local function updateToggle(state)
        isOn = state
        toggleBg.BackgroundColor3 = isOn and Colors.Primary or Colors.Border
        toggleBg.BackgroundTransparency = isOn and 0.3 or 0.4
        toggleDot.Position = isOn and UDim2.new(0, 25, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        toggleDot.BackgroundColor3 = isOn and Color3.fromRGB(255,255,255) or Color3.fromRGB(100,100,110)
        if _G.DemonologyConfig then _G.DemonologyConfig[configKey] = state end
        _G[configKey] = state
    end
    
    toggleBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateToggle(not isOn)
        end
    end)
    updateToggle(defaultState)
    return frame, updateToggle
end

local y = 10
local toggleConfigs = {
    {"🔮 自动通灵板", "AutoOuija", true},
    {"📸 自动拍照", "AutoPhoto", true},
    {"🛡️ 智能躲藏", "AutoHide", true},
    {"👁️ 证据ESP", "ESPEnabled", true},
    {"🕵️ 鬼魂识别", "AutoIdentify", true},
}
for _, config in ipairs(toggleConfigs) do
    createToggle(Content, y, config[1], config[2], config[3])
    y = y + 36
end

Content.Size = UDim2.new(1, 0, 0, y + 10)
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, y + 10)

-- 手动操作按钮区
local ActionPanel = Instance.new("Frame")
ActionPanel.Size = UDim2.new(1, -24, 0, 50)
ActionPanel.Position = UDim2.new(0, 12, 0, 408)
ActionPanel.BackgroundColor3 = Colors.BgLight
ActionPanel.BackgroundTransparency = 0.4
ActionPanel.BorderSizePixel = 0
ActionPanel.Parent = MainFrame
local ActionCorner = Instance.new("UICorner")
ActionCorner.CornerRadius = UDim.new(0, 10)
ActionCorner.Parent = ActionPanel

local function createActionBtn(parent, xPos, text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.22, 0, 0.7, 0)
    btn.Position = UDim2.new(xPos, 0, 0.15, 0)
    btn.Text = text
    btn.TextColor3 = Colors.Text
    btn.TextScaled = true
    btn.BackgroundColor3 = color or Colors.Primary
    btn.BackgroundTransparency = 0.4
    btn.BorderSizePixel = 0
    btn.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play()
    end)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

createActionBtn(ActionPanel, 0.03, "📸 拍照", Colors.Primary, function()
    if _G.TakePhoto then _G.TakePhoto() else print("⚠️ 功能未加载") end
end)
createActionBtn(ActionPanel, 0.27, "🛡️ 躲藏", Colors.PrimaryDark, function()
    if _G.HideNow then _G.HideNow() else print("⚠️ 功能未加载") end
end)
createActionBtn(ActionPanel, 0.51, "🕵️ 识别", Colors.Warning, function()
    if _G.Identify then _G.Identify() else print("⚠️ 功能未加载") end
end)
createActionBtn(ActionPanel, 0.75, "🚪 离开", Colors.Danger, function()
    if _G.ExitHide then _G.ExitHide() else print("⚠️ 功能未加载") end
end)

-- 底部状态栏
local Footer = Instance.new("Frame")
Footer.Size = UDim2.new(1, -24, 0, 28)
Footer.Position = UDim2.new(0, 12, 1, -36)
Footer.BackgroundColor3 = Colors.BgLight
Footer.BackgroundTransparency = 0.6
Footer.BorderSizePixel = 1
Footer.BorderColor3 = Colors.Border
Footer.Parent = MainFrame
local FooterCorner = Instance.new("UICorner")
FooterCorner.CornerRadius = UDim.new(0, 8)
FooterCorner.Parent = Footer

local FooterLabel = Instance.new("TextLabel")
FooterLabel.Size = UDim2.new(1, -20, 1, 0)
FooterLabel.Position = UDim2.new(0, 10, 0, 0)
FooterLabel.Text = "💡 Ctrl+H 切换界面 · 拖动前请点击🔓解锁"
FooterLabel.TextColor3 = Colors.TextDim
FooterLabel.TextScaled = true
FooterLabel.TextSize = 12
FooterLabel.TextXAlignment = Enum.TextXAlignment.Left
FooterLabel.BackgroundTransparency = 1
FooterLabel.Font = Enum.Font.Gotham
FooterLabel.Parent = Footer

-- 快捷键
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.H and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

_G.DemonologyUI_Toggle = function() MainFrame.Visible = not MainFrame.Visible end

print("✅ UI界面已加载")

-- ============================================================
--  第二部分：主功能脚本
-- ============================================================
print("🚀 正在加载主功能...")

local RunService = game:GetService("RunService")
local TweenService2 = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera

-- 配置
local CONFIG = {
    AutoOuija = true,
    OuijaDelay = 0.3,
    AutoPhoto = true,
    PhotoCooldown = 3,
    PhotoFOV = 60,
    PhotoRange = 20,
    AutoHide = true,
    HideDistance = 1.5,
    RunSpeed = 0.3,
    ESPEnabled = true,
    ESPRange = 30,
    ESPRefreshRate = 0.5,
    AutoIdentify = true,
    IdentifyInterval = 10,
}

_G.DemonologyConfig = CONFIG

-- 工具函数
local function getChar() return Player.Character end
local function getRoot()
    local char = getChar()
    return char and char:FindFirstChild("HumanoidRootPart")
end
local function distance(pos1, pos2) return (pos1 - pos2).Magnitude end
local function tableFind(tbl, val)
    for _, v in pairs(tbl) do if v == val then return true end end
    return false
end

-- 通灵板
local Ouija = {Typing = false}
function Ouija:findBoard()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and (v.Name:lower():find("ouija") or v.Name:lower():find("board")) then
            return v
        end
    end
    return nil
end
function Ouija:clickLetter(letter)
    local board = self:findBoard()
    if not board then return false end
    letter = string.upper(letter)
    for _, v in pairs(board:GetDescendants()) do
        if v:IsA("TextButton") and string.upper(v.Text) == letter then
            v:FireServer("ClickLetter", letter)
            wait(CONFIG.OuijaDelay)
            return true
        end
    end
    return false
end
function Ouija:typeName(name)
    if self.Typing then return end
    self.Typing = true
    print("🔮 通灵板输入:", name)
    for i = 1, #name do
        local letter = string.sub(name, i, i)
        if not self:clickLetter(letter) then
            print("⚠️ 字母 '" .. letter .. "' 点击失败")
        end
        wait(CONFIG.OuijaDelay)
    end
    self:clickLetter("Goodbye")
    self.Typing = false
    print("✅ 通灵板输入完成")
end

-- 拍照
local Photo = {LastTime = 0}
function Photo:findCamera()
    local char = getChar()
    local backpack = Player:FindFirstChild("Backpack")
    if char then
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("Tool") and (v.Name:lower():find("camera") or v.Name:lower():find("photo") or v.Name:lower():find("polaroid")) then
                return v
            end
        end
    end
    if backpack then
        for _, v in pairs(backpack:GetChildren()) do
            if v:IsA("Tool") and (v.Name:lower():find("camera") or v.Name:lower():find("photo") or v.Name:lower():find("polaroid")) then
                return v
            end
        end
    end
    return nil
end
function Photo:equip()
    local cam = self:findCamera()
    if cam and cam.Parent ~= getChar() then
        cam.Parent = getChar()
        wait(0.2)
        return true
    end
    return false
end
function Photo:take()
    if tick() - self.LastTime < CONFIG.PhotoCooldown then return false end
    local cam = self:findCamera()
    if not cam then
        self:equip()
        wait(0.2)
        cam = self:findCamera()
        if not cam then return false end
    end
    local remote = cam:FindFirstChild("RemoteEvent") or cam:FindFirstChild("TakePhoto") or cam:FindFirstChild("Click")
    if remote then
        remote:FireServer()
        self.LastTime = tick()
        return true
    end
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
    wait(0.05)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
    self.LastTime = tick()
    return true
end
function Photo:getGhostPos()
    local char = getChar()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= char then
            local name = v.Name:lower()
            if name:find("ghost") or name:find("spirit") or name:find("demon") then
                local part = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
                if part then return part.Position end
            end
        end
    end
    return nil
end
function Photo:isGhostInView()
    local ghostPos = self:getGhostPos()
    if not ghostPos then return false end
    local root = getRoot()
    if not root then return false end
    local dir = (ghostPos - root.Position).Unit
    local look = Camera.CFrame.LookVector
    local angle = math.acos(dir:Dot(look)) * (180 / math.pi)
    local dist = distance(ghostPos, root.Position)
    return angle < CONFIG.PhotoFOV and dist < CONFIG.PhotoRange
end

-- 躲藏
local Hider = {IsHiding = false, CurrentSpot = nil}
function Hider:isHunting()
    if _G.Hunting or _G.IsHunting then return true end
    local lighting = game:GetService("Lighting")
    if lighting and lighting:FindFirstChild("Flicker") and lighting.Flicker.Enabled then
        return true
    end
    local char = getChar()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= char then
            local name = v.Name:lower()
            if name:find("ghost") or name:find("spirit") or name:find("demon") then
                local hum = v:FindFirstChild("Humanoid")
                if hum and hum.WalkSpeed and hum.WalkSpeed > 12 then
                    return true
                end
            end
        end
    end
    return false
end
function Hider:findSpots()
    local spots = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and (v.Name:lower():find("closet") or v.Name:lower():find("locker") or 
                               v.Name:lower():find("cabinet") or v.Name:lower():find("wardrobe")) then
            local part = v:FindFirstChildWhichIsA("BasePart")
            if part then
                table.insert(spots, {Object = v, Position = part.Position, Name = v.Name})
            end
        end
        if v:IsA("Part") and (v.Name:lower():find("hide") or v.Name:lower():find("safe") or v.Name:lower():find("cover")) then
            table.insert(spots, {Object = v, Position = v.Position, Name = v.Name})
        end
    end
    local root = getRoot()
    if root then
        table.sort(spots, function(a, b)
            return distance(a.Position, root.Position) < distance(b.Position, root.Position)
        end)
    end
    return spots
end
function Hider:moveTo(pos)
    local root = getRoot()
    if not root then return false end
    local tween = TweenService2:Create(root, TweenInfo.new(CONFIG.RunSpeed), {CFrame = CFrame.new(pos)})
    tween:Play()
    return true
end
function Hider:interact(spot)
    if not spot then return false end
    for _, v in pairs(spot.Object:GetDescendants()) do
        if v:IsA("TextButton") and (v.Text:lower():find("hide") or v.Text:lower():find("enter") or v.Text:lower():find("open")) then
            v:FireServer("Click")
            return true
        end
        if v:IsA("ClickDetector") then
            v:FireClick()
            return true
        end
    end
    return false
end
function Hider:hide()
    if self.IsHiding then return end
    local spots = self:findSpots()
    if #spots == 0 then print("⚠️ 没找到藏身处！") return end
    local spot = spots[1]
    self:moveTo(spot.Position)
    wait(0.3)
    self:interact(spot)
    self.IsHiding = true
    self.CurrentSpot = spot
    print("🛡️ 已躲入:", spot.Name)
end
function Hider:exit()
    if not self.IsHiding or not self.CurrentSpot then return end
    for _, v in pairs(self.CurrentSpot.Object:GetDescendants()) do
        if v:IsA("TextButton") and (v.Text:lower():find("exit") or v.Text:lower():find("leave")) then
            v:FireServer("Click")
            break
        end
    end
    self.IsHiding = false
    self.CurrentSpot = nil
    print("🚶 已离开藏身处")
end

-- ESP
local ESP = {Elements = {}, Scanned = {}, LastScan = 0}
ESP.EvidenceTypes = {
    EMF = {Names = {"EMFReader", "EMF", "EMFReader5"}, Color = Color3.fromRGB(255, 0, 0)},
    GhostWriting = {Names = {"GhostWriting", "WritingBook", "GhostBook"}, Color = Color3.fromRGB(0, 255, 0)},
    SpiritBox = {Names = {"SpiritBox", "SpiritBoxPro", "SB"}, Color = Color3.fromRGB(0, 0, 255)},
    Thermometer = {Names = {"Thermometer", "TempGun", "Thermo"}, Color = Color3.fromRGB(255, 255, 0)},
    UVLight = {Names = {"UVLight", "UV", "Ultraviolet"}, Color = Color3.fromRGB(255, 0, 255)},
    GhostOrb = {Names = {"GhostOrb", "Orb", "DOTS"}, Color = Color3.fromRGB(0, 255, 255)},
    Camera = {Names = {"Camera", "PhotoCamera", "Polaroid"}, Color = Color3.fromRGB(255, 165, 0)},
    Crucifix = {Names = {"Crucifix", "Cross", "Cruci"}, Color = Color3.fromRGB(255, 255, 255)},
    Salt = {Names = {"Salt", "SaltPile"}, Color = Color3.fromRGB(200, 200, 200)},
}
ESP.UseDrawing = pcall(function() return Drawing.new("Square") end)

function ESP:createElement(pos, color, text)
    if self.UseDrawing then
        local line = Drawing.new("Line")
        line.From = Vector2.new(0, 0)
        line.To = Vector2.new(0, 0)
        line.Color = color
        line.Thickness = 3
        line.Transparency = 1
        local label = Drawing.new("Text")
        label.Text = text
        label.Color = color
        label.Size = 18
        label.Center = true
        label.Transparency = 1
        return {Line = line, Label = label, Pos = pos, Enabled = true}
    else
        local gui = Instance.new("BillboardGui")
        gui.Name = "ESP_Evidence"
        gui.Size = UDim2.new(0, 120, 0, 50)
        gui.Parent = game:GetService("CoreGui")
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = color
        frame.BackgroundTransparency = 0.5
        frame.BorderSizePixel = 2
        frame.Parent = gui
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0.5, 0)
        label.Position = UDim2.new(0, 0, 0.5, 0)
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextScaled = true
        label.BackgroundTransparency = 1
        label.Parent = frame
        return {Gui = gui, Frame = frame, Label = label, Pos = pos, Enabled = true}
    end
end

function ESP:scan()
    local now = tick()
    if now - self.LastScan < CONFIG.ESPRefreshRate then return end
    self.LastScan = now
    for _, v in pairs(workspace:GetDescendants()) do
        if self.Scanned[v] then continue end
        local foundType = nil
        local color = nil
        for typeName, data in pairs(self.EvidenceTypes) do
            for _, name in pairs(data.Names) do
                if v.Name:lower():find(name:lower()) then
                    foundType = typeName
                    color = data.Color
                    break
                end
            end
            if foundType then break end
        end
        if foundType and color then
            local pos = nil
            if v:IsA("BasePart") then
                pos = v.Position
            elseif v:IsA("Model") then
                local part = v:FindFirstChildWhichIsA("BasePart")
                if part then pos = part.Position end
            elseif v:IsA("Tool") and v:FindFirstChild("Handle") then
                pos = v.Handle.Position
            end
            if pos then
                local text = foundType .. " | " .. v.Name
                self.Elements[v] = self:createElement(pos, color, text)
                self.Scanned[v] = true
            end
        end
    end
    for obj, esp in pairs(self.Elements) do
        if not obj.Parent then
            if self.UseDrawing then
                esp.Line.Visible = false
                esp.Label.Visible = false
            else
                esp.Gui:Destroy()
            end
            self.Elements[obj] = nil
            self.Scanned[obj] = nil
        end
    end
end

function ESP:render()
    if not CONFIG.ESPEnabled then
        for _, esp in pairs(self.Elements) do
            if self.UseDrawing then
                esp.Line.Visible = false
                esp.Label.Visible = false
            else
                esp.Gui.Enabled = false
            end
        end
        return
    end
    for obj, esp in pairs(self.Elements) do
        local pos = esp.Pos
        if obj:IsA("BasePart") then
            pos = obj.Position
        elseif obj:IsA("Model") then
            local part = obj:FindFirstChildWhichIsA("BasePart")
            if part then pos = part.Position end
        end
        local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
        if not onScreen then
            if self.UseDrawing then
                esp.Line.Visible = false
                esp.Label.Visible = false
            else
                esp.Gui.Enabled = false
            end
            continue
        end
        local dist = distance(pos, Camera.CFrame.Position)
        if dist > CONFIG.ESPRange then
            if self.UseDrawing then
                esp.Line.Visible = false
                esp.Label.Visible = false
            else
                esp.Gui.Enabled = false
            end
            continue
        end
        if self.UseDrawing then
            esp.Line.Visible = true
            esp.Label.Visible = true
            esp.Line.From = Vector2.new(screenPos.X, screenPos.Y - 50)
            esp.Line.To = Vector2.new(screenPos.X, screenPos.Y + 100)
            esp.Label.Position = Vector2.new(screenPos.X, screenPos.Y - 70)
            local trans = math.min(1, dist / CONFIG.ESPRange)
            esp.Line.Transparency = trans
            esp.Label.Transparency = trans
        else
            esp.Gui.Enabled = true
            esp.Gui.Adornee = obj:IsA("BasePart") and obj or (obj:FindFirstChildWhichIsA("BasePart") or obj)
        end
    end
end

-- 鬼魂识别
local Identifier = {LastIdentify = 0, Evidence = {EMF5=false, SpiritBox=false, GhostWriting=false, DOTS=false, UV=false}}
Identifier.GhostDB = {
    Spirit = {Name="🧊 幽灵", Evidence={"EMF5","SpiritBox","GhostWriting"}},
    Wraith = {Name="👻 怨灵", Evidence={"EMF5","SpiritBox","DOTS"}},
    Phantom = {Name="📸 幻影", Evidence={"SpiritBox","UV","DOTS"}},
    Poltergeist = {Name="💥 骚灵", Evidence={"SpiritBox","GhostWriting","UV"}},
    Banshee = {Name="🎵 女妖", Evidence={"EMF5","UV","DOTS"}},
    Demon = {Name="👿 恶魔", Evidence={"SpiritBox","GhostWriting","UV"}},
}

function Identifier:collect()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name:lower():find("emf") then
            local level = v:FindFirstChild("Level") or v:FindFirstChild("Reading")
            if level and tonumber(level.Value) and tonumber(level.Value) >= 5 then
                self.Evidence.EMF5 = true
            end
        end
        if v.Name:lower():find("spiritbox") then
            local resp = v:FindFirstChild("Response") or v:FindFirstChild("HasResponded")
            if resp and resp.Value == true then
                self.Evidence.SpiritBox = true
            end
        end
        if v.Name:lower():find("writing") and v.Name:lower():find("book") then
            local text = v:FindFirstChild("Text") or v:FindFirstChild("Content")
            if text and #tostring(text.Value) > 3 then
                self.Evidence.GhostWriting = true
            end
        end
        if v.Name:lower():find("dots") or v.Name:lower():find("projector") then
            if v:FindFirstChild("Enabled") and v.Enabled.Value == true then
                self.Evidence.DOTS = true
            end
        end
        if v.Name:lower():find("uv") and v:FindFirstChild("Glow") then
            self.Evidence.UV = true
        end
    end
    local list = {}
    for k, v in pairs(self.Evidence) do
        if v then table.insert(list, k) end
    end
    return list
end

function Identifier:identify()
    if not CONFIG.AutoIdentify then return end
    if tick() - self.LastIdentify < CONFIG.IdentifyInterval then return end
    self.LastIdentify = tick()
    local evList = self:collect()
    if #evList == 0 then return end
    local best, bestScore = nil, 0
    for key, data in pairs(self.GhostDB) do
        local score = 0
        for _, ev in pairs(data.Evidence) do
            if tableFind(evList, ev) then
                score = score + 1
            end
        end
        if score > bestScore then
            bestScore = score
            best = {Key = key, Data = data, Score = score}
        end
    end
    if best and bestScore >= 2 then
        print("🕵️ 鬼魂识别:", best.Data.Name, "| 证据:", best.Score .. "/" .. #best.Data.Evidence, "| 已收集:", table.concat(evList, ", "))
        _G.CurrentGhost = best.Data.Name
        _G.CurrentEvidence = table.concat(evList, ", ")
        if CONFIG.AutoOuija and not Ouija.Typing then
            Ouija:typeName(best.Key)
        end
    end
end

-- 主循环
local MainLoop = {Running = true}

function MainLoop:start()
    print("=" .. string.rep("=", 50))
    print("  👻 恶魔学 V2.0 · 完整版已启动")
    print("  功能: 通灵板 | 拍照 | 躲藏 | ESP | 识别")
    print("=" .. string.rep("=", 50))
    
    RunService.Heartbeat:Connect(function()
        if not self.Running then return end
        local now = tick()
        
        -- 更新UI信息
        if _G.CurrentGhost then
            GhostLabel.Text = "👻 鬼魂: " .. _G.CurrentGhost
        end
        if _G.CurrentEvidence then
            EvidenceLabel.Text = "📋 证据: " .. _G.CurrentEvidence
        end
        
        -- 拍照
        if CONFIG.AutoPhoto and now - Photo.LastTime > CONFIG.PhotoCooldown then
            if Photo:isGhostInView() then
                Photo:take()
            end
        end
        
        -- 躲藏
        if CONFIG.AutoHide then
            local hunting = Hider:isHunting()
            if hunting and not Hider.IsHiding then
                Hider:hide()
                StatusLabel.Text = "🔴 狩猎中！"
                StatusLabel.TextColor3 = Colors.Danger
                StatusDot.BackgroundColor3 = Colors.Danger
                _G.HuntingActive = true
            elseif not hunting and Hider.IsHiding then
                Hider:exit()
                StatusLabel.Text = "🟢 安全"
                StatusLabel.TextColor3 = Colors.Success
                StatusDot.BackgroundColor3 = Colors.Success
                _G.HuntingActive = false
            end
        end
        
        -- ESP
        ESP:scan()
        ESP:render()
        
        -- 识别
        Identifier:identify()
    end)
    
    print("✅ 所有功能已加载完成！")
end

-- 全局控制函数
_G.ToggleAll = function()
    MainLoop.Running = not MainLoop.Running
    print(MainLoop.Running and "✅ 全部功能已开启" or "❌ 全部功能已关闭")
end
_G.Identify = function() Identifier:identify() end
_G.TypeName = function(name)
    if not name then print("⚠️ 用法: _G.TypeName('鬼名')") return end
    Ouija:typeName(name)
end
_G.TakePhoto = function() Photo:take() end
_G.HideNow = function() Hider:hide() end
_G.ExitHide = function() Hider:exit() end
_G.ToggleESP = function()
    CONFIG.ESPEnabled = not CONFIG.ESPEnabled
    print(CONFIG.ESPEnabled and "👁️ ESP 已开启" or "👁️ ESP 已关闭")
end

-- 启动
MainLoop:start()

-- 显示菜单
print("")
print("╔══════════════════════════════════════╗")
print("║  《恶魔学 V2.0》控制菜单            ║")
print("╠══════════════════════════════════════╣")
print("║  Ctrl+H       : 切换UI显示          ║")
print("║  _G.ToggleAll() : 开关全部功能      ║")
print("║  _G.Identify()  : 手动识别鬼魂      ║")
print("║  _G.TypeName()  : 手动输入鬼名      ║")
print("║  _G.TakePhoto() : 手动拍照          ║")
print("║  _G.HideNow()   : 手动躲藏          ║")
print("║  _G.ExitHide()  : 退出躲藏          ║")
print("║  _G.ToggleESP() : 切换ESP           ║")
print("╚══════════════════════════════════════╝")
print("")

print("🎯 提示：可以在脚本开头的 CONFIG 表中修改配置")