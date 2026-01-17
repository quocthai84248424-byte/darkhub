-- [[ DARK HUB V6.3 - FULL FEATURES & FIXED ]]
repeat task.wait() until game:IsLoaded()

local function LoadUI()
    local success, result = pcall(function()
        return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    end)
    return success and result or nil
end

local Rayfield = LoadUI()
if not Rayfield then task.wait(2); Rayfield = LoadUI() end
if not Rayfield then return end

-- [[ SECURITY & ANTI-BAN (BẢN GỐC) ]]
local g = game; local lp = g.Players.LocalPlayer; local run = g:GetService("RunService")
task.spawn(function()
    local mt = getrawmetatable(g); setreadonly(mt, false); local oldIdx = mt.__index
    mt.__index = newcclosure(function(t, k)
        if not checkcaller() then
            if k == "WalkSpeed" then return 16 end
            if k == "JumpPower" then return 50 end
        end
        return oldIdx(t, k)
    end)
    setreadonly(mt, true)
end)

local Window = Rayfield:CreateWindow({
    Name = "DARK HUB | Dead Rali V6.3",
    LoadingTitle = "Đang khởi tạo hệ thống...",
    KeySystem = false 
})

-- [[ TẠO CÁC TAB ]]
local MainTab = Window:CreateTab("Main", 4483362458)
local ESPTab = Window:CreateTab("ESP Visuals", 4483362458)
local PlayerTab = Window:CreateTab("Player", 12128784110)
local AutoTab = Window:CreateTab("Auto Farm", 4483362458)
local SettingTab = Window:CreateTab("Settings", 4483362458)

local function ApplyESP(obj, color)
    if obj and not obj:FindFirstChild("DH_Highlight") then
        local h = Instance.new("Highlight", obj)
        h.Name = "DH_Highlight"; h.FillColor = color; h.OutlineColor = Color3.new(1,1,1)
        h.FillTransparency = 0.5; h.DepthMode = "AlwaysOnTop"
    end
end

-- [[ TAB MAIN: COMBAT & SELECTIVE BRING ]]
MainTab:CreateSection("Combat")
local ar = 50
MainTab:CreateSlider({Name = "Kill Aura Range", Range = {0, 100}, Increment = 1, CurrentValue = 50, Callback = function(v) ar = v end})
MainTab:CreateToggle({Name = "Kill Aura", CurrentValue = false, Callback = function(v) _G.KA = v end})

MainTab:CreateSection("Bring Items")
local selectedItem = "All"
MainTab:CreateDropdown({
    Name = "Chọn loại đồ để hút",
    Options = {"All", "Food", "Medical", "Ammo", "Weapon"},
    CurrentOption = "All",
    Callback = function(v) selectedItem = v end
})
MainTab:CreateButton({
    Name = "Hút Vật Phẩm Đã Chọn",
    Callback = function()
        for _, item in pairs(workspace:GetDescendants()) do
            if item:IsA("TouchTransmitter") then
                local itemName = item.Parent.Name:lower()
                local shouldBring = (selectedItem == "All") or 
                                   (selectedItem == "Food" and (itemName:find("food") or itemName:find("water"))) or
                                   (selectedItem == "Medical" and (itemName:find("med") or itemName:find("bandage"))) or
                                   (selectedItem == "Ammo" and itemName:find("ammo")) or
                                   (selectedItem == "Weapon" and (itemName:find("gun") or itemName:find("sword")))
                if shouldBring then
                    firetouchinterest(lp.Character.HumanoidRootPart, item.Parent, 0)
                    firetouchinterest(lp.Character.HumanoidRootPart, item.Parent, 1)
                end
            end
        end
    end
})

-- [[ TAB ESP: PHÂN LOẠI CHI TIẾT ]]
ESPTab:CreateSection("Entities")
local function ESP_Loop(toggle_var, keyword, color)
    while _G[toggle_var] do
        for _, o in pairs(workspace:GetChildren()) do
            if o:FindFirstChild("Humanoid") and o ~= lp.Character then
                if o.Name:lower():find(keyword) then ApplyESP(o, color) end
            end
        end
        task.wait(2)
    end
end
ESPTab:CreateToggle({Name = "ESP Zombie", CurrentValue = false, Callback = function(v) _G.EZ = v; if v then task.spawn(function() ESP_Loop("EZ", "zombie", Color3.new(0,1,0)) end) end end})
ESPTab:CreateToggle({Name = "ESP Ma Sói", CurrentValue = false, Callback = function(v) _G.EW = v; if v then task.spawn(function() ESP_Loop("EW", "werewolf", Color3.fromRGB(139, 69, 19)) end) end end})
ESPTab:CreateToggle({Name = "ESP Ma Cà Rồng", CurrentValue = false, Callback = function(v) _G.EV = v; if v then task.spawn(function() ESP_Loop("EV", "vampire", Color3.new(1,0,0)) end) end end})
ESPTab:CreateToggle({Name = "ESP Boss", CurrentValue = false, Callback = function(v) _G.EB = v; if v then task.spawn(function() ESP_Loop("EB", "boss", Color3.new(1,0,1)) end) end end})

