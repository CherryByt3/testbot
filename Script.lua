print("my dih is itching ")
print("sybau niya")
print(" test bot ")


getgenv().main = {
    settings = {
        Rapid_firing = true,
        Rapid_Fire_Sec = 0,
        InfAmmo = true,
        InfAmmo_amount = 999999
    }
}

local plr = game.Players.LocalPlayer

task.spawn(function()
    while task.wait(getgenv().main.settings.Rapid_Fire_Sec) do
        if getgenv().main.settings.Rapid_firing then
            local t = plr.Character and plr.Character:FindFirstChildOfClass("Tool")
            if t and t:FindFirstChild("GunScript") then
                for _, c in pairs(getconnections(t.Activated)) do
                    if c.Function then
                        for i = 1, debug.getinfo(c.Function).nups do
                            if type(debug.getupvalue(c.Function, i)) == "number" then
                                debug.setupvalue(c.Function, i, 1e-20)
                            end
                        end
                    end
                end
            end
        end
    end
end)

local function setupGun(gun)
    if not getgenv().main.settings.InfAmmo then return end
    if not gun then return end
    local ammo = gun:FindFirstChild("Ammo")
    if ammo then
        ammo.Value = getgenv().main.settings.InfAmmo_amount
        ammo.Changed:Connect(function()
            if getgenv().main.settings.InfAmmo then
                ammo.Value = getgenv().main.settings.InfAmmo_amount
            end
        end)
    end
end

local function charAdded(char)
    char.ChildAdded:Connect(function(tool)
        if tool:IsA("Tool") then
            setupGun(tool)
        end
    end)
end

plr.CharacterAdded:Connect(charAdded)
if plr.Character then
    charAdded(plr.Character)
end

--\\Trew//--

function Notify(msg, duration)
    Library:Notify({
		Title = "Matrix",
		Description = msg,
		Time = duration,
	})
end
--// Services
local player = game.Players.LocalPlayer
local tweenService = game:GetService("TweenService")
local lighting = game:GetService("Lighting")
local TextChatService = game:GetService("TextChatService")

--// Blur Effect
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Name = "ToggleBlur"

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "BlurToggleGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--// Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 60, 0, 50)
frame.Position = UDim2.new(1, -90, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Active = true
frame.Draggable = true
frame.Visible = true -- Start visible

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

--// Toggle Button
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 44, 0, 24)
button.Position = UDim2.new(0.5, -22, 0.5, -12)
button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
button.Text = "Click!"
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.GothamBold
button.TextSize = 7
button.Parent = frame

local buttonCorner = Instance.new("UICorner", button)
buttonCorner.CornerRadius = UDim.new(0, 6)

--// Tween Info
local blurTweenIn = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local blurTweenOut = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

--// Toggle Logic
local enabled = false
local guiVisible = true -- tracks GUI state from chat commands

button.MouseButton1Click:Connect(function()
	if not guiVisible then return end -- don't toggle if GUI is hidden

	enabled = not enabled

	if enabled then
		button.Text = "Open"
		blur.Size = 0
		blur.Parent = lighting
		tweenService:Create(blur, blurTweenIn, {Size = 24}):Play()

		if Library and typeof(Library.Toggle) == "function" then
			pcall(function()
				Library:Toggle(true)
			end)
		end
	else
		button.Text = "Hide"
		tweenService:Create(blur, blurTweenOut, {Size = 0}):Play()
		task.delay(0.5, function()
			if not enabled then
				blur.Parent = nil
			end
		end)

		if Library and typeof(Library.Toggle) == "function" then
			pcall(function()
				Library:Toggle(false)
			end)
		end
	end
end)

--// Chat Commands for show/hide
TextChatService.OnIncomingMessage = function(message)
	if message.TextSource and message.TextSource.UserId == player.UserId then
		local text = message.Text:lower()
		if text == "/hide" then
			frame.Visible = false
			guiVisible = false
		elseif text == "/show" then
			frame.Visible = true
			guiVisible = true
		end
	end
