local g = game; local lp = g.Players.LocalPlayer; local core = g:GetService("CoreGui")

-- [[ SECURITY ]]
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

-- [[ UI INITIALIZATION ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "DARK HUB | by ilovedog",
    LoadingTitle = "Dead Rali System",
    LoadingSubtitle = "by ilovedog",
    KeySystem = true,
    KeySettings = {
        Title = "DARK HUB | Key System",
        Subtitle = "Key: HACKER_100k",
        FileName = "HACKER_100k",
        SaveKey = true,
        Key = {"HACKER_100k"}
    }
})

-- [[ TABS ]]
local MainTab = Window:CreateTab("Main", 4483362458)
local PlayerTab = Window:CreateTab("Player", "rbxassetid://12128784110")
local AutoTab = Window:CreateTab("Auto Farm", 4483362458)
local SettingTab = Window:CreateTab("Settings", 4483362458)

local function ApplyESP(obj, color)
    if not obj:FindFirstChild("DH_Highlight") then
        local h = Instance.new("Highlight", obj)
        h.Name = "DH_Highlight"; h.FillColor = color; h.OutlineColor = Color3.fromRGB(255, 255, 255)
        h.FillTransparency = 0.5; h.OutlineTransparency = 0; h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
end

-- [[ MAIN TAB ]]
MainTab:CreateSection("Combat")
local ar = 50
MainTab:CreateSlider({
    Name = "Kill Aura Range",
    Range = {0, 100},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 50,
    Callback = function(v) ar = v end
})

MainTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Callback = function(v)
        _G.KA = v
        task.spawn(function()
            while _G.KA do
                pcall(function()
                    for _, e in pairs(workspace:GetChildren()) do
                        if e:FindFirstChild("Humanoid") and e ~= lp.Character then
                            local er = e:FindFirstChild("HumanoidRootPart")
                            if er and (lp.Character.HumanoidRootPart.Position - er.Position).Magnitude <= ar then
                                -- Combat logic here
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
})

MainTab:CreateSection("Visuals")
MainTab:CreateToggle({
    Name = "ESP Zombie (Green)",
    CurrentValue = false,
    Callback = function(v)
        _G.ZE = v
        task.spawn(function()
            while _G.ZE do
                for _, z in pairs(workspace:GetChildren()) do
                    if z:FindFirstChild("Humanoid") and z.Name:lower():find("zombie") then ApplyESP(z, Color3.fromRGB(0, 255, 0)) end
                end
                task.wait(2)
            end
        end)
    end
})

MainTab:CreateToggle({
    Name = "ESP Soldier (Orange)",
    CurrentValue = false,
    Callback = function(v)
        _G.SE = v
        task.spawn(function()
            while _G.SE do
                for _, s in pairs(workspace:GetChildren()) do
                    if s:FindFirstChild("Humanoid") and s ~= lp.Character then
                        local hasWeapon = s:FindFirstChildOfClass("Tool") or s:FindFirstChild("Weapon") or s:FindFirstChild("Gun")
                        if hasWeapon or s.Name:lower():find("soldier") then ApplyESP(s, Color3.fromRGB(255, 165, 0)) end
                    end
                end
                task.wait(2)
            end
        end)
    end
})

-- [[ PLAYER TAB ]]
PlayerTab:CreateSection("Movement")
_G.SpeedValue = 16
PlayerTab:CreateInput({Name = "WalkSpeed", PlaceholderText = "Number...", Callback = function(t) _G.SpeedValue = tonumber(t) or 16 end})
PlayerTab:CreateToggle({
    Name = "Enable Speed",
    CurrentValue = false,
    Callback = function(v)
        _G.SpeedEnabled = v
        task.spawn(function()
            while _G.SpeedEnabled do
                pcall(function() lp.Character.Humanoid.WalkSpeed = _G.SpeedValue end)
                task.wait(0.1)
            end
            lp.Character.Humanoid.WalkSpeed = 16
        end)
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
                    local cam = workspace.CurrentCamera.CFrame; local dir = Vector3.new(0,0,0); local UIS = game:GetService("UserInputService")
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

-- [[ AUTO FARM TAB ]]
AutoTab:CreateSection("Farming")
AutoTab:CreateToggle({
    Name = "Auto Loot Money (Corpse)",
    CurrentValue = false,
    Callback = function(v)
        _G.LootMoney = v
        task.spawn(function()
            while _G.LootMoney do
                for _, obj in pairs(workspace:GetDescendants()) do
                    if _G.LootMoney and (obj.Name:lower():find("corpse") or obj.Name:lower():find("money")) then
                        lp.Character.HumanoidRootPart.CFrame = (obj:IsA("Model") and obj:GetModelCFrame() or obj.CFrame)
                        task.wait(0.5)
                    end
                end
                task.wait(1)
            end
        end)
    end
})

AutoTab:CreateToggle({
    Name = "Auto Farm Bond",
    CurrentValue = false,
    Callback = function(v)
        _G.FB = v
        task.spawn(function()
            while _G.FB do
                for _, b in pairs(workspace:GetDescendants()) do
                    if b.Name:find("Bond") and _G.FB then lp.Character.HumanoidRootPart.CFrame = b.CFrame task.wait(0.5) end
                end
                task.wait(1)
            end
        end)
    end
})

-- [[ SETTINGS TAB ]]
SettingTab:CreateSection("Performance")
SettingTab:CreateToggle({
   Name = "White Part Mode",
   CurrentValue = false,
   Callback = function(v)
      _G.WhitePart = v
      task.spawn(function()
         while _G.WhitePart do
            for _, obj in pairs(workspace:GetDescendants()) do
               if obj:IsA("BasePart") and not (obj.Parent:FindFirstChild("Humanoid") or obj:FindFirstChild("ClickDetector") or obj.Name:find("Bond")) then
                  obj.Color = Color3.fromRGB(255, 255, 255); obj.Material = Enum.Material.SmoothPlastic
               end
            end
            task.wait(5)
         end
      end)
   end
})

SettingTab:CreateSection("System")
SettingTab:CreateButton({
    Name = "❌ [destroy]",
    Callback = function()
        Rayfield:Notify({
            Title = "XÁC NHẬN",
            Content = "Bạn muốn tắt script?",
            Duration = 10,
            Actions = {
                ["Yes"] = {Name = "Yes", Callback = function()
                    _G.KA = false; _G.ZE = false; _G.SE = false; _G.Flying = false; 
                    _G.SpeedEnabled = false; _G.LootMoney = false; _G.FB = false; _G.WhitePart = false
                    Rayfield:Destroy()
                end},
                ["No"] = {Name = "No", Callback = function() end}
            }
        })
    end
})

Rayfield:Notify({Title = "DARK HUB", Content = "Dead Rali Final Loaded!", Duration = 5})
