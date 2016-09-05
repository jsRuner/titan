
print("action 2")

if UnitHealth("player") < ( UnitHealthMax("player") / 2) then
	hiphp.treatmentFromMS()
end

--判断是否有目标。有则执行
nameString = GetUnitName("target")
if nameString == nil then
	hiphp.goFish()
	return
end



local health = UnitHealth("target")
-- true表示可以攻击 false表示不可以攻击
local gfr = UnitCanAttack("player", "target")
if gfr == true then

	--血量
	if health > 0 then
		-- print('目标存活')
		hiphp.hurtFromMSByAoe()
	else
		-- print('目标死亡')
		InteractUnit("target")

	end
end



