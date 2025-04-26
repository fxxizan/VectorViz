---
sidebar_position: 1
---

# Intro

## Overview
VectorViz is an easy to use module which simplifies debugging directions you're applying on your parts by visualising your vectors. The beam scales with the size of your vector allowing you to fine tune the forces you're applying much easier than before.

## Installation
Unfortunately VectorViz currently doesn't support any package libraries. In order to install this simply copy and paste the module inside the src folder in the Github resporitory and get started!

(https://github.com/fxxizan/VectorViz/blob/main/src/VectorViz.luau)

## Example
Below is an example on how you can utilise VectorViz to visualise an external air resistance force being applied on a football.

```lua

--// Create a beam to represent the air resistance force
VectorViz:CreateVisualiser("AirResistance", Ball.Position, Vector3.zero, {
    Colour : Color3.fromRGB(255, 0, 0),
    Width : 0.1,
    Scale : 1.5
    }
)

--// Update the beam to continue matching the ball's position and updating the air resistance value

local Connection = nil

Connection = RunService.Stepped:Connect(function()
    local AirResistance = -Ball.AssemblyLinearVelocity * math.exp(Ball.AssemblyLinearVelocity.Magnitude ^ 2 / 2750)

    VectorViz:UpdateBeam("AirResistance", Ball.Position, AirResistance)
end)

task.wait(5)

Connection:Disconnect()
VectorViz:DestroyVisualiser("AirResistance") --// Okay I've had enough of visualising, lets destroy the beam
```