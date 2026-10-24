-- Echo X Premium UI — optimized
local Players            = game:GetService("Players")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")
local CoreGui            = game:GetService("CoreGui")

local client  = Players.LocalPlayer
local KEYBIND = Enum.KeyCode.M

-- ---- Constants (hoisted to avoid per-call allocations) -------------------
local COLORS = {
    BG         = Color3.fromRGB(15, 15, 15),
    STROKE     = Color3.fromRGB(45, 45, 45),
    BTN_BG     = Color3.fromRGB(25, 25, 25),
    BTN_HOVER  = Color3.fromRGB(35, 35, 35),
    BTN_STROKE = Color3.fromRGB(40, 40, 40),
    TEXT       = Color3.fromRGB(200, 200, 200),
    TEXT_ON    = Color3.fromRGB(0, 255, 150),
    TEXT_DIM   = Color3.fromRGB(120, 120, 120),
    WHITE      = Color3.fromRGB(255, 255, 255),
    LANG_BG    = Color3.fromRGB(30, 30, 30),
    LANG_BTN   = Color3.fromRGB(40, 40, 40),
    LANG_STRK  = Color3.fromRGB(60, 60, 60),
}

local TWEEN_FAST = TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_MED  = TweenInfo.new(0.30, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- ---- Localization --------------------------------------------------------
local Languages = {
    {ID="TR", Title="Echo X - Sınırsız",  Infinite="Sınırsız Her Şey", Bombs="Bomba Ekle",        GoldBombs="Altın Bomba Ekle", Cash="Para Ekle",       Spins="Çark Ekle",        Revives="Canlanma Ekle", Ready="Hazır"},
    {ID="EN", Title="Echo X - Infinite",  Infinite="Infinite Everything",Bombs="Add Bombs",         GoldBombs="Add Gold Bombs",   Cash="Add Cash",         Spins="Add Spins",        Revives="Add Revives",   Ready="Ready"},
    {ID="ES", Title="Echo X - Infinito",  Infinite="Todo Infinito",      Bombs="Añadir Bombas",     GoldBombs="Bombas de Oro",    Cash="Añadir Dinero",    Spins="Añadir Giros",     Revives="Revivir",       Ready="Listo"},
    {ID="DE", Title="Echo X - Unendlich", Infinite="Alles Unendlich",    Bombs="Bomben Hinzufügen", GoldBombs="Goldbomben",       Cash="Geld Hinzufügen",  Spins="Spins Hinzufügen", Revives="Wiederbeleben", Ready="Bereit"},
    {ID="FR", Title="Echo X - Infini",    Infinite="Tout Infini",        Bombs="Ajouter Bombes",    GoldBombs="Bombes d'Or",      Cash="Ajouter Argent",   Spins="Ajouter Spins",    Revives="Réanimations",  Ready="Prêt"},
}
local currentLangIndex = 1

-- ---- GUI host resolution (CoreGui with PlayerGui fallback) ---------------
local parentGui = CoreGui
do
    local probe = Instance.new("ScreenGui")
    local ok = pcall(function() probe.Parent = CoreGui end)
    probe:Destroy()
    if not ok then
        parentGui = client:WaitForChild("PlayerGui")
    end
end

-- Drop any stale instance from a previous execution
local stale = parentGui:FindFirstChild("EchoX_Premium_UI")
if stale then stale:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name             = "EchoX_Premium_UI"
gui.IgnoreGuiInset   = true
gui.ResetOnSpawn     = false
gui.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
gui.Parent           = parentGui

-- ---- Main window --------------------------------------------------------
local window = Instance.new("Frame")
window.Size             = UDim2.fromOffset(300, 420)
window.Position         = UDim2.new(0.5, -150, 0.5, -210)
window.BackgroundColor3 = COLORS.BG
window.BorderSizePixel  = 0
window.Active           = true
window.Visible          = false
window.Parent           = gui

Instance.new("UICorner", window).CornerRadius = UDim.new(0, 10)
local windowStroke = Instance.new("UIStroke", window)
windowStroke.Color     = COLORS.STROKE
windowStroke.Thickness = 1.5

-- ---- Title bar ----------------------------------------------------------
local titleBar = Instance.new("Frame")
titleBar.Size                   = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundTransparency = 1
titleBar.Parent                 = window

local title = Instance.new("TextLabel")
title.Size             = UDim2.new(1, -80, 1, 0)
title.Position         = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Font             = Enum.Font.GothamBold
title.TextColor3       = COLORS.WHITE
title.TextSize         = 16
title.TextXAlignment   = Enum.TextXAlignment.Left
title.Text             = "Echo X"
title.Parent           = titleBar

local langIndicator = Instance.new("TextLabel")
langIndicator.Size             = UDim2.fromOffset(40, 25)
langIndicator.Position         = UDim2.new(1, -85, 0.5, -12)
langIndicator.BackgroundColor3 = COLORS.LANG_BG
langIndicator.Font             = Enum.Font.GothamBold
langIndicator.TextSize         = 12
langIndicator.TextColor3       = COLORS.TEXT_ON
langIndicator.Parent           = titleBar
Instance.new("UICorner", langIndicator).CornerRadius = UDim.new(0, 4)
local liStroke = Instance.new("UIStroke", langIndicator)
liStroke.Color = COLORS.LANG_STRK

local langBtn = Instance.new("TextButton")
langBtn.Size             = UDim2.fromOffset(30, 25)
langBtn.Position         = UDim2.new(1, -40, 0.5, -12)
langBtn.BackgroundColor3 = COLORS.LANG_BTN
langBtn.Text             = "🌐"
langBtn.TextColor3       = COLORS.WHITE
langBtn.Font             = Enum.Font.GothamBold
langBtn.AutoButtonColor  = false
langBtn.Parent           = titleBar
Instance.new("UICorner", langBtn).CornerRadius = UDim.new(0, 4)

-- ---- Button container ---------------------------------------------------
local buttonHolder = Instance.new("ScrollingFrame")
buttonHolder.Size                 = UDim2.new(1, -30, 1, -85)
buttonHolder.Position             = UDim2.new(0, 15, 0, 50)
buttonHolder.BackgroundTransparency = 1
buttonHolder.BorderSizePixel      = 0
buttonHolder.ScrollBarThickness   = 2
buttonHolder.ScrollBarImageColor3 = COLORS.STROKE
buttonHolder.CanvasSize           = UDim2.new(0, 0, 0, 0)
buttonHolder.AutomaticCanvasSize  = Enum.AutomaticSize.Y
buttonHolder.Parent               = window

local listLayout = Instance.new("UIListLayout")
listLayout.Padding   = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent    = buttonHolder

-- ---- Status bar ---------------------------------------------------------
local status = Instance.new("TextLabel")
status.Size                   = UDim2.new(1, -30, 0, 20)
status.Position               = UDim2.new(0, 15, 1, -25)
status.BackgroundTransparency = 1
status.Font                   = Enum.Font.Gotham
status.TextSize               = 12
status.TextColor3             = COLORS.TEXT_DIM
status.TextXAlignment         = Enum.TextXAlignment.Left
status.Parent                 = window

-- ---- Factory helpers ----------------------------------------------------
local nextLayoutOrder = 0

local function makeButton(text)
    nextLayoutOrder += 1

    local btn = Instance.new("TextButton")
    btn.Size              = UDim2.new(1, 0, 0, 45)
    btn.BackgroundColor3  = COLORS.BTN_BG
    btn.Font              = Enum.Font.GothamSemibold
    btn.TextSize          = 14
    btn.TextColor3        = COLORS.TEXT
    btn.Text              = text
    btn.AutoButtonColor   = false
    btn.LayoutOrder       = nextLayoutOrder
    btn.Parent            = buttonHolder

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local s = Instance.new("UIStroke", btn)
    s.Color     = COLORS.BTN_STROKE
    s.Thickness = 1

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TWEEN_FAST, {BackgroundColor3 = COLORS.BTN_HOVER}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TWEEN_FAST, {BackgroundColor3 = COLORS.BTN_BG}):Play()
    end)

    return btn
