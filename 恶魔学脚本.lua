-- ============================================================
--  恶魔学 HUB · 透视专用UI（鬼魂仅名字标签）
--  左侧7个分类，鬼魂透视只显示名字相关选项
-- ============================================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- 防止重复创建
if _G.DemonologyUI then _G.DemonologyUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DemonologyUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false
_G.DemonologyUI = ScreenGui

-- ============================================================
--  颜色配置
-- ============================================================
local Colors = {
    Bg = Color3.fromRGB(15, 15, 20),
    BgDark = Color3.fromRGB(10, 10, 14),
    BgLight = Color3.fromRGB(25, 25, 35),
    Primary = Color3.fromRGB(0, 180, 255),
    PrimaryDark = Color3.fromRGB(0, 120, 200),
    Text = Color3.fromRGB(230, 230, 240),
    TextDim = Color3.fromRGB(150, 150, 180),
    TextBright = Color3.fromRGB(255, 255, 255),
    Success = Color3.fromRGB(0, 255, 150),
    Danger = Color3.fromRGB(255, 70, 70),
    Warning = Color3.fromRGB(255, 200, 50),
    Border = Color3.fromRGB(40, 40, 55),
}

-- ============================================================
--  主窗口
-- ============================================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 750, 0, 500)
MainFrame.Position = UDim2.new(0.5, -375, 0.5, -250)
MainFrame.BackgroundColor3 = Colors.Bg
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Colors.Border
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- ============================================================
--  顶部标题栏
-- ============================================================
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Colors.BgDark
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.3, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Text = "👻 恶魔学 · 透视"
TitleLabel.TextColor3 = Colors.TextBright
TitleLabel.TextScaled = true
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = TitleBar

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.new(0.1, 0, 1, 0)
VersionLabel.Position = UDim2.new(0.3, 0, 0, 0)
VersionLabel.Text = "v2.0"
VersionLabel.TextColor3 = Colors.Primary
VersionLabel.TextScaled = true
VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
VersionLabel.BackgroundTransparency = 1
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.Parent = TitleBar

local OnlineLabel = Instance.new("TextLabel")
OnlineLabel.Size = UDim2.new(0.12, 0, 1, 0)
OnlineLabel.Position = UDim2.new(0.88, 0, 0, 0)
OnlineLabel.Text = "🟢 1人"
OnlineLabel.TextColor3 = Colors.Success
OnlineLabel.TextScaled = true
OnlineLabel.TextXAlignment = Enum.TextXAlignment.Center
OnlineLabel.BackgroundTransparency = 1
OnlineLabel.Font = Enum.Font.Gotham
OnlineLabel.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 10)
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
--  左侧分类栏
-- ============================================================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 160, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Colors.BgDark
Sidebar.BackgroundTransparency = 0.3
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local Categories = {
    {Icon = "👁️", Name = "全屏透视", Key = "esp_all"},
    {Icon = "👻", Name = "鬼魂透视", Key = "esp_ghost"},
    {Icon = "📋", Name = "证据透视", Key = "esp_evidence"},
    {Icon = "🚪", Name = "出口透视", Key = "esp_exit"},
    {Icon = "🕯️", Name = "道具透视", Key = "esp_items"},
    {Icon = "⚡", Name = "狩猎预警", Key = "esp_hunt"},
    {Icon = "⚙️", Name = "透视设置", Key = "esp_settings"},
}

local SidebarButtons = {}
local currentCategory = "esp_all"

