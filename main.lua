-- SCAN GUI: LIHAT SEMUA TOMBOL
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

-- TAMPILKAN DI NOTIFIKASI
local function notif(text)
    game.StarterGui:SetCore("SendNotification", {
        Title = "SCAN GUI",
        Text = text,
        Duration = 10
    })
end

-- JALANKAN SCAN
task.wait(2) -- kasih waktu buat GUI muncul
local results = scanGUI()

if #results > 0 then
    notif("Ditemukan " .. #results .. " tombol:\n" .. table.concat(results, "\n"))
else
    notif("Tidak ada tombol ditemukan!")
end

-- TAMPILKAN JUGA DI OUTPUT CONSOLE
print("=== TOMBOL YANG DITEMUKAN ===")
for i, txt in ipairs(results) do
    print(i .. ". " .. txt)
end
