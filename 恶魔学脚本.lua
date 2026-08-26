-- ============================================================
--  恶魔学 · 透视专用UI（仿截图风格）
--  左侧分类：地图 | 透视功能 | 功能 | UI调试
--  右侧显示实时数据 + 开关
-- ============================================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- 防止重复创建
if _G.DemonologyUI then _G.DemonologyUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DemonologyUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false
_G.DemonologyUI = ScreenGui

-- ============================================================
--  颜色配置（暗夜主题 · 仿截图）
-- ============================================================
local Colors = {
    Bg = Color3.fromRGB(14, 14, 18),
    BgDark = Color3.fromRGB(8, 8, 12),
    BgLight = Color3.fromRGB(22, 22, 30),
    BgHover = Color3.fromRGB(35, 35, 50),
    Primary = Color3.fromRGB(0, 180, 255),
    PrimaryDark = Color3.fromRGB(0, 120, 200),
    Accent = Color3.fromRGB(150, 100, 255),
    Text = Color3.fromRGB(220, 220, 230),
    TextDim = Color3.fromRGB(140, 140, 170),
    TextBright = Color3.fromRGB(255, 255, 255),
    Success = Color3.fromRGB(0, 255, 150),
    Danger = Color3.fromRGB(255, 70, 70),
    Warning = Color3.fromRGB(255, 200, 50),
    Border = Color3.fromRGB(35, 35, 45),
    DataBg = Color3.fromRGB(20, 20, 28),
}

-- ============================================================
--  主窗口
-- ============================================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 780, 0, 520)
MainFrame.Position = UDim2.new(0.5, -390, 0.5, -260)
MainFrame.BackgroundColor3 = Colors.Bg
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Colors.Border
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- ============================================================
--  顶部标题栏
-- ============================================================
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 46)
TitleBar.BackgroundColor3 = Colors.BgDark
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.25, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Text = " 恶魔学 "
TitleLabel.TextColor3 = Colors.TextBright
TitleLabel.TextScaled = true
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = TitleBar

local SearchBox = Instance.new("Frame")
SearchBox.Size = UDim2.new(0.18, 0, 0.55, 0)
SearchBox.Position = UDim2.new(0.5, 0, 0.22, 0)
SearchBox.BackgroundColor3 = Colors.BgLight
SearchBox.BorderSizePixel = 1
SearchBox.BorderColor3 = Colors.Border
SearchBox.Parent = TitleBar
local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 5)
SearchCorner.Parent = SearchBox

local SearchLabel = Instance.new("TextLabel")
SearchLabel.Size = UDim2.new(1, -10, 1, 0)
SearchLabel.Position = UDim2.new(0, 10, 0, 0)
SearchLabel.Text = "🔍 Search"
SearchLabel.TextColor3 = Colors.TextDim
SearchLabel.TextScaled = true
SearchLabel.TextXAlignment = Enum.TextXAlignment.Left
SearchLabel.BackgroundTransparency = 1
SearchLabel.Font = Enum.Font.Gotham
SearchLabel.Parent = SearchBox

local OnlineLabel = Instance.new("TextLabel")
OnlineLabel.Size = UDim2.new(0.12, 0, 1, 0)
OnlineLabel.Position = UDim2.new(0.88, 0, 0, 0)
OnlineLabel.Text = "🟢 1人正在看"
OnlineLabel.TextColor3 = Colors.Success
OnlineLabel.TextScaled = true
OnlineLabel.TextXAlignment = Enum.TextXAlignment.Center
OnlineLabel.BackgroundTransparency = 1
OnlineLabel.Font = Enum.Font.Gotham
OnlineLabel.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 8)
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
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    _G.DemonologyUI = nil
end)

-- ============================================================
--  左侧分类栏（仿截图）
-- ============================================================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 140, 1, -46)
Sidebar.Position = UDim2.new(0, 0, 0, 46)
Sidebar.BackgroundColor3 = Colors.BgDark
Sidebar.BackgroundTransparency = 0.3
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local Categories = {
    {Icon = "🗺️", Name = "地图", Key = "map"},
    {Icon = "👁️", Name = "透视功能", Key = "esp"},
    {Icon = "⚙️", Name = "功能", Key = "features"},
    {Icon = "🔧", Name = "UI调试", Key = "debug"},
}

local SidebarButtons = {}
local currentCategory = "esp"

-- 内容面板
local ContentPanel = Instance.new("ScrollingFrame")
ContentPanel.Name = "ContentPanel"
ContentPanel.Size = UDim2.new(1, -155, 1, -60)
ContentPanel.Position = UDim2.new(0, 150, 0, 56)
ContentPanel.BackgroundTransparency = 1
ContentPanel.BorderSizePixel = 0
ContentPanel.ScrollBarThickness = 4
ContentPanel.ScrollBarImageColor3 = Colors.Primary
ContentPanel.Parent = MainFrame

