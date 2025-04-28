--!strict

--[=[
    @interface Visualiser
    @private

    @field Attachment0 Part,
    @field Attachment1 Part,
    @field Beam Beam

    Internal type just used to retrieve the objects involved in the visualiser

    @within VectorViz
]=]

type Visualiser = {
    Attachment0 : Part,
    Attachment1 : Part,
    Beam : Beam
}

--[=[
    @interface Settings

    @field Colour Color3?, -- The colour of your visualiser
    @field Width number?, -- How wide your visualiser is
    @field Scale number?, -- How big the scale factor of your direction is

    Settings for specifying how your visualiser looks like.
    @within VectorViz
]=]

type Settings = {
    Colour : Color3?,
    Width : number?,
    Scale : number?,
}

--[=[
    @class VectorViz
]=]

local VisualiserModule = {
    VisualObjects = {} :: {[string] : {
        ["Visualisers"] : Visualiser,
        ["Settings"] : Settings
    }},
}

--[=[
    @private 

    An internal function for creating the attachments to hold the beam together

    @return Part
    @within VectorViz
]=]

local function CreateAttachment() : Part
    local Holder = Instance.new("Part")
    Holder.Transparency = 1
    Holder.Anchored = true
    Holder.CanCollide = false
    Holder.CanTouch = false
    Holder.CanQuery = false
    Holder.Size = Vector3.one * 0.1
    Holder.Parent = workspace

    local Attachment = Instance.new("Attachment")
    Attachment.Parent = Holder

    return Holder
end

--[=[
    @private 

    An internal function for retrieving a proper settings table with everything included

    @param Settings Settings?

    @return Settings
    @within VectorViz
]=]

local function GetDeserialisedSettings(Settings : Settings?) : Settings
    local RealVisualsTable = Settings

    if RealVisualsTable ~= nil then
        if RealVisualsTable.Colour == nil then
            RealVisualsTable.Colour = Color3.fromRGB(255, 0, 0)
        end

        if RealVisualsTable.Scale == nil then
            RealVisualsTable.Scale = 1
        end

        if RealVisualsTable.Width == nil then
            RealVisualsTable.Width = 0.2
        end
    else
        RealVisualsTable = {
            Colour = Color3.fromRGB(255, 0, 0),
            Scale = 1,
            Width = 0.2,
        }
    end

    return RealVisualsTable :: Settings
end

--[=[
    This function creates a visualiser object. You must keep a note of the ObjectName if you want to destroy or update the visualiser

    @param ObjectName string -- The name you want to use to identify your visualiser
    @param OriginPoint Vector3 -- The origin of your visualiser
    @param Direction Vector3 -- Where your visualiser points towards. The beam scales linearly with the size of your direction 
    @param Settings Settings? -- The visuals you want your beam to have


    @within VectorViz
]=]

function VisualiserModule:CreateVisualiser(ObjectName: string, OriginPoint: Vector3, Direction: Vector3, Settings: Settings?)
    local NewSettings = GetDeserialisedSettings(Settings)

    if VisualiserModule.VisualObjects[ObjectName] then
        warn("Visualiser already exists! Overwriting settings.")
        VisualiserModule.VisualObjects[ObjectName].Settings = NewSettings
    else
        local ClonedBeam = Instance.new("Beam")
        ClonedBeam.Brightness = 1
        ClonedBeam.LightEmission = 0
        ClonedBeam.LightInfluence = 0
        ClonedBeam.TextureLength = 1
        ClonedBeam.Transparency = NumberSequence.new(0)
        ClonedBeam.Parent = workspace

        local Attachment0 = CreateAttachment()
        local Attachment1 = CreateAttachment()

        ClonedBeam.Attachment0 = Attachment0:FindFirstChildWhichIsA("Attachment")
        ClonedBeam.Attachment1 = Attachment1:FindFirstChildWhichIsA("Attachment")

        VisualiserModule.VisualObjects[ObjectName] = {
            Visualisers = {
                Beam = ClonedBeam,
                Attachment0 = Attachment0,
                Attachment1 = Attachment1
            },

            Settings = NewSettings
        }
    end

    VisualiserModule:UpdateVisualiserAppearance(ObjectName, Settings)
    VisualiserModule:UpdateBeam(ObjectName, OriginPoint, Direction)
end

--[=[
    Simply updates your visualiser to fit your new vector

    @param ObjectName string -- The visualiser you want to edit
    @param OriginPoint Vector3 -- The new origin of your visualiser
    @param Direction Vector3 -- The new direction of your visualiser

    @within VectorViz
]=]

function VisualiserModule:UpdateBeam(ObjectName : string, OriginPoint : Vector3, Direction : Vector3)
    local VisualObject = VisualiserModule.VisualObjects[ObjectName]

    if VisualObject ~= nil then
        VisualObject.Visualisers.Attachment0.CFrame = CFrame.new(OriginPoint)
        VisualObject.Visualisers.Attachment1.CFrame = CFrame.new(OriginPoint + (Direction / VisualObject.Settings.Scale :: number)) 
    end
end

--[=[
    Updates how your visualiser looks

    @param ObjectName string -- The visualiser you want to edit
    @param Settings Settings? -- Your new settings

    @within VectorViz
]=]

function VisualiserModule:UpdateVisualiserAppearance(ObjectName : string, Settings : Settings?)
    local VisualObject = VisualiserModule.VisualObjects[ObjectName]

    if VisualObject ~= nil then
        local NewSettings = GetDeserialisedSettings(Settings)
        VisualiserModule.VisualObjects[ObjectName].Settings = NewSettings
    
        local Beam = VisualObject.Visualisers.Beam

        Beam.Color = ColorSequence.new(VisualObject.Settings.Colour :: Color3)

        Beam.Width0 = VisualObject.Settings.Width :: number
        Beam.Width1 = VisualObject.Settings.Width :: number
    else
        error("Visual object doesn't exist so we can't update!")
    end
end

--[=[
    Destroys your visualiser object

    @param ObjectName string -- The visualiser you want to destroy
 
    @within VectorViz
]=]

function VisualiserModule:DestroyVisualiser(ObjectName : string)
    if VisualiserModule.VisualObjects[ObjectName] ~= nil then
        VisualiserModule.VisualObjects[ObjectName].Visualisers.Beam:Destroy()
        VisualiserModule.VisualObjects[ObjectName].Visualisers.Attachment0:Destroy()
        VisualiserModule.VisualObjects[ObjectName].Visualisers.Attachment1:Destroy()
    end

    table.clear(VisualiserModule.VisualObjects[ObjectName])
    VisualiserModule.VisualObjects[ObjectName] = nil
end

return VisualiserModule
