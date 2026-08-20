--[[
  ROOT RIPPER PRO v5.0 — Dengan Estimasi Waktu Real-time
  Menampilkan persentase, bagian yang sedang disalin, dan perkiraan detik tersisa.
--]]

local function CreateProgressHUD()
    -- Buat ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name = "ProgressHUD"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 350, 0, 110)
    frame.Position = UDim2.new(1, -370, 0, 20)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.35
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.new(1, 0, 0)
    frame.Parent = gui
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 25)
    title.Position = UDim2.new(0, 0, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = L4NG ZONE"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    local progressLabel = Instance.new("TextLabel")
    progressLabel.Size = UDim2.new(1, 0, 0, 25)
    progressLabel.Position = UDim2.new(0, 0, 0, 30)
    progressLabel.BackgroundTransparency = 1
    progressLabel.Text = "0% — Initializing..."
    progressLabel.TextColor3 = Color3.new(0.3, 1, 0.5)
    progressLabel.TextScaled = true
    progressLabel.Font = Enum.Font.GothamMedium
    progressLabel.Parent = frame
    
    local etaLabel = Instance.new("TextLabel")
    etaLabel.Size = UDim2.new(1, 0, 0, 20)
    etaLabel.Position = UDim2.new(0, 0, 0, 55)
    etaLabel.BackgroundTransparency = 1
    etaLabel.Text = "⏱ ETA: -- s"
    etaLabel.TextColor3 = Color3.new(1, 1, 0.5)
    etaLabel.TextScaled = true
    etaLabel.Font = Enum.Font.GothamMedium
    etaLabel.Parent = frame
    
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 0, 0, 15)
    bar.Position = UDim2.new(0, 0, 0, 78)
    bar.BackgroundColor3 = Color3.new(1, 0, 0)
    bar.BorderSizePixel = 0
    bar.Parent = frame
    
    -- Tambahkan ke player
    local player = game.Players.LocalPlayer
    if player and player:FindFirstChild("PlayerGui") then
        gui.Parent = player.PlayerGui
    else
        gui.Parent = game.StarterGui
    end
    
    -- Variabel untuk estimasi
    local startTime = os.clock()
    local lastPercent = 0
    local eta = 0
    
    return {
        Update = function(percent, section, estimatedSeconds)
            percent = math.clamp(percent, 0, 100)
            local elapsed = os.clock() - startTime
            
            -- Hitung ETA jika progress > 0
            if percent > 0 then
                local speed = percent / elapsed -- % per detik
                local remaining = 100 - percent
                eta = remaining / speed
                if eta < 0 then eta = 0 end
            end
            
            -- Format ETA
            local etaText
            if percent >= 100 then
                etaText = "✅ Complete!"
            elseif eta > 60 then
                etaText = string.format("⏱ ETA: ~%d menit", math.ceil(eta / 60))
            else
                etaText = string.format("⏱ ETA: ~%d detik", math.ceil(eta))
            end
            
            progressLabel.Text = string.format("%d%% — %s...", percent, section)
            etaLabel.Text = etaText
            bar.Size = UDim2.new(percent / 100, 0, 0, 15)
            
            -- Warna bar
            if percent < 30 then
                bar.BackgroundColor3 = Color3.new(1, 0, 0)
            elseif percent < 70 then
                bar.BackgroundColor3 = Color3.new(1, 0.8, 0)
            else
                bar.BackgroundColor3 = Color3.new(0, 1, 0)
            end
        end,
        Destroy = function()
            gui:Destroy()
        end
    }
end