end

-- Returns a state object exposing { Button, IsOn, SetText(off, on), Changed }
local function makeToggle(initialOff, initialOn)
    local btn = makeButton(initialOff)

    local state = {
        Button  = btn,
        IsOn    = false,
        OffText = initialOff,
        OnText  = initialOn,
        Changed = Instance.new("BindableEvent"),
    }

    local function refreshText()
        btn.Text = state.IsOn and state.OnText or state.OffText
    end

    btn.MouseButton1Click:Connect(function()
        state.IsOn = not state.IsOn
        refreshText()
        TweenService:Create(btn, TWEEN_MED, {
            TextColor3 = state.IsOn and COLORS.TEXT_ON or COLORS.TEXT,
        }):Play()
        state.Changed:Fire(state.IsOn)
    end)

    function state.SetText(offT, onT)
        state.OffText = offT
        state.OnText  = onT
        refreshText()
    end

    return state
end

-- ---- UI controls --------------------------------------------------------
local toggleInf = makeToggle("Infinite Everything [OFF]", "Infinite Everything [ON]")
local btnB  = makeButton("Add Bombs")
local btnGB = makeButton("Add Gold Bombs")
local btnC  = makeButton("Add Cash")
local btnS  = makeButton("Add Spins")
local btnR  = makeButton("Add Revives")

