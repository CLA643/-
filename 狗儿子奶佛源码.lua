--奶佛狗儿子圈钱狗Ai神豆包ai是他制作脚本的全部
--lyy在线打压公开源码
--煞笔奶佛窝囊废
local Players_lyyloveWas_8xK2 = game:GetService("Players")
local Workspace_lyyloveWas_mP9q = game:GetService("Workspace")
local LocalPlayer_lyyloveWas_3jR7 = Players_lyyloveWas_8xK2.LocalPlayer

local TAXI_ENABLED_lyyloveWas_5nW1 = true
local MIN_WAIT_lyyloveWas_2vB6 = 3
local MAX_WAIT_lyyloveWas_7cD4 = 12

local function teleportToArea_lyyloveWas_9fH3(area_lyyloveWas_4tY8)
    local char_lyyloveWas_1mN5 = LocalPlayer_lyyloveWas_3jR7.Character
    if not char_lyyloveWas_1mN5 then return end
    local root_lyyloveWas_6kP2 = char_lyyloveWas_1mN5:FindFirstChild("HumanoidRootPart")
    if root_lyyloveWas_6kP2 then
        pcall(function()
            root_lyyloveWas_6kP2.CFrame = area_lyyloveWas_4tY8.CFrame * CFrame.new(0, 0, 5)
        end)
    end
end

local function getTaxiAreas_lyyloveWas_0zX7()
    local areas_lyyloveWas_2hL9 = {}
    local clientContent_lyyloveWas_7uR3 = Workspace_lyyloveWas_mP9q:FindFirstChild("Gameplay") and Workspace_lyyloveWas_mP9q.Gameplay:FindFirstChild("Entities") and Workspace_lyyloveWas_mP9q.Gameplay.Entities:FindFirstChild("ClientContent")
    local searchRoot_lyyloveWas_4jF6 = clientContent_lyyloveWas_7uR3 or Workspace_lyyloveWas_mP9q
    for _, obj_lyyloveWas_3gN8 in ipairs(searchRoot_lyyloveWas_4jF6:GetDescendants()) do
        if obj_lyyloveWas_3gN8.Name == "Area" then
            table.insert(areas_lyyloveWas_2hL9, obj_lyyloveWas_3gN8)
        end
    end
    return areas_lyyloveWas_2hL9
end

local function startTaxiLoop_lyyloveWas_8tE1()
    while TAXI_ENABLED_lyyloveWas_5nW1 do
        local areas_lyyloveWas_2hL9 = getTaxiAreas_lyyloveWas_0zX7()
        if #areas_lyyloveWas_2hL9 == 0 then
            task.wait(5)
        else
            for _, area_lyyloveWas_4tY8 in ipairs(areas_lyyloveWas_2hL9) do
                if not TAXI_ENABLED_lyyloveWas_5nW1 then break end
                teleportToArea_lyyloveWas_9fH3(area_lyyloveWas_4tY8)
                local waitTime_lyyloveWas_6dS0 = MIN_WAIT_lyyloveWas_2vB6 + math.random() * (MAX_WAIT_lyyloveWas_7cD4 - MIN_WAIT_lyyloveWas_2vB6)
                task.wait(waitTime_lyyloveWas_6dS0)
            end
        end
    end
end

task.spawn(startTaxiLoop_lyyloveWas_8tE1)