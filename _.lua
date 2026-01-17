-- [[ DARK HUB V6.7 - DEAD RAIL BOND HUNTER ]]
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
    Name = "DARK HUB | Dead Rali V6.7",
    LoadingTitle = "Đang khởi tạo hệ thống săn Bond...",
    LoadingSubtitle = "by quocthai8424",
    KeySystem = false 
})

-- TABS
local MainTab = Window:CreateTab("Main", 4483362458)
local ESPTab = Window:CreateTab("ESP Visuals", 4483362458)
local PlayerTab = Window:CreateTab("Player", 12128784110)
local AutoTab = Window:CreateTab("Auto Farm", 4483362458)
local SettingTab = Window:CreateTab("Settings", 4483362458)

-- [[ TÍNH NĂNG MỚI: ESP BOND ]]
-- Giúp bạn nhìn thấy Bond xuyên tường để biết nó đang ở đâu
ESPTab:CreateToggle({
    Name = "ESP Bond (Tiền Class)",
    CurrentValue = false,
    Callback = function(v)
        _G.ESPBond = v
        while _G.ESPBond do
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name:lower():find("bond") and not obj:FindFirstChild("DH_Highlight") then
                    local h = Instance.new("Highlight", obj)
                    h.Name = "DH_Highlight"; h.FillColor = Color3.fromRGB(255, 0, 255); h.DepthMode = "AlwaysOnTop"
                end
            end
            task.wait(3)
        end
    end
})

-- [[ TAB AUTO FARM: SMART SCANNER ]]
AutoTab:CreateSection("Bond & Money Hunting")

-- AUTO HUNT BOND (Săn Bond xuất hiện ngẫu nhiên)
AutoTab:CreateToggle({
    Name = "Auto Hunt Bond (Bay tới nhặt Bond)",
    CurrentValue = false,
    Callback = function(v)
        _G.HuntBond = v
        task.spawn(function()
            while _G.HuntBond do
                local found = false
                pcall(function()
                    for _, obj in pairs(workspace:GetDescendants()) do
                        -- Quét các vật phẩm có tên Bond trong các khu vực (Ngân hàng, nhà cửa)
                        if _G.HuntBond and obj.Name:lower():find("bond") then
                            found = true
                            local targetPos = (obj:IsA("Model") and obj:GetModelCFrame() or obj.CFrame)
                            
                            -- Bay đến vị trí Bond
                            lp.Character.HumanoidRootPart.CFrame = targetPos * CFrame.new(0, 2, 0)
                            task.wait(0.5)
                            
                            -- Kích hoạt nhặt (Thử cả Chạm và Nhấn E)
                            if obj:FindFirstChild("TouchTransmitter") then
                                firetouchinterest(lp.Character.HumanoidRootPart, obj, 0)
                                firetouchinterest(lp.Character.HumanoidRootPart, obj, 1)
                            end
                            if obj:FindFirstChild("ProximityPrompt") then
                                fireproximityprompt(obj.ProximityPrompt)
                            end
                            task.wait(0.5)
                        end
                    end
                end)
                if not found then task.wait(2) else task.wait(0.5) end
            end
        end)
    end
})

-- AUTO FARM MONEY (Gom xác & Bán tại bàn)
AutoTab:CreateToggle({
    Name = "Auto Farm Tiền (Gom & Bán)",
    CurrentValue = false,
    Callback = function(v)
        _G.AutoMoney = v
        task.spawn(function()
            while _G.AutoMoney do
                local itemsToSell = false
                pcall(function()
                    -- 1. Gom xác và tiền rơi
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if _G.AutoMoney and (obj.Name:lower():find("corpse") or obj.Name:lower():find("money")) then
                            itemsToSell = true
                            lp.Character.HumanoidRootPart.CFrame = (obj:IsA("Model") and obj:GetModelCFrame() or obj.CFrame)
                            task.wait(0.4)
                        end
                    end
                    -- 2. Tự động tìm bàn bán (Sell Table)
                    if itemsToSell then
                        for _, s in pairs(workspace:GetDescendants()) do
                            local n = s.Name:lower()
                            if n:find("sell") or n:find("trader") or (n:find("table") and s:FindFirstChild("ClickDetector")) then
                                lp.Character.HumanoidRootPart.CFrame = (s:IsA("Model") and s:GetModelCFrame() or s.CFrame)
                                task.wait(1)
                                if s:FindFirstChild("ClickDetector") then fireclickdetector(s.ClickDetector) end
                                break
                            end
                        end
                    end
                end)
                task.wait(1.5)
            end
        end)
    end
})

-- [[ CÁC TÍNH NĂNG GỐC CỦA BẠN (KHÔNG ĐỔI) ]]
MainTab:CreateSection("Combat")
local ar = 50
MainTab:CreateSlider({Name = "Kill Aura Range", Range = {0, 100}, Increment = 1, CurrentValue = 50, Callback = function(v) ar = v end})
MainTab:CreateToggle({Name = "Kill Aura", CurrentValue = false, Callback = function(v) _G.KA = v end})

PlayerTab:CreateToggle({Name = "Bất Tử (God Mode)", CurrentValue = false, Callback = function(v) _G.God = v; task.spawn(function() while _G.God do pcall(function() lp.Character.Humanoid.Health = 100 end) task.wait(0.1) end end) end})
PlayerTab:CreateToggle({Name = "Tàng Hình (Invisible)", CurrentValue = false, Callback = function(v) pcall(function() for _, p in pairs(lp.Character:GetDescendants()) do if p:IsA("BasePart") or p:IsA("Decal") then p.Transparency = v and 1 or 0 end end end) end})

SettingTab:CreateButton({Name = "🚀 FPS Boost", Callback = function() g:GetService("Lighting").GlobalShadows = false; for _, v in pairs(g:GetDescendants()) do if v:IsA("Part") then v.Material = "SmoothPlastic" end end end})
SettingTab:CreateButton({Name = "❌ Hủy Script", Callback = function() _G.KA = false; _G.HuntBond = false; _G.AutoMoney = false; Rayfield:Destroy() end})

Rayfield:Notify({Title = "DARK HUB", Content = "Đã cập nhật Radar săn Bond ngẫu nhiên!", Duration = 5})
