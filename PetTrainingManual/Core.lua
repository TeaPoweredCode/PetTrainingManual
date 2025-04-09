local _, Addon = ...
local UI = Addon.UI

PetTrainingManual = CreateFrame("Frame")

function PetTrainingManual:OnEvent(event, ...)
	self[event](self, event, ...)
end

function PetTrainingManual:ADDON_LOADED(event, addOnName)
	if addOnName == "PetTrainingManual" then
		PetTrainingManualDB = PetTrainingManualDB or {}
		self.db = PetTrainingManualDB
		for k, v in pairs(self.defaults) do
			if self.db[k] == nil then
				self.db[k] = v
			end
		end

		self:InitializeOptions()
		self:InitializeOptionsNEW()
		self:UnregisterEvent(event)
	end
end

function PetTrainingManual:CRAFT_SHOW()        
	UI.ManualWindow:CRAFT_SHOW()
end

function PetTrainingManual:CRAFT_CLOSE()
	print("Close")
	UI:Hide()
end

PetTrainingManual:RegisterEvent("ADDON_LOADED")
PetTrainingManual:RegisterEvent("CRAFT_SHOW")
PetTrainingManual:RegisterEvent("CRAFT_CLOSE")

PetTrainingManual:SetScript("OnEvent", PetTrainingManual.OnEvent)