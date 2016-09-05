
-- print('test')

-- hiphp.findFishFromBag()
-- hiphp.test()
-- hiphp.moveToASL()


--存储坐标。每次执行，会获取一个坐标，存到table中
-- _G.poss = _G.poss or {}
-- local playPos = hiphp.ttGetObjectPosition("player")
-- print('获取当前位置坐标:',playPos['X'],playPos['Y'],playPos['Z'],playPos['R'])
-- table.insert(_G.poss ,{playPos['X'],playPos['Y'],playPos['Z'],playPos['R']})









-- name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = UnitBuff("party1","熊形态")
-- print(name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3)

--当前目标，是否存在恢复
name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = UnitBuff("target","恢复")
print(name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3)

if name ~=nil then
	print('存在恢复')
else
	print('不存在恢复')
end

start, duration, enable =  GetSpellCooldown("身心合一")
print(start, duration, enable) 
--

-- canBeTank, canBeHealer, canBeDPS = UnitGetAvailableRoles("player")

-- print(canBeTank, canBeHealer, canBeDPS)