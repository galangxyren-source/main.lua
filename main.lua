-- SCAN GUI - SIMPAN KE .TXT
local player = game.Players.LocalPlayer

-- Tunggu 3 detik biar GUI dialog muncul
task.wait(3)

local results = {}
for _, gui in pairs(player.PlayerGui:GetChildren()) do
    if gui:IsA("ScreenGui") then
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

-- Buat isi file
local content = "=== TOMBOL YANG DITEMUKAN ===\n"
content = content .. "Total: " .. #results .. " tombol\n\n"
for i, txt in ipairs(results) do
    content = content .. "[" .. i .. "] " .. txt .. "\n"
end

-- Simpan ke file
local fileName = "scan_gui_result.txt"
writefile(fileName, content)

-- Notifikasi
game.StarterGui:SetCore("SendNotification", {
    Title = "✅ SCAN SELESAI",
    Text = "File " .. fileName .. " dibuat di folder executor",
    Duration = 5
})

-- Tampilkan juga di output executor
print("File saved: " .. fileName)
print(content)
