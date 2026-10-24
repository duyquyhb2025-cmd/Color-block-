local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local client = Players.LocalPlayer
local KEYBIND = Enum.KeyCode.M

-- Diller Tablosu
local Languages = {
    {ID = "TR", Title = "Echo X - Sınırsız", Infinite = "Sınırsız Her Şey", Bombs = "Bomba Ekle", GoldBombs = "Altın Bomba Ekle", Cash = "Para Ekle", Spins = "Çark Ekle", Revives = "Canlanma Ekle", Ready = "Hazır"},
    {ID = "EN", Title = "Echo X - Infinite", Infinite = "Infinite Everything", Bombs = "Add Bombs", GoldBombs = "Add Gold Bombs", Cash = "Add Cash", Spins = "Add Spins", Revives = "Add Revives", Ready = "Ready"},
    {ID = "ES", Title = "Echo X - Infinito", Infinite = "Todo Infinito", Bombs = "Añadir Bombas", GoldBombs = "Bombas de Oro", Cash = "Añadir Dinero", Spins = "Añadir Giros", Revives = "Revivir", Ready = "Listo"},
    {ID = "DE", Title = "Echo X - Unendlich", Infinite = "Alles Unendlich", Bombs = "Bomben Hinzufügen", GoldBombs = "Goldbomben", Cash = "Geld Hinzufügen", Spins = "Spins Hinzufügen", Revives = "Wiederbeleben", Ready = "Bereit"},
    {ID = "FR", Title = "Echo X - Infini", Infinite = "Tout Infini", Bombs = "Ajouter Bombes", GoldBombs = "Bombes d'Or", Cash = "Ajouter Argent", Spins = "Ajouter Spins", Revives = "Réanimations", Ready = "Prêt"}
}
local currentLangIndex = 1

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "EchoX_Premium_UI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

local window = Instance.new("Frame", gui)
window.Size = UDim2.fromOffset(300, 420)
window.Position = UDim2.new(0.5, -150, 0.5, -210)
window.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
window.BorderSizePixel = 0
window.Visible = false
window.Active = true
window.Draggable = true

local windowCorner = Instance.new("UICorner", window); windowCorner.CornerRadius = UDim.new(0, 10)
local windowStroke = Instance.new("UIStroke", window); windowStroke.Color = Color3.fromRGB(45, 45, 45); windowStroke.Thickness = 1.5

local titleBar = Instance.new("Frame", window)
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundTransparency = 1

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBold; title.TextColor3 = Color3.fromRGB(255, 255, 255); title.TextSize = 16; title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "Echo X"

-- DİL GÖSTERGESİ (Yeni)
local langIndicator = Instance.new("TextLabel", titleBar)
langIndicator.Size = UDim2.fromOffset(40, 25)
langIndicator.Position = UDim2.new(1, -85, 0.5, -12)
langIndicator.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
langIndicator.Font = Enum.Font.GothamBold; langIndicator.TextSize = 12; langIndicator.TextColor3 = Color3.fromRGB(0, 255, 150)
local liCorner = Instance.new("UICorner", langIndicator); liCorner.CornerRadius = UDim.new(0, 4)
local liStroke = Instance.new("UIStroke", langIndicator); liStroke.Color = Color3.fromRGB(60, 60, 60)

-- Dil Butonu
local langBtn = Instance.new("TextButton", titleBar)
langBtn.Size = UDim2.fromOffset(30, 25)
langBtn.Position = UDim2.new(1, -40, 0.5, -12)
langBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
langBtn.Text = "🌐"
langBtn.TextColor3 = Color3.fromRGB(255, 255, 255); langBtn.Font = Enum.Font.GothamBold
local lbCorner = Instance.new("UICorner", langBtn); lbCorner.CornerRadius = UDim.new(0, 4)

local buttonHolder = Instance.new("Frame", window)
buttonHolder.Size = UDim2.new(1, -30, 1, -85)
buttonHolder.Position = UDim2.new(0, 15, 0, 50)
buttonHolder.BackgroundTransparency = 1
local listLayout = Instance.new("UIListLayout", buttonHolder); listLayout.Padding = UDim.new(0, 8)

