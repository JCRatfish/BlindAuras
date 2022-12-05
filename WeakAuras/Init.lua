local AddonName, Private = ...
BlindAuras = {}
BlindAuras.L = {}
BlindAuras.frames = {}

BlindAuras.normalWidth = 1.3
BlindAuras.halfWidth = BlindAuras.normalWidth / 2
BlindAuras.doubleWidth = BlindAuras.normalWidth * 2

local versionStringFromToc = GetAddOnMetadata("BlindAuras", "Version")
local versionString = "@project-version@"
local buildTime = "@build-time@"

local flavorFromToc = GetAddOnMetadata("BlindAuras", "X-Flavor")
local flavorFromTocToNumber = {
  Vanilla = 1,
  TBC = 2,
  Wrath = 3,
  Mainline = 10
}
local flavor = flavorFromTocToNumber[flavorFromToc]

--@debug@
if versionStringFromToc == "@project-version@" then
  versionStringFromToc = "Dev"
  buildTime = "Dev"
end
--@end-debug@

BlindAuras.versionString = versionStringFromToc
BlindAuras.buildTime = buildTime
BlindAuras.newFeatureString = "|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0|t"
BlindAuras.BuildInfo = select(4, GetBuildInfo())

function BlindAuras.IsClassic()
  return flavor == 1
end

function BlindAuras.IsBCC()
  return flavor == 2
end

function BlindAuras.IsWrathClassic()
  return flavor == 3
end

function BlindAuras.IsRetail()
  return flavor == 10
end

function BlindAuras.IsClassicOrBCC()
  return BlindAuras.IsClassic() or BlindAuras.IsBCC()
end

function BlindAuras.IsClassicOrBCCOrWrath()
  return BlindAuras.IsClassic() or BlindAuras.IsBCC() or BlindAuras.IsWrathClassic()
end

function BlindAuras.IsBCCOrWrath()
  return BlindAuras.IsBCC() or BlindAuras.IsWrathClassic()
end

function BlindAuras.IsBCCOrWrathOrRetail()
  return BlindAuras.IsBCC() or BlindAuras.IsWrathClassic() or BlindAuras.IsRetail()
end

function BlindAuras.IsWrathOrRetail()
  return BlindAuras.IsRetail() or BlindAuras.IsWrathClassic()
end


BlindAuras.prettyPrint = function(...)
  print("|cff9900ffBlindAuras:|r ", ...)
end

-- Force enable BlindAurasCompanion and Archive because some addon managers interfere with it
EnableAddOn("BlindAurasCompanion")
EnableAddOn("BlindAurasArchive")

local libsAreOk = true
do
  local StandAloneLibs = {
    "Archivist",
    "LibStub"
  }
  local LibStubLibs = {
    "CallbackHandler-1.0",
    "AceConfig-3.0",
    "AceConsole-3.0",
    "AceGUI-3.0",
    "AceEvent-3.0",
    "AceGUISharedMediaWidgets-1.0",
    "AceTimer-3.0",
    "AceSerializer-3.0",
    "AceComm-3.0",
    "LibSharedMedia-3.0",
    "LibDataBroker-1.1",
    "LibCompress",
    "SpellRange-1.0",
    "LibCustomGlow-1.0",
    "LibDBIcon-1.0",
    "LibGetFrame-1.0",
    "LibSerialize",
  }
  if BlindAuras.IsClassic() then
    tinsert(LibStubLibs, "LibClassicSpellActionCount-1.0")
    tinsert(LibStubLibs, "LibClassicCasterino")
    tinsert(LibStubLibs, "LibClassicDurations")
  end
  if BlindAuras.IsRetail() then
    tinsert(LibStubLibs, "LibSpecialization")
  end
  for _, lib in ipairs(StandAloneLibs) do
    if not lib then
        libsAreOk = false
        BlindAuras.prettyPrint("Missing library:", lib)
    end
  end
  if LibStub then
    for _, lib in ipairs(LibStubLibs) do
        if not LibStub:GetLibrary(lib, true) then
          libsAreOk = false
          BlindAuras.prettyPrint("Missing library:", lib)
        end
    end
  else
    libsAreOk = false
  end
end

function BlindAuras.IsLibsOK()
  return libsAreOk
end

if not BlindAuras.IsLibsOK() then
  C_Timer.After(1, function() BlindAuras.prettyPrint("BlindAuras is missing necessary libraries. Please reinstall a proper package.") end)
end

-- These function stubs are defined here to reduce the number of errors that occur if BlindAuras.lua fails to compile
function BlindAuras.RegisterRegionType()
end

function BlindAuras.RegisterRegionOptions()
end

function Private.StartProfileSystem()
end

function Private.StartProfileAura()
end

function Private.StopProfileSystem()
end

function Private.StopProfileAura()
end

function Private.StartProfileUID()
end

function Private.StopProfileUID()
end

-- If BlindAuras shuts down due to being installed on the wrong target, keep the bindings from erroring
function BlindAuras.StartProfile()
end

function BlindAuras.StopProfile()
end

function BlindAuras.PrintProfile()
end

function BlindAuras.CountWagoUpdates()
  -- XXX this is to work around the Companion app trying to use our stuff!
  return 0
end
