-- [[ 1. KHỞI CHẠY AN TOÀN ]]
if not game:IsLoaded() then game.Loaded:Wait() end
local g = game; local lp = g.Players.LocalPlayer; local core = g:GetService("CoreGui"); local run = g:GetService("RunService")

-- [[ 2. SECURITY & ANTI-BAN (Logic gốc của bạn) ]]
task.spawn(function()
    local mt = getrawmetatable(g); setreadonly(mt, false); local oldIdx = mt.__index; local oldNc = mt.__namecall
    mt.__index = newcclosure(function(t, k)
        if not checkcaller() then
            if k == "WalkSpeed" then return 16 end
            if k == "JumpPower" then return 50 end
        end
        return oldIdx(t, k)
    end)
    mt.__namecall = newcclosure(function(self, ...)
        local m = getnamecallmethod()
        if not checkcaller() then
            if m == "Kick" or m == "kick" then return nil end
            if m == "FireServer" and (tostring(self):find("Log") or tostring(self):find("Ban")) then return nil end
        end
        return oldNc(self, ...)
    end)
    setreadonly(mt, true)
end)

-- [[ 3. KHỞI TẠO UI (Đã gỡ bỏ Key System hoàn toàn) ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "DARK HUB | by ilovedog",
    LoadingTitle = "Dead Rali System",
    LoadingSubtitle = "by ilovedog",
    KeySystem = false 
})

-- [[ CÁC TAB CHI TIẾT ]]
local MainTab = Window:CreateTab("Combat", 4483362458)
local ESPTab = Window:CreateTab("ESP Visuals", 4483362458)
local PlayerTab = Window:CreateTab("Player", 12128784110)
local AutoTab = Window:CreateTab("Auto Farm", 4483362458)
local SettingTab = Window:CreateTab("Settings", 4483362458)

-- Hàm ESP chuẩn
local function ApplyESP(obj, color)
    if obj and not obj:FindFirstChild("DH_Highlight") then
        local h = Instance.new("Highlight", obj)
        h.Name = "DH_Highlight"; h.FillColor = color; h.OutlineColor = Color3.fromRGB(255, 255, 255)
        h.FillTransparency = 0.5; h.OutlineTransparency = 0; h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
end

-- [[ TAB COMBAT ]]
MainTab:CreateSection("Kill Aura")
local ar = 50
MainTab:CreateSlider({
    Name = "Kill Aura Range",
    Range = {0, 100}, Increment = 1, Suffix = " studs", CurrentValue = 50,
    Callback = function(v) ar = v end
})
MainTab:CreateToggle({
    Name = "Enable Kill Aura",
    CurrentValue = false,
    Callback = function(v) _G.KA = v end
})

-- [[ TAB ESP VISUALS (Phân loại cực chi tiết) ]]
ESPTab:CreateSection("Players & Items")
ESPTab:CreateToggle({
    Name = "ESP Bạn Bè (Friend)",
    CurrentValue = false,
    Callback = function(v)
        _G.ESPFriend = v
        while _G.ESPFriend do
            for _, p in pairs(g.Players:GetPlayers()) do
                if p ~= lp and lp:IsFriendsWith(p.UserId) and p.Character then ApplyESP(p.Character, Color3.fromRGB(0, 255, 255)) end
            end
            task.wait(2)
        end
    end
})
ESPTab:CreateToggle({
    Name = "ESP Vật Phẩm (Items)",
    CurrentValue = false,
    Callback = function(v)
        _G.ESPItems = v
        while _G.ESPItems do
            for _, i in pairs(workspace:GetDescendants()) do
                if i:IsA("TouchTransmitter") then ApplyESP(i.Parent, Color3.fromRGB(255, 255, 0)) end
            end
            task.wait(3)
        end
    end
})

ESPTab:CreateSection("Entities")
local function ESP_Loop(toggle_var, keyword, color)
    while _G[toggle_var] do
        for _, o in pairs(workspace:GetChildren()) do
            if o:FindFirstChild("Humanoid") and o ~= lp.Character then
                local n = o.Name:lower()
                if n:find(keyword) then ApplyESP(o, color) end
            end
        end
        task.wait(2)
    end
end

ESPTab:CreateToggle({Name = "ESP Zombie", CurrentValue = false, Callback = function(v) _G.ESPZ = v; if v then task.spawn(function() ESP_Loop("ESPZ", "zombie", Color3.fromRGB(0, 255, 0)) end) end end})
ESPTab:CreateToggle({Name = "ESP Ma Sói (Werewolf)", CurrentValue = false, Callback = function(v) _G.ESPW = v; if v then task.spawn(function() ESP_Loop("ESPW", "werewolf", Color3.fromRGB(139, 69, 19)) end) end end})
ESPTab:CreateToggle({Name = "ESP Ma Cà Rồng (Vampire)", CurrentValue = false, Callback = function(v) _G.ESPV = v; if v then task.spawn(function() ESP_Loop("ESPV", "vampire", Color3.fromRGB(255, 0, 0)) end) end end})
ESPTab:CreateToggle({Name = "ESP Boss", CurrentValue = false, Callback = function(v) _G.ESPB = v; if v then task.spawn(function() ESP_Loop("ESPB", "boss", Color3.fromRGB(255, 0, 255)) end) end end})
ESPTab:CreateToggle({Name = "ESP Soldier (Cầm vũ khí)", CurrentValue = false, Callback = function(v)
    _G.SE = v
    while _G.SE do
        for _, s in pairs(workspace:GetChildren()) do
            if s:FindFirstChild("Humanoid") and s ~= lp.Character then
                if s:FindFirstChildOfClass("Tool") or s.Name:lower():find("soldier") then ApplyESP(s, Color3.fromRGB(255, 165, 0)) end
            end
        end
        task.wait(2)
    end
end})

