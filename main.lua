-- // MateScript for Tvekich
-- // Fly + Noclip GUI (Delta / Xeno)
-- // Fly сделан по системе Infinity Yield (рабочий 100%)

local plr = game.Players.LocalPlayer
local cam = workspace.CurrentCamera
local hrp = plr.Character:WaitForChild("HumanoidRootPart")
local hum = plr.Character:WaitForChild("Humanoid")

local flying = false
local noclip = false
local flySpeed = 2 -- скорость полёта

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
local UICorner = Instance.new("UICorner", Frame)
local Title = Instance.new("TextLabel", Frame)
local FlyBtn = Instance.new("TextButton", Frame)
local NoclipBtn = Instance.new("TextButton", Frame)
local CloseBtn = Instance.new("TextButton", Frame)

ScreenGui.Name = "MateScript_for_Tvekich"

Frame.Size = UDim2.new(0, 240, 0, 170)
Frame.Position = UDim2.new(0.05, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Active = true
Frame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 12)

-- Заголовок
Title.Size = UDim2.new(1, -40, 0, 35)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.Text = "MateScript for Tvekich"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- Fly Button
FlyBtn.Size = UDim2.new(0, 220, 0, 40)
FlyBtn.Position = UDim2.new(0, 10, 0, 50)
FlyBtn.Text = "Fly: OFF"
FlyBtn.TextColor3 = Color3.fromRGB(255,255,255)
FlyBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)

-- Noclip Button
NoclipBtn.Size = UDim2.new(0, 220, 0, 40)
NoclipBtn.Position = UDim2.new(0, 10, 0, 100)
NoclipBtn.Text = "Noclip: OFF"
NoclipBtn.TextColor3 = Color3.fromRGB(255,255,255)
NoclipBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)

-- Close Button (X)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)

-- Infinity Yield Fly функция
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local bodyVel, bodyGyro

local function startFly()
    bodyVel = Instance.new("BodyVelocity")
    bodyVel.Velocity = Vector3.new(0,0,0)
    bodyVel.MaxForce = Vector3.new(9e9,9e9,9e9)
    bodyVel.P = 9e4
    bodyVel.Parent = hrp

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bodyGyro.P = 9e4
    bodyGyro.Parent = hrp

    rs.RenderStepped:Connect(function()
        if flying then
            local dir = Vector3.new()
            if uis:IsKeyDown(Enum.KeyCode.W) then
                dir = dir + cam.CFrame.LookVector
            end
            if uis:IsKeyDown(Enum.KeyCode.S) then
                dir = dir - cam.CFrame.LookVector
            end
            if uis:IsKeyDown(Enum.KeyCode.A) then
                dir = dir - cam.CFrame.RightVector
            end
            if uis:IsKeyDown(Enum.KeyCode.D) then
                dir = dir + cam.CFrame.RightVector
            end
            if uis:IsKeyDown(Enum.KeyCode.Space) then
                dir = dir + Vector3.new(0,1,0)
            end
            if uis:IsKeyDown(Enum.KeyCode.LeftControl) then
                dir = dir - Vector3.new(0,1,0)
            end
            bodyVel.Velocity = dir * (flySpeed * 50)
            bodyGyro.CFrame = cam.CFrame
        end
    end)
end

local function stopFly()
    if bodyVel then bodyVel:Destroy() bodyVel = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
end

-- Fly toggle
local function toggleFly()
    flying = not flying
    if flying then
        startFly()
        FlyBtn.Text = "Fly: ON"
        FlyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        stopFly()
        FlyBtn.Text = "Fly: OFF"
        FlyBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    end
end
FlyBtn.MouseButton1Click:Connect(toggleFly)

-- Noclip toggle
local function toggleNoclip()
    noclip = not noclip
    if noclip then
        NoclipBtn.Text = "Noclip: ON"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        NoclipBtn.Text = "Noclip: OFF"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    end
end
NoclipBtn.MouseButton1Click:Connect(toggleNoclip)

-- Close / Open toggle
local minimized = false
CloseBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        FlyBtn.Visible = false
        NoclipBtn.Visible = false
        Title.Visible = false
        Frame.Size = UDim2.new(0, 240, 0, 40)
        CloseBtn.Text = "+"
    else
        FlyBtn.Visible = true
        NoclipBtn.Visible = true
        Title.Visible = true
        Frame.Size = UDim2.new(0, 240, 0, 170)
        CloseBtn.Text = "X"
    end
end)

-- Noclip logic
rs.Stepped:Connect(function()
    if noclip and plr.Character then
        for _, v in pairs(plr.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end
end)
