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

return function(Props: table)
	Props.Keycode = EnsureProp(Props.Keycode, "EnumItem", nil)
  
  local KeycodeImage = Computed(function()
    if typeof(Props.Keycode:get()) == "EnumItem" then
      return UserInputService:GetImageForKeyCode(Props.Keycode:get())
    else
      return ""
    end
  end)

	return Hydrate(States.InstanceSet:get()[script.Name]:Clone()) {
    GroupTransparency = Spring(Computed(function()
      if States.GamepadInUse:get() and (string.len(KeycodeImage:get()) >= 1) then
        return 0
      else
        return 1
      end
    end), 40, 1),

    [Child "Image"] = {
      Image = KeycodeImage,
    }
	}
end