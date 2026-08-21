-- SCAN GUI - TAMPILKAN DI LAYAR
local player = game.Players.LocalPlayer

-- Buat UI untuk menampilkan hasil scan
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 380, 0, 280)
label.Position = UDim2.new(0.5, -190, 0.5, -140)
label.BackgroundTransparency = 1
label.Text = "SCAN GUI...\nTunggu 3 detik..."
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextSize = 14
label.Font = Enum.Font.Gotham
label.TextWrapped = true
label.TextScaled = false
label.Parent = frame

-- Tunggu GUI muncul
task.wait(3)

-- Scan semua tombol
local results = {}
for _, gui in pairs(player.PlayerGui:GetChildren()) do
    if gui:IsA("ScreenGui") and gui ~= screenGui then
        for _, btn in pairs(gui:GetDescendants()) do
            if btn:IsA("TextButton") or btn:IsA("ImageButton") then
                local txt = btn.Text or ""
                if txt ~= "" then
                    table.insert(results, txt)
                end
            end
        end
    end
end

-- Tampilkan hasil
if #results > 0 then
    label.Text = "=== TOMBOL DITEMUKAN ===\n" .. table.concat(results, "\n")
else
    label.Text = "TIDAK ADA TOMBOL DITEMUKAN!\n\nPastikan GUI dialog sudah muncul."
end