end

--
local game_name = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
--// Role detection
local role = "FreeUser!!"
if player.Name == "Mllowsz" then
	role = "Owner"
elseif player.Name == "gian1n9" then
	role = "2nd Owner"
elseif player.Name == "unkr12" then
	role = "Director King"
end

--// Load Library and Addons
local repo = "https://raw.githubusercontent.com/CherryByt3/LibraryLoader/main/"
local Library = loadstring(game:HttpGet(repo .. "ModdedLib.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "Addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "Addons/SaveManager.lua"))()

local Options = Library.Options
local ToggleButton = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = false

-- Create window and tabs
local Window = Library:CreateWindow({
	Title = "Matrix",
	Footer = "Player Is : " .. role,
	Icon = 78117064682304,
	Center = true,
	AutoShow = true,
	Resizable = true,
	MobileButtonsSide = "Right",
	NotifySide = "Left",
	ShowCustomCursor = true,
	Font = Enum.Font.Arcade,
	CornerRadius = 2,
})

local Tabs = {
    Main = Window:AddTab("Main", "candy-cane", "test"),
    HvH = Window:AddTab("Ragebot/RageCheat", "bot", "Raging Gang"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

local RageHvH1 = Tabs.HvH:AddLeftGroupbox("RapidFire - Section", "angry")
local RageHvH2 = Tabs.HvH:AddLeftGroupbox("Inf Ammo - Section", "layout-list")
local RageHvH3 = Tabs.HvH:AddRightGroupbox("Hitbox - Sectoin", "box")
local RageHvH4 = Tabs.HvH:AddRightGroupbox("Velocity Fly - Section", "origami")

RageHvH1:AddToggle("Toggle", {
    Text = "Enable_Rapid Fire",
    Default = true,
    Visible = true,
    Risky = true,
    Callback = function(abc)
        getgenv().main.settings.Rapid_firing = abc
    end,
})

RageHvH1:AddInput("InputText", {
    Default = "0",
    Numeric = true,
    Text = "Rapid Fire Delay",
    ClearTextOnFocus = true,
    Callback = function(abc)
        getgenv.main.settings.Rapid_Fire_Sec = abc
    end,
})

RageHvH2:AddToggle("Toggle", {
    Text = "Enable_Inf Ammo",
    Default = true,
    Visible = true,
    Risky = true,
    Callback = function(abc)
        getgenv().main.settings.InfAmmo = abc
    end,
})

RageHvH2:AddInput("InputText", {
    Default = "999999",
    Numeric = true,
    Text = "Ammo Amount",
    ClearTextOnFocus = true,
    Callback = function(abc)
        getgenv.main.settings.InfAmmo_amount = abc
    end,
})

RageHvH3:AddToggle("Custom", {
    Text = "Hitbox",
    Default = false,
    Callback = function(value)
        getgenv().HitboxConfig.Enabled = value
    end
}):AddColorPicker("ColorPicker1", {
	Default = Color3.new(0, 150, 255),
	Title = "Some color1",
	Transparency = 0,
	Callback = function(Value)
		getgenv().HitboxConfig.Color = Value
	end,
})

RageHvH3:AddToggle("Custom", {
    Text = "Hitbox Outline",
    Default = false,
    Callback = function(value)
        getgenv().HitboxConfig.OutlineEnabled = value
    end
}):AddColorPicker("ColorPicker1", {
	Default = Color3.new(0, 255, 255),
	Title = "Some color1",
	Transparency = 0,
	Callback = function(Value)
		getgenv().HitboxConfig.OutlineColor = Value
	end,
})

RageHvH3:AddInput("MyTextbox", {
	Default = "10",
	Numeric = false,
	Finished = false,
	ClearTextOnFocus = true,
	Text = "Hitbox Size",
	Tooltip = "Put the Exact number u want",
	Placeholder = "",
	Callback = function(Value)
	    getgenv().HitboxConfig.Size = tonumber(Value)
    end,
})

RageHvH3:AddInput("MyTextbox", {
	Default = "2",
	Numeric = false,
	Finished = false,
	ClearTextOnFocus = true,
	Text = "Refresh Time [ Hitbox ]",
	Tooltip = "Put the Exact number u want",
	Placeholder = "",
	Callback = function(Value)
	    getgenv().HitboxConfig.RefreshTime = tonumber(Value)
    end,
})

RageHvH3:AddInput("MyTextbox", {
	Default = "0.5",
	Numeric = false,
	Finished = false,
	ClearTextOnFocus = true,
	Text = "Hitbox Transparency",
	Tooltip = "Put the Exact number u want",
	Placeholder = "",
	Callback = function(Value)
	    getgenv().HitboxConfig.Transparency = tonumber(Value)
    end,
})

RageHvH3:AddInput("MyTextbox", {
	Default = "0.2",
	Numeric = false,
	Finished = false,
	ClearTextOnFocus = true,
	Text = "Hitbox Outline Transparency",
	Tooltip = "Put the Exact number u want",
	Placeholder = "",
	Callback = function(Value)
	    getgenv().HitboxConfig.OutlineTransparency = tonumber(Value)
    end,
})

RageHvH3:AddDropdown("ForceMaterial", {
    Values = { "ForceField", "Plastic", "Neon", "Glass", "SmoothPlastic", "Ice" },
    Default = "ForceField",
    Multi = false,
    Text = "Material",
    Tooltip = "Pick a material for the forcefield",
    DisabledTooltip = "Forcefield is disabled",
    Searchable = false,
    Callback = function(Value)
        getgenv().HitboxConfig.Material = Value
    end,
    Disabled = false,
    Visible = true,
})


RageHvH4:AddLabel("Use /hide2 and /show2")

RageHvH1:AddButton("Hi",{
	Text = "Button",
	Func = function()
		local TriggerAlreadyLoaded = false

if TriggerAlreadyLoaded then
    Notify("Already Loaded", 3.5)
   return
end

local player = game.Players.LocalPlayer
local auto_shooting = false

--// GUI
local ShootGui = Instance.new("ScreenGui")
ShootGui.Name = "TriggerBotUI"
ShootGui.ResetOnSpawn = false -- GUI won’t reset when you respawn
ShootGui.IgnoreGuiInset = true
ShootGui.Parent = game:GetService("CoreGui")

local ShootFrame = Instance.new("Frame")
ShootFrame.Size = UDim2.new(0, 120, 0, 60)
ShootFrame.Position = UDim2.new(0.5, -60, 0.5, -30)
ShootFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ShootFrame.BorderSizePixel = 0
ShootFrame.Active = true
ShootFrame.Draggable = true
ShootFrame.Parent = ShootGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = ShootFrame

local ShootButton = Instance.new("TextButton")
ShootButton.Size = UDim2.new(0, 100, 0, 40)
ShootButton.Position = UDim2.new(0.5, -50, 0.5, -20)
ShootButton.Text = "Triggerbot: OFF"
ShootButton.TextScaled = true
ShootButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ShootButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ShootButton.BackgroundTransparency = 0.5
ShootButton.BorderSizePixel = 0
ShootButton.Parent = ShootFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 10)
btnCorner.Parent = ShootButton

--// Toggle
local function toggleAutoShoot()
    auto_shooting = not auto_shooting
    ShootButton.Text = auto_shooting and "Triggerbot: ON" or "Triggerbot: OFF"
end
ShootButton.MouseButton1Click:Connect(toggleAutoShoot)

--// Auto fire
local function AutoShoot()
    local char = player.Character
    if not char then return end

    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
        -- If Activate() does nothing, replace with gun Remote later
    end
end


--// Loop
game:GetService("RunService").Heartbeat:Connect(function()
    if auto_shooting then
        AutoShoot()
    end
end)

TriggerAlreadyLoaded = true
load()
	end,
	DoubleClick = false,
	Disabled = false,
	Visible = true,
	Risky = false,
})


RageHvH4:AddToggle("Toggle", {
    Text = "Enable_Velocity Fly",
    Default = false,
    Visible = true,
    Risky = true,
    Callback = function(abc)
        getgenv().FlySettings.Enabled = abc
    end,
})

RageHvH4:AddInput("InputText", {
    Default = "150",
    Numeric = true,
    Text = "XSpeed - Fly",
    ClearTextOnFocus = true,
    Callback = function(abc)
        getgenv().FlySettings.Speed = abc
    end,
})

RageHvH4:AddInput("InputText", {
    Default = "50",
    Numeric = true,
    Text = "YSpeed - Fly",
    ClearTextOnFocus = true,
    Callback = function(abc)
        getgenv().FlySettings.YSpeed = abc
    end,
})

-- UI Settings Group
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu", "wrench")

MenuGroup:AddToggle("KeybindMenuOpen", {
	Default = Library.KeybindFrame.Visible,
	Text = "Open Keybind Menu",
	Callback = function(value)
		Library.KeybindFrame.Visible = value
	end,
})

MenuGroup:AddToggle("ShowCustomCursor", {
	Text = "Custom Cursor",
	Default = true,
	Callback = function(Value)
		Library.ShowCustomCursor = Value
	end,
})

MenuGroup:AddToggle("ShowCustomCursor", {
	Text = "Watermark",
	Default = false,
	Callback = function(Value)
		Library:SetWatermarkVisibility(Value)
	end,
})

MenuGroup:AddDropdown("NotificationSide", {
	Values = { "Left", "Right" },
	Default = "Left",
	Text = "Notification Side",
	Callback = function(Value)
		Library:SetNotifySide(Value)
	end,
})

MenuGroup:AddDropdown("DPIDropdown", {
	Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
	Default = "100%",
	Text = "DPI Scale",
	Callback = function(Value)
		Value = Value:gsub("%%", "")
		local DPI = tonumber(Value)
		Library:SetDPIScale(DPI)
	end,
})

MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
	:AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })

