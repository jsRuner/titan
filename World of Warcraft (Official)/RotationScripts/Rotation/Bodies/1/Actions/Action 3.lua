
--[[
下副本加血脚本
优先判断焦点
然后判断全队
焦点的血必须80%
全队的则依次保证70%
简单的版本：目标血量过低，则指向读条技能。这里最好能判断目标的buff

--判断是否有目标 是否可以攻击。可以攻击则不执行

检测是否有恢复，没有则丢恢复。

普通情况。低于90%
快速治疗即可。如果蓝耗过多，则执行治疗术

特别情况。低于50%
立即使用 金身
执行身心合一与静

低于20% 则给保护

1、脱离战斗则暂停逻辑。
2、自动驱散。检测是否有增益魔法。存在则执行驱散
3、寻找小队血量最低的人。找到则设置目标为它。
4、



--]]

-- print('action 3')


--判断是否有目标。没有则不执行
local nameString = GetUnitName("target")
if nameString == nil then
	return
end

--判断是否可以攻击
-- true表示可以攻击 false表示不可以攻击
local gfr = UnitCanAttack("player", "target")
if gfr == true then
	return
end


--检测是否有恢复buff
local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = UnitBuff("target","恢复")

if name ~=nil then

else
	hiphp.castRunByName('恢复')
end

--判断目标血量 从低向高 20 50 80 
local health = UnitHealth("target")
local maxHealth =  UnitHealthMax("target")

--低于20
if (health <= maxHealth * 20 / 100) then
	hiphp.castRunByName('守护之魂')
end

if (health <= maxHealth * 50 / 100) then
	hiphp.castRunByName('神圣化身')
	hiphp.castRunByName('圣言术：静')
	hiphp.castRunByName('身心合一')
end

if (health <= maxHealth * 90 / 100) then
	hiphp.castRunByName('快速治疗')
end





