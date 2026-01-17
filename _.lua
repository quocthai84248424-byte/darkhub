--[[
    DARK HUB - DEAD RAIL ULTIMATE
    Author: ilovedog
    Key: T_H_R_E_N_5_@
    Discord: https://discord.gg/HfVYnr8z
]]

-- Tự động copy link Discord ngay khi chạy script
local discordLink = "https://discord.gg/HfVYnr8z"
if setclipboard then
    setclipboard(discordLink)
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

-- Variables
local Config = {
    AutoFarm = false,
    FarmSpeed = 150,
    Noclip = false,
    ServerHop = false,
    AntiBan = true
}

-- [NOCLIP LOGIC]
RunService.Stepped:Connect(function()
    if Config.Noclip then
        local char = Players.LocalPlayer.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end
end)

-- [SERVER HOP LOGIC]
local function doServerHop()
    local success, servers = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100")).data
    end)
    if success then
        for _, v in pairs(servers) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id)
                break
            end
        end
    end
end

-- [FARM LOGIC]
local function startUltraFarm()
    task.spawn(function()
        while Config.AutoFarm do
            task.wait(0.1)
            local char = Players.LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then continue end

            local target = nil
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "Bond" or v.Name == "BondNote" or v.Name == "BondItem" then
                    target = v:IsA("BasePart") and v or v:FindFirstChildWhichIsA("BasePart")
                    if target then break end
                end
            end

            if target then
                local dist = (root.Position - target.Position).Magnitude
                local tween = TweenService:Create(root, TweenInfo.new(dist/Config.FarmSpeed, Enum.EasingStyle.Linear), {CFrame = target.CFrame * CFrame.new(0, 2, 0)})
                tween:Play()
                tween.Completed:Wait()
                
                local prompt = target:FindFirstChildOfClass("ProximityPrompt") or target.Parent:FindFirstChildOfClass("ProximityPrompt")
                if prompt then fireproximityprompt(prompt) end
            elseif Config.ServerHop then
                doServerHop()
                break
            end
        end
    end)
end

-- [RAYFIELD WINDOW]
local Window = Rayfield:CreateWindow({
   Name = "Dark Hub | Dead Rail",
   LoadingTitle = "Script by ilovedog",
   LoadingSubtitle = "Link Discord đã được copy!",
   KeySystem = true,
   KeySettings = {
      Title = "Key System",
      Subtitle = "Join Discord to get Key",
      Note = "Link: " .. discordLink .. " (Nhấn để copy lại)",
      FileName = "DarkHubKey", 
      SaveKey = true, 
      GrabKeyFromSite = false,
      Key = {"T_H_R_E_N_5_@"}
   }
})

-- Thông báo sau khi nhập Key thành công
Rayfield:Notify({
    Title = "Dark Hub",
    Content = "Chào mừng ilovedog! Link Discord đã nằm trong Clipboard của bạn.",
    Duration = 5
})

-- Tabs
local FarmTab = Window:CreateTab("Auto Farm")
local SettingTab = Window:CreateTab("Settings")

-- Farm Section
FarmTab:CreateSection("Main Farming")
FarmTab:CreateToggle({
   Name = "Auto Farm Bond",
   CurrentValue = false,
   Callback = function(v)
      Config.AutoFarm = v
      if v then startUltraFarm() end
   end,
})

FarmTab:CreateToggle({
   Name = "Auto Server Hop",
   CurrentValue = false,
   Callback = function(v) Config.ServerHop = v end,
})

-- Settings Section
SettingTab:CreateSection("Movement & Security")
SettingTab:CreateToggle({
   Name = "Noclip (Xuyên tường)",
   CurrentValue = false,
   Callback = function(v) Config.Noclip = v end,
})

SettingTab:CreateSlider({
   Name = "Tween Speed",
   Min = 50, Max = 300, CurrentValue = 150,
   Callback = function(v) Config.FarmSpeed = v end,
})

SettingTab:CreateButton({
   Name = "Copy Discord Link Again",
   Callback = function()
       if setclipboard then
           setclipboard(discordLink)
           Rayfield:Notify({Title = "Success", Content = "Đã copy link Discord!", Duration = 2})
       end
   end,
})

SettingTab:CreateButton({
   Name = "Force Server Hop",
   Callback = function() doServerHop() end,
})

Rayfield:LoadConfiguration()