-- [[ TAB PLAYER: BẤT TỬ, TÀNG HÌNH, FLY ]]
PlayerTab:CreateSection("Special Abilities")
PlayerTab:CreateToggle({Name = "Bất Tử (God Mode)", CurrentValue = false, Callback = function(v) _G.God = v; task.spawn(function() while _G.God do pcall(function() lp.Character.Humanoid.Health = 100 end) task.wait(0.1) end end) end})
PlayerTab:CreateToggle({Name = "Tàng Hình (Invisible)", CurrentValue = false, Callback = function(v) pcall(function() for _, p in pairs(lp.Character:GetDescendants()) do if p:IsA("BasePart") or p:IsA("Decal") then p.Transparency = (v and 1 or 0) end end end) end})

PlayerTab:CreateSection("Movement")
PlayerTab:CreateSlider({Name = "WalkSpeed", Range = {16, 200}, Increment = 1, CurrentValue = 16, Callback = function(v) lp.Character.Humanoid.WalkSpeed = v end})

_G.FlySpeed = 50
PlayerTab:CreateToggle({
    Name = "Fly Mode (Bay)",
    CurrentValue = false,
    Callback = function(v)
        _G.Flying = v
        local c = lp.Character
        if v then
            local bv = Instance.new("BodyVelocity", c.HumanoidRootPart); bv.Name = "DHFly_V"; bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            local bg = Instance.new("BodyGyro", c.HumanoidRootPart); bg.Name = "DHFly_G"; bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            task.spawn(function()
                while _G.Flying do
                    local cam = workspace.CurrentCamera.CFrame; local dir = Vector3.new(0,0,0); local UIS = g:GetService("UserInputService")
                    if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.RightVector end
                    bv.Velocity = dir * _G.FlySpeed; bg.CFrame = cam; task.wait()
                end
                if c.HumanoidRootPart:FindFirstChild("DHFly_V") then c.HumanoidRootPart.DHFly_V:Destroy() end
                if c.HumanoidRootPart:FindFirstChild("DHFly_G") then c.HumanoidRootPart.DHFly_G:Destroy() end
            end)
        end
    end
})

-- [[ TAB AUTO FARM: SMART MONEY FARM ]]
AutoTab:CreateSection("Farming")
AutoTab:CreateToggle({
    Name = "Auto Farm Tiền (Gom xác & Tự tìm bàn bán)",
    CurrentValue = false,
    Callback = function(v)
        _G.AutoMoney = v
        task.spawn(function()
            while _G.AutoMoney do
                local foundItem = false
                pcall(function()
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if _G.AutoMoney and (obj.Name:lower():find("corpse") or obj.Name:lower():find("money")) then
                            foundItem = true
                            lp.Character.HumanoidRootPart.CFrame = (obj:IsA("Model") and obj:GetModelCFrame() or obj.CFrame)
                            task.wait(0.5)
                        end
                    end
                    if foundItem then
                        local sellTarget = nil
                        for _, s in pairs(workspace:GetDescendants()) do
                            local n = s.Name:lower()
                            if n:find("sell") or n:find("trader") or (n:find("table") and s:FindFirstChild("ClickDetector")) then
                                sellTarget = s; break
                            end
                        end
                        if sellTarget then
                            lp.Character.HumanoidRootPart.CFrame = (sellTarget:IsA("Model") and sellTarget:GetModelCFrame() or sellTarget.CFrame)
                            task.wait(1.2)
                            if sellTarget:FindFirstChild("ClickDetector") then fireclickdetector(sellTarget.ClickDetector) end
                        end
                    end
                end)
                task.wait(1.5)
            end
        end)
    end
})

-- [[ TAB SETTINGS: FPS & WHITE PART ]]
SettingTab:CreateSection("Performance")
SettingTab:CreateButton({Name = "🚀 FPS Boost", Callback = function() g:GetService("Lighting").GlobalShadows = false; for _, v in pairs(g:GetDescendants()) do if v:IsA("Part") then v.Material = Enum.Material.SmoothPlastic end end end})
SettingTab:CreateToggle({Name = "White Part Mode", CurrentValue = false, Callback = function(v) _G.WP = v; while _G.WP do for _, obj in pairs(workspace:GetDescendants()) do if obj:IsA("BasePart") and not (obj.Parent:FindFirstChild("Humanoid") or obj:FindFirstChild("ClickDetector")) then obj.Color = Color3.new(1,1,1) end end task.wait(5) end end})

SettingTab:CreateSection("System")
SettingTab:CreateButton({Name = "❌ Hủy Script", Callback = function() _G.KA = false; _G.EZ = false; _G.God = false; Rayfield:Destroy() end})

Rayfield:Notify({Title = "DARK HUB", Content = "Bản FULL V6.3 đã sẵn sàng!", Duration = 5})