local status = Instance.new("TextLabel", window)
status.Size = UDim2.new(1, -30, 0, 20); status.Position = UDim2.new(0, 15, 1, -25)
status.BackgroundTransparency = 1; status.Font = Enum.Font.Gotham; status.TextSize = 12; status.TextColor3 = Color3.fromRGB(120, 120, 120); status.TextXAlignment = Enum.TextXAlignment.Left

local function makeButton(text)
    local btn = Instance.new("TextButton", buttonHolder)
    btn.Size = UDim2.new(1, 0, 0, 45); btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Font = Enum.Font.GothamSemibold; btn.TextSize = 14; btn.TextColor3 = Color3.fromRGB(200, 200, 200); btn.Text = text
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local s = Instance.new("UIStroke", btn); s.Color = Color3.fromRGB(40, 40, 40); s.Thickness = 1
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play() end)
    return btn
end

local function makeToggle(offText, onText)
    local btn = makeButton(offText); local isOn = false; local changed = Instance.new("BindableEvent")
    btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        btn.Text = isOn and onText or offText
        TweenService:Create(btn, TweenInfo.new(0.3), {TextColor3 = isOn and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(200, 200, 200)}):Play()
        changed:Fire(isOn)
    end)
    return btn, changed.Event
end

local btnInf, infChanged = makeToggle("Infinite Everything [OFF]", "Infinite Everything [ON]")
local btnB = makeButton("Add Bombs"); local btnGB = makeButton("Add Gold Bombs")
local btnC = makeButton("Add Cash"); local btnS = makeButton("Add Spins"); local btnR = makeButton("Add Revives")

-- Dil Güncelleme Sistemi
local function updateLanguage()
    local L = Languages[currentLangIndex]
    title.Text = L.Title
    langIndicator.Text = L.ID -- Aktif dili burada gösteriyoruz
    btnInf.Text = L.Infinite .. " [OFF]"
    btnB.Text = L.Bombs; btnGB.Text = L.GoldBombs; btnC.Text = L.Cash; btnS.Text = L.Spins; btnR.Text = L.Revives
    status.Text = "Echo X | " .. L.Ready
end

langBtn.MouseButton1Click:Connect(function()
    currentLangIndex = (currentLangIndex % #Languages) + 1
    updateLanguage()
    -- Küçük bir efekt
    langIndicator.TextColor3 = Color3.fromRGB(255, 255, 255)
    task.wait(0.1)
    TweenService:Create(langIndicator, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(0, 255, 150)}):Play()
end)

-- Arka Plan İşlemleri
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 5)
local SpinWheelPrizeEvent = Remotes and Remotes:WaitForChild("SpinWheelPrizeEvent", 5)
local AddRewardEvent = Remotes and Remotes:WaitForChild("AddRewardEvent", 5)

local autoInfinite = false
infChanged:Connect(function(val)
    autoInfinite = val
    if val and SpinWheelPrizeEvent then
        task.spawn(function()
            while autoInfinite do
                for i = 1, 9 do pcall(function() SpinWheelPrizeEvent:FireServer(i) end) end
                task.wait(0.01)
            end
        end)
    end
end)

if AddRewardEvent then
    btnB.MouseButton1Click:Connect(function() pcall(function() AddRewardEvent:FireServer("Bombs", 10) end) end)
    btnGB.MouseButton1Click:Connect(function() pcall(function() AddRewardEvent:FireServer("Gold Bombs", 10) end) end)
    btnC.MouseButton1Click:Connect(function() pcall(function() AddRewardEvent:FireServer("Cash", 999999999999) end) end)
    btnS.MouseButton1Click:Connect(function() pcall(function() AddRewardEvent:FireServer("Spins", 99999999999) end) end)
    btnR.MouseButton1Click:Connect(function() pcall(function() AddRewardEvent:FireServer("Revives", 9999999999) end) end)
end

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == KEYBIND then window.Visible = not window.Visible end
end)

-- Açılış
updateLanguage()
window.Visible = true
