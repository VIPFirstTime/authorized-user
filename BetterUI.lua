local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ranstart = os.clock()

local Lib = {}
Lib.connections = {}

local ClickInput = (Enum.UserInputType.MouseButton1)
local TouchInput = (Enum.UserInputType.Touch)

local services = setmetatable({}, {
	__index = function(_, k)
	k = (k == "InputService" and "UserInputService") or k
	return game:GetService(k)
	end
})

local client = services.Players.LocalPlayer

local Utility = {}

function Utility.connect(signal, callback)
local connection = signal:Connect(callback)
table.insert(Lib.connections, connection)

return connection
end

function Utility.disconnect(connection)
local index = table.find(Lib.connections, connection)
connection:Disconnect()

if index then
table.remove(Lib.connections, index)
end
end

local touchpoints = {}
local conducting = 0

local hasdragged = false
function Utility.dragify(import,object, dragoutline, stroke, multi)
local start, objectposition, dragging, currentpos

UserInputService.InputBegan:Connect(function(input)
	if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
	conducting = conducting + 1
	touchpoints[conducting] = input
	end
	if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not hasdragged and dragoutline and dragoutline.Visible == true then
	dragoutline.Visible = false; hasdragged = true
	end
	end)

local dragtouch

import.InputBegan:Connect(function(input)
	if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
	dragging = true
	dragtouch = input
	start = input.Position
	if dragoutline then
	dragoutline.Visible = true
	end
	objectposition = object.Position
	end
	end)

Utility.connect(services.InputService.InputChanged, function(input)
	if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
	local input = input
	if multi then
	input = dragtouch
	end
	currentpos = UDim2.new(objectposition.X.Scale, objectposition.X.Offset + (input.Position - start).X, objectposition.Y.Scale, objectposition.Y.Offset + (input.Position - start).Y)
	if dragoutline then
	dragoutline.Position = currentpos
	end
	end
	end)

Utility.connect(services.InputService.InputEnded, function(input)
	if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and dragging then
	dragging = false
	dragtouch = nil
	if dragoutline then
	dragoutline.Visible = false
	end
	object.Position = currentpos
	end
	end)

local Signal
Signal = UserInputService.InputEnded:Connect(function(input)
	if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
	touchpoints[conducting] = nil
	conducting = conducting - 1
	end
	end)

end

function Utility.getcenter(sizeX, sizeY)
return UDim2.new(0.5, -(sizeX / 2), 0.5, -(sizeY / 2))
end

if getgenv and getgenv().ScreenGui_ then
ScreenGui_:Destroy()
end

if getgenv and getgenv().DC_ then
for i, v in pairs(DC_) do
v:Disconnect()
DC_[i] = nil
end
end

getgenv().DC_ = {}

local CProvider = game:GetService("ContentProvider")

local creations = 0

--Window
local BarIn = "rbxassetid://12002282362"
--Bar
local SearchIn = "rbxassetid://12112852615"
local MenuIn = "rbxassetid://11949054349"
local OutIn = "rbxassetid://11949055629"
--Minimized
local IconIn = "rbxassetid://12213561084"
--Scroll
local MoreIn = "rbxassetid://11949185875"
--Features
local TogOn = "rbxassetid://12007342639"
local TogOff = "rbxassetid://12007348679"
local PointerIn = "rbxassetid://12080467938"
local DropIn = "rbxassetid://12080300828"

CProvider:PreloadAsync({
	BarIn,SearchIn,MenuIn,OutIn,IconIn,MoreIn,TogOn,TogOff,DropIn
})

function Lib:Randomized()
local length = math.random(15,30)
local array = {}
local forstart = os.clock()
for i = 1, length do
local ranstart = ranstart-os.clock()
local forstart = forstart-os.clock()
local start = os.clock()
array[i] = string.char(math.random(32, 126))
local calc = (start-os.clock()+ranstart+forstart)*math.random(1871,37129)+os.time()
math.randomseed(calc)
end
return table.concat(array)
end

function Lib:UICorner(instance,num)
local UIC = Instance.new("UICorner")
local num = num or 8
UIC.CornerRadius = UDim.new(0, num)
UIC.Parent = instance
return UIC
end

