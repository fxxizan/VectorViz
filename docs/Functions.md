---
sidebar_position: 2
---

# Functions

## Creating a visualiser
Visualisers are incredibly easy to create. Simply call the 'CreateVisualiser' function as so:

```lua
VectorViz:CreateVisualiser("AirResistance", Ball.Position, Vector3.zero, {
    Colour : Color3.fromRGB(255, 0, 0),
    Width : 0.1,
    Scale : 1.5
    }
)
```

You have to keep a note of the identifier you pass (the first argument) in order to edit it later on in time or destroy it. Also note that the argument for visuals (the fourth argument) is optional and if you don't pass a setting through then it'll automatically default to the default setting for that specific visual setting.

## Updating the visualiser
You can update the visualiser's position / direction with the following function:

```lua
VisualiserModule:UpdateBeam("AirResistance", Ball.Position, AirResistanceForce)
```

Similarly you can update how the beam looks if you wish later on:

```lua
VisualiserModule:UpdateVisualiserAppearance("AirResistance", {
    Colour : Color3.fromRGB(0, 255, 0),
    Width : 0.3,
    Scale : 0.8
    }
)
```

## Destroying the visualiser
Visualisers can be destroyed like so:

```lua
VisualiserModule:DestroyVisualiser("AirResistance")
```

Note that you can reuse the identifier if you want to after destroying it
