local _, Addon = ...
local DB = Addon.DB
local L = Addon.Locale

local eTooltipShowFor = Addon.ENUMS.eTooltipShowFor
local eTooltipShowWhen = Addon.ENUMS.eTooltipShowWhen

local MinimapIcon = Addon.UI.MinimapIcon
local Options = Addon.UI.Options
local Widgets = Addon.UI.Widgets

function Options:Init()
	local container = Widgets:SimpleGroup({layout = "List"})	
	Widgets:Heading(container,"Hunter's Pet Training Manual")
	self:AddOptions(container)
	Widgets:LineSpacer(container)
	self:AddCredits(container)
	self:RegisterCanvas(container.frame, "Hunter's Pet Training Manual", "HuntersPetTrainingManual")
end

function Options:AddOptions(parent)
	
	local simpleGroup = Widgets:SimpleGroup({
		height = 520,
		layout = "Fill"
	})
	
	local scrollContainer = AceGUI:Create("ScrollFrame")
	scrollContainer:SetFullWidth(true)
	scrollContainer:SetFullHeight(true)
	self:AddToolTipOptions(scrollContainer)


	simpleGroup:AddChild(scrollContainer)
	

	parent:AddChild(simpleGroup)
end

function Options:AddToolTipOptions(parent)

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

	self:CreateCheckboxGroup({
		parent = BEAST_TOOLTIP,
		setting = {
			domain = "global",
			category = "tooltip",
			key = "showFor",
			values = {
				{value = eTooltipShowFor.HuntersOnly , text = "Hunters only"},
				{value = eTooltipShowFor.AllClasses , text = "All classes"},	
			}
		}
	})


  	Widgets:Label({
		parent = BEAST_TOOLTIP,
		text = L.SHOW_WHEN,
		fullWidth = true
	})

	self:CreateCheckboxGroup({
		parent = BEAST_TOOLTIP,
		setting = {
			domain = "global",
			category = "tooltip",
			key = "showWhen",
			values = {
				{value = eTooltipShowWhen.AllBeasts , text = "All beasts with abilities"},
				{value = eTooltipShowWhen.UnlearntAbilities , text = "Only beasts with unlearnt abilities"},
				{value = eTooltipShowWhen.Never , text = "Never"},	
			}
		}
	})


end

function Options:AddCredits(parent)
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

function Options:RegisterCanvas(frame,text,id)
	local cat = Settings.RegisterCanvasLayoutCategory(frame,text,id)
	cat.ID = id
	Settings.RegisterAddOnCategory(cat)
end

function Options:CreateCheckboxGroup(data)

	local parent = data.parent
	local setting = data.setting

	local group = {}
	for _, key in ipairs(setting.values) do

		local cb = Widgets:CheckBox({
			parent = parent,
			text = key.text,
			fullWidth = true,
			setting = setting,
			value = key.value,
			checked = DB[setting.domain][setting.category][setting.key] == key.value,
			OnValueChanged = function(widget, event, value)
				for _, button in ipairs(widget.optionGroup) do
					button:SetValue(button == widget)
				end
				if value then
					DB[widget.setting.domain][widget.setting.category][widget.setting.key] = widget.value
				end
			end
		})

		table.insert(group, cb)

	    for i,v in ipairs(group) do
			v.optionGroup = group
		end		

	end

end