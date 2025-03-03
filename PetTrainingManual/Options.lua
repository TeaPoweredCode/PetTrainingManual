local AddonName, Addon = ...

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





-- a bit more efficient to register/unregister the event when it fires a lot
function PetTrainingManual:UpdateEvent(value, event)
	if value then
		self:RegisterEvent(event)
	else
		self:UnregisterEvent(event)
	end
end
