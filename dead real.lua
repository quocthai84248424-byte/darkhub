-- [[[
--!!!!!!ÂJHSJSJSJSJSJJZJZJ1/1/101/1/101)1//1/#92)/2/2/1/10

local g = game; local lp = g.Players.LocalPlayer; local core = g:GetService("CoreGui"); local run = g:GetService("RunService")

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
        local m = getnamecallmethod(); local a = {...}
        if not checkcaller() then
            if m == "Kick" or m == "kick" then return nil end
            if m == "FireServer" and (tostring(self):find("Log") or tostring(self):find("Ban")) then return nil end
        end
        return oldNc(self, ...)
    end)
    setreadonly(mt, true)
end)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "DARK HUB | by ilovedog",
    LoadingTitle = "System Initializing...",
    LoadingSubtitle = "by ilovedog",
    ConfigurationSaving = { Enabled = false },
    KeySystem = true,
    KeySettings = {
        Title = "DARK HUB | Key System",
        Subtitle = "Join Discord to get your key",
        Note = "Key: HACKER_100k",
        FileName = "HACKER_100k",
        SaveKey = true,
        Key = {"HACKER_100k"}
    }
})

local InfoTab = Window:CreateTab("Info", 4483362458)
local MainTab = Window:CreateTab("Main", 4483362458)
local PlayerTab = Window:CreateTab("Player", "rbxassetid://12128784110")
local AutoTab = Window:CreateTab("Auto Farm", 4483362458)
local SettingTab = Window:CreateTab("Settings", 4483362458)

PlayerTab:CreateSection("Movement Settings")
_G.SpeedValue = 16
PlayerTab:CreateInput({
    Name = "WalkSpeed Amount",
    PlaceholderText = "Input speed...",
    Callback = function(t) _G.SpeedValue = tonumber(t) or 16 end
})

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
PlayerTab:CreateInput({
    Name = "Fly Speed",
    PlaceholderText = "Input fly speed...",
    Callback = function(t) _G.FlySpeed = tonumber(t) or 50 end
})

PlayerTab:CreateToggle({
    Name = "Fly Mode",
    CurrentValue = false,
    Callback = function(v)
        _G.Flying = v
        local c = lp.Character
        if v then
            local bv = Instance.new("BodyVelocity", c.HumanoidRootPart)
            local bg = Instance.new("BodyGyro", c.HumanoidRootPart)
            bv.Name = "DHFly_V"; bv.MaxForce = Vector3.new(1e5, 1e5, 1e5); bv.Velocity = Vector3.new(0,0,0)
            bg.Name = "DHFly_G"; bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5); bg.CFrame = c.HumanoidRootPart.CFrame
            task.spawn(function()
                while _G.Flying do
                    local cam = workspace.CurrentCamera.CFrame
                    local dir = Vector3.new(0,0,0)
                    local UIS = game:GetService("UserInputService")
                    if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.RightVector end
                    bv.Velocity = dir * _G.FlySpeed
                    bg.CFrame = cam
                    task.wait()
                end
                if c.HumanoidRootPart:FindFirstChild("DHFly_V") then c.HumanoidRootPart.DHFly_V:Destroy() end
                if c.HumanoidRootPart:FindFirstChild("DHFly_G") then c.HumanoidRootPart.DHFly_G:Destroy() end
            end)
        end
    end
})

MainTab:CreateSection("Visuals")
MainTab:CreateToggle({
    Name = "ESP Zombie",
    CurrentValue = false,
    Callback = function(v)
        _G.ZE = v
        task.spawn(function()
            while _G.ZE do
                for _, z in pairs(workspace:GetChildren()) do
                    if z:FindFirstChild("Humanoid") and z.Name:lower():find("zombie") then 
                        if not z:FindFirstChild("DH_ESP") then
                            local h = Instance.new("Highlight", z); h.Name = "DH_ESP"
                            h.FillColor = Color3.fromRGB(0, 255, 0)
                        end
                    end
                end
                task.wait(2)
            end
        end)
    end
})

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

Rayfield:Notify({Title = "DARK HUB", Content = "Dead Rali Loaded!", Duration = 5})
