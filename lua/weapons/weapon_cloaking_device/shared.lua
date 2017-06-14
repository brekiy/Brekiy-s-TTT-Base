if SERVER then
   AddCSLuaFile( "shared.lua" )
end

if( CLIENT ) then
    SWEP.PrintName = "Cloaking Device";
    SWEP.Slot = 7;
    SWEP.DrawAmmo = false;
    SWEP.DrawCrosshair = false;
 
   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "Hold it to become nearly invisible.\n\nDoesn't hide your name, shadow or\nbloodstains on your body."
   };

end

SWEP.Author= "Kerdizoumé"

SWEP.Base = "weapon_tttbase"
SWEP.Spawnable= false
SWEP.AdminSpawnable= true
SWEP.HoldType = "normal"
 
SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = {ROLE_TRAITOR,ROLE_DETECTIVE}
 
SWEP.ViewModelFOV= 60
SWEP.ViewModelFlip= false
SWEP.ViewModel      = "models/weapons/c_slam.mdl"
SWEP.WorldModel      = ""
SWEP.UseHands	= true

function SWEP:Initialize()
	self:DrawShadow(false)

end

 --- PRIMARY FIRE ---
function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire(CurTime()+5)
 
	local result = math.random(1, 2)
	if result == 1 then
    TauntSound = Sound("npc/stalker/breathing3.wav")
	else
    TauntSound = Sound("npc/stalker/go_alert2a.wav")
end

self:SetNextPrimaryFire(CurTime()+2)
 
    self.Weapon:EmitSound( TauntSound )

    if (!SERVER) then return end
 
    self.Weapon:EmitSound( TauntSound )
end
 
 --- SECONDARY FIRE ---
SWEP.Secondary.Delay= 0.5
SWEP.Secondary.Recoil= 0
SWEP.Secondary.Damage= 0
SWEP.Secondary.NumShots= 1
SWEP.Secondary.Cone= 0
SWEP.Secondary.ClipSize= -60
SWEP.Secondary.DefaultClip= -60
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo         = "none"
 
function SWEP:SecondaryAttack() // conceal yourself

if ( !self.conceal ) then
	self.Owner:SetColor( Color(255, 255, 255, 3) ) 			
	self.Owner:SetMaterial( "sprites/heatwave" )
	self.Weapon:SetMaterial("sprites/heatwave")
	self.Owner:PrintMessage( HUD_PRINTCENTER, "Cloak On" )
	self.conceal = true
else
	self.Owner:SetMaterial("models/glass")
	self.Weapon:SetMaterial("models/glass")
	self.Owner:PrintMessage( HUD_PRINTCENTER, "Cloak Off" )
	self.conceal = false
end

end
 
function SWEP:PreDrop()

if ( self.conceal ) then
   self.conceal = false
end
 
end

hook.Add("TTTPrepareRound", "UnCloakAll",function()
    for k, v in pairs(player.GetAll()) do
        v:SetMaterial("models/glass")
    end
end)