local ContentPanel = Instance.new("ScrollingFrame")
ContentPanel.Name = "ContentPanel"
ContentPanel.Size = UDim2.new(1, -175, 1, -65)
ContentPanel.Position = UDim2.new(0, 170, 0, 60)
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
    btn.Size = UDim2.new(1, -10, 0, 40)
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
    indicator.Size = UDim2.new(0, 3, 0.6, 0)
    indicator.Position = UDim2.new(0, 0, 0.2, 0)
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
            btn.BackgroundTransparency = 0.5
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
    label.Size = UDim2.new(0.7, 0, 1, 0)
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
            toggleDot.Position = isOn and UDim2.new(0, 25, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            toggleDot.BackgroundColor3 = isOn and Color3.fromRGB(255,255,255) or Color3.fromRGB(100,100,110)
        end
    end)
    
    toggleBg.BackgroundColor3 = isOn and Colors.Primary or Colors.Border
    toggleBg.BackgroundTransparency = isOn and 0.2 or 0.5
    toggleDot.Position = isOn and UDim2.new(0, 25, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    toggleDot.BackgroundColor3 = isOn and Color3.fromRGB(255,255,255) or Color3.fromRGB(100,100,110)
    
    return frame
end

local function createSlider(parent, yPos, labelText, minVal, maxVal, defaultVal)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 36)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Text = labelText
    label.TextColor3 = Colors.Text
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.15, 0, 1, 0)
    valueLabel.Position = UDim2.new(0.55, 0, 0, 0)
    valueLabel.Text = tostring(defaultVal)
    valueLabel.TextColor3 = Colors.Primary
    valueLabel.TextScaled = true
    valueLabel.TextXAlignment = Enum.TextXAlignment.Center
    valueLabel.BackgroundTransparency = 1
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0.3, 0, 0.3, 0)
    sliderBg.Position = UDim2.new(0.72, 0, 0.35, 0)
    sliderBg.BackgroundColor3 = Colors.Border
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.BackgroundColor3 = Colors.Primary
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    local currentVal = defaultVal
    local dragging = false
    
    local function updateSlider(input)
        local pos = input.Position.X - sliderBg.AbsolutePosition.X
        local width = sliderBg.AbsoluteSize.X
        local percent = math.clamp(pos / width, 0, 1)
        local val = math.round(minVal + percent * (maxVal - minVal))
        currentVal = val
        valueLabel.Text = tostring(val)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
    end
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    return frame
end

