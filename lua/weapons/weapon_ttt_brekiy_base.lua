-- Custom TTT weapon base heavily derived from the original TTT base.
-- This is meant only for guns.
-- Aims to change recoil mechanics a bit. As such, most of the parameters
-- do not have comments and instead you can refer to the original code in the TTT base for that.

AddCSLuaFile()

SWEP.Kind = WEAPON_NONE
SWEP.CanBuy = nil

if CLIENT then
   SWEP.EquipMenuData = nil
   SWEP.Icon = "vgui/ttt/icon_nades"
end


SWEP.AutoSpawnable = false
SWEP.AllowDrop = true
SWEP.IsSilent = false

if CLIENT then
   SWEP.DrawCrosshair   = false
   SWEP.ViewModelFOV    = 82
   SWEP.ViewModelFlip   = true
   SWEP.CSMuzzleFlashes = true
end

SWEP.Base = "weapon_tttbase"

SWEP.Category           = "TTT Brekiy" -- Custom category for a custom base
SWEP.Spawnable          = false

SWEP.Weight             = 5
SWEP.AutoSwitchTo       = false
SWEP.AutoSwitchFrom     = false

SWEP.Primary.Sound          = Sound( "Weapon_Pistol.Empty" )
SWEP.Primary.Recoil         = 1.5
SWEP.Primary.Damage         = 1
SWEP.Primary.NumShots       = 1
SWEP.Primary.Cone           = 0.02
SWEP.Primary.Delay          = 0.15

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"
SWEP.Primary.ClipMax        = -1

SWEP.Secondary.ClipSize     = 1
SWEP.Secondary.DefaultClip  = 1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.ClipMax      = -1
--SWEP.ShellLoad 				 = false

-- Moving inaccuracy related parameters.
-- Multiplier on gun spread when crouching. Lower is better.
SWEP.CrouchBonus 				 = 0.7
-- Modifies gun spread when moving. Formula is 
-- cone + ((MovePenalty / 100) * PlayerVelocity * cone). Lower is better.
SWEP.MovePenalty			 	 = 2
-- Multiplier on gun spread when jumping. Lower is better.
SWEP.JumpPenalty			 	 = 3
-- Maximum inaccuracy allowed for the gun.
SWEP.MaxCone 					 = 0.06

--SWEP.Penetration 						= 0
--work on this later, currently does not fire the penetrated bullet correctly
--[[ function SWEP:BulletPenetrate(hitNum, attacker, tr, dmginfo)
	print("BulletPenetrate funct")
	print("hitNum: ", hitNum, "penetration power: ", self.Penetration)
	local penetrate = self.Penetration
	local dmgMult = 1
	
	-- Prevent the bullet from going through more than 2 surfaces
	-- This is for performance and shit
	if(hitNum > 2) then 
		print("Bullet hit too many surfaces") 
		return false 
	end
	
	-- The bullet can penetrate different amounts of material
	-- and takes a damage penalty according to the material
	if (tr.MatType == MAT_METAL or tr.MatType == MAT_VENT or 
		tr.MatType == MAT_COMPUTER or tr.MatType == MAT_GRATE) then
		penetrate = penetrate * 0.3
		dmgMult = 0.3
	elseif (tr.MatType == MAT_CONCRETE) then
		penetrate = penetrate * 0.5
		dmgMult = 0.5
	elseif(tr.MatType == MAT_DIRT or tr.MatType == MAT_TILE or tr.MatType == MAT_SAND) then
		penetrate = penetrate * 0.7
		dmgMult = 0.7
	elseif (tr.MatType == MAT_PLASTIC or tr.MatType == MAT_WOOD) then
		penetrate = penetrate * 0.85
		dmgMult = 0.85
	end
	print("Penetration calculated: ", penetrate, " units")
	print("Dmg and mult:", self.Primary.Damage, dmgMult)
	print(tr.Normal)
	local penVec = tr.Normal * penetrate * 2 -- Penetration vector
	local penTrace = {}
	penTrace.endpos = tr.HitPos
	penTrace.start = tr.HitPos + penVec
	penTrace.filter = {}
	penTrace.mask = MASK_SHOT
	local penTraceLine = util.TraceLine(penTrace)
	print("Trace created")
	
	if (penTraceLine.StartSolid or penTraceLine.Fraction >= 1.0 or tr.Fraction <= 0.0) then 
		print("Bullet did not penetrate!")
		return false 
	end
	
	local newHit = 0
	if(tr.MatType == MAT_GLASS) then newHit = 1 end
	
	print("Making penetrated shot")
	
	local exitShot = {}
	exitShot.Num = 1
	exitShot.src = penTraceLine.HitPos + penVec
	exitShot.dir = penTraceLine.Normal
	exitShot.spread = Vector(0, 0, 0)
	exitShot.dmg = self.Primary.Damage * dmgMult
	exitShot.force = self.Primary.Damage * dmgMult * 0.4
	exitShot.Tracer = 1
	exitShot.tracerName = "AR2Tracer"
	if(SERVER) then
		exitShot.Callback = function(a, b, c) BulletPenetrate(hitNum + newHit, a, b, c) end
	end
	print("Bullet penetrated")
	attacker:FireBullets(exitShot)
	print("exitShot fired")
end ]]