MenuGroup:AddButton("Unload", function()
	Library:Unload()
end)

-- Sets the watermark visibility
Library:SetWatermarkVisibility(false)

-- Watermark updater
local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60

game:GetService("RunService").RenderStepped:Connect(function()
	FrameCounter += 1
	if (tick() - FrameTimer) >= 1 then
		FPS = FrameCounter
		FrameTimer = tick()
		FrameCounter = 0
	end

	Library:SetWatermark(('Manta.wtf | %s fps | %s ms'):format(
		math.floor(FPS),
		math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
	))
end)

-- Enable/disable the custom cursor
Library.ShowCustomCursor = true
Library.ToggleKeybind = Options.MenuKeybind

-- Theme/Config setup
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("Manta/themes")
SaveManager:SetFolder("Manta/config")
SaveManager:SetSubFolder("config")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()


-- Library:SetDPIScale(100)
-- Force library open at start
Library:Toggle(true)
blur.Size = 0
blur.Parent = lighting
tweenService:Create(blur, blurTweenIn, {Size = 24}):Play()

-- Hitnox ° --
getgenv().HitboxConfig = {
    Enabled = false, -- Toggle on/off
    Size = 10,
    RefreshTime = 2,
    Transparency = 0.5, -- Fully invisible box
    Color = Color3.fromRGB(0, 150, 255), -- Ignored when Transparency=1
    Material = "Plastic", -- USE STRING HERE
    OutlineEnabled = false, -- Toggle outline
    OutlineColor = Color3.fromRGB(0,255,255), -- Navy blue
    OutlineTransparency = 0, -- 0 = opaque
    OutlineThickness = 0.05 -- Outline thickness
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Helper to convert string to Enum.Material
local function GetMaterial(materialName)
    local enumValue = Enum.Material[materialName]
    if enumValue then
        return enumValue
    else
        warn("[Hitbox] Invalid material name:", materialName)
        return Enum.Material.Plastic
    end
end

local appliedPlayers = {}

local function ApplyOrRemoveHitbox(Player)
    if Player == LocalPlayer then return end
    local character = Player.Character
    if not character then return end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if getgenv().HitboxConfig.Enabled then
        root.Size = Vector3.new(
            getgenv().HitboxConfig.Size,
            getgenv().HitboxConfig.Size,
            getgenv().HitboxConfig.Size
        )
        root.Transparency = getgenv().HitboxConfig.Transparency
        root.CanCollide = false
        root.Material = GetMaterial(getgenv().HitboxConfig.Material)
        root.Color = getgenv().HitboxConfig.Color
        appliedPlayers[Player] = true

        -- Outline
        local box = root:FindFirstChild("SelectionBox")
        if getgenv().HitboxConfig.OutlineEnabled then
            if not box then
                box = Instance.new("SelectionBox")
                box.Name = "SelectionBox"
                box.Adornee = root
                box.Parent = root
            end
            box.Color3 = getgenv().HitboxConfig.OutlineColor
            box.SurfaceColor3 = Color3.new(0,0,0)
            box.SurfaceTransparency = 1
            box.LineThickness = getgenv().HitboxConfig.OutlineThickness
        elseif box then
            box:Destroy()
        end
    else
        if appliedPlayers[Player] then
            root.Size = Vector3.new(2,2,1)
            root.Transparency = 1
            root.CanCollide = true
            root.Material = Enum.Material.Plastic
            local box = root:FindFirstChild("SelectionBox")
            if box then box:Destroy() end
            appliedPlayers[Player] = nil
        end
    end
end

-- ♻️ Loop
task.spawn(function()
    while true do
        for _,player in ipairs(Players:GetPlayers()) do
            ApplyOrRemoveHitbox(player)
        end
        task.wait(getgenv().HitboxConfig.RefreshTime)
    end
end)

-- Handle new players
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        ApplyOrRemoveHitbox(player)
    end)
