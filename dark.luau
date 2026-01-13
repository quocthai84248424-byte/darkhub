-- [[ D4RK HUB - TEST 🤓 ]]
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.fastgit.org/Footagesus/WindUI/main/main.lua"))()
end)

if not success then return warn("Lỗi tải UI, check mạng bro ơi! 🤓") end

local Window = WindUI:CreateWindow({
    Title = "D4RK HUB 🤓",
    Author = "By ilovedog1901ilovecat5551",
    Folder = "d4rk_test",
    Size = UDim2.fromOffset(580, 420),
    Theme = "Dark"
})

local Tab = Window:Tab({ Title = "Main", Icon = "house" })

Tab:Toggle({
    Title = "Auto Fix Generator 🤓",
    Callback = function(state)
        _G.AutoFix = state
        task.spawn(function()
            while _G.AutoFix do
                pcall(function()
                    for _, v in pairs(workspace:GetChildren()) do
                        if v.Name == "Generator" and v:FindFirstChild("Hinge") then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Hinge.CFrame * CFrame.new(0, 3, 0)
                            task.wait(0.2)
                            fireproximityprompt(v.Prompt)
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
    end
})

Tab:Toggle({
    Title = "Auto Eat Chicken 🤓",
    Callback = function(state)
        _G.AutoEat = state
        task.spawn(function()
            while _G.AutoEat do
                pcall(function()
                    local p = game.Players.LocalPlayer
                    local t = p.Character:FindFirstChild("Chicken Leg") or p.Backpack:FindFirstChild("Chicken Leg")
                    if t then
                        if t.Parent == p.Backpack then p.Character.Humanoid:EquipTool(t) end
                        t:Activate()
                    end
                end)
                task.wait(1)
            end
        end)
    end
})
