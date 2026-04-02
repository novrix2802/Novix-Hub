local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local CORRECT_KEY = "NOVIXVIP"
local unlocked = false

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

local function getImage(path,url)
    if getcustomasset then
        if not isfile(path) then
            writefile(path, game:HttpGet(url))
        end
        return getcustomasset(path)
    else
        return url
    end
end

local LOGO = getImage("novixlogo.png","https://i.ibb.co/ymm3xwwy/1000084884-1-512x512.png")

local savedKey = ""
if isfile and readfile then
    if isfile("novix_key.txt") then
        savedKey = readfile("novix_key.txt")
    end
end

local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0,300,0,170)
KeyFrame.Position = UDim2.new(0.5,-150,0.5,-85)
KeyFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
Instance.new("UICorner", KeyFrame)

local stroke = Instance.new("UIStroke", KeyFrame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0,255,170)

local Title = Instance.new("TextLabel", KeyFrame)
Title.Size = UDim2.new(1,0,0.25,0)
Title.Text = "🔐 NOVIX KEY SYSTEM"
Title.BackgroundTransparency = 1
Title.TextScaled = true
Title.TextColor3 = Color3.new(1,1,1)

local Box = Instance.new("TextBox", KeyFrame)
Box.Size = UDim2.new(0.8,0,0.25,0)
Box.Position = UDim2.new(0.1,0,0.35,0)
Box.TextScaled = true
Box.BackgroundColor3 = Color3.fromRGB(25,25,25)
Box.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Box)
Box.Text = savedKey

local Status = Instance.new("TextLabel", KeyFrame)
Status.Size = UDim2.new(1,0,0.15,0)
Status.Position = UDim2.new(0,0,0.6,0)
Status.BackgroundTransparency = 1
Status.TextScaled = true

local Check = Instance.new("TextButton", KeyFrame)
Check.Size = UDim2.new(0.6,0,0.25,0)
Check.Position = UDim2.new(0.2,0,0.75,0)
Check.Text = "Unlock"
Check.TextScaled = true
Check.BackgroundColor3 = Color3.fromRGB(0,255,170)
Check.TextColor3 = Color3.new(0,0,0)
Instance.new("UICorner", Check)

local function shake()
    for i=1,6 do
        KeyFrame.Position = KeyFrame.Position + UDim2.new(0,math.random(-5,5),0,0)
        task.wait(0.03)
    end
end

local function checkKey()
    Status.Text = "Checking..."
    Status.TextColor3 = Color3.fromRGB(255,255,0)
    task.wait(0.4)

    if Box.Text == CORRECT_KEY then
        Status.Text = "Access Granted ✅"
        Status.TextColor3 = Color3.fromRGB(0,255,100)

        unlocked = true
        KeyFrame.Visible = false
        Main.Visible = true

        if writefile then
            writefile("novix_key.txt", Box.Text)
        end
    else
        Status.Text = "Wrong Key ❌"
        Status.TextColor3 = Color3.fromRGB(255,0,0)
        shake()
    end
end

Check.MouseButton1Click:Connect(checkKey)
Box.FocusLost:Connect(function(enter)
    if enter then checkKey() end
end)

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0,300,0,220)
Main.Position = UDim2.new(0.4,0,0.3,0)
Main.BackgroundColor3 = Color3.fromRGB(10,10,10)
Main.Visible = false
Instance.new("UICorner", Main)

local strokeMain = Instance.new("UIStroke", Main)
strokeMain.Thickness = 2

local Title2 = Instance.new("TextLabel", Main)
Title2.Size = UDim2.new(1,0,0.2,0)
Title2.Text = "🔥 NOVIX HUB VIP 🔥"
Title2.BackgroundTransparency = 1
Title2.TextScaled = true
Title2.TextColor3 = Color3.new(1,1,1)

local Toggle = Instance.new("TextButton", Main)
Toggle.Size = UDim2.new(0.8,0,0.25,0)
Toggle.Position = UDim2.new(0.1,0,0.25,0)
Toggle.BackgroundColor3 = Color3.fromRGB(20,20,20)
Toggle.TextScaled = true
Toggle.TextColor3 = Color3.fromRGB(0,255,170)
Toggle.Text = "ANTI AFK ❌"

local FreezeBox = Instance.new("TextButton", Main)
FreezeBox.Size = UDim2.new(0.8,0,0.25,0)
FreezeBox.Position = UDim2.new(0.1,0,0.55,0)
FreezeBox.BackgroundColor3 = Color3.fromRGB(20,20,20)
FreezeBox.Text = "Freeze: OFF"
FreezeBox.TextScaled = true
FreezeBox.TextColor3 = Color3.fromRGB(0,170,255)

local Time = Instance.new("TextLabel", Main)
Time.Size = UDim2.new(0.8,0,0.2,0)
Time.Position = UDim2.new(0.1,0,0.82,0)
Time.BackgroundTransparency = 1
Time.TextScaled = true
Time.TextColor3 = Color3.fromRGB(0,255,170)
Time.Text = "AFK: 00:00"

local afk = false
local freeze = false
local sec = 0

Toggle.MouseButton1Click:Connect(function()
    afk = not afk
    Toggle.Text = "ANTI AFK "..(afk and "✅" or "❌")
end)

FreezeBox.MouseButton1Click:Connect(function()
    freeze = not freeze
    FreezeBox.Text = "Freeze: "..(freeze and "ON" or "OFF")
end)

RunService.Heartbeat:Connect(function()
    if afk then
        pcall(function()
            VIM:SendMouseMoveEvent(0,0,game)
            VIM:SendMouseButtonEvent(0,0,0,true,game,0)
            VIM:SendMouseButtonEvent(0,0,0,false,game,0)
        end)

        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end

        if char and char:FindFirstChild("HumanoidRootPart") then
            if freeze then
                char.HumanoidRootPart.Anchored = true
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        if afk then
            sec += 1
            Time.Text = "AFK: "..string.format("%02d:%02d",math.floor(sec/60),sec%60)
        end
    end
end)

local function drag(obj)
    local d,sp,op
    obj.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then
            d=true sp=i.Position op=obj.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if d then
            local delta=i.Position-sp
            obj.Position = UDim2.new(op.X.Scale, op.X.Offset + delta.X, op.Y.Scale, op.Y.Offset + delta.Y)
        end
    end)
    obj.InputEnded:Connect(function() d=false end)
end

local Open = Instance.new("ImageButton", ScreenGui)
Open.Size = UDim2.new(0,60,0,60)
Open.Position = UDim2.new(0.05,0,0.5,0)
Open.BackgroundColor3 = Color3.fromRGB(0,0,0)
Open.Image = LOGO
Instance.new("UICorner", Open).CornerRadius = UDim.new(1,0)

drag(Open)
drag(Main)

RunService.RenderStepped:Connect(function()
    Open.Rotation += 0.3
end)

task.spawn(function()
    local h=0
    while true do
        h+=0.01
        if h>1 then h=0 end
        strokeMain.Color = Color3.fromHSV(h,1,1)
        task.wait()
    end
end)

Open.MouseButton1Click:Connect(function()
    if not unlocked then
        KeyFrame.Visible = true
    else
        Main.Visible = not Main.Visible
    end
end) 
