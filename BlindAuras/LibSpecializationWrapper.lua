if not BlindAuras.IsLibsOK() then return end
if not BlindAuras.IsRetail() then return end
--- @type string, Private
local AddonName, Private = ...

--- @class LibSpecialization
--- @field Register fun(self: LibSpecialization, name: string, callback: function)
--- @field MySpecialization fun(): number, string, string
local LibSpec = LibStub("LibSpecialization")

--- @alias specData {[1]: number, [2]: string, [3]: string}

--- @type table<string, specData>
local nameToSpecMap = {}
--- @type table<string, string>
local nameToUnitMap = {
  [GetUnitName("player", true)] = "player"
}

--- @type function[]
local subscribers = {}

--- @class LibSpecWrapper
--- @field Register fun(callback: fun(unit: string))
--- @field SpecForUnit fun(unit: string): number?
--- @field SpecRolePositionForUnit fun(unit: string): number?, string?, string?

Private.LibSpecWrapper = {}
if LibSpec then
  local frame = CreateFrame("Frame")
  frame:RegisterEvent("PLAYER_LOGIN")
  frame:RegisterEvent("GROUP_ROSTER_UPDATE")
  frame:SetScript("OnEvent", function()
    --- @type string
    local ownName = GetUnitName("player", true)

    nameToUnitMap = {}
    nameToUnitMap[ownName] = "player"

    if IsInRaid() then
      local max = GetNumGroupMembers()
      for i = 1, max do
        local name = GetUnitName(BlindAuras.raidUnits[i], true)
        nameToUnitMap[name] = BlindAuras.raidUnits[i]
      end
    else
      local max = GetNumSubgroupMembers()
      for i = 1, max do
        local name = GetUnitName(BlindAuras.partyUnits[i], true)
        nameToUnitMap[name] = BlindAuras.partyUnits[i]
      end
    end

    for name in pairs(nameToSpecMap) do
      if not nameToUnitMap[name] then
        nameToSpecMap[name] = nil
      end
    end
  end)

  --- LibSpecialization callback
  ---@param specId number
  ---@param role string
  ---@param position string
  ---@param sender string
  ---@param channel string
  local function LibSpecCallback(specId, role, position, sender, channel)
    if nameToSpecMap[sender]
       and nameToSpecMap[sender][1] == specId
       and nameToSpecMap[sender][2] == role
       and nameToSpecMap[sender][3] == position
    then
      return
    end

    if not nameToUnitMap[sender] then
      return
    end

    nameToSpecMap[sender] = {specId, role, position}
    for _, f in ipairs(subscribers) do
      f(nameToUnitMap[sender])
    end
  end

  LibSpec:Register("BlindAuras", LibSpecCallback)

  function Private.LibSpecWrapper.Register(f)
    tinsert(subscribers, f)
  end

  function Private.LibSpecWrapper.SpecForUnit(unit)
    if UnitIsUnit(unit, "player") then
      return (LibSpec:MySpecialization())
    end

    if nameToSpecMap[GetUnitName(unit, true)] then
      return nameToSpecMap[GetUnitName(unit, true)][1]
    end
  end

  function Private.LibSpecWrapper.SpecRolePositionForUnit(unit)
    if UnitIsUnit(unit, "player") then
      return LibSpec:MySpecialization()
    end
    local data = nameToSpecMap[GetUnitName(unit, true)]
    return data and unpack(data) or nil
  end
else -- non retail
  function Private.LibSpecWrapper.Register(f)

  end

  function Private.LibSpecWrapper.SpecForUnit(unit)
    return nil
  end

  function Private.LibSpecWrapper.SpecRolePositionForUnit(unit)
    return nil
  end
end

-- Export for GenericTrigger
BlindAuras.SpecForUnit = Private.LibSpecWrapper.SpecForUnit
BlindAuras.SpecRolePositionForUnit = Private.LibSpecWrapper.SpecRolePositionForUnit
