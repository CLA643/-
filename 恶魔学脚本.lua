-- ============================================================
--  《恶魔学》V1.0
--  功能：自动通灵板 | 自动拍照 | 智能躲藏 | 证据ESP | 鬼魂识别
--  作者：zy
-- ============================================================

local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera

-- ============================================================
--  一、全局配置（用户可自定义）
-- ============================================================
local CONFIG = {
    -- 自动通灵板
    AutoOuija = true,           -- 是否启用
    OuijaDelay = 0.3,           -- 字母点击间隔
    
    -- 自动拍照
    AutoPhoto = true,           -- 是否启用
    PhotoCooldown = 3,          -- 拍照冷却（秒）
    PhotoFOV = 60,              -- 视野角度
    PhotoRange = 20,            -- 检测范围
    
    -- 智能躲藏
    AutoHide = true,            -- 是否启用
    HideDistance = 1.5,         -- 到达判定距离
    RunSpeed = 0.3,            -- 跑步速度（Tween时间）
    
    -- 证据ESP
    ESPEnabled = true,          -- 是否启用
    ESPRange = 30,              -- 显示范围
    ESPRefreshRate = 0.5,       -- 扫描间隔
    
    -- 鬼魂识别
    AutoIdentify = true,        -- 是否启用
    IdentifyInterval = 10,      -- 识别间隔（秒）
}

-- ============================================================
--  二、工具函数
-- ============================================================
local function getChar()
    return Player.Character
end

local function getRoot()
    local char = getChar()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = getChar()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function distance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

local function tableFind(tbl, val)
    for _, v in pairs(tbl) do
        if v == val then return true end
    end
    return false
end

-- ============================================================
--  三、功能1：自动通灵板
-- ============================================================
local Ouija = {
    Active = false,
    CurrentName = "",
    Typing = false,
}

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

-- ============================================================
--  四、功能2：自动拍照
-- ============================================================
local Photo = {
    Active = false,
    LastTime = 0,
    Camera = nil,
}

function Photo:findCamera()
    local char = getChar()
    local backpack = Player:FindFirstChild("Backpack")
    
    -- 检查手里
    if char then
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("Tool") and (v.Name:lower():find("camera") or v.Name:lower():find("photo") or v.Name:lower():find("polaroid")) then
                return v
            end
        end
    end
    
    -- 检查背包
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
    
    -- 尝试各种触发方式
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

-- ============================================================
--  五、功能3：智能躲藏
-- ============================================================
local Hider = {
    Active = false,
    IsHiding = false,
    CurrentSpot = nil,
    Hunting = false,
}

function Hider:isHunting()
    -- 方法1：全局变量
    if _G.Hunting or _G.IsHunting then return true end
    
    -- 方法2：灯光闪烁
    local lighting = game:GetService("Lighting")
    if lighting and lighting:FindFirstChild("Flicker") and lighting.Flicker.Enabled then
        return true
    end
    
    -- 方法3：鬼魂速度
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
        -- 柜子类
        if v:IsA("Model") and (v.Name:lower():find("closet") or v.Name:lower():find("locker") or 
                               v.Name:lower():find("cabinet") or v.Name:lower():find("wardrobe")) then
            local part = v:FindFirstChildWhichIsA("BasePart")
            if part then
                table.insert(spots, {Object = v, Position = part.Position, Name = v.Name})
            end
        end
        -- 安全区域
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
    
    local tween = TweenService:Create(root, 
        TweenInfo.new(CONFIG.RunSpeed), 
        {CFrame = CFrame.new(pos)}
    )
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
    if #spots == 0 then
        print("⚠️ 没找到藏身处！")
        return
    end
    
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

-- ============================================================
--  六、功能4：证据高亮ESP
-- ============================================================
local ESP = {
    Active = false,
    Elements = {},
    Scanned = {},
    LastScan = 0,
}

-- 证据数据库
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

-- 检查Drawing支持
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
    
    -- 清理已删除的对象
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

-- ============================================================
--  七、功能5：鬼魂识别
-- ============================================================
local Identifier = {
    Active = false,
    LastIdentify = 0,
    Evidence = {EMF5=false, SpiritBox=false, GhostWriting=false, DOTS=false, UV=false},
}

-- 鬼魂数据库（精简版，可扩展）
Identifier.GhostDB = {
    Spirit = {Name="🧊 幽灵", Evidence={"EMF5","SpiritBox","GhostWriting"}},
    Wraith = {Name="👻 怨灵", Evidence={"EMF5","SpiritBox","DOTS"}},
    Phantom = {Name="📸 幻影", Evidence={"SpiritBox","UV","DOTS"}},
    Poltergeist = {Name="💥 骚灵", Evidence={"SpiritBox","GhostWriting","UV"}},
    Banshee = {Name="🎵 女妖", Evidence={"EMF5","UV","DOTS"}},
    Demon = {Name="👿 恶魔", Evidence={"SpiritBox","GhostWriting","UV"}},
    Jinn = {Name="⚡ 巨灵", Evidence={"EMF5","GhostWriting","DOTS"}},
    Mare = {Name="🌙 梦魇", Evidence={"SpiritBox","GhostWriting","DOTS"}},
    Revenant = {Name="💀 亡魂", Evidence={"EMF5","GhostWriting","UV"}},
    Shade = {Name="🌑 暗影", Evidence={"EMF5","GhostWriting","SpiritBox"}},
    Yurei = {Name="🌸 幽霊", Evidence={"EMF5","DOTS","GhostWriting"}},
    Oni = {Name="👹 鬼", Evidence={"EMF5","SpiritBox","DOTS"}},
    Yokai = {Name="🗣️ 妖怪", Evidence={"SpiritBox","GhostWriting","DOTS"}},
    Hantu = {Name="❄️ 寒冰", Evidence={"EMF5","UV","GhostWriting"}},
    Goryo = {Name="👁️ 御灵", Evidence={"EMF5","SpiritBox","DOTS"}},
    Myling = {Name="🔇 静音", Evidence={"EMF5","UV","GhostWriting"}},
    Onryo = {Name="🕯️ 怨灵", Evidence={"SpiritBox","UV","GhostWriting"}},
    Twins = {Name="👯 双子", Evidence={"EMF5","SpiritBox","DOTS"}},
    Raiju = {Name="⚡ 雷兽", Evidence={"EMF5","GhostWriting","DOTS"}},
    Obake = {Name="🔄 妖怪", Evidence={"EMF5","UV","GhostWriting"}},
    Moroi = {Name="🧛 亡魂", Evidence={"SpiritBox","UV","GhostWriting"}},
    Deogen = {Name="👀 死根", Evidence={"SpiritBox","UV","DOTS"}},
    Thaye = {Name="📈 泰耶", Evidence={"EMF5","GhostWriting","DOTS"}},
}

