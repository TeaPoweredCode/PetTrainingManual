local AddonName, Addon = ...

local AceGUI = Addon.Libs.AceGUI
local Widgets = Addon.UI.Widgets

local L = Addon.Locale

local eTooltipShowFor = Addon.eTooltipShowFor
local eTooltipShowWhen = Addon.eTooltipShowWhen

PetTrainingManual.defaults = {
	sessions = 0,
	tooltipShowFor = eTooltipShowFor.HuntersOnly,
	tooltipShowWhen = eTooltipShowWhen.AllBeasts,
}

local function RegisterCanvas(frame)
	local cat = Settings.RegisterCanvasLayoutCategory(frame, frame.name, frame.name);
	cat.ID = frame.name
	Settings.RegisterAddOnCategory(cat)
end

function PetTrainingManual:InitializeOptions()

	self.panel_main = CreateFrame("Frame")
	self.panel_main.name = "Pet Training Manual"

	self:CreateText({
		text = "Tameable",
		offset = {x=5,y=-5},
		colour = {red=1,green=1,blue=1},
		style = {size = 20}
	})

	----------
	-- Tooltip
	----------
	local BeastTooltipFrame = self:CreateBorderedFrame({
		size = {width=645,height=200},	
		offset = {x=0,y=-30},		
	})
	

	self:CreateText({
		parent = BeastTooltipFrame,
		text = "Beast tooltip",
		offset = {x=10,y=-10}
	})

	self:CreateText({
		text = "Show for:",
		parent = BeastTooltipFrame,
		offset = {x=20,y=-30}
	})

	self:CreateCheckboxGroup({
		parent = BeastTooltipFrame,
		option = "tooltipShowFor",
		optionValues = {
			{value = eTooltipShowFor.HuntersOnly , text = "Hunters only"},
			{value = eTooltipShowFor.AllClasses , text = "All classes"},	
		},
		offset = {x=20,y=-45}
	})

	self:CreateText({
		text = "Show when:",
		parent = BeastTooltipFrame,
		offset = {x=20, y=-95}
	})

	self:CreateCheckboxGroup({
		parent = BeastTooltipFrame,
		option = "tooltipShowWhen",
		optionValues = {
			{value = eTooltipShowWhen.AllBeasts , text = "All beasts with abilities"},
			{value = eTooltipShowWhen.UnlearntAbilities , text = "Only beasts with unlearnt abilities"},
			{value = eTooltipShowWhen.Never , text = "Never"},			
		},
		offset = {x=20,y=-110}
	})

	-- Version
	self:CreateText({
		text = "Built on on Moody's Tamed - https://github.com/moody/Tamed\n" ..
			   "Pet Trainer soruce - https://github.com/TeaPoweredCode/PetTrainer\n" ..
		       "v." .. GetAddOnMetadata("PetTrainingManual", "Version"),
		alignment = "RIGHT",
		location = "BOTTOMRIGHT"
	})

	RegisterCanvas(self.panel_main)
end


function PetTrainingManual:InitializeOptionsNEW()
	local container = Widgets:SimpleGroup({layout = "List"})	
	Widgets:Heading(container,"Hunter's Pet Training Manual")
	self:AddOptions(container)
	Widgets:LineSpacer(container)
	self:AddCredits(container)
	self:RegisterCanvasNEW(container.frame, "Hunter's Pet Training Manual", "HuntersPetTrainingManual")
end


function PetTrainingManual:AddOptions(parent)
	local simpleGroup = Widgets:SimpleGroup({
		height = 520,
		layout = "Fill"
	})
	
	local scrollContainer = AceGUI:Create("ScrollFrame")
	scrollContainer:SetFullWidth(true)
	scrollContainer:SetFullHeight(true)
	

	self:AddToolTipOptions(scrollContainer)
	self:AddToolTipOptions(scrollContainer)
	self:AddToolTipOptions(scrollContainer)
	self:AddToolTipOptions(scrollContainer)
	self:AddToolTipOptions(scrollContainer)
	self:AddToolTipOptions(scrollContainer)

	simpleGroup:AddChild(scrollContainer)
	

	parent:AddChild(simpleGroup)
end

function PetTrainingManual:AddToolTipOptions(parent)

	local BEAST_TOOLTIP = Widgets:InlineGroup({
		parent = parent,
		title = L.BEAST_TOOLTIP,
		fullWidth = true,
		layout = "List"
	})

    Widgets:Label({
		parent = BEAST_TOOLTIP,
		text = L.SHOW_FOR,
		fullWidth = true
	})

	self:CreateCheckboxGroupV({
		parent = BEAST_TOOLTIP,
		groupKey = "tooltipShowFor",
		groupValues = {
			{value = eTooltipShowFor.HuntersOnly , text = "Hunters only"},
			{value = eTooltipShowFor.AllClasses , text = "All classes"},			
		},
	})
	
    Widgets:Label({
		parent = BEAST_TOOLTIP,
		text = L.SHOW_WHEN,
		fullWidth = true
	})

	self:CreateCheckboxGroupV({
		parent = BEAST_TOOLTIP,
		groupKey = "tooltipShowWhen",
		groupValues = {
			{value = eTooltipShowWhen.AllBeasts , text = "All beasts with abilities"},
			{value = eTooltipShowWhen.UnlearntAbilities , text = "Only beasts with unlearnt abilities"},
			{value = eTooltipShowWhen.Never , text = "Never"},			
		},
	})

end


function PetTrainingManual:AddCredits(parent)
    local titleFont, _, titleflasg = GameFontNormal:GetFont()

	local yellow = "|cffffd100 %s |r"
	local tamedURL =  string.format(yellow, "https://github.com/moody/Tamed")
	local hptmURL = string.format(yellow, "https://github.com/TeaPoweredCode/PetTrainer")
	local version = string.format(yellow, GetAddOnMetadata("PetTrainingManual", "Version"))

	local credits = Widgets:Label({
		parent = parent,
		text = string.format(L.CREDITS, tamedURL, hptmURL, version),
		font = {font = titleFont , height = 12 , flags = titleflasg},
		fullWidth = true,
		align = "RIGHT",
	})
end


function PetTrainingManual:RegisterCanvasNEW(frame,text,id)
	local cat = Settings.RegisterCanvasLayoutCategory(frame,text,id)
	cat.ID = id
	Settings.RegisterAddOnCategory(cat)
end


-- a bit more efficient to register/unregister the event when it fires a lot
function PetTrainingManual:UpdateEvent(value, event)
	if value then
		self:RegisterEvent(event)
	else
		self:UnregisterEvent(event)
	end
end


function PetTrainingManual:CreateCheckboxGroupV(data)

	local parent = data.parent
	local groupKey = data.groupKey
	local groupValues = data.groupValues

	print(self.db[groupKey])

	local group = {}
	for _, key in ipairs(groupValues) do

		local cb = Widgets:CheckBox({
			parent = parent,
			text = key.text,
			fullWidth = true,
			groupKey = groupKey,
			value = key.value,
			checked = self.db[groupKey] == key.value,
			OnValueChanged = function(widget, event, value)
				for _, button in ipairs(widget.optionGroup) do
					button:SetValue(button == widget)
				end
				if value then
					self.db[widget.groupKey] = widget.value
				end
			end
		})

		table.insert(group, cb)

	    for i,v in ipairs(group) do
			v.optionGroup = group
		end		

	end

end