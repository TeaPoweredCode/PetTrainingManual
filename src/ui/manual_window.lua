local _, Addon = ...
local UI = Addon.UI
local ManualWindow = Addon.UI.ManualWindow


function ManualWindow:IsProbablyBeastWindow()
	local skill, currentLevel, maxLevel  = GetCraftDisplaySkillLine()
	return skill == nil and currentLevel == 0 and maxLevel == 0
end	

function ManualWindow:CRAFT_SHOW()
	local craftFrame = CraftFrame  -- This is the crafting window frame
  
    local isBeastWindow = self:IsProbablyBeastWindow()
    if isBeastWindow then 
        UI:Show(CraftFrame)
    else
        UI:Hide()
    end


		-- for k,v in pairs(CraftFrame) do
		-- 	n=n+1
		-- 	keyset[n]=k
		--   end
        
        -- Now you can interact with the CraftFrame, for example, set its size:
        --craftFrame:SetSize(500, 400)
        
--         -- You can also check if the crafting frame is visible or hidden:
--         if craftFrame:IsVisible() then
--             print("Crafting window is visible.")
--         else
--             print("Crafting window is not visible.")
--         end


        local numCrafts = GetNumCrafts()  -- Get the number of available crafts in the window
        print("Number of crafts available: " .. numCrafts)

        -- Loop through all crafts
        for i = 1, numCrafts do
            local craftName, craftType, craftSubType, craftID, craftSkill, numReagents = GetCraftInfo(i)
            --  print("Craft #" .. i .. ": " .. craftName .. " ID: " .. craftID)
            --  print("  Type: " .. craftType .. " | Subtype: " .. craftSubType)

			--print("Name: " .. craftName .. " | rank: " .. craftType)
        end

  end
  
  