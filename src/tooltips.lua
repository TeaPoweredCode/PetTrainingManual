local AddonName, Addon = ...
local Colors = Addon.Colors
local DB = Addon.DB
local DCL = Addon.Libs.DCL
local strsplit = _G.strsplit
local TameableNPCs = Addon.TameableNPCs
local UnitGUID = _G.UnitGUID

_G.GameTooltip:HookScript("OnTooltipSetUnit", function(self)
  if not DB.global.npc_tooltips then return end

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
