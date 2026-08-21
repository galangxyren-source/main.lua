-- TEST JALAN NORMAL + UI (TANPA NOCLIP)
local player = game.Players.LocalPlayer
local char = player.Character
if not char then
    player.CharacterAdded:Wait()
    char = player.Character
end
local hum = char:FindFirstChild("Humanoid")
local root = char:FindFirstChild("HumanoidRootPart")
if not hum or not root then return end

-- HAPUS GUI LAMA
for _, gui in pairs(player.PlayerGui:GetChildren()) do
    if gui:IsA("ScreenGui") then gui:Destroy() end
end

-- UI
local gui = Instance.new("ScreenGui")
gui.Name = "TestUI"
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(0.5, -110, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.4
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 200, 0, 30)
title.Position = UDim2.new(0.5, -100, 0, 5)
title.BackgroundTransparency = 1
title.Text = "🧪 TEST JALAN"
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = frame

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 200, 0, 20)
label.Position = UDim2.new(0.5, -100, 0, 38)
label.BackgroundTransparency = 1
label.Text = "JALAN NORMAL + SLOW"
label.TextColor3 = Color3.fromRGB(200, 200, 255)
label.TextSize = 13
label.Font = Enum.Font.Gotham
label.Parent = frame

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 140, 0, 35)
btn.Position = UDim2.new(0.5, -70, 0, 70)
btn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
btn.Text = "▶ START"
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.TextSize = 16
btn.Font = Enum.Font.GothamBold
btn.BorderSizePixel = 0
btn.Parent = frame

-- JALAN LAMBAT
local function walkTo(pos)
    hum.WalkSpeed = 8
    hum:MoveTo(pos)
    while (root.Position - pos).Magnitude > 5 do
        task.wait(0.2)
    end
    hum.WalkSpeed = 16
end

-- NOTIF
local function notif(text)
    game.StarterGui:SetCore("SendNotification", {
        Title = "TEST",
        Text = text,
        Duration = 3
    })
end

local isRunning = false

btn.MouseButton1Click:Connect(function()
    if isRunning then
        isRunning = false
        btn.Text = "▶ START"
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
        notif("⏹️ Dihentikan")
        return
    end

    isRunning = true
    btn.Text = "⏳ PROSES"
    btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

    notif("🚶 Jalan lambat ke NPC...")
    walkTo(Vector3.new(510.56, 3.58, 598.88))

    notif("✅ Sampai tujuan!")
    isRunning = false
    btn.Text = "▶ START"
    btn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
end)

-- TOGGLE UI
game:GetService("UserInputService").InputBegan:Connect(function(input, p)
    if p then return end
    if input.KeyCode == Enum.KeyCode.Z then
        gui.Enabled = not gui.Enabled
    end
end)

notif("✅ TEST siap! Klik START untuk jalan lambat ke NPC.")