function Lib:UIPad(instance,num,a,b,c)
local UIP = Instance.new("UIPadding")
UIP.Parent = instance
return UIP
end

function Lib:UIList(instance,num,num2,align)
local UIL = Instance.new("UIListLayout")
local align = align or "Center"
UIL.Padding = UDim.new(num,num2)
UIL.HorizontalAlignment = align
UIL.SortOrder = "LayoutOrder"
UIL.Parent = instance
return UIL
end

local guiInset = game:GetService("GuiService"):GetGuiInset()
function Lib:InScreen(gui)
local pos = gui.AbsolutePosition + guiInset
return pos.X + gui.AbsoluteSize.X <= game.Workspace.CurrentCamera.ViewportSize.X and pos.X >= 0, pos.Y + gui.AbsoluteSize.Y <= game.Workspace.CurrentCamera.ViewportSize.Y and pos.Y >= 0
end

function Lib:Scale(gui,parent)
local parent = parent or gui.Parent
return (gui.AbsoluteSize.X/parent.AbsoluteSize.X), (gui.AbsoluteSize.Y/parent.AbsoluteSize.Y)
end

function Lib:CreateWindow(name,tabnum,winsize)
local name = tostring(name) or "InfiniX"
local func = func or function() end

local hiddenUI = get_hidden_gui or gethui
local protect_gui = protect_gui or (syn and syn.protect_gui) or function() end

local ScreenGui = Instance.new("ScreenGui")

protect_gui(ScreenGui)

if getgenv and getgenv().ScreenGui_ then
ScreenGui_:Destroy()
end
getgenv().ScreenGui_ = ScreenGui
ScreenGui.Name = Lib:Randomized()

if hiddenUI then
ScreenGui.Parent = hiddenUI()
else
	ScreenGui.Parent = CoreGui
end

local iconsize = 0.15
local Icon = Instance.new("ImageButton")
Icon.Visible = false
Icon.Name = "Icon"
Icon.BorderSizePixel = 0
Icon.Image = IconIn
Icon.ImageTransparency = 0
Icon.Active = true
Icon.BackgroundColor3 = Color3.fromRGB(255,255,255)
Icon.Position = UDim2.new(0.105, 0, 0.05, 0)
Icon.AnchorPoint = Vector2.new(0.5,0.5)
Icon.Size = UDim2.new(iconsize, 0, iconsize, 0)
Icon.Transparency = 0
Icon.BackgroundTransparency = 1
Icon.BorderSizePixel = 0
Icon.ZIndex = 10
Icon.SizeConstraint = "RelativeYY"
Icon.Parent = ScreenGui
Icon.Draggable = true
Icon.Selectable = true
Icon.Active = true

local winsize = winsize or 0.49994444444444
local windowsize = UDim2.new(0.41005555555556+winsize, 0, winsize,0)
local windowpos = nil
local Window = Instance.new("Frame")
local WindowBox = Instance.new("Frame")

local ui_minimized = false

local closefunc = function(...) return end
local openfunc = func or closefunc

function OpenRS(time)
local Timer = time or 0.05
local Info = TweenInfo.new(Timer)
local Goal = {}
Goal.Size = windowsize
Goal.Position = windowpos
Tween = TweenService:Create(Window,Info,Goal)
Icon.Visible = false
openfunc()
Tween:Play()
Window.Visible = true
task.wait(Timer)
if not hasdragged then
WindowBox.Visible = true
end
ui_minimized = false
return ui_minimized
end

