
--[[
先判断是否死亡
没死亡则释放技能
死亡则释放拾取。
如果是敌对的，就释放技能，如果不是敌对的则不执行。
--]]

-- print('action 1')
if UnitHealth("player") < ( UnitHealthMax("player") / 3 * 2 ) then
	hiphp.treatmentFromMS()
end

if UnitHealth("player") < ( UnitHealthMax("player") / 3 * 1 ) then
	hiphp.castRunByName('纳鲁之光')
end

if UnitHealth("player") < ( UnitHealthMax("player") / 4 * 1 ) then
	hiphp.castRunByName('守护之魂')
end

--判断是否有目标。有则执行
nameString = GetUnitName("target")
if nameString == nil then
	return
end



local health = UnitHealth("target")
-- true表示可以攻击 false表示不可以攻击
local gfr = UnitCanAttack("player", "target")
if gfr == true then

	--血量
	if health > 0 then
		-- print('目标存活')
		hiphp.hurtFromMS()
		-- hiphp.hurtFromMSByAoe()
	else
		-- print('目标死亡')
		InteractUnit("target")
	end
end





-- if health > 0 then
-- 	print('目标存活')
-- 	hiphp.castRunByName('惩击')
-- else
-- 	print('目标死亡')
-- 	-- return "Action 2"
-- end