local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Primary = Instance.new("ScreenGui")
Primary.Name = "Primary"
Primary.Parent = playerGui

local Secondary = Instance.new("ScreenGui")
Secondary.Name = "Secondary"
Secondary.Parent = playerGui

local gui = {
	Primary = Primary,
	Secondary = Primary,
}

_G.gui = gui

local preset = {
	id = "baseGui",

	subClasses = {
		["Window"] = {
			className = "Frame",
			properties = {
				["AnchorPoint"] = Vector2.new(0.5, 0.5),
				["Size"] = UDim2.new(0.5, 0, 0.75, 0),
				["Position"] = UDim2.new(0.5, 0, 0.5, 0),
				["BackgroundTransparency"] = 0.125,
				["BackgroundColor3"] = Color3.fromRGB(25, 25, 25),
				["Parent"] = gui.Secondary,
				["Visible"] = false,
			},
			children = {
				{ -- Title
					className = "TextLabel",
					properties = {
						["Name"] = "Title",
						["AnchorPoint"] = Vector2.new(0.5, 0),
						["Size"] = UDim2.new(1, -20, 0.125, -15),
						["Position"] = UDim2.new(0.5, 0, 0, 10),
						["BackgroundTransparency"] = 1,
						["Text"] = "Title",
						["TextScaled"] = true,
						["TextColor3"] = Color3.new(1, 1, 1),
					},
				},
				{ -- Content
					className = "Frame",
					properties = {
						["Name"] = "Content",
						["AnchorPoint"] = Vector2.new(0.5, 1),
						["Size"] = UDim2.new(1, -20, 0.875, -15),
						["Position"] = UDim2.new(0.5, 0, 1, -10),
						["BackgroundTransparency"] = 1,
						["ClipsDescendants"] = true,
					},
					children = {
						--Scrolling Frame
						{
							className = "ScrollingFrame",
							properties = {
								["AnchorPoint"] = Vector2.new(0.5, 0.5),
								["Position"] = UDim2.new(0.5, 0, 0.5, 0),
								["CanvasSize"] = UDim2.new(0, 0, 0, 0),
								["Size"] = UDim2.new(1, -10, 1, -10),
								["BackgroundTransparency"] = 1,
								["ScrollBarThickness"] = 10,
								["BottomImage"] = "",
								["TopImage"] = "",
								["BorderSizePixel"] = 0,
								["ClipsDescendants"] = false,
							},
							children = {
								{
									className = "UIGridLayout",
									properties = {
										["CellSize"] = UDim2.new(0.1, -5, 0.1, -5),
									},
								},
							},
						},
					},
				},
				{ -- Close
					className = "TextButton",
					properties = {
						["Name"] = "Close",
						["AnchorPoint"] = Vector2.new(0.5, 0.5),
						["Size"] = UDim2.new(0.1, 0, 0.1, 0),
						["Position"] = UDim2.new(1, 0, 0, 0),
						["Text"] = "X",
						["TextScaled"] = true,
						["BackgroundColor3"] = Color3.fromRGB(230, 0, 0),
						["TextColor3"] = Color3.new(0, 0, 0),
					},
					children = {
						{
							className = "UIAspectRatioConstraint",
						},
						{
							className = "UICorner",
							properties = {
								["CornerRadius"] = UDim.new(0, 5),
							},
						},
						{
							className = "UIStroke",
							properties = {
								["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border,
								["Color"] = Color3.new(1, 1, 1),
								["Thickness"] = 1.5,
								["Transparency"] = 0.2,
							},
						},
					},
				},
				-- UI Elements
				{
					className = "UIStroke",
					properties = {
						["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border,
						["Color"] = Color3.new(1, 1, 1),
						["Thickness"] = 3.5,
						["Transparency"] = 0.2,
					},
				},
				{
					className = "UICorner",
					properties = {
						["CornerRadius"] = UDim.new(0, 5),
					},
				},
			},
		},
		["Sidebar"] = {
			className = "Frame",
			properties = {
				["AnchorPoint"] = Vector2.new(0.5, 0.5),
				["Size"] = UDim2.new(0.1, 0, 0.2, 0),
				["Position"] = UDim2.new(1, 0, 0.5, 0),
				["BackgroundTransparency"] = 0.45,
				["BackgroundColor3"] = Color3.fromRGB(25, 25, 25),
				["Parent"] = gui.Secondary,
				["Visible"] = false,
			},
			children = {
				{ -- Content
					className = "Frame",
					properties = {
						["Name"] = "Content",
						["AnchorPoint"] = Vector2.new(1, 0),
						["Size"] = UDim2.new(0.5, 0, 1, 0),
						["Position"] = UDim2.new(0.4, 0, 0, 0),
						["BackgroundTransparency"] = 1,
						["ClipsDescendants"] = false,
					},
					children = {
						{
							className = "TextButton",
							properties = {
								["Name"] = "ButtonPreset",
								["AnchorPoint"] = Vector2.new(0.5, 0.5),
								["Size"] = UDim2.new(1, 0, 1, 0),
								["BackgroundTransparency"] = 0.15,
								["BackgroundColor3"] = Color3.fromRGB(25, 25, 25),
								["Text"] = "",
								["TextScaled"] = true,
								["TextColor3"] = Color3.new(1, 1, 1),
								["Visible"] = false, --Preset
							},
							children = {
								{
									className = "UIAspectRatioConstraint",
								},
								{
									className = "UICorner",
									properties = {
										["CornerRadius"] = UDim.new(0, 10),
									},
								},
								{
									className = "UIStroke",
									properties = {
										["Transparency"] = 0.1,
										["Thickness"] = 3.5,
										["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border,
										["Enabled"] = false,
										["Color"] = Color3.new(1, 1, 1),
									},
								},
							},
						},
						{
							className = "UIListLayout",
							properties = {
								["Padding"] = UDim.new(0, 5),
								["VerticalAlignment"] = Enum.VerticalAlignment.Center,
								["SortOrder"] = Enum.SortOrder.LayoutOrder,
							},
						},
					},
				},
				-- UI Elements
				{
					className = "UICorner",
					properties = {
						["CornerRadius"] = UDim.new(0, 5),
					},
				},
			},
		},
		["Slot"] = {
			className = "TextButton",
			properties = {
				["AnchorPoint"] = Vector2.new(0.5, 0.5),
				["Size"] = UDim2.new(0.5, 0, 0.5, 0),
				["Position"] = UDim2.new(0.5, 0, 0.5, 0),
				["BackgroundTransparency"] = 0.125,
				["BackgroundColor3"] = Color3.fromRGB(25, 25, 25),
				["Text"] = "",
			},
			children = {
				{ -- Content
					className = "Frame",
					properties = {
						["Name"] = "Content",
						["AnchorPoint"] = Vector2.new(0.5, 0.5),
						["Size"] = UDim2.new(1, -5, 0.875, -5),
						["Position"] = UDim2.new(0.5, 0, 0.5, 0),
						["BackgroundTransparency"] = 1,
						["ClipsDescendants"] = true,
					},
					children = {
						--Text
						{
							className = "TextLabel",
							properties = {
								["Name"] = "Label",
								["BackgroundTransparency"] = 1,
								["Text"] = "",
								["AnchorPoint"] = Vector2.new(0.5, 0.5),
								["Size"] = UDim2.new(1, 0, 1, 0),
								["Position"] = UDim2.new(0.5, 0, 0.5, 0),
								["TextScaled"] = true,
								["TextColor3"] = Color3.new(1, 1, 1),
							},
						},
						--Viewport
						{
							className = "ViewportFrame",
							properties = {
								["Name"] = "Viewport",
								["Size"] = UDim2.new(1, 0, 1, 0),
								["BackgroundTransparency"] = 1,
							},
							children = {
								{
									className = "Camera",
									properties = {},
								},
							},
						},
					},
				},
				-- UI Elements
				{
					className = "UIStroke",
					properties = {
						["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border,
						["Color"] = Color3.new(1, 1, 1),
						["Thickness"] = 1,
						["Transparency"] = 0.25,
					},
				},
				{
					className = "UICorner",
					properties = {
						["CornerRadius"] = UDim.new(0, 5),
					},
				},
			},
		},
	},
}

return preset