function Identifier:collect()
    -- EMF
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
        print("🕵️ 鬼魂识别:", best.Data.Name, 
              "| 证据:", best.Score .. "/" .. #best.Data.Evidence,
              "| 已收集:", table.concat(evList, ", "))
        
        -- 如果识别到鬼魂，自动触发通灵板输入
        if CONFIG.AutoOuija and not Ouija.Typing then
            Ouija:typeName(best.Key)
        end
    end
end

-- ============================================================
--  八、主循环（所有功能统一调度）
-- ============================================================
local MainLoop = {
    Running = true,
}

function MainLoop:start()
    print("=" .. string.rep("=", 50))
    print("  《恶魔学》 V1.0 已启动")
    print("  功能: 通灵板 | 拍照 | 躲藏 | ESP | 识别")
    print("=" .. string.rep("=", 50))
    
    RunService.Heartbeat:Connect(function()
        if not self.Running then return end
        
        local now = tick()
        
        -- ===== 功能1：自动通灵板 =====
        -- 由鬼魂识别触发，不需要循环
        
        -- ===== 功能2：自动拍照 =====
        if CONFIG.AutoPhoto and now - Photo.LastTime > CONFIG.PhotoCooldown then
            if Photo:isGhostInView() then
                Photo:take()
            end
        end
        
        -- ===== 功能3：智能躲藏 =====
        if CONFIG.AutoHide then
            local hunting = Hider:isHunting()
            if hunting and not Hider.IsHiding then
                Hider:hide()
            elseif not hunting and Hider.IsHiding then
                Hider:exit()
            end
        end
        
        -- ===== 功能4：证据ESP =====
        ESP:scan()
        ESP:render()
        
        -- ===== 功能5：鬼魂识别 =====
        Identifier:identify()
    end)
    
    print("✅ 所有功能已加载完成！")
    print("📌 输入 _G.ToggleAll() 切换全部功能")
    print("📌 输入 _G.ShowMenu() 显示控制菜单")
end

-- ============================================================
--  九、控制菜单
-- ============================================================
function _G.ShowMenu()
    print("")
    print("╔══════════════════════════════════════╗")
    print("║  《恶魔学》控制菜单              ║")
    print("╠══════════════════════════════════════╣")
    print("║  1. 切换全部功能  : _G.ToggleAll()   ║")
    print("║  2. 手动识别鬼魂  : _G.Identify()    ║")
    print("║  3. 手动输入鬼名  : _G.TypeName()    ║")
    print("║  4. 手动拍照      : _G.TakePhoto()   ║")
    print("║  5. 手动躲藏      : _G.HideNow()     ║")
    print("║  6. 切换ESP       : _G.ToggleESP()   ║")
    print("╚══════════════════════════════════════╝")
    print("")
end

-- 切换全部功能
function _G.ToggleAll()
    MainLoop.Running = not MainLoop.Running
    print(MainLoop.Running and "✅ 全部功能已开启" or "❌ 全部功能已关闭")
end

-- 手动识别
function _G.Identify()
    Identifier:identify()
end

-- 手动输入鬼名
function _G.TypeName(name)
    if not name then
        print("⚠️ 用法: _G.TypeName('鬼名')")
        return
    end
    Ouija:typeName(name)
end

-- 手动拍照
function _G.TakePhoto()
    Photo:take()
end

-- 手动躲藏
function _G.HideNow()
    Hider:hide()
end

-- 手动退出躲藏
function _G.ExitHide()
    Hider:exit()
end

-- 切换ESP
function _G.ToggleESP()
    CONFIG.ESPEnabled = not CONFIG.ESPEnabled
    print(CONFIG.ESPEnabled and "👁️ ESP 已开启" or "👁️ ESP 已关闭")
end

-- 显示配置
function _G.ShowConfig()
    print("📋 当前配置:")
    for k, v in pairs(CONFIG) do
        print("  " .. k .. " = " .. tostring(v))
    end
end

-- ============================================================
--  十、启动
-- ============================================================
MainLoop:start()
_G.ShowMenu()

-- 自动关闭之前可能存在的UI
if _G.ResultUI then
    _G.ResultUI:Destroy()
    _G.ResultUI = nil
end

print("🎯 提示：可以在脚本开头修改 CONFIG 配置")