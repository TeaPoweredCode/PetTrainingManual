local _, Addon = ...
local DB = Addon.DB

local defaults = {
  global = {
    tooltip = {
      showFor = 1, -- eTooltipShowFor.HuntersOnly
      showWhen = 1, -- eTooltipShowWhen.AllBeasts
    },
    minimapIcon = { hide = false },
    npc_tooltips = true,
  },
  char = {
    knownAbilities = {}
  }
}

function DB:Initialize()
  local db = LibStub("AceDB-3.0"):New("__HuntersPetManual_ADDON_DB__", defaults)
  setmetatable(self, { __index = db })
  self.Initialize = nil
end
