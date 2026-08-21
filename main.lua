-- TEST NOCLIP + FLY + JALAN LAMBAT (PAKAI BODYVELOCITY)
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
title.Text = "🧪 TEST MODE"
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = frame

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 200, 0, 20)
label.Position = UDim2.new(0.5, -100, 0, 38)
label.BackgroundTransparency = 1
label.Text = "NOCLIP + FLY + SLOW"
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

-- VARIABLE BODYVELOCITY
local flyBV = nil
local targetY = nil

-- FUNGSI FLY
local function setFly(state, yPos)
    if state then
        if flyBV then flyBV:Destroy() end
        flyBV = Instance.new("BodyVelocity")
        flyBV.MaxForce = Vector3.new(0, 1e6, 0)
        flyBV.Velocity = Vector3.new(0, 0, 0)
        flyBV.Parent = root
        targetY = yPos or root.Position.Y
    else
        if flyBV then
            flyBV:Destroy()
            flyBV = nil
        end
    end
end

-- FUNGSI JAGA POSISI Y
local function keepY()
    while flyBV and targetY do
        local delta = targetY - root.Position.Y
        if math.abs(delta) > 0.1 then
            root.CFrame = CFrame.new(root.Position.X, targetY, root.Position.Z)
        end
        task.wait(0.05)
    end
end

-- NOCLIP
local function noclip(state)
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = not state
        end
    end
    if state then
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
        hum.PlatformStand = true
    else
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        hum.PlatformStand = false
    end
end

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
        noclip(false)
        setFly(false)
        notif("⏹️ Dihentikan")
        return
    end

    isRunning = true
    btn.Text = "⏳ PROSES"
    btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

    notif("🚀 Noclip + Fly ON")
    noclip(true)

    -- FLY di ketinggian sekarang + 2 stud
    local flyHeight = root.Position.Y + 2
    setFly(true, flyHeight)
    task.spawn(keepY)

    notif("🚶 Jalan lambat ke NPC...")
    walkTo(Vector3.new(510.56, 3.58, 598.88))

    noclip(false)
    setFly(false)
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

notif("✅ TEST siap! Klik START untuk test noclip + fly + jalan lambat.")
