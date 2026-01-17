
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

local g = game; local lp = g.Players.LocalPlayer; local UIS = g:GetService("UserInputService")

local Window = Rayfield:CreateWindow({
    Name = "DARK HUB | Dead Rail ULTIMATE",
    LoadingTitle = "Đang kiểm tra bản quyền...",
    LoadingSubtitle = "by ilovedog",
    KeySystem = true,
    KeySettings = {
        Title = "DARK HUB | Key System",
        Subtitle = "Vui lòng nhập Key để tiếp tục",
        Note = "Tham gia Discord để lấy Key miễn phí!",
        FileName = "PRINT____KEY", 
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"PRINT36"} 
    }
})

-- TABS
local MainTab = Window:CreateTab("Main", 4483362458)
local ESPTab = Window:CreateTab("ESP Visuals", 4483362458)
local PlayerTab = Window:CreateTab("Player", 12128784110)
local AutoTab = Window:CreateTab("Auto Farm", 4483362458)
local InfoTab = Window:CreateTab("Information", 4483362458) -- KHÔI PHỤC TAB INFO
local SettingTab = Window:CreateTab("Settings", 4483362458)

InfoTab:CreateSection("Bản Quyền")
InfoTab:CreateLabel("Script được viết bởi: ilovedog")
InfoTab:CreateLabel("Phiên bản: 6.7 Ultimate")

InfoTab:CreateSection("Hệ Thống Key")
InfoTab:CreateButton({
    Name = "Copy Link Discord (Lấy Key)",
    Callback = function()
        setclipboard("https://discord.gg/RWpWmd4G") 
        Rayfield:Notify({Title = "DARK HUB", Content = "Đã copy link Discord vào bộ nhớ tạm!", Duration = 5})
    end
})

-- Hàm hỗ trợ ESP
local function ApplyESP(obj, color)
    if obj and not obj:FindFirstChild("DH_Highlight") then
        local h = Instance.new("Highlight", obj)
        h.Name = "DH_Highlight"; h.FillColor = color; h.OutlineColor = Color3.new(1,1,1)
        h.FillTransparency = 0.5; h.DepthMode = "AlwaysOnTop"
    end
end

-- [[ TAB MAIN ]]
MainTab:CreateSection("Combat")
MainTab:CreateToggle({Name = "Kill Aura", CurrentValue = false, Callback = function(v) _G.KA = v end})

MainTab:CreateSection("Bring Items")
local selectedItem = "All"
MainTab:CreateDropdown({
    Name = "Chọn loại đồ",
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

-- [[ TAB ESP ]]
ESPTab:CreateToggle({Name = "ESP Zombie", CurrentValue = false, Callback = function(v) _G.EZ = v; if v then task.spawn(function() while _G.EZ do for _, o in pairs(workspace:GetChildren()) do if o:FindFirstChild("Humanoid") and o.Name:lower():find("zombie") then ApplyESP(o, Color3.new(0,1,0)) end end task.wait(2) end end) end end})
ESPTab:CreateToggle({Name = "ESP Bond (Tiền Class)", CurrentValue = false, Callback = function(v) _G.ESPB = v; task.spawn(function() while _G.ESPB do for _, obj in pairs(workspace:GetDescendants()) do if obj.Name:lower():find("bond") then ApplyESP(obj, Color3.fromRGB(255, 0, 255)) end end task.wait(3) end end) end end})

-- [[ TAB PLAYER ]]
PlayerTab:CreateToggle({Name = "Bất Tử (God Mode)", CurrentValue = false, Callback = function(v) _G.God = v; task.spawn(function() while _G.God do pcall(function() lp.Character.Humanoid.Health = 100 end) task.wait(0.1) end end) end})
PlayerTab:CreateSlider({Name = "WalkSpeed", Range = {16, 200}, Increment = 1, CurrentValue = 16, Callback = function(v) if lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.WalkSpeed = v end end})

_G.FlySpeed = 50
PlayerTab:CreateToggle({
    Name = "Fly Mode (Bay)",
    CurrentValue = false,
    Callback = function(v)
        _G.Flying = v; local c = lp.Character
        if v and c and c:FindFirstChild("HumanoidRootPart") then
            local bv = Instance.new("BodyVelocity", c.HumanoidRootPart); bv.Name = "Dark_V"; bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            local bg = Instance.new("BodyGyro", c.HumanoidRootPart); bg.Name = "Dark_G"; bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            task.spawn(function()
                while _G.Flying do
                    local cam = workspace.CurrentCamera.CFrame; local dir = Vector3.new(0,0,0)
                    if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.RightVector end
                    bv.Velocity = dir * _G.FlySpeed; bg.CFrame = cam; task.wait()
                end
                if c.HumanoidRootPart:FindFirstChild("Dark_V") then c.HumanoidRootPart.Dark_V:Destroy() end
                if c.HumanoidRootPart:FindFirstChild("Dark_G") then c.HumanoidRootPart.Dark_G:Destroy() end
            end)
        end
    end
})

-- [[ TAB AUTO FARM ]]
AutoTab:CreateToggle({
    Name = "Auto Hunt Bond",
    CurrentValue = false,
    Callback = function(v)
        _G.HuntBond = v
        task.spawn(function()
            while _G.HuntBond do
                pcall(function()
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if _G.HuntBond and obj.Name:lower():find("bond") then
                            lp.Character.HumanoidRootPart.CFrame = (obj:IsA("Model") and obj:GetModelCFrame() or obj.CFrame) * CFrame.new(0, 2, 0)
                            task.wait(0.5)
                            if obj:FindFirstChild("TouchTransmitter") then firetouchinterest(lp.Character.HumanoidRootPart, obj, 0); firetouchinterest(lp.Character.HumanoidRootPart, obj, 1) end
                        end
                    end
                end)
                task.wait(2)
            end
        end)
    end
})

-- [[ TAB SETTINGS ]]
SettingTab:CreateButton({Name = "🚀 FPS Boost", Callback = function() g:GetService("Lighting").GlobalShadows = false; for _, v in pairs(g:GetDescendants()) do if v:IsA("Part") then v.Material = "SmoothPlastic" end end end})
SettingTab:CreateButton({Name = "❌ Hủy Script", Callback = function() Rayfield:Destroy() end})

Rayfield:Notify({Title = "DARK HUB", Content = "Đã sẵn sàng", Duration = 5})
