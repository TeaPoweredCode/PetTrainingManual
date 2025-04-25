local _, Addon = ...
local BaseAbility = Addon.UI.Groups.BaseAbility
local DB = Addon.DB
local Widgets = Addon.UI.Widgets
local AceGUI = Addon.Libs.AceGUI
local L = Addon.Locale

function BaseAbility:AbilityKnown(spellName , rank)
  for index, value in ipairs(DB.char.knownAbilities) do
    if value == string.format("%s-%s", spellName, rank) then    
      return true
    end
  end  
  return false  
end

function BaseAbility:AddSkillGroup(parent, ability, rankIndex)
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
    
    local Known = self:AbilityKnown(ability.name,rankIndex)

    local checkbox = AceGUI:Create("CheckBox")
    checkbox:SetLabel(nil)
    checkbox:SetValue(Known)
    checkbox.frame:SetScale(1.5)
    checkbox:SetWidth(20)
    checkbox:SetHeight(35)
  
    checkbox:SetCallback("OnValueChanged", function(widget, event, value)
      checkbox:SetValue(Known) -- locks it to "Known" without disabling and making it gray
    end)
  
    checkbox.checkbg:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
      GameTooltip:SetText(Known and L["KNOWN_ABILITY_TOOLTIP"] or L["UNKNOWN_ABILITY_TOOLTIP"], 1, 1, 1)
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