local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, 0, 0, 0)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = ContentPanel

-- ============================================================
--  创建侧边栏按钮
-- ============================================================
local function createSidebarButton(yPos, icon, name, key)
    local btn = Instance.new("TextButton")
    btn.Name = "Btn_" .. key
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.Text = icon .. "  " .. name
    btn.TextColor3 = Colors.TextDim
    btn.TextScaled = true
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BackgroundColor3 = Colors.BgDark
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Parent = Sidebar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 3, 0.5, 0)
    indicator.Position = UDim2.new(0, 0, 0.25, 0)
    indicator.BackgroundColor3 = Colors.Primary
    indicator.BackgroundTransparency = 1
    indicator.BorderSizePixel = 0
    indicator.Parent = btn
    
    btn.MouseEnter:Connect(function()
        if currentCategory ~= key then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if currentCategory ~= key then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        end
    end)
    
    btn.MouseButton1Click:Connect(function()
        switchCategory(key)
    end)
    
    return btn, indicator
end

-- ============================================================
--  分类切换
-- ============================================================
function switchCategory(key)
    currentCategory = key
    
    for k, data in pairs(SidebarButtons) do
        local btn = data.Button
        local ind = data.Indicator
        if k == key then
            btn.TextColor3 = Colors.TextBright
            btn.BackgroundColor3 = Colors.BgLight
            btn.BackgroundTransparency = 0.4
            ind.BackgroundTransparency = 0
        else
            btn.TextColor3 = Colors.TextDim
            btn.BackgroundColor3 = Colors.BgDark
            btn.BackgroundTransparency = 1
            ind.BackgroundTransparency = 1
        end
    end
    
    updateContent(key)
end

-- ============================================================
--  UI组件
-- ============================================================
local function createToggle(parent, yPos, labelText, defaultState)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 32)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.Text = labelText
    label.TextColor3 = Colors.Text
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 42, 0, 22)
    toggleBg.Position = UDim2.new(1, -52, 0.5, -11)
    toggleBg.BackgroundColor3 = Colors.Border
    toggleBg.BackgroundTransparency = 0.5
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
    toggleBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isOn = not isOn
            toggleBg.BackgroundColor3 = isOn and Colors.Primary or Colors.Border
            toggleBg.BackgroundTransparency = isOn and 0.2 or 0.5
            toggleDot.Position = isOn and UDim2.new(0, 23, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            toggleDot.BackgroundColor3 = isOn and Color3.fromRGB(255,255,255) or Color3.fromRGB(100,100,110)
        end
    end)
    
    toggleBg.BackgroundColor3 = isOn and Colors.Primary or Colors.Border
    toggleBg.BackgroundTransparency = isOn and 0.2 or 0.5
    toggleDot.Position = isOn and UDim2.new(0, 23, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    toggleDot.BackgroundColor3 = isOn and Color3.fromRGB(255,255,255) or Color3.fromRGB(100,100,110)
    
    return frame
end

-- 数据条目（显示数值，如“EMF等级：2级”）
local function createDataEntry(parent, yPos, labelText, valueText)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 28)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundColor3 = Colors.DataBg
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Colors.Border
    frame.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = labelText
    label.TextColor3 = Colors.TextDim
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local value = Instance.new("TextLabel")
    value.Size = UDim2.new(0.3, 0, 1, 0)
    value.Position = UDim2.new(0.7, -10, 0, 0)
    value.Text = valueText
    value.TextColor3 = Colors.Primary
    value.TextScaled = true
    value.TextXAlignment = Enum.TextXAlignment.Right
    value.BackgroundTransparency = 1
    value.Font = Enum.Font.GothamBold
    value.Parent = frame
    
    return frame, value
end

local function createButton(parent, yPos, text, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.35, 0, 0, 34)
    btn.Position = UDim2.new(0.32, 0, 0, yPos)
    btn.Text = text
    btn.TextColor3 = Colors.TextBright
    btn.TextScaled = true
    btn.BackgroundColor3 = color or Colors.Primary
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        print("🔘 按钮被点击: " .. text)
    end)
    return btn
end

-- ============================================================
--  各分类内容
-- ============================================================
local contentY = 10