-- ============================================
-- ROOT RIPPER DENGAN ESTIMASI WAKTU
-- ============================================
local function RootRipperPro()
    -- Inisialisasi HUD
    local hud = CreateProgressHUD()
    wait(0.5)
    
    -- Folder master
    local MasterRoot = Instance.new("Folder")
    MasterRoot.Name = "ROOT_EXTRACT_" .. os.time()
    
    -- Fungsi salin rekursif
    local function CopyDeep(original, parent)
        if not original then return end
        
        local copy = Instance.new(original.ClassName)
        copy.Name = original.Name
        
        local properties = {"CFrame", "Size", "Position", "Orientation", "Color", "BrickColor", "Material", 
                            "Transparency", "Reflectance", "Anchored", "CanCollide", "Shape", "Value", 
                            "StringValue", "NumberValue", "BoolValue", "ObjectValue", "Vector3Value"}
        for _, prop in ipairs(properties) do
            pcall(function() 
                if original[prop] ~= nil then 
                    copy[prop] = original[prop] 
                end 
            end)
        end
        
        if original:IsA("BaseScript") then
            copy.Source = original.Source
        end
        
        for attr, val in pairs(original:GetAttributes()) do
            copy:SetAttribute(attr, val)
        end
        
        for _, tag in ipairs(original:GetTags()) do
            copy:AddTag(tag)
        end
        
        for _, child in ipairs(original:GetChildren()) do
            if child.ClassName ~= "Terrain" and child.ClassName ~= "Camera" then
                CopyDeep(child, copy)
            end
        end
        
        copy.Parent = parent
        return copy
    end
    
    -- ========== EKSEKUSI BERTAHAP ==========
    local progress = 0
    local totalSteps = 9
    
    local function UpdateProgress(step, sectionName)
        progress = math.floor((step / totalSteps) * 100)
        -- Kirim estimasi waktu ke HUD (dihitung internal)
        hud.Update(progress, sectionName, nil)
        wait(0.3)
    end
    
    -- 1. Workspace
    UpdateProgress(1, "Workspace")
    local wsClone = Instance.new("Folder")
    wsClone.Name = "Workspace_Clone"
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj.ClassName ~= "Terrain" and obj.ClassName ~= "Camera" then
            CopyDeep(obj, wsClone)
        end
    end
    wsClone.Parent = MasterRoot
    
    -- 2. Terrain
    UpdateProgress(2, "Terrain")
    local terrainClone = Instance.new("Terrain")
    local success, terrainData = pcall(function()
        return workspace.Terrain:ReadVoxels(workspace.Terrain.MaxExtents, 1)
    end)
    if success and terrainData then
        terrainClone:WriteVoxels(terrainData, 1)
    end
    terrainClone.Parent = MasterRoot
    
    -- 3. StarterCharacter
    UpdateProgress(3, "StarterCharacter")
    local sc = Instance.new("Folder")
    sc.Name = "StarterCharacter_Clone"
    for _, obj in ipairs(game.StarterPlayer.StarterCharacter:GetChildren()) do
        CopyDeep(obj, sc)
    end
    sc.Parent = MasterRoot
    
    -- 4. StarterPlayer
    UpdateProgress(4, "StarterPlayer")
    local sp = Instance.new("Folder")
    sp.Name = "StarterPlayer_Clone"
    for _, obj in ipairs(game.StarterPlayer:GetChildren()) do
        if obj.Name ~= "StarterCharacter" then
            CopyDeep(obj, sp)
        end
    end
    sp.Parent = MasterRoot
    
    -- 5. StarterPack
    UpdateProgress(5, "StarterPack")
    local spack = Instance.new("Folder")
    spack.Name = "StarterPack_Clone"
    for _, obj in ipairs(game.StarterPack:GetChildren()) do
        CopyDeep(obj, spack)
    end
    spack.Parent = MasterRoot
    
    -- 6. ReplicatedStorage
    UpdateProgress(6, "ReplicatedStorage")
    local rs = Instance.new("Folder")
    rs.Name = "ReplicatedStorage_Clone"
    for _, obj in ipairs(game.ReplicatedStorage:GetChildren()) do
        CopyDeep(obj, rs)
    end
    rs.Parent = MasterRoot
    
    -- 7. ServerScriptService
    UpdateProgress(7, "ServerScriptService")
    local sss = Instance.new("Folder")
    sss.Name = "ServerScriptService_Clone"
    for _, obj in ipairs(game.ServerScriptService:GetChildren()) do
        CopyDeep(obj, sss)
    end
    sss.Parent = MasterRoot
    
    -- 8. Remote Events
    UpdateProgress(8, "Remote Events & Functions")
    local remoteList = {}
    for _, obj in ipairs(game.ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            table.insert(remoteList, {Name = obj.Name, Class = obj.ClassName})
        end
    end
    MasterRoot:SetAttribute("RemoteList", remoteList)
    
    -- 9. DataStore
    UpdateProgress(9, "DataStore Snapshot")
    local ds = game:GetService("DataStoreService")
    local sampleKeys = {"PlayerData", "GameProgress", "Inventory", "Settings"}
    local dsSnapshot = {}
    for _, key in ipairs(sampleKeys) do
        local ok, val = pcall(function() return ds:GetAsync(key) end)
        if ok then
            dsSnapshot[key] = val
        end
    end
    MasterRoot:SetAttribute("DataStoreSnapshot", dsSnapshot)
    
    -- FINISH
    hud.Update(100, "COMPLETE! All roots extracted", 0)
    wait(1)
    
    MasterRoot.Parent = workspace
    
    print("==========================================")
    print("[ROOT RIPPER PRO] EKSTRAKSI TOTAL SELESAI!")
    print("Folder master: " .. MasterRoot.Name)
    print("==========================================")
    
    task.delay(3, function()
        hud.Destroy()
    end)
    
    return MasterRoot
end

-- ========== EKSEKUSI ==========
local result = RootRipperPro()
print("SUKSES! Semua akar tersalin di: " .. result:GetFullName())
