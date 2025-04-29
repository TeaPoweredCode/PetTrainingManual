local _, Addon = ...
local UI = Addon.UI
local ManualWindow = Addon.UI.ManualWindow
local DB = Addon.DB

function ManualWindow:IsProbablyBeastWindow()
	local skill, currentLevel, maxLevel  = GetCraftDisplaySkillLine()
	return skill == nil and currentLevel == 0 and maxLevel == 0
end	

function ManualWindow:CRAFT_SHOW()  
    local isBeastWindow = self:IsProbablyBeastWindow()
    if isBeastWindow then 
        local knownAbilities = {}
        local numCrafts = GetNumCrafts()    
        for i = 1, numCrafts do
            local craftName, craftType, craftSubType, craftID, craftSkill, numReagents = GetCraftInfo(i)
            local rank = string.match(craftType, "%d+")
            local spell = string.format("%s-%s", craftName, rank)
            table.insert(knownAbilities, spell)
        end

        DB.char.knownAbilities = knownAbilities

        UI:Show(CraftFrame)
    else
        UI:Hide()
    end
  end