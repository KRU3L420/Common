--[[
 
        Auto Carry Plugin - Soraka: The Starchild
                Author: KRU3L420
                Version: See version variables below.
                Copyright 2014

                Dependency: Sida's Auto Carry: Reborn
 
                How to install:
                        Make sure you already have AutoCarry installed.
                        Name the script EXACTLY "SidasAutoCarryPlugin - Soraka.lua" without the quotes.
                        Place the Plugin in BoL/Scripts/Common folder.

                Features:
                    Harass with HotKey (Default A) - Also moves to cursor.
		    Cast Q when enemy in range, with Auto Carry, and Mixed modes.
		    Killsteal ability with Q+E. Casts Q+E when it can KILL the enemy.
		    Used with Soraka Slack to Auto Q+E Team Members.(Will be added next release!) - http://botoflegends.com/forum/topic/1931-soraka-slack/
				    
                
                Download: 

                Version History:
		    Version: 1.02
		        Added: Auto-Q Enemy in Auto Carry, and Mixed modes.
		        Added: HotKey to Harass with Q, also moves to cursor.
		        Added: Kill Steal with Q+E
		Version: 1.01
		        Removed: Damage Check for Astral Blessing(W)
                Version: 1.00
                        Release         
--]]

-- Champion Check
if myHero.charName ~= "Soraka" then return end

--Variables
local SpellRangeQ = 530
local SpellRangeE = 725

-- PluginOnLoad()
function PluginOnLoad()
	-- Here we define our Skill Q into the AutoCarry Skills Class
	SkillQ = AutoCarry.Skills:NewSkill(false, _Q, 530, "Starcall", AutoCarry.SPELL_TARGETED, 0, false, false, 2, 0, 0, false)
	-- Here we define our Skill E into the AutoCarry Skills Class
	SkillE = AutoCarry.Skills:NewSkill(false, _E, 725, "Infuse", AutoCarry.SPELL_TARGETED, 0, false, false, 2, 0, 0, false)
	-- Here we add our Harass option to the menu
	AutoCarry.PluginMenu:addParam("harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, 65)
        -- Here we add our function to always show our HotKeys.
	AutoCarry.PluginMenu:permaShow("harass")
        -- Here we add the options to toggle harassing with Q+E
        AutoCarry.PluginMenu:addParam("hwQ", "Harass with Q", SCRIPT_PARAM_ONOFF, true) -- Harass with Q
	AutoCarry.PluginMenu:addParam("hwE", "Harass with E", SCRIPT_PARAM_ONOFF, true) -- Harass with E

	--AutoCarry Range
	AutoCarry.Crosshair:SetSkillCrosshairRange(1000)
end

-- Plugin:OnTick
function PluginOnTick()
	Target = AutoCarry.Crosshair:GetTarget()

	KillSteal()
	if AutoCarry.Keys.AutoCarry then
		SkillQ:Cast(Target)
		SkillE:Cast(Target)
	end
	if AutoCarry.Keys.MixedMode then
		SkillQ:Cast(Target)
		SkillE:Cast(Target)
	end
	if not myHero.dead then
		if AutoCarry.PluginMenu.harass then Harass() end -- harass
	end
end

-- Other Functions
function Harass()
	local target = AutoCarry.GetAttackTarget(true)
	if ValidTarget(target) then
		if AutoCarry.PluginMenu.hwQ and (GetDistance(target) <= SpellRangeQ) then SkillQ:Cast(Target) end
		if AutoCarry.PluginMenu.hwE and (GetDistance(target) <= SpellRangeE) then SkillE:Cast(Target) end
	end
	
	if not (AutoCarry.MainMenu.LastHit or AutoCarry.MainMenu.MixedMode) then myHero:MoveTo(mousePos.x, mousePos.z) end
end

function KillSteal()
	if ValidTarget(Target) then
		local qDamage = getDmg("Q", Target, myHero)
		local eDamage = getDmg("E", Target, myHero)
		if Target.health <= qDamage then SkillQ:Cast(Target) end
		if Target.health <= eDamage then SkillE:Cast(Target) end
	end
end
