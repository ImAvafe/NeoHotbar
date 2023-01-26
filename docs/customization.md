---
sidebar_position: 2
---

# Customization

## Custom UI

You can completely customize NeoHotbar's UI however you like! You can even add your own reactive effects.

*Behind the scenes, this uses Fusion's magical instance hydration!*

### Modification

1. Copy over the default UI to use as a template.
2. Piece it together for easy modification.
3. Modify all you like, you have full control!

### Application

1. Break your UI apart again and put it into a folder.
2. Call `:OverrideGui()` on NeoHotbar and tell it to use your folder.

## Custom buttons

You can add your own custom buttons to NeoHotbar, like for opening a backpack, or a pet inventory! They'll be locked to the left, and look extra special compared to the other items.

First, find an image you really like. I'll just use this "add" icon for the tutorial. Copy its Asset ID.

*image here*

Next, let's add the button to NeoHotbar. We'll use the image ID, and a callback function to tell NeoHotbar what to do when it's clicked.

```
local NeoHotbar = require(path.to.NeoHotbar)

NeoHotbar:AddCustomButton("rbxassetid://0w0", function()
    print('Button was clicked!')
end)
```

You're done! You can hook this button up to whatever you want in your game!