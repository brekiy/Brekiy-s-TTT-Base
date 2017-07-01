
AddCSLuaFile()

SWEP.HoldType			= "pistol"

if CLIENT then
   SWEP.PrintName			= "Desert Eagle"			
   SWEP.Author				= "TTT"

   SWEP.Slot				= 1
   SWEP.SlotPos			= 1

   SWEP.Icon = "vgui/ttt/icon_deagle"
end

SWEP.Base		= "weapon_ttt_brekiy_base"

SWEP.Spawnable = true
SWEP.Kind = WEAPON_PISTOL
SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo       = "AlyxGun"
SWEP.Primary.Recoil		= 6.5
SWEP.Primary.Damage = 50
SWEP.Primary.Delay = 0.275
SWEP.Primary.Cone = 0.016
SWEP.Primary.ClipSize = 7
SWEP.Primary.ClipMax = 35
SWEP.Primary.DefaultClip = 7
SWEP.Primary.Automatic = false
SWEP.HeadshotMultiplier = 2
SWEP.CrouchBonus 				 	= 0.7
SWEP.MovePenalty			 	 	= 1.8
SWEP.JumpPenalty			 	 	= 2.2
SWEP.MaxCone 					 	= 0.06

SWEP.AutoSpawnable      = true
SWEP.AmmoEnt = "item_ammo_revolver_ttt"
SWEP.Primary.Sound			= Sound( "Weapon_deagle.shot" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_deagle.mdl"

SWEP.IronSightsPos = Vector(-6.361, -3.701, 2.15)
SWEP.IronSightsAng = Vector(0, 0, 0)