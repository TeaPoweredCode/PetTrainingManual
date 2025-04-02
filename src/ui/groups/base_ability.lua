local _, Addon = ...
local BaseAbility = Addon.UI.Groups.BaseAbility
local Widgets = Addon.UI.Widgets
local AceGUI = Addon.Libs.AceGUI
local L = Addon.Locale

function BaseAbility:AddSkillGroup(parent, ability, rankIndex, knowen)
    inlineGroup = Widgets:InlineGroup({
      parent = parent,
      title = L.SKILL,
      fullWidth = true,
      layout = "Flow"
    })
  
    local titleFont, _, titleflasg = GameFontNormal:GetFont()
    Widgets:Label({
      parent = inlineGroup,
      text = ("%s (%s %s)"):format(ability.name, L.RANK, rankIndex),
      icon = {image = ability.icon, size = 32},
      font = {font = titleFont , height = 18 , flags = titleflasg},
      width = 340,
      tooltip = {
        onEnter = function()
          GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
          GameTooltip:SetHyperlink("spell:" .. ability.ranks[rankIndex].spell_id)
          GameTooltip:Show()
        end,
        onLeave = function()
          GameTooltip:Hide()
        end
      }
    })
    
    local checkbox = AceGUI:Create("CheckBox")
    checkbox:SetLabel(nil)
    checkbox:SetValue(knowen)
    checkbox.frame:SetScale(1.5)
    checkbox:SetWidth(20)
    checkbox:SetHeight(35)
  
    checkbox:SetCallback("OnValueChanged", function(widget, event, value)
      checkbox:SetValue(knowen)
    end)
  
    checkbox.checkbg:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_CURSOR")  -- Tooltip shows near the cursor
      GameTooltip:SetText(knowen and L["KNOWN_ABILITY_TOOLTIP"] or L["UNKNOWN_ABILITY_TOOLTIP"], 1, 1, 1)  -- Custom tooltip text
      GameTooltip:Show()
    end)
  
    checkbox.checkbg:SetScript("OnLeave", function(self)
      GameTooltip:Hide()
    end)
  
    inlineGroup:AddChild(checkbox)
  end

  function BaseAbility:AddPetLevelGroup(parent, ability, rankIndex)
    parent = Widgets:InlineGroup({
      parent = parent,
      title = L.PET_LEVEL,
      fullWidth = true,
    })
  
    Widgets:Label({
      parent = parent,
      text = ability.ranks[rankIndex].pet_level or 1,
      fullWidth = true
    })
  end
  
  function BaseAbility:AddTrainingCostGroup(parent, ability, rankIndex)
    parent = Widgets:InlineGroup({
      parent = parent,
      title = L.TRAINING_POINTS,
      fullWidth = true,
    })
  
    Widgets:Label({
      parent = parent,
      text = ability.ranks[rankIndex].training_cost or 0,
      fullWidth = true
    })
  end  