local function createButton(parent, yPos, text, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.3, 0, 0, 32)
    btn.Position = UDim2.new(0.35, 0, 0, yPos)
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
    title.Size = UDim2.new(1, -20, 0, 40)
    title.Position = UDim2.new(0, 10, 0, contentY)
    title.TextColor3 = Colors.TextBright
    title.TextScaled = true
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Parent = ContentContainer
    
    if key == "esp_all" then
        title.Text = "👁️ 全屏透视"
        contentY = contentY + 50
        createToggle(ContentContainer, contentY, "启用全屏透视", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "透视所有实体", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "透视所有道具", true)
        contentY = contentY + 38
        createSlider(ContentContainer, contentY, "全局透视距离", 10, 80, 40)
        contentY = contentY + 42
        createButton(ContentContainer, contentY, "🔄 刷新透视", Colors.Primary)
        
    elseif key == "esp_ghost" then
        title.Text = "👻 鬼魂透视"
        contentY = contentY + 50
        
        -- ★★★ 只保留名字标签相关选项 ★★★
        createToggle(ContentContainer, contentY, "显示鬼魂名字", true)
        contentY = contentY + 38
        
        -- 名字颜色选择（用开关代替）
        createToggle(ContentContainer, contentY, "名字颜色: 红色", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "名字颜色: 紫色", false)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "名字颜色: 青色", false)
        contentY = contentY + 38
        
        createSlider(ContentContainer, contentY, "名字大小", 10, 40, 20)
        contentY = contentY + 42
        createSlider(ContentContainer, contentY, "显示距离", 10, 50, 25)
        contentY = contentY + 42
        
        createToggle(ContentContainer, contentY, "显示距离数值", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "狩猎时闪烁", true)
        contentY = contentY + 38
        
        createButton(ContentContainer, contentY, "🔍 刷新鬼魂位置", Colors.Primary)
        
    elseif key == "esp_evidence" then
        title.Text = "📋 证据透视"
        contentY = contentY + 50
        createToggle(ContentContainer, contentY, "显示EMF位置", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "显示通灵板", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "显示笔迹本", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "显示DOTS投影", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "显示温度计", true)
        contentY = contentY + 38
        createSlider(ContentContainer, contentY, "证据高亮范围", 10, 40, 20)
        
    elseif key == "esp_exit" then
        title.Text = "🚪 出口透视"
        contentY = contentY + 50
        createToggle(ContentContainer, contentY, "显示出口位置", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "显示出口距离", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "紧急出口高亮", true)
        contentY = contentY + 38
        createButton(ContentContainer, contentY, "🧭 导航到出口", Colors.Success)
        
    elseif key == "esp_items" then
        title.Text = "🕯️ 道具透视"
        contentY = contentY + 50
        createToggle(ContentContainer, contentY, "显示十字架", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "显示盐堆", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "显示蜡烛", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "显示相机", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "显示所有可用道具", true)
        contentY = contentY + 38
        createSlider(ContentContainer, contentY, "道具拾取距离", 5, 30, 15)
        
    elseif key == "esp_hunt" then
        title.Text = "⚡ 狩猎预警"
        contentY = contentY + 50
        createToggle(ContentContainer, contentY, "狩猎状态监控", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "鬼魂接近预警", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "狩猎倒计时显示", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "屏幕边缘警告", true)
        contentY = contentY + 38
        createSlider(ContentContainer, contentY, "预警触发距离", 5, 30, 15)
        contentY = contentY + 42
        createButton(ContentContainer, contentY, "🛡️ 立即躲藏", Colors.Danger)
        
    elseif key == "esp_settings" then
        title.Text = "⚙️ 透视设置"
        contentY = contentY + 50
        createToggle(ContentContainer, contentY, "透明墙模式", false)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "显示距离数值", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "显示方框边框", true)
        contentY = contentY + 38
        createToggle(ContentContainer, contentY, "显示生命条", false)
        contentY = contentY + 38
        createSlider(ContentContainer, contentY, "边框透明度", 10, 100, 60)
        contentY = contentY + 42
        createButton(ContentContainer, contentY, "🔄 重置透视配置", Colors.Warning)
        contentY = contentY + 38
        createButton(ContentContainer, contentY, "❌ 关闭所有透视", Colors.Danger)
    end
    
    ContentContainer.Size = UDim2.new(1, 0, 0, contentY + 30)
    ContentPanel.CanvasSize = UDim2.new(0, 0, 0, contentY + 30)
end

-- ============================================================
--  创建侧边栏按钮
-- ============================================================
local yPos = 10
for _, cat in ipairs(Categories) do
    local btn, ind = createSidebarButton(yPos, cat.Icon, cat.Name, cat.Key)
    SidebarButtons[cat.Key] = {Button = btn, Indicator = ind}
    yPos = yPos + 45
end

switchCategory("esp_all")

-- ============================================================
--  底部作者信息
-- ============================================================
local Footer = Instance.new("Frame")
Footer.Size = UDim2.new(1, 0, 0, 30)
Footer.Position = UDim2.new(0, 0, 1, -30)
Footer.BackgroundColor3 = Colors.BgDark
Footer.BackgroundTransparency = 0.5
Footer.BorderSizePixel = 0
Footer.Parent = MainFrame

local FooterLabel = Instance.new("TextLabel")
FooterLabel.Size = UDim2.new(1, 0, 1, 0)
FooterLabel.Text = "Created by zy · 恶魔学透视 HUB v2.0"
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

print("=" .. string.rep("=", 50))
print("  👻 恶魔学 · 鬼魂仅名字透视UI 已加载")
print("  📌 快捷键: Ctrl+H 切换界面")
print("  📌 鬼魂透视分类只显示名字标签相关选项")
print("=" .. string.rep("=", 50))