
--[[
智能刷血脚本

1、脱战状态。不执行

2、驱散的问题。如果有增益魔法，执行驱散

3、距离问题。40码-则距离对应为41

--]]
-- print('action 4')

--控制间隔
hiphpst =  hiphpst or GetTime()

--寻找最低血量的间隔.3秒寻找一次
minHealthSt = minHealthSt or 0

--血量低于60%人的数量。超过2个人则使用群体治疗
local lowHealthCount =  0

--间隔太短。跳过
if hiphpst > GetTime() then
	return
end

--如果死亡，则不执行
if UnitIsDead("player") == true or UnitIsDead("target") == true then
	return
end

--非战斗中。执行上马逻辑。在户外+没有上马。
-- if hiphp.isFire()==false  then
-- 	if hiphp.hiphpIsOutdoors() == true and hiphp.hiphpIsMounted() == false then
-- 		--执行上马逻辑
-- 		hiphp.castRunByName('银色角鹰兽')
-- 		hiphpst = GetTime()+1
-- 		return
-- 	end	
-- end





--是否在队伍中。非队伍中不执行
local playerNumber = GetNumGroupMembers()
if playerNumber < 1 then
	return
end

local currentHealth = 1 --比较的值。表示满血
local currentName = nil

if minHealthSt < GetTime() then
	for i=1,playerNumber do
		
		local partyName = GetUnitName("party"..tostring(i))
		local partyHealth = UnitHealth("party"..tostring(i))
		local partyMaxHealth =  UnitHealthMax("party"..tostring(i))

		--排除距离过远的
		if   false then
			print(partyName..'距离过远')
		else
			if partyName == nil then
				break
			end

			--找出低血的。死亡的排除
			if partyHealth ~= 0 and currentHealth >= (partyHealth/partyMaxHealth)    then
				currentHealth = partyHealth/partyMaxHealth
				currentName = string.sub(partyName,0,string.len(partyName)-3)

				--统计低于80%的数量
				if (partyHealth/partyMaxHealth) <= 0.8 then
					lowHealthCount = lowHealthCount +1
				end
			end
		end
	end

	
	--添加自己的判断。如果自己的血量过低则优先自己
	local playerName = GetUnitName("player")
	local playerHealth = UnitHealth("player")
	local playerMaxHealth =  UnitHealthMax("player")

	if playerHealth ~= 0 and currentHealth >= (playerHealth/playerMaxHealth) then
		currentHealth = playerHealth/playerMaxHealth
		currentName = playerName
		--统计低于80%的数量
		if (playerHealth/playerMaxHealth) <= 0.8 then
			lowHealthCount = lowHealthCount +1
		end
	end

	

	--如果存在低血的，则修改对象为当前目标
	if currentName ~= nil and currentName ~= GetUnitName("target") then
		minHealthSt = GetTime()+3
		print(currentName)
		hiphp.targetRunByName(currentName)
	else
		return
	end
end

--判断是否存在目标
if  UnitExists("target") == false then
	return
end
--判断是否友好
local gfr = UnitIsFriend("player", "target")
if gfr == false then
	return
end


--有2个人低血，则使用群刷
if lowHealthCount >= 2 then	
	hiphp.moreTreatment('圣言术：灵')
	hiphp.castRunByName('治疗祷言')
end

--判断距离是否够。如果距离不够，则需要移动。30-80之间，才移动。超过了则不管了
if hiphp.ttGetDistance('player','target') > 30 and hiphp.ttGetDistance('player','target') < 80 then
	-- hiphp.ttClickToMove('target')
	hiphpst = GetTime()+1
	return
end

-- if hiphp.ttGetDistance('player','target') > 40 then
-- 	return
-- end


--检测是否有恢复buff
local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = UnitBuff("target","恢复")

if name ~=nil then

else
	hiphp.castRunByName('恢复')
	-- return
end

--检测是否有debuff
for i=1,5 do
	local buffName, _, _, _, dispelType, _, _, _, _, _, _, _, isBossDebuff, _, _, _, _, _, _ = UnitDebuff("target", i)
	if buffName ==nil then
		break
	end

	if dispelType == 'Magic' then
		print(buffName)
		hiphp.castRunByName('纯净术')
		hiphpst = GetTime()+1
	end
end


--判断是否为坦克


--判断目标血量 从低向高 20 50 80 
local health = UnitHealth("target")
local maxHealth =  UnitHealthMax("target")

--低于20
if (health <= maxHealth * 20 / 100) then
	hiphp.castRunByName('守护之魂')
end

if (health <= maxHealth * 60 / 100) then
	hiphp.castRunByName('神圣化身')
	hiphp.castRunByName('圣言术：静')
	hiphp.castRunByName('身心合一')
end

if (health <= maxHealth * 90 / 100) then
	hiphp.castRunByName('快速治疗')
end
