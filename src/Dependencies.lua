local ReplicatedStorage = game:GetService("ReplicatedStorage")

local WallyPackages = ReplicatedStorage:FindFirstChild("Packages")
local BundledPackages = script:GetChildren()

assert(BundledPackages or WallyPackages, "NeoBar is improperly installed. Missing dependencies.")

return #BundledPackages > 0 and BundledPackages or WallyPackages