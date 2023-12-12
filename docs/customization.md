---
sidebar_position: 2
---

# Customization

## Custom buttons

You can add your own custom buttons to NeoHotbar, like to open a backpack for example!

1. First, find an image to use for the button's icon.
2. Next, let's add the button to NeoHotbar. We'll use the image's asset ID and a callback function to tell NeoHotbar what to do when it's clicked.

    ```
    local NeoHotbar = require(path.to.NeoHotbar)

    NeoHotbar:AddCustomButton("rbxassetid://0", function()
        print('Button was clicked!')
    end)
    ```
3. You're done! You can hook this button up to whatever you want in your game.

## Custom UI

NeoHotbar's UI is fully overridable, so you can customize it however you like! 

1. Copy over the default UI to use as a template. The folder can be found in `NeoHotbar/DefaultInstances`.
2. Modify all you like, you have full control!
3. Call [:OverrideGui()](/api/NeoHotbar#OverrideGui) on NeoHotbar, passing your folder as an argument.

### Dynamic attributes

You can also plug into dynamic attributes to have your UI react to changes.

For example, the `ToolButton` component has an attribute called `Equipped`. Here's what a code snippet for that might look like:

```lua
local ToolButton = path.to.ToolButton

local function ReactToEquipped(Equipped: boolean)
    print(`Equipped: {Equipped}`)
end

ToolButton:GetAttributeChangedSignal("Equipped"):Connect(function()
    ReactToEquipped(ToolButton:GetAttribute("Equipped"))
end)

ReactToEquipped(ToolButton:GetAttribute("Equipped"))
```

You may also choose to use a UI library like [Fusion](https://elttob.uk/Fusion/0.2/) to handle reactive logic. Fun fact, NeoHotbar uses Fusion behind the scenes itself.

## Properties

You might want to change simpler things, like temporarily hiding the hotbar or locking tool reordering. You can set those properties with the functions listed here:

- [SetEnabled](/api/NeoHotbar#SetEnabled)
- [SetManagementEnabled](/api/NeoHotbar#SetManagementEnabled)
- [SetToolTipsEnabled](/api/NeoHotbar#SetToolTipsEnabled)
- [SetContextMenuEnabled](/api/NeoHotbar#SetContextMenuEnabled)