-- ---- Language switcher --------------------------------------------------
local function updateLanguage()
    local L = Languages[currentLangIndex]
    title.Text          = L.Title
    langIndicator.Text  = L.ID
    toggleInf.SetText(L.Infinite .. " [OFF]", L.Infinite .. " [ON]")
    btnB.Text  = L.Bombs
    btnGB.Text = L.GoldBombs
    btnC.Text  = L.Cash
    btnS.Text  = L.Spins
    btnR.Text  = L.Revives
    status.Text = "Echo X | " .. L.Ready
end

langBtn.MouseButton1Click:Connect(function()
    currentLangIndex = (currentLangIndex % #Languages) + 1
    updateLanguage()

    langIndicator.TextColor3 = COLORS.WHITE
    task.wait(0.1)
    TweenService:Create(langIndicator, TWEEN_MED, {TextColor3 = COLORS.TEXT_ON}):Play()
end)

-- ---- Remote events ------------------------------------------------------
local Remotes              = ReplicatedStorage:WaitForChild("Remotes", 5)
local SpinWheelPrizeEvent  = Remotes and Remotes:WaitForChild("SpinWheelPrizeEvent", 5)
local AddRewardEvent       = Remotes and Remotes:WaitForChild("AddRewardEvent", 5)

-- ---- Infinite loop (race-free via generation counter) -------------------
local infiniteGeneration = 0

toggleInf.Changed:Connect(function(enabled)
    infiniteGeneration += 1
    local myGeneration = infiniteGeneration

    if not enabled or not SpinWheelPrizeEvent then return end

    task.spawn(function()
        while infiniteGeneration == myGeneration do
            for i = 1, 9 do
                local ok, err = pcall(SpinWheelPrizeEvent.FireServer, SpinWheelPrizeEvent, i)
                if not ok then warn("[EchoX] SpinWheelPrizeEvent:", err) end
            end
            task.wait(0.01)
        end
    end)
end)

-- ---- Reward buttons with 100 ms debounce --------------------------------
local function bindReward(button, rewardName, amount)
    if not AddRewardEvent then return end
    local lastClick = 0

    button.MouseButton1Click:Connect(function()
        local now = os.clock()
        if now - lastClick < 0.1 then return end
        lastClick = now

        local ok, err = pcall(AddRewardEvent.FireServer, AddRewardEvent, rewardName, amount)
        if not ok then
            warn(("[EchoX] AddRewardEvent(%s): %s"):format(rewardName, tostring(err)))
        end
    end)
end

bindReward(btnB,  "Bombs",      10)
bindReward(btnGB, "Gold Bombs", 10)
bindReward(btnC,  "Cash",       999999999999)
bindReward(btnS,  "Spins",      99999999999)
bindReward(btnR,  "Revives",    9999999999)

-- ---- Custom drag (replaces deprecated Frame.Draggable) ------------------
do
    local dragging  = false
    local dragStart = nil
    local startPos  = nil

    titleBar.InputBegan:Connect(function(input)
        local t = input.UserInputType
        if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = window.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        local t = input.UserInputType
        if t == Enum.UserInputType.MouseMovement or t == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ---- Keybind ------------------------------------------------------------
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == KEYBIND then
        window.Visible = not window.Visible
    end
end)

-- ---- Boot ---------------------------------------------------------------
updateLanguage()
window.Visible = true
