local Fusion = require(script.Parent.Fusion)

local Value = Fusion.Value

return function(Prop: any, Type: string, Default: any)
  if Prop == nil then
    return Value(Default)
  elseif typeof(Prop) == Type then
    return Value(Prop)
  else
    return Prop
  end
end