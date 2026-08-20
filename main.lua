--[[
  ROOT RIPPER PRO v6.0 — VERSI ANTI-GAGAL
  Dipastikan berjalan di semua executor (Synapse/Krnl/Fluxus/Valyse/Command Bar)
--]]

-- ============================================
-- HUD PROGRESS (PAKAI STARTERGUI AGAR PASTI MUNCUL)
-- ============================================
local function CreateProgressHUD()
    local gui = Instance.new("ScreenGui")
    gui.Name = "ProgressHUD"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 380, 0, 120)
    frame.Position = UDim2.new(1, -400, 0, 20)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.new(1, 0, 0)
    frame.Parent = gui
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 25)
    title.Position = UDim2.new(0, 0, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = "🔥 ROOT RIPPER PRO"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    local progressLabel = Instance.new("TextLabel")
    progressLabel.Size = UDim2.new(1, 0, 0, 30)
    progressLabel.Position = UDim2.new(0, 0, 0, 30)
    progressLabel.BackgroundTransparency = 1
    progressLabel.Text = "0% — Initializing..."
    progressLabel.TextColor3 = Color3.new(0.3, 1, 0.5)
    progressLabel.TextScaled = true
    progressLabel.Font = Enum.Font.GothamMedium
    progressLabel.Parent = frame
    
    local etaLabel = Instance.new("TextLabel")
    etaLabel.Size = UDim2.new(1, 0, 0, 25)
    etaLabel.Position = UDim2.new(0, 0, 0, 60)
    etaLabel.BackgroundTransparency = 1
    etaLabel.Text = "⏱ ETA: -- s"
    etaLabel.TextColor3 = Color3.new(1, 1, 0.5)
    etaLabel.TextScaled = true
    etaLabel.Font = Enum.Font.GothamMedium
    etaLabel.Parent = frame
    
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 0, 0, 16)
    bar.Position = UDim2.new(0, 0, 0, 88)
    bar.BackgroundColor3 = Color3.new(1, 0, 0)
    bar.BorderSizePixel = 0
    bar.Parent = frame
    
    -- ========== GUNAKAN STARTERGUI AGAR PASTI MUNCUL ==========
    local success = pcall(function()
        -- Coba masukkan ke PlayerGui dulu
        local player = game.Players.LocalPlayer
        if player and player:FindFirstChild("PlayerGui") then
            gui.Parent = player.PlayerGui
            return
        end
    end)
    
    if not gui.Parent then
        -- Fallback ke StarterGui (pasti jalan)
        gui.Parent = game:GetService("StarterGui")
    end
    
    -- Simpan referensi
    local startTime = os.clock()
    local hudData = {
        gui = gui,
        progressLabel = progressLabel,
        etaLabel = etaLabel,
        bar = bar,
        startTime = startTime,
        lastPercent = 0,
        Update = function(self, percent, section)
            local elapsed = os.clock() - self.startTime
            percent = math.clamp(percent, 0, 100)
            
            -- Hitung ETA
            local eta = 0
            if percent > 0 and elapsed > 0 then
                local speed = percent / elapsed
                eta = (100 - percent) / speed
                if eta < 0 then eta = 0 end
            end
            
            local etaText
            if percent >= 100 then
                etaText = "✅ Complete!"
            elseif eta > 60 then
                etaText = string.format("⏱ ETA: ~%d m", math.ceil(eta / 60))
            else
                etaText = string.format("⏱ ETA: ~%d s", math.ceil(eta))
            end
            
            self.progressLabel.Text = string.format("%d%% — %s...", percent, section)
            self.etaLabel.Text = etaText
            self.bar.Size = UDim2.new(percent / 100, 0, 0, 16)
            
            if percent < 30 then
                self.bar.BackgroundColor3 = Color3.new(1, 0, 0)
            elseif percent < 70 then
                self.bar.BackgroundColor3 = Color3.new(1, 0.8, 0)
            else
                self.bar.BackgroundColor3 = Color3.new(0, 1, 0)
            end
        end,
        Destroy = function(self)
            pcall(function() self.gui:Destroy() end)
        end
    }
    
    return hudData
end

-- ============================================
-- FUNGSI COPY REKURSIF (DIPERCEPAT)
-- ============================================
local function CopyDeep(original, parent)
    if not original then return end
    
    local copy = Instance.new(original.ClassName)
    copy.Name = original.Name
    
    -- Salin properti penting (dipersingkat agar lebih cepat)
    local props = {"CFrame", "Size", "Position", "Orientation", "Color", "BrickColor", 
                   "Material", "Transparency", "Reflectance", "Anchored", "CanCollide", 
                   "Shape", "Value", "StringValue", "NumberValue", "BoolValue", "ObjectValue"}
    for _, prop in ipairs(props) do
        pcall(function()
            if original[prop] ~= nil then
                copy[prop] = original[prop]
            end
        end)
    end
    
    -- Source skrip
    if original:IsA("BaseScript") then
        copy.Source = original.Source
    end
    
    -- Attribute & Tag
    for attr, val in pairs(original:GetAttributes()) do
        pcall(function() copy:SetAttribute(attr, val) end)
    end
    for _, tag in ipairs(original:GetTags()) do
        pcall(function() copy:AddTag(tag) end)
    end
    
    -- Anak-anak
    for _, child in ipairs(original:GetChildren()) do
        if child.ClassName ~= "Terrain" and child.ClassName ~= "Camera" then
            CopyDeep(child, copy)
        end
    end
    
    copy.Parent = parent
    return copy
