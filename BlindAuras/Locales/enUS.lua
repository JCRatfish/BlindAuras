local L = BlindAuras.L

-- Make missing translations available
setmetatable(BlindAuras.L, {__index = function(self, key)
  self[key] = (key or "")
  return key
end})

