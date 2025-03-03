local _, Addon = ...

PetTrainingManual = CreateFrame("Frame")

function PetTrainingManual:OnEvent(event, ...)
	self[event](self, event, ...)
end
PetTrainingManual:SetScript("OnEvent", PetTrainingManual.OnEvent)
PetTrainingManual:RegisterEvent("ADDON_LOADED")

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
		self:UnregisterEvent(event)

	end
end