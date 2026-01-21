--// HARDCORE HUB | TSB
--// Remake by huunhan sc

repeat task.wait() until game:IsLoaded()

-- UI LIB
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("HARDCORE HUB | TSB", "DarkTheme")

-- SERVICES
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- MAIN TAB
local Main = Window:NewTab("Main")
local MainSec = Main:NewSection("Core")

-- FIX LAG
MainSec:NewButton("Fix Lag (Safe)", "Reduce effects", function()
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Trail") then
			v.Enabled = false
		end
	end
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 1e9
end)

-- GRAPHIC LEVELS
local Gfx = Window:NewTab("Graphics")
local GfxSec = Gfx:NewSection("Reduce Graphics")

local function setGfx(level)
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Material = Enum.Material.Plastic
			v.Reflectance = 0
			if level >= 67 then v.CastShadow = false end
		elseif v:IsA("Decal") or v:IsA("Texture") then
			if level >= 36 then v.Transparency = 0.8 end
			if level >= 67 then v.Transparency = 1 end
		end
	end
	if level >= 90 then
		Lighting.Brightness = 0
		Lighting.GlobalShadows = false
	end
end

GfxSec:NewButton("Graphics 36%", "", function() setGfx(36) end)
GfxSec:NewButton("Graphics 67%", "", function() setGfx(67) end)
GfxSec:NewButton("Graphics 90% (MAX FPS)", "", function() setGfx(90) end)

-- MOVESET
local Move = Window:NewTab("Moveset")
local MoveSec = Move:NewSection("Player")

MoveSec:NewSlider("WalkSpeed", "Safe speed", 80, 16, function(v)
	LocalPlayer.Character.Humanoid.WalkSpeed = v
end)

MoveSec:NewSlider("JumpPower", "Safe jump", 120, 50, function(v)
	LocalPlayer.Character.Humanoid.JumpPower = v
end)

-- AUTO BLOCK (SAFE)
local Combat = Window:NewTab("Combat")
local CombatSec = Combat:NewSection("Defense")

local AutoBlock = false
CombatSec:NewToggle("Auto Block (Safe)", "", function(state)
	AutoBlock = state
end)

RunService.RenderStepped:Connect(function()
	if AutoBlock and LocalPlayer.Character then
		local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
		if tool and tool:FindFirstChild("Block") then
			tool.Block:FireServer(true)
		end
	end
end)

-- CREDITS
local Cre = Window:NewTab("Credits")
Cre:NewSection("HARDCORE HUB")
Cre:NewLabel("Remake by: huunhan sc")
Cre:NewLabel("TSB Hardcore Style")
