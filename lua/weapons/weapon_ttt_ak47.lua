AddCSLuaFile()

if CLIENT then
   SWEP.PrintName = "AK-47"
   SWEP.Slot = 2
   SWEP.Icon = "vgui/ttt/icon_ak47"
   SWEP.IconLetter = "b"
end

SWEP.Base = "weapon_ttt_brekiy_base"
SWEP.HoldType = "ar2"

SWEP.AutoSpawnable = true
SWEP.AmmoEnt = "item_ammo_smg1_ttt"
SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.NoSights = false
SWEP.Primary.Ammo 				= "SMG1"
SWEP.Primary.Delay 				= 0.13
SWEP.Primary.Recoil 				= 1.7
SWEP.Primary.Cone 				= 0.0085
SWEP.Primary.Damage 				= 23
SWEP.Primary.Automatic 			= true
SWEP.Primary.ClipSize 			= 30
SWEP.Primary.ClipMax 			= 60
SWEP.Primary.DefaultClip 		= 30
SWEP.Primary.Sound 				= Sound( "Weapon_ak47.shot" )
SWEP.HeadshotMultiplier 		= 2.5
SWEP.CrouchBonus 				 	= 0.7
SWEP.MovePenalty			 	 	= 1.5
SWEP.JumpPenalty			 	 	= 3
SWEP.MaxCone 					 	= 0.0675

SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 50
SWEP.ViewModel = Model( "models/weapons/cstrike/c_rif_ak47.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_rif_ak47.mdl" )

SWEP.IronSightsPos = Vector( -6.45, 10, 1.4 )
SWEP.IronSightsAng = Vector( 2.737, 0.158, 0 )

SWEP.Kind = WEAPON_HEAVY

function SWEP:SetZoom(state)
   if CLIENT then return end
   if not (IsValid(self.Owner) and self.Owner:IsPlayer()) then return end
   if state then
      self.Owner:SetFOV(50, 0.2)
   else
      self.Owner:SetFOV(0, 0.2)
   end
end

function SWEP:SecondaryAttack()
   if not self.IronSightsPos then return end
   if self:GetNextSecondaryFire() > CurTime() then return end

   local bIronsights = not self:GetIronsights()

   self:SetIronsights( bIronsights )

   if SERVER then
      self:SetZoom( bIronsights )
   end

   self:SetNextSecondaryFire( CurTime() + 0.3 )
end

function SWEP:PreDrop()
   self:SetZoom(false)
   self:SetIronsights(false)
   return self.BaseClass.PreDrop(self)
end

function SWEP:Reload()
    if (self:Clip1() == self.Primary.ClipSize or
        self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0) then
       return
    end
    self:DefaultReload(ACT_VM_RELOAD)
    self:SetIronsights(false)
    self:SetZoom(false)
end

function SWEP:Holster()
   self:SetIronsights(false)
   self:SetZoom(false)
   return true
end