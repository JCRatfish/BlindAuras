local L = BlindAuras.L

--@localization(locale="enUS", format="lua_additive_table", namespace="BlindAuras", handle-subnamespaces="none")@

-- Make missing translations available
setmetatable(BlindAuras.L, {__index = function(self, key)
  self[key] = (key or "")
  return key
end})

