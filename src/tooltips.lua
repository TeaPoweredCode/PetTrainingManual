local AddonName, Addon = ...
local Colors = Addon.Colors
local DB = Addon.DB
local DCL = Addon.Libs.DCL
local TameableNPCs = Addon.TameableNPCs

local eTooltipShowFor = Addon.ENUMS.eTooltipShowFor
local eTooltipShowWhen = Addon.ENUMS.eTooltipShowWhen

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
  -- Calc if to show
  local _, class = UnitClass("player")
  if class ~= "HUNTER" and DB.global.tooltip.showFor == eTooltipShowFor.HuntersOnly then
    return
  end

  if DB.global.tooltip.showWhen == eTooltipShowWhen.Never then
    return
  end
  
  -- Do Show
  -- Get unit.
  local _, unit = self:GetUnit()
  if not unit then return end

  -- Get unit type and id.
  local guid = UnitGUID(unit) or ""
  local unitType, _, _, _, _, id = strsplit("-", guid)
  if not (id and unitType == "Creature") then return end

  -- Get npc.
  local npc = TameableNPCs[id]
  if not npc then return end

  -- Add lines.
  self:AddLine(DCL:ColorString(AddonName, Colors.Primary))
  for _, ability in ipairs(npc.abilities) do
    self:AddLine("  " .. ability, 1, 1, 1)
  end
end)
