getgenv().ScriptTitle = "🔥NOVIX HUB VIP🔥"
getgenv().ScriptImage = "https://i.ibb.co/ymm3xwwy/1000084884-1-512x512.png"

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer

local CORRECT_KEY = "NOVIXVIP"
local savedKey = nil

pcall(function()
    if isfile("novix_key.txt") then
        savedKey = readfile("novix_key.txt")
    end
end)

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Size = UDim2.new(0,60,0,60)
ToggleBtn.Position = UDim2.new(0,20,0.5,0)
ToggleBtn.Image = getgenv().ScriptImage
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Parent = ScreenGui

local dragging, dragInput, dragStart, startPos
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleBtn.Position
    end
end)

ToggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        ToggleBtn.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0,250,0,240)
MainFrame.Position = UDim2.new(0.5,-125,0.5,-120)
MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0,200,0,40)
KeyBox.Position = UDim2.new(0.5,-100,0,20)
KeyBox.PlaceholderText = "Enter Key..."
KeyBox.Text = savedKey or ""
KeyBox.Parent = MainFrame

local unlocked = false

KeyBox.FocusLost:Connect(function()
    if KeyBox.Text == CORRECT_KEY then
        unlocked = true
        pcall(function()
            writefile("novix_key.txt", KeyBox.Text)
        end)
        KeyBox.Text = "Correct"
    else
        KeyBox.Text = "Wrong"
    end
end)

local antiAFK = false
local afkConn1, afkConn2, afkConn3

function ToggleAFK(state)
    antiAFK = state

    if state then
        local char = player.Character or player.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")
        local hum = char:WaitForChild("Humanoid")

        local pos = root.CFrame

        hum:ChangeState(Enum.HumanoidStateType.Physics)
        hum.AutoRotate = false

        afkConn1 = RunService.Heartbeat:Connect(function()
            root.CFrame = pos
            root.Velocity = Vector3.new(0,0,0)
            root.RotVelocity = Vector3.new(0,0,0)
        end)

        afkConn2 = RunService.Stepped:Connect(function()
            pcall(function()
                sethiddenproperty(player, "SimulationRadius", math.huge)
            end)
        end)

        afkConn3 = player.Idled:Connect(function()
            local vu = game:GetService("VirtualUser")
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end)

        spawn(function()
            while antiAFK do
                task.wait(10)
                pcall(function()
                    VIM:SendKeyEvent(true, Enum.KeyCode.Unknown, false, game)
                    VIM:SendKeyEvent(false, Enum.KeyCode.Unknown, false, game)
                end)
            end
        end)

        spawn(function()
            while antiAFK do
                task.wait(15)
                root.Anchored = true
                task.wait(0.1)
                root.Anchored = false
            end
        end)

    else
        if afkConn1 then afkConn1:Disconnect() end
        if afkConn2 then afkConn2:Disconnect() end
        if afkConn3 then afkConn3:Disconnect() end

        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.AutoRotate = true
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
    end
end

local freeze = false
local freezeConn

function ToggleFreeze(state)
    freeze = state

    if state then
        local char = player.Character or player.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")
        local hum = char:WaitForChild("Humanoid")

        local pos = root.CFrame

        hum.WalkSpeed = 0
        hum.JumpPower = 0
        hum.AutoRotate = false

        freezeConn = RunService.Heartbeat:Connect(function()
            root.CFrame = pos
            root.Velocity = Vector3.new(0,0,0)
            root.RotVelocity = Vector3.new(0,0,0)
        end)
    else
        if freezeConn then freezeConn:Disconnect() end

        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = 16
                hum.JumpPower = 50
                hum.AutoRotate = true
            end
        end
    end
end

local AFKBtn = Instance.new("TextButton")
AFKBtn.Size = UDim2.new(0,200,0,40)
AFKBtn.Position = UDim2.new(0.5,-100,0,80)
AFKBtn.Text = "Anti AFK: OFF"
AFKBtn.Parent = MainFrame

AFKBtn.MouseButton1Click:Connect(function()
    if not unlocked then return end
    antiAFK = not antiAFK
    ToggleAFK(antiAFK)
    AFKBtn.Text = antiAFK and "Anti AFK: ON" or "Anti AFK: OFF"
end)

local FreezeBtn = Instance.new("TextButton")
FreezeBtn.Size = UDim2.new(0,200,0,40)
FreezeBtn.Position = UDim2.new(0.5,-100,0,140)
FreezeBtn.Text = "Freeze: OFF"
FreezeBtn.Parent = MainFrame

FreezeBtn.MouseButton1Click:Connect(function()
    if not unlocked then return end
    freeze = not freeze
    ToggleFreeze(freeze)
    FreezeBtn.Text = freeze and "Freeze: ON" or "Freeze: OFF"
end)
