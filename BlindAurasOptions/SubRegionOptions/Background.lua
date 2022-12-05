if not BlindAuras.IsLibsOK() then return end
local AddonName, OptionsPrivate = ...
local L = BlindAuras.L;

do
  local function subCreateOptions(parentData, data, index, subIndex)
      local options = {
        __title = L["Background"],
        __order = 1,
        __up = function()
          for child in OptionsPrivate.Private.TraverseLeafsOrAura(parentData) do
            OptionsPrivate.MoveSubRegionUp(child, index, "subbackground")
          end
          BlindAuras.ClearAndUpdateOptions(parentData.id)
        end,
        __down = function()
          for child in OptionsPrivate.Private.TraverseLeafsOrAura(parentData) do
            OptionsPrivate.MoveSubRegionDown(child, index, "subbackground")
          end
          BlindAuras.ClearAndUpdateOptions(parentData.id)
        end,
        __notcollapsable = true
      }
      return options
    end

  BlindAuras.RegisterSubRegionOptions("subbackground", subCreateOptions, L["Background"]);
end

-- Foreground for aurabar

do
  local function subCreateOptions(parentData, data, index, subIndex)
    local options = {
      __title = L["Foreground"],
      __order = 1,
      __up = function()
        for child in OptionsPrivate.Private.TraverseLeafsOrAura(parentData) do
          OptionsPrivate.MoveSubRegionUp(child, index, "subforeground")
        end
        BlindAuras.ClearAndUpdateOptions(parentData.id)
      end,
      __down = function()
        for child in OptionsPrivate.Private.TraverseLeafsOrAura(parentData) do
          OptionsPrivate.MoveSubRegionDown(child, index, "subforeground")
        end
        BlindAuras.ClearAndUpdateOptions(parentData.id)
      end,
      __notcollapsable = true
    }
    return options
  end

  BlindAuras.RegisterSubRegionOptions("subforeground", subCreateOptions, L["Foreground"]);
end