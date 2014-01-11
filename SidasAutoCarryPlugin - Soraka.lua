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
					Casts Q+E when enemy in range, with Auto Carry, Mixed Mode, and Lane Clear
					Killsteal ability with Q+E. Casts Q+E when it can KILL the enemy.
					Used with Soraka Slack to Auto Q+E Team Members.(Will be added next release!) - http://botoflegends.com/forum/topic/1931-soraka-slack/
				
                
                Download: 

                Version History:
						Version: 1.01
							Fixed / Removed: Damage Check for Astral Blessing(W)
							Added: Auto-Cast Q+E when Enemy In Range
							Added: Kill Steal with Q+E
                        Version: 1.00
                            Release         
--]]

-- Champion Check
if myHero.charName ~= "Soraka" then return end

--Variables
local SpellRangeQ = 530

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
		if (GetDistance(target) <= SpellRangeQ) then CastSpell(_Q, target) end
	end
	
	if not (AutoCarry.MainMenu.LastHit or AutoCarry.MainMenu.MixedMode) then myHero:MoveTo(mousePos.x, mousePos.z) end
end

function KillSteal()
-- This is our super basic KillSteal function, checks if enemies can die from
	-- our basicskills and if they can then it will cast it
	-- first we check if our target is valid by using ValidTarget which checks if
	-- target is valid, visible and targetable (for example tryn's ult, kayle ult etc)
	if ValidTarget(Target) then
		-- First we make our variable to get the damage that our skills do to our Target
			-- for our variable we use spellDmg library which is included by default
			-- in BoL, the format is: getDmg("_spellkey", target, source)
		local qDamage = getDmg("Q", Target, myHero)
		local eDamage = getDmg("E", Target, myHero)
		-- Now all we need to do is check if the target's health is less than our skill Dmg
			-- then cast the skill on them same way as we did before
		if Target.health <= qDamage then SkillQ:Cast(Target) end
		if Target.health <= eDamage then SkillE:Cast(Target) end
	end
end