function SWEP:PrimaryAttack(worldsnd)

   self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not self:CanPrimaryAttack() then return end

   if not worldsnd then
      self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
   elseif SERVER then
      sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
   end

   self:ShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone())

   self:TakePrimaryAmmo( 1 )

   local owner = self.Owner
   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

   owner:ViewPunch(Angle(math.Rand(-0.2,-0.15) * self.Primary.Recoil, math.Rand(-0.08,0.11) * self.Primary.Recoil, 0 ))
end

function SWEP:ShootBullet( dmg, recoil, numbul, cone )
   self:SendWeaponAnim(self.PrimaryAnim)

   self.Owner:MuzzleFlash()
   self.Owner:SetAnimation( PLAYER_ATTACK1 )

   if not IsFirstTimePredicted() then return end

   local sights = self:GetIronsights()

   numbul = numbul or 1
   cone   = cone   or 0.01

   local bullet = {}
   bullet.Num    = numbul
   bullet.Src    = self.Owner:GetShootPos()
   bullet.Dir    = self.Owner:GetAimVector()
   bullet.Spread = Vector( cone, cone, 0 )
   bullet.Tracer = 4
   bullet.TracerName = self.Tracer or "Tracer"
   bullet.Force  = dmg * 0.4
   bullet.Damage = dmg
	
	--bullet.Callback = function(a, b, c)
	--return self:BulletPenetrate(0, a, b, c) end

   self.Owner:FireBullets( bullet )

   -- Owner can die after firebullets
   if (not IsValid(self.Owner)) or (not self.Owner:Alive()) or self.Owner:IsNPC() then return end

   if ((game.SinglePlayer() and SERVER) or
       ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted())) then

      -- reduce recoil if ironsighting
      recoil = sights and (recoil * 0.6) or recoil

      local eyeang = self.Owner:EyeAngles()
      eyeang.pitch = eyeang.pitch - (math.Rand(0.25, 0.3) * recoil)
		eyeang.yaw = eyeang.yaw - (math.Rand(-0.05, 0.1) * recoil)
      self.Owner:SetEyeAngles(eyeang)
   end

end

function SWEP:GetPrimaryCone()
   local cone = self.Primary.Cone or 0.2
	cone = cone + ((self.MovePenalty / 100) * self.Owner:GetVelocity():Length()*cone)
	if self.Owner:Crouching() then cone = cone * self.CrouchBonus end
	if !self.Owner:IsOnGround() then cone = cone * self.JumpPenalty end
	if self:GetIronsights() then cone = cone * 0.7 end
	if self.MaxCone < cone then cone = self.MaxCone end
   return cone
end

function SWEP:GetHeadshotMultiplier(victim, dmginfo)
   return self.HeadshotMultiplier
end

function SWEP:Think()
	--local inaccMult = 1 + self.Owner:GetWalkSpeed() * 0.75
end