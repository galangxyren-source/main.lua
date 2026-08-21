-- SCAN GUI: KIRIM KE CHAT + NOTIF
local player = game.Players.LocalPlayer

local function scanGUI()
    local found = {}
    for _, gui in pairs(player.PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            for _, btn in pairs(gui:GetDescendants()) do
                if btn:IsA("TextButton") or btn:IsA("ImageButton") then
                    local txt = btn.Text or ""
                    if txt ~= "" then
                        table.insert(found, txt)
                    end
                end
            end
        end
    end
    return found
end

local function notif(text)
    game.StarterGui:SetCore("SendNotification", {
        Title = "SCAN GUI",
        Text = text,
        Duration = 10
    })
end

-- Tunggu 3 detik biar GUI sempat muncul
task.wait(3)

local results = scanGUI()

if #results > 0 then
    -- Kirim ke notifikasi
    notif("Ditemukan " .. #results .. " tombol!")
    
    -- Kirim ke chat game (biar keliatan di layar)
    for i, txt in ipairs(results) do
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
            "[" .. i .. "] " .. txt,
            "All"
        )
        task.wait(0.2)
    end
    
    -- Kirim ke console executor (bukan F9)
    warn("=== TOMBOL YANG DITEMUKAN ===")
    for i, txt in ipairs(results) do
        warn(i .. ". " .. txt)
    end
else
    notif("Tidak ada tombol ditemukan!")
    warn("Tidak ada tombol ditemukan!")
end