DC_[#DC_+1] = Icon.MouseButton1Click:Connect(OpenRS)

WindowBox.Active = false
WindowBox.Name = "WindowBox"
WindowBox.BackgroundColor3 = Color3.fromRGB(39,39,39)
WindowBox.Position = UDim2.new(0.5,0,0.5, 0)
WindowBox.AnchorPoint = Vector2.new(0.5,0.5)
WindowBox.Transparency = 0.5
WindowBox.BackgroundTransparency = 0.75
WindowBox.ClipsDescendants = false
WindowBox.BorderColor3 = Color3.fromRGB(100,255,100)
WindowBox.BorderSizePixel = 3.25
WindowBox.BorderMode = "Outline"
WindowBox.SizeConstraint = "RelativeYY"
WindowBox.Size = windowsize
WindowBox.Parent = ScreenGui

local BoxStroke = Instance.new("UIStroke")
BoxStroke.ApplyStrokeMode = "Border"
BoxStroke.LineJoinMode = "Bevel"
BoxStroke.Color = Color3.fromRGB(100,255,100)
BoxStroke.Thickness = 2.5
BoxStroke.Transparency = 0.5
BoxStroke.Enabled = true
BoxStroke.Parent = WindowBox

--Original Size
--Window.Size = UDim2.new(0.38976422764228, 0, 0.49994444444444,0)
Window.Name = "Window"
Window.BackgroundColor3 = Color3.fromRGB(39,39,39)
Window.Position = UDim2.new(0.5,0,0.5, 0)
Window.AnchorPoint = Vector2.new(0.5,0.5)
Window.Size = UDim2.new(0.41005555555556+winsize, 0, winsize,0)
Window.Transparency = 0.5
Window.BorderSizePixel = 0
Window.Draggable = false
Window.ClipsDescendants = false
Window.SizeConstraint = "RelativeYY"
--Window.Size = UDim2.new(0.38976422764228, 0, 0.215,0)
--Window.SizeConstraint = "RelativeXX"
Window.Parent = ScreenGui
Lib:UICorner(Window,10)

local Bar = Instance.new("ImageButton")
Bar.Active = true
Bar.Name = "Bar"
Bar.Image = BarIn
Bar.ImageColor3 = Color3.fromRGB(20,20,20)
Bar.ScaleType = "Crop"
Bar.BackgroundColor3 = Color3.fromRGB(0,0,0)
Bar.Position = UDim2.new(-0,0,-0,0)
Bar.Size = UDim2.new(1, 0, 0.0825, 0)
Bar.Transparency = 0
Bar.BorderSizePixel = 0
Bar.AutoButtonColor = false
Bar.BackgroundTransparency = 1
Bar.Parent = Window
Lib:UICorner(Bar,5)

print (Bar.Size)
warn (Lib:Scale(Bar,Bar.Parent))

local Padding = Instance.new("Frame")
Padding.Visible = SearchUp or false
Padding.Name = "TextBoxPadding"
Padding.BorderSizePixel = 0
Padding.Active = true
Padding.BackgroundColor3 = Color3.fromRGB(50,50,50)
Padding.Position = UDim2.new(0.556, 0, 0.505, 0)
Padding.AnchorPoint = Vector2.new(0.5,0.5)
Padding.Size = UDim2.new(0.54, 0, 0.6, 0)
Padding.Transparency = 0
Padding.BackgroundTransparency = 0
Padding.BorderSizePixel = 0
Padding.ZIndex = 4
Padding.SizeConstraint = "RelativeXY"
Padding.Parent = Bar
Lib:UICorner(Padding,4)

local Textbox = Instance.new("TextBox")
Textbox.Visible = SearchUp or false
Textbox.Name = "TextBox"
Textbox.BorderSizePixel = 0
Textbox.Active = true
Textbox.BackgroundColor3 = Color3.fromRGB(39,39,39)
Textbox.TextColor3 = Color3.fromRGB(255,255,255)
Textbox.Position = UDim2.new(0.564, 0, 0.505, 0)
Textbox.AnchorPoint = Vector2.new(0.5,0.5)
Textbox.Size = UDim2.new(0.54, 0, 0.6, 0)
Textbox.Transparency = 0
Textbox.BackgroundTransparency = 0
Textbox.BorderSizePixel = 0
Textbox.RichText = true
Textbox.Font = "Nunito"
Textbox.TextSize = 10
Textbox.Text = ""
Textbox.PlaceholderText = "Search"
Textbox.ZIndex = 4
Textbox.TextXAlignment = "Left"
Textbox.SizeConstraint = "RelativeXY"
Textbox.Parent = Bar
Lib:UICorner(Textbox,4)

local Base = {}
local Canvas = {}
function MatchSearch()
local matched = false
for i, t in pairs(Base) do
local v = t[1]
local Tab = t[2]
local Container = v.Parent.Parent
local Scroll = v.Parent
local Insert = {
	Scroll.CanvasPosition,Scroll
}
local Found = false
local Position
local Index
for i, v in pairs(Canvas) do
if v[2] == Scroll then
Index = i
Found = true
Position = v[1]
end
end
if string.lower(v.Name):match(Textbox.Text:lower()) and not v.ClassName:match("UI") then
matched = true
v.Visible = true
if not Found then
table.insert(Canvas,Insert)
Scroll.CanvasPosition = Vector2.new(0,0)
elseif Found and Position and Index then
if string.len(Textbox.Text) <= 0 then
Scroll.CanvasPosition = Position
table.remove(Canvas,Index)
if Canvas[Index] then Canvas[Index] = nil end
end
end
elseif Textbox.Text == "" or Textbox.Text == " " and not v.ClassName:match("UI") then
matched = false
Tab.Visible = true
v.Visible = true
if Found and Position then
Scroll.CanvasPosition = Position
table.remove(Canvas,Index)
end
elseif not v.ClassName:match("UI") then
v.Visible = false
end
if matched == false then
Tab.Visible = false
elseif matched == true then
Tab.Visible = true
end
end
end

DC_[#DC_+1] = Textbox:GetPropertyChangedSignal("Text"):Connect(MatchSearch)

local Search = Instance.new("ImageButton")
Search.Visible = true
Search.Name = "Search"
Search.BorderSizePixel = 0
Search.Image = SearchIn
Search.ImageTransparency = 0
Search.Active = true
Search.BackgroundColor3 = Color3.fromRGB(255,255,255)
Search.Position = UDim2.new(0.855, 0, 0.505, 0)
Search.AnchorPoint = Vector2.new(0.5,0.5)
Search.Size = UDim2.new(0.0375, 0, 0.7, 0)
Search.Transparency = 0
Search.BackgroundTransparency = 1
Search.BorderSizePixel = 0
Search.ZIndex = 4
Search.SizeConstraint = "RelativeXY"
Search.Parent = Bar

local Googling = false
DC_[#DC_+1] = Search.MouseButton1Down:Connect(function()
	Googling = true
	end)

DC_[#DC_+1] = Search.MouseButton1Up:Connect(function()
	if Googling == true then
	Padding.Visible = not Padding.Visible
	Textbox.Visible = not Textbox.Visible
	Textbox.Text = ""
--MatchSearch()
	Googling = false
	end
	end)

local Menu = Instance.new("ImageButton")
Menu.Visible = true
Menu.Name = "Menu"
Menu.BorderSizePixel = 0
Menu.Image = MenuIn
Menu.ImageTransparency = 0
Menu.Active = true
Menu.BackgroundColor3 = Color3.fromRGB(255,255,255)
Menu.Position = UDim2.new(0.9025, 0, 0.505, 0)
Menu.AnchorPoint = Vector2.new(0.5,0.5)
Menu.Size = UDim2.new(0.0375, 0, 0.925, 0)
Menu.Transparency = 0
Menu.BackgroundTransparency = 1
Menu.BorderSizePixel = 0
Menu.ZIndex = 4
Menu.SizeConstraint = "RelativeXY"
Menu.Parent = Bar

local Close = Instance.new("ImageButton")
Close.Visible = true
Close.Name = "Close"
Close.BorderSizePixel = 0
Close.Image = OutIn
Close.ImageTransparency = 0
Close.Active = true
Close.BackgroundColor3 = Color3.fromRGB(255,255,255)
Close.Position = UDim2.new(0.95, 0, 0.4925, 0)
Close.AnchorPoint = Vector2.new(0.5,0.5)
Close.Size = UDim2.new(0.0425, 0, 0.9, 0)
Close.Transparency = 0
Close.BackgroundTransparency = 1
Close.BorderSizePixel = 0
Close.ZIndex = 4
Close.SizeConstraint = "RelativeXY"
Close.Parent = Bar

function CloseRS(time)
local Timer = time or 0.05
local Info = TweenInfo.new(Timer)
local Goal = {}
local guiInset = game:GetService("GuiService"):GetGuiInset()
local ISX,ISY = Icon.AbsoluteSize.X, Icon.AbsoluteSize.Y
local DSX,DSY = ISX*0.575,ISY*0.575
local GSX,GSY = ISX+guiInset.X,ISY+guiInset.Y
Goal.Size = UDim2.new(0,ISX*0.75,0,ISY*0.75)
Goal.Position = UDim2.new(0,Icon.AbsolutePosition.X+DSX,0,Icon.AbsolutePosition.Y+DSY)
Tween = TweenService:Create(Window,Info,Goal)
windowpos = Window.Position
closefunc()
WindowBox.Visible = false
Tween:Play()
task.wait(Timer)
Icon.Visible = true
Window.Visible = false
ui_minimized = true
return ui_minimized
end

DC_[#DC_+1] = Close.MouseButton1Click:Connect(CloseRS)

Utility.dragify(Bar,Window,WindowBox,BoxStroke,true)
--[[
local UserInputService = game:GetService("UserInputService")

local gui = Window

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
local delta = input.Position - dragStart
gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Bar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
	dragging = true
	dragStart = input.Position
	startPos = gui.Position

	input.Changed:Connect(function()
		if input.UserInputState == Enum.UserInputState.End then
		dragging = false
		end
		end)
	end
	end)

Bar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
	dragInput = input
	end
	end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
	update(input)
	end
	end)
]]

local Scroll = Instance.new("Frame")
Scroll.Name = "ScrollTab"
Scroll.BackgroundColor3 = Color3.fromRGB(52,52,52)
Scroll.Position = UDim2.new(0.025,0,0.125, 0)
Scroll.Size = UDim2.new(0.21, 0, 0.825,0)
Scroll.Transparency = 0
Scroll.BorderSizePixel = 0
Scroll.Parent = Window

local Categories = Instance.new("ScrollingFrame")
Categories.Active = true
Categories.Name = "Categories"
Categories.BackgroundColor3 = Color3.fromRGB(52,52,52)
Categories.Size = UDim2.new(1, 0, 1, 0)
Categories.Transparency = 1
Categories.BorderSizePixel = 0
Categories.ElasticBehavior = "Never"
Categories.CanvasSize = UDim2.new(0,0,0,0)
Categories.ScrollBarThickness = 2
Categories.ScrollingDirection = "Y"
Categories.ScrollBarImageTransparency = 1
Categories.Parent = Scroll
Lib:UICorner(Scroll,7.5)

local UIPad = Lib:UIPad(Categories)
UIPad.PaddingTop = UDim.new(0,Categories.AbsoluteSize.Y*0.05)
local UIList = Lib:UIList(Categories,0,Categories.AbsoluteSize.Y*0.05)

local Tab_ = {}

local TabTable = {}
local PreviousTab
local ExistingTabs = {}

function Tab_:Minimize(bool,time,yield)
local time = time or 0.2
local function Yield()
repeat task.wait() until ui_minimized == bool
end
if bool then
CloseRS(time)
else
	OpenRS(time)
end;if yield then Yield() end
end

function Tab_:Closing(func)
if type (func) == "function" then else return end
closefunc = func
end

function Tab_:Opening(func)
if type(func) == "function" then else return end
openfunc = func
end

function Tab_:CreateTab(name,func)
local name = tostring(name) or "InfiniX"
local func = func or function() end
local tabnum = tabnum or 1
local tabVis = true

if #ExistingTabs >= tabnum then
tabVis = false
elseif #ExistingTabs < tabnum and PreviousTab then
PreviousTab.Visible = false
end

local TabColor = Color3.fromRGB(65,65,65)
local Tab = Instance.new("TextButton")
Tab.Active = true
Tab.Name = name
Tab.BackgroundColor3 = Color3.fromRGB(65,65,65)
Tab.Position = UDim2.new(0, 0, 0, 0)
Tab.Size = UDim2.new(0.875, 0, 0.145,0)
Tab.Transparency = 0
Tab.Text = ""
Tab.AutoButtonColor = false
Tab.BorderSizePixel = 0
Tab.SizeConstraint = "RelativeXX"
Tab.ZIndex = 2
Tab.Parent = Categories
Lib:UICorner(Tab,5)

if #ExistingTabs < tabnum then
Tab.BackgroundColor3 = Color3.fromRGB(100,100,100)
for i, v in pairs(TabTable) do
if v ~= Tab then
v.BackgroundColor3 = TabColor
end
end
end

table.insert(TabTable,Tab)

local Center = Instance.new("Frame")
Center.Active = false
Center.Name = "Center"
Center.BackgroundColor3 = Color3.fromRGB(255,255,255)
Center.Position = UDim2.new(0.5, 0, 0.1, 0)
Center.AnchorPoint = Vector2.new(0.5,0,0.5,0)
Center.Size = UDim2.new(0.925,0,0.75,0)
Center.Transparency = 0.975
Center.BorderSizePixel = 0
Center.SizeConstraint = "RelativeXY"
Center.ZIndex = 2
Center.Parent = Tab
Lib:UICorner(Center,5)

local Shade = Instance.new("Frame")
Shade.Active = true
Shade.Name = "Shade"
Shade.BackgroundColor3 = Color3.fromRGB(0,0,0)
Shade.Position = UDim2.new(-0.01, 0, 0.075, 0)
Shade.Size = UDim2.new(1, 0, 1,0)
Shade.Transparency = 0.75
Shade.BorderSizePixel = 0
Shade.SizeConstraint = "RelativeXY"
Shade.ZIndex = 1
Shade.Parent = Tab
Lib:UICorner(Shade,5)

local Light = Instance.new("Frame")
Light.Active = true
Light.Name = "Light"
Light.BackgroundColor3 = Color3.fromRGB(255,255,255)
Light.Position = UDim2.new(0, 0, -0.05, 0)
Light.Size = UDim2.new(1, 0, 1,0)
Light.Transparency = 0.9
Light.BorderSizePixel = 0
Light.SizeConstraint = "RelativeXY"
Light.ZIndex = 1
Light.Parent = Tab
Lib:UICorner(Light,5)

Categories.CanvasSize = UDim2.new(0,0,0,UIList.AbsoluteContentSize.Y+UIList.Padding.Offset+Tab.AbsoluteSize.Y*0.75)

local Text = Instance.new("TextLabel")
Text.Name = "Text"
Text.BackgroundColor3 = Color3.fromRGB(0,0,0)
Text.Position = UDim2.new(0.05, 0, 0.2, 0)
Text.Size = UDim2.new(0.9, 0, 0.115,0)
Text.TextScaled = true
Text.Transparency = 0
Text.BackgroundTransparency = 1
Text.TextColor3 = Color3.new(255,255,255)
Text.BorderSizePixel = 0
Text.SizeConstraint = "RelativeXX"
Text.TextSize = 0
Text.RichText = true
Text.Text = name
Text.Font = "Nunito"
Text.ZIndex = 3
Text.Parent = Tab

local Inside = Instance.new("Frame")
Inside.Active = false
Inside.Name = "ScrollFrame"
Inside.BackgroundColor3 = Color3.fromRGB(30,30,30)
Inside.Position = UDim2.new(1.125, 0, 0, 0)
Inside.Size = UDim2.new(3.4, 0, 1,0)
Inside.Transparency = 0
Inside.Visible = tabVis
Inside.BorderSizePixel = 0
Inside.SizeConstraint = "RelativeXY"
Inside.Parent = Scroll
Lib:UICorner(Inside,5)

PreviousTab = Inside
if #ExistingTabs == tabnum-1 then
for i, v in pairs(ExistingTabs) do
Inside.Visible = true
if v ~= Inside then
v.Visible = false
end
end
end

table.insert(ExistingTabs,Inside)

local InScroll = Instance.new("ScrollingFrame")
