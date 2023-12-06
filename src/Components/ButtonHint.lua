local UserInputService = game:GetService("UserInputService")
local NeoHotbar = script.Parent.Parent

local Fusion = require(NeoHotbar.Parent.Fusion)
local FusionUtils = require(NeoHotbar.Parent.FusionUtils)
local States = require(NeoHotbar.States)
local EnsureProp = require(NeoHotbar.ExtPackages.EnsureProp)

local Hydrate = Fusion.Hydrate
local Computed = Fusion.Computed
local Child = FusionUtils.Child
local Spring = Fusion.Spring
local Observer = Fusion.Observer
local Cleanup = Fusion.Cleanup

return function(Props: table)
	Props.Keycode = EnsureProp(Props.Keycode, "EnumItem", nil)
  
  local KeycodeImage = Computed(function()
    if typeof(Props.Keycode:get()) == "EnumItem" then
      return UserInputService:GetImageForKeyCode(Props.Keycode:get())
    else
      return ""
    end
  end)
  local Shown = Computed(function()
    return States.GamepadInUse:get() and (string.len(KeycodeImage:get()) >= 1)
  end)
  local ObserverDisconnects = {}

	local ButtonHint = Hydrate(States.InstanceSet:get()[script.Name]:Clone()) {
    [Child "Image"] = {
      Image = KeycodeImage,
    },
    
    [Cleanup] = function()
      for _, Disconnect in ipairs(ObserverDisconnects) do
        Disconnect()
      end
    end
	}

  if States.DefaultEffectsEnabled:get() then
    Hydrate(ButtonHint) {
      GroupTransparency = Spring(Computed(function()
        return (Shown:get() and 0) or 1
      end), 40, 1),
    }
  end

  table.insert(ObserverDisconnects, Observer(Shown):onChange(function()
    ButtonHint:SetAttribute("Shown", Shown:get())
  end))
  ButtonHint:SetAttribute("Shown", Shown:get())

  return ButtonHint
end