function updateContent(key)
    for _, child in pairs(ContentContainer:GetChildren()) do
        child:Destroy()
    end
    contentY = 10
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 36)
    title.Position = UDim2.new(0, 10, 0, contentY)
    title.TextColor3 = Colors.TextBright
    title.TextScaled = true
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Parent = ContentContainer
    
    if key == "map" then
        title.Text = "🗺️ 地图"
        contentY = contentY + 46
        
        createDataEntry(ContentContainer, contentY, "当前地图", "---")
        contentY = contentY + 34
        createDataEntry(ContentContainer, contentY, "房间数量", "0")
        contentY = contentY + 34
        createDataEntry(ContentContainer, contentY, "鬼房位置", "未知")
        contentY = contentY + 34
        createToggle(ContentContainer, contentY, "显示地图标记", true)
        contentY = contentY + 38
        createButton(ContentContainer, contentY, "🗺️ 标记鬼房", Colors.Primary)
        
    elseif key == "esp" then
        title.Text = "👁️ 透视功能"
        contentY = contentY + 46
        
        -- 数据条目（仿截图）
        createDataEntry(ContentContainer, contentY, "EMF等级", "2级")
        contentY = contentY + 34
        createDataEntry(ContentContainer, contentY, "灵书未写数量", "1")
        contentY = contentY + 34
        createDataEntry(ContentContainer, contentY, "灵书已写数量", "0")
        contentY = contentY + 34
        createDataEntry(ContentContainer, contentY, "幽灵球证据", "无")
        contentY = contentY + 34
        createDataEntry(ContentContainer, contentY, "花盆未枯萎数量", "1")
        contentY = contentY + 34
        createDataEntry(ContentContainer, contentY, "花盆已枯萎数量", "0")
        contentY = contentY + 34
        createDataEntry(ContentContainer, contentY, "投影仪数量", "1")
        contentY = contentY + 34
        createDataEntry(ContentContainer, contentY, "投影仪证据", "未现形")
        contentY = contentY + 40
        
        -- 开关
        createToggle(ContentContainer, contentY, "物品透视", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "鬼魂透视", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "玩家透视", false)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "诅咒物透视", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "UI调试", false)
        
    elseif key == "features" then
        title.Text = "⚙️ 功能"
        contentY = contentY + 46
        
        createToggle(ContentContainer, contentY, "自动通灵板", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "自动拍照", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "智能躲藏", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "鬼魂识别", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "狩猎预警", true)
        contentY = contentY + 45
        
        createButton(ContentContainer, contentY, "📸 手动拍照", Colors.Primary)
        contentY = contentY + 40
        createButton(ContentContainer, contentY, "🛡️ 立即躲藏", Colors.Danger)
        
    elseif key == "debug" then
        title.Text = "🔧 UI调试"
        contentY = contentY + 46
        
        createToggle(ContentContainer, contentY, "显示帧率", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "显示坐标", false)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "显示日志", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "显示碰撞箱", false)
        contentY = contentY + 45
        
        createButton(ContentContainer, contentY, "🔄 重载UI", Colors.Warning)
        contentY = contentY + 40
        createButton(ContentContainer, contentY, "📋 复制日志", Colors.Primary)
    end
    
    ContentContainer.Size = UDim2.new(1, 0, 0, contentY + 30)
    ContentPanel.CanvasSize = UDim2.new(0, 0, 0, contentY + 30)
end

-- ============================================================
--  创建侧边栏按钮
-- ============================================================
local yPos = 12
for _, cat in ipairs(Categories) do
    local btn, ind = createSidebarButton(yPos, cat.Icon, cat.Name, cat.Key)
    SidebarButtons[cat.Key] = {Button = btn, Indicator = ind}
    yPos = yPos + 44
end

switchCategory("esp")

-- ============================================================
--  底部信息
-- ============================================================
local Footer = Instance.new("Frame")
Footer.Size = UDim2.new(1, 0, 0, 28)
Footer.Position = UDim2.new(0, 0, 1, -28)
Footer.BackgroundColor3 = Colors.BgDark
Footer.BackgroundTransparency = 0.5
Footer.BorderSizePixel = 0
Footer.Parent = MainFrame

local FooterLabel = Instance.new("TextLabel")
FooterLabel.Size = UDim2.new(1, 0, 1, 0)
FooterLabel.Text = "zy"
FooterLabel.TextColor3 = Colors.TextDim
FooterLabel.TextScaled = true
FooterLabel.TextSize = 12
FooterLabel.BackgroundTransparency = 1
FooterLabel.Font = Enum.Font.Gotham
FooterLabel.Parent = Footer

-- ============================================================
--  快捷键
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.H and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- ============================================================
--  模拟数据更新
-- ============================================================
spawn(function()
    while ScreenGui and ScreenGui.Parent do
        wait(2)
        -- 这里可以更新数据条目的数值
        -- 例如：找到对应数据条目，修改其Value的Text
    end
end)

-- ============================================================
--  启动完成
-- ============================================================
print("=" .. string.rep("=", 50))
print("  👻 恶魔学 · 透视专用UI 已加载")
print("  📌 快捷键: Ctrl+H 切换界面")
print("  📌 左侧分类: 地图 | 透视功能 | 功能 | UI调试")
print("=" .. string.rep("=", 50))