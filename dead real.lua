
--{~×~×€=$==${%{©==©[©{©{%°€✓€{=$=©=©=101982(3///1/10293)2///29292(2939tlovali2992(2(₫+(₫(*(#(#(#(₫((thucaisjsjjgsshhsbzbzjzjlgenvnslsksjsj/#//#)#(₫("bshsh
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
            if m == "ReportAbuse" or (tostring(self) == "SetCore" and a[1] == "SendNotification") then return nil end
            if m == "FireServer" and (tostring(self):find("Log") or tostring(self):find("Ban")) then return nil end
        end
        return oldNc(self, ...)
    end)
    setreadonly(mt, true)
end)

task.spawn(function()
    _G.SecurityLoop = run.Stepped:Connect(function()
        local s = 0; for _, v in pairs(core:GetChildren()) do 
            if v:IsA("ScreenGui") and v.Name ~= "Rayfield" and v.Name ~= "RobloxGui" and v.Name ~= "Chat" then s = s + 1 end 
        end
        if s > 1 then lp:Kick("DARK HUB Security: Unauthorized execution detected.") end
    end)
end)

setclipboard("https://discord.gg/8VaXJ77d")

local Rayfield
local success = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success or not Rayfield then
    warn("FAILED")
    return
end

local Window = Rayfield:CreateWindow({
   Name = "DARK HUB | by ilovedog",
   LoadingTitle = "System Initializing...",
   LoadingSubtitle = "by ilovedog",
   ConfigurationSaving = { Enabled = false },
   KeySystem = true,
   KeySettings = {
      Title = "DARK HUB | Key System",
      Subtitle = "Join Discord to get your key",
      Note = "Access Key Required!",
      FileName = "DarkHubKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"DARKHUB_TOP1"},
      Actions = {
            [1] = {
                Text = "Get Key (Discord Link)",
                OnPress = function()
                    setclipboard("https://discord.gg/8VaXJ77d")
                end,
            }
        }
   }
})

local InfoTab = Window:CreateTab("Info", 4483362458)
local MainTab = Window:CreateTab("Main", 4483362458)
local AutoTab = Window:CreateTab("Auto Farm", 4483362458)
local SettingTab = Window:CreateTab("Settings", 4483362458)

InfoTab:CreateSection("Server Information")
InfoTab:CreateButton({
   Name = "Copy Discord Link",
   Callback = function()
      setclipboard("https://discord.gg/8VaXJ77d")
      Rayfield:Notify({Title = "DARK HUB", Content = "Discord link copied!", Duration = 3})
   end,
})

InfoTab:CreateButton({
   Name = "Random Server",
   Callback = function()
      local ts = g:GetService("TeleportService"); local hs = g:GetService("HttpService")
      local svs = hs:JSONDecode(g:HttpGet("https://games.roblox.com/v1/games/"..g.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
      for _, v in pairs(svs) do if v.playing < v.maxPlayers then ts:TeleportToPlaceInstance(g.PlaceId, v.id) break end end
   end,
})

MainTab:CreateSection("Combat System")
local ar = 0
MainTab:CreateSlider({
   Name = "Kill Aura Range",
   Range = {0, 100},
   Increment = 1,
   Suffix = " studs",
   CurrentValue = 0,
   Callback = function(v) ar = v end,
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
                        -- Combat logic
                     end
                  end
               end
            end)
            task.wait(0.1)
         end
      end)
   end,
})

MainTab:CreateSection("Item Management")
local ti = ""; local am = 1
MainTab:CreateDropdown({
   Name = "Select Item",
   Options = {"Wood", "Scrap", "Engine Part", "Fuel", "First Aid", "Ammo", "Metal", "Bond"},
   CurrentOption = "",
   Callback = function(o) ti = o end,
})

MainTab:CreateInput({
   Name = "Item Amount",
   PlaceholderText = "Enter quantity...",
   Callback = function(t) am = tonumber(t) or 1 end,
})

MainTab:CreateButton({
   Name = "Bring Item",
   Callback = function()
      local c = 0; for _, i in pairs(workspace:GetDescendants()) do
         if i.Name:find(ti) and c < am then
            if i:IsA("BasePart") then i.CFrame = lp.Character.HumanoidRootPart.CFrame
            elseif i:IsA("Model") then i:MoveTo(lp.Character.HumanoidRootPart.Position) end
            c = c + 1
         end
      end
   end,
})

MainTab:CreateSection("Survival")
MainTab:CreateToggle({
   Name = "God Mode",
   CurrentValue = false,
   Callback = function(v) lp.Character.Humanoid.MaxHealth = v and math.huge or 100; lp.Character.Humanoid.Health = lp.Character.Humanoid.MaxHealth end
})

MainTab:CreateToggle({
   Name = "Invisibility",
   CurrentValue = false,
   Callback = function(v) for _, p in pairs(lp.Character:GetChildren()) do if p:IsA("BasePart") then p.Transparency = v and 0.8 or 0 end end end
})

MainTab:CreateSection("Visuals (ESP)")
local function AddESP(obj, col)
    if not obj:FindFirstChild("DH_ESP") then
        local h = Instance.new("Highlight", obj); h.Name = "DH_ESP"; h.FillColor = col; h.FillTransparency = 0.5; h.OutlineColor = Color3.fromRGB(255, 255, 255)
    end
end

MainTab:CreateToggle({
   Name = "ESP Zombie",
   CurrentValue = false,
   Callback = function(v)
      _G.ZE = v
      task.spawn(function()
         while _G.ZE do
            for _, z in pairs(workspace:GetChildren()) do
               if z:FindFirstChild("Humanoid") and z.Name:lower():find("zombie") then AddESP(z, Color3.fromRGB(0, 255, 0)) end
            end
            task.wait(2)
         end
      end)
   end,
})

MainTab:CreateToggle({
   Name = "ESP Boss",
   CurrentValue = false,
   Callback = function(v)
      _G.BE = v
      task.spawn(function()
         while _G.BE do
            for _, b in pairs(workspace:GetChildren()) do
               if b:FindFirstChild("Humanoid") and (b:FindFirstChild("BossTag") or b.Name:lower():find("boss")) then AddESP(b, Color3.fromRGB(0, 0, 255)) end
            end
            task.wait(2)
         end
      end)
   end,
})

MainTab:CreateToggle({
   Name = "ESP Items",
   CurrentValue = false,
   Callback = function(v)
      _G.IE = v
      task.spawn(function()
         while _G.IE do
            for _, i in pairs(workspace:GetDescendants()) do
               if i:IsA("ClickDetector") or i:IsA("ProximityPrompt") then AddESP(i.Parent, Color3.fromRGB(0, 255, 0)) end
            end
            task.wait(5)
         end
      end)
   end,
})

AutoTab:CreateSection("Farming System")
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
   end,
})

SettingTab:CreateSection("System Management")
SettingTab:CreateButton({
   Name = "Press to turn off",
   Callback = function()
      _G.KA = false; _G.ZE = false; _G.BE = false; _G.FB = false; _G.IE = false
      if _G.SecurityLoop then _G.SecurityLoop:Disconnect() end
      for _, v in pairs(workspace:GetDescendants()) do if v.Name == "DH_ESP" then v:Destroy() end end
      Rayfield:Destroy()
   end,
})

Rayfield:Notify({Title = "DARK HUB", Content = "Key correct! Systems ready.", Duration = 5})
