local _, Addon = ...
local BaseAbility = Addon.UI.Groups.BaseAbility
local TaughtAbility = Addon.UI.Groups.TaughtAbility
local DCL = Addon.Libs.DCL
local HBDPins = Addon.Libs.HBDPins
local L = Addon.Locale
local PinHelper = Addon.UI.PinHelper
local Widgets = Addon.UI.Widgets

function TaughtAbility:Create(parent, ability, rankIndex)
  local knowen = true
  BaseAbility:AddSkillGroup(parent, ability, rankIndex, knowen)
  BaseAbility:AddPetLevelGroup(parent, ability, rankIndex)
  BaseAbility:AddTrainingCostGroup(parent, ability, rankIndex)
  
  self:AddCostToLearnGroup(parent, ability, rankIndex)

end

function TaughtAbility:GetGoldCostString(cost)

  local coin = {
    gold = "|TInterface\\MoneyFrame\\UI-GoldIcon:13:13:2:1|t",
		silver = "|TInterface\\MoneyFrame\\UI-SilverIcon:13:13:2:1|t",
		copper = "|TInterface\\MoneyFrame\\UI-CopperIcon:13:13:2:1|t"
  }

  local gold = math.floor(cost / 10000)
  local silver = math.floor((cost % 10000) / 100)
  local copper = cost % 100
  
  return (gold > 0 and string.format("%d%s ", gold, coin.gold) or "") ..
         (silver > 0 and string.format("%d%s ", silver, coin.silver) or "") ..
         string.format("%d%s", copper, coin.copper)
end

function TaughtAbility:AddCostToLearnGroup(parent, ability, rankIndex)

  parent = Widgets:InlineGroup({
    parent = parent,
    title = L.COST_TO_LEARN,
    fullWidth = true,
  })

  Widgets:Label({
    parent = parent,
    text = self:GetGoldCostString(ability.ranks[rankIndex].gold_cost),
    fullWidth = true
  })
end