end)

-- Handle respawns
for _,player in ipairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function()
        task.wait(1)
        ApplyOrRemoveHitbox(player)
    end)
end

-- vel fly
--// SERVICES
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local player = Players.LocalPlayer

--// CHARACTER & CAMERA
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")
local camera = workspace.CurrentCamera
camera.CameraType = Enum.CameraType.Custom

--// SETTINGS
getgenv().FlySettings = {
    Enabled = false,
    Speed = 150,
    YSpeed = 50,
    YMultiplier = 1,
    LockY = false,
    BodyFollow = false,
    UpHeld = false,
    DownHeld = false,
    InputVector = Vector3.zero
}

getgenv().FlyGUIVisible = true -- controls GUI visibility

--// BODYVELOCITY
local velocityControl = Instance.new("BodyVelocity")
velocityControl.Name = "FlyVelocity"
velocityControl.MaxForce = Vector3.zero
velocityControl.Velocity = Vector3.zero
velocityControl.P = 10000
local currentVelocity = Vector3.zero
local lerpSpeed = 5
local lastLookDir = Vector3.new(0,0,-1)

--// CAMERA UPDATE
local function updateCamera()
    local character = player.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    camera.CameraSubject = character:FindFirstChildOfClass("Humanoid") or rootPart
end

player.CharacterAdded:Connect(function()
    task.wait(0.1)
    char = player.Character
    root = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
    updateCamera()
end)
updateCamera()

--// GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FlyControlGui"
gui.ResetOnSpawn = false
gui.Enabled = getgenv().FlyGUIVisible

local function updateGUIVisibility()
    gui.Enabled = getgenv().FlyGUIVisible
end

local function createBtn(text, posY)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0,100,0,50)
    b.Position = UDim2.new(1,-110,0,posY)
    b.AnchorPoint = Vector2.new(0,0)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.TextColor3 = Color3.new(1,1,1)
    b.AutoButtonColor = true
    b.Draggable = true
    b.Parent = gui
    return b
end

local upBtn = createBtn("↑",100)
local downBtn = createBtn("↓",170)

-- Touch support for mobile
local function setupTouchButton(button,key)
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            getgenv().FlySettings[key] = true
        end
    end)
    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            getgenv().FlySettings[key] = false
        end
    end)
end

setupTouchButton(upBtn,"UpHeld")
setupTouchButton(downBtn,"DownHeld")

--// JOYSTICK
local joystickTouch = nil
local joystickStart = nil

UIS.TouchStarted:Connect(function(input)
    if getgenv().FlySettings.Enabled and not joystickTouch then
        local screen = camera.ViewportSize
        if input.Position.X < screen.X/2 then
            joystickTouch = input
            joystickStart = input.Position
        end
    end
end)

