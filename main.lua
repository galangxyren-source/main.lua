-- KLIK DIALOG (PASTI)
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
title.Text = "🧪 KLIK DIALOG"
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = frame

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 200, 0, 20)
label.Position = UDim2.new(0.5, -100, 0, 38)
label.BackgroundTransparency = 1
label.Text = "PASTI KLIK DIALOG"
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

-- =====================================================
-- ===== VIRTUAL INPUT =====
-- =====================================================
local VirtualInputManager = game:GetService("VirtualInputManager")

local function holdE()
    VirtualInputManager:SendKeyEvent(true, "E", false, game)
    task.wait(3)
    VirtualInputManager:SendKeyEvent(false, "E", false, game)
end

-- =====================================================
-- ===== FIRE PROMPT =====
-- =====================================================
local function firePrompt()
    for _, p in pairs(workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") and p.Enabled == true then
            local parent = p.Parent
            if parent and parent:IsA("BasePart") then
                local dist = (parent.Position - root.Position).Magnitude
                if dist < 15 then
                    p:Hold(3)
                    return true
                end
            end
        end
    end
    return false
end

-- =====================================================
-- ===== JALAN PAKSA =====
-- =====================================================
local function walkForce(pos)
    hum.WalkSpeed = 8
    local startTime = os.time()
    while (root.Position - pos).Magnitude > 5 and os.time() - startTime < 120 do
        hum:MoveTo(pos)
        task.wait(0.5)
    end
    hum.WalkSpeed = 16
end

-- =====================================================
-- ===== KLIK DIALOG (PASTI) =====
-- =====================================================
local function clickDialog()
    task.wait(2)  -- TUNGGU GUI LOAD
    local dialogs = {"You here to buy?", "Yea.. you the guy?"}
    
    for _, g in pairs(player.PlayerGui:GetChildren()) do
        for _, b in pairs(g:GetDescendants()) do
            if (b:IsA("TextButton") or b:IsA("ImageButton")) then
                local txt = b.Text or ""
                for _, d in ipairs(dialogs) do
                    if txt:find(d) then
                        b:Click()
                        task.wait(1)
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- =====================================================
-- ===== KLIK SHOP =====
-- =====================================================
local function clickShopItem(name)
    task.wait(0.5)
    for _, g in pairs(player.PlayerGui:GetChildren()) do
        for _, b in pairs(g:GetDescendants()) do
            if (b:IsA("TextButton") or b:IsA("ImageButton")) then
                local txt = b.Text or ""
                if txt:find(name) then
                    b:Click()
                    task.wait(0.3)
                    return true
                end
            end
        end
    end
    return false
end

local function clickExit()
    task.wait(0.5)
    for _, g in pairs(player.PlayerGui:GetChildren()) do
        for _, b in pairs(g:GetDescendants()) do
            if (b:IsA("TextButton") or b:IsA("ImageButton")) then
                local txt = b.Text or ""
                if txt:lower():find("exit") then
                    b:Click()
                    task.wait(0.3)
                    return true
                end
            end
        end
    end
    return false
end

-- =====================================================
-- ===== NOTIF =====
-- =====================================================
local function notif(text)
    game.StarterGui:SetCore("SendNotification", {
        Title = "TEST",
        Text = text,
        Duration = 3
    })
end

-- =====================================================
-- ===== MAIN =====
-- =====================================================
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

    notif("🚶 Jalan ke NPC...")
    walkForce(Vector3.new(510.56, 3.58, 598.88))

    -- 1. INTERACT
    notif("⌨️ Hold E 3 detik...")
    holdE()
    task.wait(0.5)

    notif("🖐️ Fire Prompt 3 detik...")
    firePrompt()
    task.wait(0.5)

    -- 2. KLIK DIALOG (PASTI)
    notif("💬 Klik dialog...")
    local dialogOk = clickDialog()
    if dialogOk then
        notif("✅ Dialog berhasil!")
    else
        notif("❌ Dialog tidak ditemukan!")
    end

    -- 3. SHOP
    if dialogOk then
        notif("🛒 Beli bahan...")
        local items = {"Gelatin", "Sugar Block Bag", "Water"}
        for _, item in ipairs(items) do
            clickShopItem(item)
        end
        clickExit()
        notif("✅ Beli bahan selesai!")
    end

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

notif("✅ TEST siap! Klik START.")