-- [[ TAB PLAYER (Movement & Abilities) ]]
PlayerTab:CreateSection("Abilities")
PlayerTab:CreateToggle({
    Name = "Bất Tử (God Mode)",
    CurrentValue = false,
    Callback = function(v)
        _G.God = v
        while _G.God do pcall(function() lp.Character.Humanoid.Health = lp.Character.Humanoid.MaxHealth end) task.wait(0.1) end
    end
})
PlayerTab:CreateToggle({
    Name = "Tàng Hình (Invisible)",
    CurrentValue = false,
    Callback = function(v)
        for _, p in pairs(lp.Character:GetDescendants()) do
            if p:IsA("BasePart") or p:IsA("Decal") then p.Transparency = (v and 1 or 0) end
        end
    end
})

PlayerTab:CreateSection("Movement")
_G.SpeedValue = 16
PlayerTab:CreateInput({Name = "WalkSpeed", PlaceholderText = "Number...", Callback = function(t) _G.SpeedValue = tonumber(t) or 16 end})
PlayerTab:CreateToggle({
    Name = "Enable Speed",
    CurrentValue = false,
    Callback = function(v)
        _G.SpeedEnabled = v
        while _G.SpeedEnabled do pcall(function() lp.Character.Humanoid.WalkSpeed = _G.SpeedValue end) task.wait(0.1) end
        lp.Character.Humanoid.WalkSpeed = 16
    end
})

_G.FlySpeed = 50
PlayerTab:CreateInput({Name = "Fly Speed", PlaceholderText = "Number...", Callback = function(t) _G.FlySpeed = tonumber(t) or 50 end})
PlayerTab:CreateToggle({
    Name = "Fly Mode",
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

-- [[ TAB AUTO FARM & ITEMS ]]
AutoTab:CreateSection("Items")
AutoTab:CreateButton({
    Name = "Bring All Items (Hút vật phẩm)",
    Callback = function()
        for _, item in pairs(workspace:GetDescendants()) do
            if item:IsA("TouchTransmitter") then
                firetouchinterest(lp.Character.HumanoidRootPart, item.Parent, 0)
                firetouchinterest(lp.Character.HumanoidRootPart, item.Parent, 1)
            end
        end
    end
})

AutoTab:CreateToggle({
    Name = "Auto Loot Money (Corpse)",
    CurrentValue = false,
    Callback = function(v)
        _G.LootMoney = v
        while _G.LootMoney do
            for _, obj in pairs(workspace:GetDescendants()) do
                if _G.LootMoney and (obj.Name:lower():find("corpse") or obj.Name:lower():find("money")) then
                    lp.Character.HumanoidRootPart.CFrame = (obj:IsA("Model") and obj:GetModelCFrame() or obj.CFrame)
                    task.wait(0.5)
                end
            end
            task.wait(1)
        end
    end
})

AutoTab:CreateToggle({Name = "Auto Farm Bond", CurrentValue = false, Callback = function(v) _G.FB = v; while _G.FB do for _, b in pairs(workspace:GetDescendants()) do if b.Name:find("Bond") and _G.FB then lp.Character.HumanoidRootPart.CFrame = b.CFrame task.wait(0.5) end end task.wait(1) end end})

-- [[ TAB SETTINGS (Performance & System) ]]
SettingTab:CreateSection("Performance")
SettingTab:CreateButton({
    Name = "🚀 FPS Boost (Giảm lag cực mạnh)",
    Callback = function()
        g:GetService("Lighting").GlobalShadows = false
        for _, v in pairs(g:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") then v.Material = Enum.Material.SmoothPlastic v.Reflectance = 0
            elseif v:IsA("Decal") then v:Destroy() end
        end
    end
})
SettingTab:CreateToggle({
   Name = "White Part Mode",
   CurrentValue = false,
   Callback = function(v)
      _G.WhitePart = v
      while _G.WhitePart do
         for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not (obj.Parent:FindFirstChild("Humanoid") or obj:FindFirstChild("ClickDetector")) then
               obj.Color = Color3.fromRGB(255, 255, 255)
            end
         end
         task.wait(5)
      end
   end
})

SettingTab:CreateSection("System")
SettingTab:CreateButton({
    Name = "❌ Hủy Script (Destroy)",
    Callback = function()
        _G.KA = false; _G.ZE = false; _G.SE = false; _G.Flying = false; _G.SpeedEnabled = false; 
        _G.LootMoney = false; _G.FB = false; _G.WhitePart = false; _G.God = false
        Rayfield:Notify({Title = "DARK HUB", Content = "Đang tắt hệ thống...", Duration = 3})
        task.wait(1)
        Rayfield:Destroy()
    end
})

Rayfield:Notify({Title = "DARK HUB", Content = "Bản ULTIMATE v3 đã sẵn sàng!", Duration = 5})
