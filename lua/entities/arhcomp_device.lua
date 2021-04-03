AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Category = "ArhComp"

if SERVER then
    function ENT:InitFromConfig(config)
        ArhComp.SubDevice.HostInit(self)

        self.SpawnConfig = config
        self:SetModel(config.Model)

        ArhComp.SubDevice.HostConfigurateDevs(self, config.SubDevices)
    end

    function ENT:Use(activator)
        local keyboard = ArhComp.SubDevice.GetSingleOfType(self, "keyboard")
    
        if keyboard then
            keyboard:OnHostUsed(activator)
        end
    end
    
    function ENT:OnRemove()
        ArhComp.SubDevice.HostRemove(self)
    end
end

function ENT:Initialize()
    if SERVER then
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetUseType( SIMPLE_USE )
    end
end