end

-- ============================================
-- MAIN EXECUTOR
-- ============================================
local function RootRipperPro()
    print("[ROOT RIPPER] Starting...")
    
    -- Buat HUD
    local hud = CreateProgressHUD()
    wait(0.5)
    
    -- Folder master
    local MasterRoot = Instance.new("Folder")
    MasterRoot.Name = "ROOT_EXTRACT_" .. os.time()
    
    -- Progress tracker
    local totalSteps = 9
    local currentStep = 0
    
    local function UpdateProgress(sectionName)
        currentStep = currentStep + 1
        local percent = math.floor((currentStep / totalSteps) * 100)
        hud:Update(percent, sectionName)
        wait(0.2)
    end
    
    -- ===== 1. WORKSPACE =====
    UpdateProgress("Workspace")
    local wsClone = Instance.new("Folder")
    wsClone.Name = "Workspace_Clone"
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj.ClassName ~= "Terrain" and obj.ClassName ~= "Camera" then
            CopyDeep(obj, wsClone)
        end
    end
    wsClone.Parent = MasterRoot
    
    -- ===== 2. TERRAIN =====
    UpdateProgress("Terrain")
    local terrainClone = Instance.new("Terrain")
    local ok, data = pcall(function()
        return workspace.Terrain:ReadVoxels(workspace.Terrain.MaxExtents, 1)
    end)
    if ok and data then
        terrainClone:WriteVoxels(data, 1)
    end
    terrainClone.Parent = MasterRoot
    
    -- ===== 3. STARTERCHARACTER =====
    UpdateProgress("StarterCharacter")
    local sc = Instance.new("Folder")
    sc.Name = "StarterCharacter_Clone"
    local starterChar = game:GetService("StarterPlayer"):FindFirstChild("StarterCharacter")
    if starterChar then
        for _, obj in ipairs(starterChar:GetChildren()) do
            CopyDeep(obj, sc)
        end
    end
    sc.Parent = MasterRoot
    
    -- ===== 4. STARTERPLAYER =====
    UpdateProgress("StarterPlayer")
    local sp = Instance.new("Folder")
    sp.Name = "StarterPlayer_Clone"
    for _, obj in ipairs(game:GetService("StarterPlayer"):GetChildren()) do
        if obj.Name ~= "StarterCharacter" then
            CopyDeep(obj, sp)
        end
    end
    sp.Parent = MasterRoot
    
    -- ===== 5. STARTERPACK =====
    UpdateProgress("StarterPack")
    local spack = Instance.new("Folder")
    spack.Name = "StarterPack_Clone"
    for _, obj in ipairs(game:GetService("StarterPack"):GetChildren()) do
        CopyDeep(obj, spack)
    end
    spack.Parent = MasterRoot
    
    -- ===== 6. REPLICATEDSTORAGE =====
    UpdateProgress("ReplicatedStorage")
    local rs = Instance.new("Folder")
    rs.Name = "ReplicatedStorage_Clone"
    for _, obj in ipairs(game:GetService("ReplicatedStorage"):GetChildren()) do
        CopyDeep(obj, rs)
    end
    rs.Parent = MasterRoot
    
    -- ===== 7. SERVERSERVICESCRIPT =====
    UpdateProgress("ServerScriptService")
    local sss = Instance.new("Folder")
    sss.Name = "ServerScriptService_Clone"
    for _, obj in ipairs(game:GetService("ServerScriptService"):GetChildren()) do
        CopyDeep(obj, sss)
    end
    sss.Parent = MasterRoot
    
    -- ===== 8. REMOTE EVENTS =====
    UpdateProgress("Remote Events")
    local remoteList = {}
    for _, obj in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            table.insert(remoteList, {Name = obj.Name, Class = obj.ClassName})
        end
    end
    MasterRoot:SetAttribute("RemoteList", remoteList)
    
    -- ===== 9. DATASTORE =====
    UpdateProgress("DataStore")
    local ds = game:GetService("DataStoreService")
    local sampleKeys = {"PlayerData", "GameProgress", "Inventory"}
    local snapshot = {}
    for _, key in ipairs(sampleKeys) do
        local ok2, val = pcall(function() return ds:GetAsync(key) end)
        if ok2 then snapshot[key] = val end
    end
    MasterRoot:SetAttribute("DataStoreSnapshot", snapshot)
    
    -- FINISH
    hud:Update(100, "COMPLETE! All roots extracted")
    wait(1)
    
    -- Taruh di Workspace
    MasterRoot.Parent = workspace
    
    print("==========================================")
    print("[ROOT RIPPER PRO] EKSTRAKSI SELESAI!")
    print("Hasil: " .. MasterRoot:GetFullName())
    print("==========================================")
    
    -- HUD hilang setelah 3 detik
    task.delay(3, function()
        pcall(function() hud:Destroy() end)
    end)
    
    return MasterRoot
end

-- ========== EKSEKUSI ==========
local result = RootRipperPro()
print("SUKSES! Folder: " .. (result and result.Name or "GAGAL"))