UIS.TouchMoved:Connect(function(input)
    if getgenv().FlySettings.Enabled and input == joystickTouch then
        local delta = input.Position - joystickStart
        local maxRadius = 100
        if delta.Magnitude > maxRadius then
            delta = delta.Unit * maxRadius
        end
        getgenv().FlySettings.InputVector = Vector3.new(delta.X/maxRadius,0,delta.Y/maxRadius)
    end
end)

UIS.TouchEnded:Connect(function(input)
    if getgenv().FlySettings.Enabled and input == joystickTouch then
        joystickTouch = nil
        getgenv().FlySettings.InputVector = Vector3.zero
    end
end)

--// CHAT COMMANDS
TextChatService.OnIncomingMessage = function(msg)
    if msg.TextSource and msg.TextSource.UserId == player.UserId then
        local text = msg.Text:lower()
        if text == "/hide2" then
            getgenv().FlyGUIVisible = false
            gui.Enabled = false
        elseif text == "/show2" then
            getgenv().FlyGUIVisible = true
            gui.Enabled = true
        end
    end
end

--// RENDER LOOP
RS.RenderStepped:Connect(function(dt)
    if not root or not humanoid then return end

    if getgenv().FlySettings.Enabled then
        local camCF = camera.CFrame
        local camRight = Vector3.new(camCF.RightVector.X,0,camCF.RightVector.Z).Unit
        local camForward = Vector3.new(camCF.LookVector.X,0,camCF.LookVector.Z).Unit

        local moveDir = Vector3.zero
        if getgenv().FlySettings.InputVector.Magnitude > 0.1 then
            moveDir = (camRight * getgenv().FlySettings.InputVector.X + camForward * -getgenv().FlySettings.InputVector.Z).Unit
            local targetVelocity = moveDir * getgenv().FlySettings.Speed * getgenv().FlySettings.InputVector.Magnitude
            currentVelocity = currentVelocity:Lerp(targetVelocity, math.clamp(lerpSpeed * dt,0,1))

            if getgenv().FlySettings.BodyFollow then
                lastLookDir = lastLookDir:Lerp(moveDir, math.clamp(lerpSpeed*dt,0,1))
                root.CFrame = CFrame.lookAt(root.Position, root.Position + lastLookDir)
            end
        else
            currentVelocity = currentVelocity:Lerp(Vector3.zero, math.clamp(lerpSpeed*dt,0,1))
        end

        local finalY = 0
        if getgenv().FlySettings.UpHeld then
            finalY = getgenv().FlySettings.YSpeed * getgenv().FlySettings.YMultiplier
        elseif getgenv().FlySettings.DownHeld then
            finalY = -getgenv().FlySettings.YSpeed * getgenv().FlySettings.YMultiplier
        elseif getgenv().FlySettings.LockY then
            finalY = 0
        end

        velocityControl.MaxForce = Vector3.new(1e9,1e9,1e9)
        velocityControl.Velocity = Vector3.new(currentVelocity.X, finalY, currentVelocity.Z)
        if not velocityControl.Parent then
            velocityControl.Parent = root
        end
    else
        velocityControl.Velocity = Vector3.zero
        velocityControl.Parent = nil
        currentVelocity = Vector3.zero
        getgenv().FlySettings.UpHeld = false
        getgenv().FlySettings.DownHeld = false
    end
end)

--
task.wait(1)
Notify("Loaded In " .. game_name, 5)

