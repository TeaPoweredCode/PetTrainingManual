local _, Addon = ...

local BaseAbility = Addon.UI.Groups.BaseAbility
local TameableAbility = Addon.UI.Groups.TameableAbility
local DCL = Addon.Libs.DCL
local HBDPins = Addon.Libs.HBDPins
local L = Addon.Locale
local PinHelper = Addon.UI.PinHelper
local Widgets = Addon.UI.Widgets
local AceGUI = Addon.Libs.AceGUI

local UI = Addon.UI

function TameableAbility:Create(parent, ability, rankIndex)  
  local knowen = true
  BaseAbility:AddSkillGroup(parent, ability, rankIndex, knowen)
  BaseAbility:AddPetLevelGroup(parent, ability, rankIndex)
  BaseAbility:AddTrainingCostGroup(parent, ability, rankIndex)

  self:AddLearnedByGroup(parent, ability)
  self:AddTameableNPCsGroup(parent, ability, rankIndex)
end

function TameableAbility:AddLearnedByGroup(parent, ability)
  parent = Widgets:InlineGroup({
    parent = parent,
    title = L.LEARNABLE_FROM,
    fullWidth = true,
  })

  Widgets:Label({
    parent = parent,
    text = (
        #ability.learned_by > 0 and
            table.concat(ability.learned_by, ", ") or
            L.ALL_PET_FAMILIES
        ),
    fullWidth = true
  })
end

function TameableAbility:AddTameableNPCsGroup(parent, ability, rankIndex)
  parent = Widgets:InlineGroup({
    parent = parent,
    title = L.TAMEABLE_BEASTS,
    fullWidth = true
  })

  local npc_ids = ability.ranks[rankIndex].npc_ids
  if #npc_ids > 0 then
    for _, npc_id in ipairs(npc_ids) do
      local npc = Addon.TameableNPCs[tostring(npc_id)]
      self:AddNPC(parent, npc)
    end
  else
    Widgets:Label({
      parent = parent,
      text = L.NONE,
      fullWidth = true
    })
  end
end

function TameableAbility:AddNPC(parent, npc)
  if not npc then return end

  local LABEL_S = DCL:ColorString("%s:", Addon.Colors.Label) .. " %s"

  parent = Widgets:InlineGroup({
    parent = parent,
    title = DCL:ColorString(npc.name, Addon.Colors.Primary),
    fullWidth = true
  })

  -- Level.
  Widgets:Label({
    parent = parent,
    text = LABEL_S:format(L.LEVEL, npc.level_range),
    fullWidth = true
  })

  -- Abilities.
  Widgets:Label({
    parent = parent,
    text = LABEL_S:format(L.ABILITIES, table.concat(npc.abilities, ", ")),
    fullWidth = true
  })

  -- Family.
  Widgets:Label({
    parent = parent,
    text = LABEL_S:format(L.FAMILY, npc.family),
    fullWidth = true
  })

  -- Diet.
  Widgets:Label({
    parent = parent,
    text = LABEL_S:format(L.DIET, npc.diet),
    fullWidth = true
  })

  -- Type.
  Widgets:Label({
    parent = parent,
    text = LABEL_S:format(L.TYPE, npc.type),
    fullWidth = true
  })

  -- Location.
  Widgets:Label({
    parent = parent,
    text = LABEL_S:format(L.LOCATION, npc.location),
    fullWidth = true
  })

  -- "Show on Map" button.
  local b = Widgets:Button({
    parent = parent,
    -- fullWidth = true,
    text = L.SHOW_ON_MAP,
    onClick = function()
      WorldMapFrame:Show()
      WorldMapFrame:SetMapID(npc.ui_map_id)

      PinHelper:Clear()

      for _, coords in pairs(npc.coords) do
        HBDPins:AddWorldMapIconMap(
          Addon,
          PinHelper:Get(npc),
          npc.ui_map_id,
          coords.x * 0.01,
          coords.y * 0.01,
          HBD_PINS_WORLDMAP_SHOW_WORLD
        )
      end
    end,
  })

  if not npc.ui_map_id or #npc.coords == 0 then
    b:SetText(L.MAP_UNAVAILABLE)
    b:SetDisabled(true)
  end
end
