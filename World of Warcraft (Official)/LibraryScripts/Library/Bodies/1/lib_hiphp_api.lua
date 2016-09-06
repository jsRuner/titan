--[[

]]--


--物品是否是unit施放的
function isObjectByUnit(unit,object)
	if unit and object then
		if ttGetObjectCreator(object)~=nil and ttGetObject(unit)==ttGetObject(GetObjectCreator(object)) then
			return true;
		end
	end
	return false;
end

--根据条件过滤
function filterObjs(conditionFunction, objs, returnAll)
	if objs==nil or #objs==0 then
		return nil;
	end
	local arr = {};
	for _,objId in ipairs(objs) do	
		if conditionFunction(objId) then
			if returnAll then
				table.insert(arr, objId);
			else
				return objId;
			end
		end
	end
	if returnAll then
		return arr;
	else
		return nil;
	end
end

function getObjs(conditionFunction, objs, returnAll)
	return filterObjs(conditionFunction, ttGetObjects({}) ,returnAll)
end

--释放技能
function castRunByName(name)
	-- body
	ChatFrame10.editBox:SetText("/cast "..name) 
	ChatEdit_SendText(ChatFrame10.editBox) 
	ChatFrame10.editBox:SetText("")
end

--选取目标
function targetRunByName(name)
	-- body
	ChatFrame10.editBox:SetText("/target "..name) 
	ChatEdit_SendText(ChatFrame10.editBox) 
	ChatFrame10.editBox:SetText("")
end

--使用技能
function useRunByName(name)
	-- body
	ChatFrame10.editBox:SetText("/use "..name) 
	ChatEdit_SendText(ChatFrame10.editBox) 
	ChatFrame10.editBox:SetText("")
end
--判断目标是否存在
function isExistTarget()
	-- body
	return GetObject('target')
end


-----------------------------------------------------------------------------------
--商业模块
-----------------------------------------------------------------------------------
--判断是否打开了贩卖的窗口
function checkMerchant()
	local items = GetMerchantNumItems()
	if MerchantFrame:IsShown() and items > 0 then
		return true
	else
		return false
	end
end

--售卖列表
local shopping_list = {}
function add_Shopping_List(name,link,rarity,level,price,stack)
	local x
	local found = 0
	if price > 0 and #shopping_list > 1 then
		for x=1, #shopping_list, 1 do
			if shopping_list[x][1] == name then
				found = 1
				shopping_list[x][5] = shopping_list[x][5] + price
				shopping_list[x][6] = shopping_list[x][6] + stack
				shopping_list[x][7] = shopping_list[x][7] + 1
			end
		end
	end
	if price > 0 and #shopping_list == 0 or price > 0 and found == 0 then
		shopping_list[#shopping_list+1] = { name,link,rarity,level,price,stack,1 }
	end
end

local num = 0
--遍历包裹。符合售卖列表的，则可以售卖。需要判断当前商人是否可用。否则不执行
function findFishFromBag()
	-- body
	for bag = 0,NUM_BAG_SLOTS,1 do
		for slot = 1, GetContainerNumSlots(bag), 1 do
			local texture, itemCount, _, quality, _, _, itemLink, _ = GetContainerItemInfo(bag, slot);
			if texture ~= nil then
				local itemName, itemLink, itemRarity, itemLevel, _, _, _, _, _, _, itemSellPrice = GetItemInfo(itemLink);
				if itemName == '新月剑齿鱼清汤' then
					--添加到售卖列表
					add_Shopping_List(itemName,itemLink,quality,itemLevel,itemSellPrice,itemCount)
				end
				
				for i = 1, #shopping_list, 1 do
					if shopping_list[i][1] == itemName and shopping_list[i][3] == itemRarity then
						if not CursorHasItem() then
							-- Sell item
							UseContainerItem(bag,slot)
							print("出售"..itemLink)
							num = num + 1
						end
					end
				end
			end
		end
	end
end
--自动与指定Npc聊天。地址暂时无法存储。
function test()
	-- body
	-- local ttp= ttGetObjectPosition('player')
	-- print(ttp['X'])
	-- print(ttp['Y'])
	-- print(ttp['Z'])
	-- print(ttp['R'])
	-- _G.hiphpSellNpcP = ttp	
end

--[[
移动到阿什兰的克拉得军需官那。走的是直线。
--]]
local function getNpc()
	local objs = ttGetObjects({
		IncludedNamePattern="血卫士斩斧"
	});
	local npc = filterObjs(function(obj)
		return ttGetObjectName(obj)=="血卫士斩斧";
	end,objs,false)
	return npc;
end
function toNpc()
	-- body
	local npc = getNpc()
	if npc then
		InteractUnit(npc)
		SelectGossipOption(1)
		--卖东西的逻辑
		return;
	else
		t = GetDistance({['X']='5235.098',['Y']='-3977.462',['R']='11.317',['Z']='2.038'},ttGetObject('player'))
        if t > 10 then
        	ttClickToMove({['X']='5235.098',['Y']='-3977.462',['R']='11.317',['Z']='2.038'})
            return;
        end
	end
    return;
end
-----------------------------------------------------------------------------------
--钓鱼模块
-----------------------------------------------------------------------------------
local function getBobber()
	local objs = ttGetObjects({
		--IncludedNamePattern="鱼漂"
	});
	local bobber = filterObjs(function(obj)
		return ttGetObjectName(obj)=="鱼漂" and isObjectByUnit("player", obj);
	end,objs,false)
	return bobber;
end

--测试.如果包满了，自动售卖。
function xxx()
	-- body
end

--钓鱼之前的检查工作。鱼饵。
local function goFishBefore()
	-- body
	baitTable={"超级鱼虫","水下诱鱼器","锐利的鱼钩","明亮的小珠"}
	for _,v in ipairs(baitTable) do
		
		if GetItemCount(v)>0 and not GetWeaponEnchantInfo(v) then
			castRunByName(v);
			return;
		end
	end

end


local GotoFish = 0
function goFish()
	ttResetAfkTimer();
	goFishBefore()
	local bobber = getBobber()
	if bobber then
		if ttIsBobbing(bobber) then
			InteractUnit(bobber)
			return
		end
	else
        if GotoFish < GetTime() then
            CastSpellByName(tostring(select(1,GetSpellInfo(131474))))
            GotoFish = GetTime()+0.3
            return;
        end
	end
    return;
end

--杀鱼模块。寻找指定的鱼。存在则执行杀鱼逻辑
function killFish()
	-- body
	local baitTable={"巨型新月剑齿鱼","新月剑齿鱼","巨型海蝎子","海蝎子"}
	for _,v in ipairs(baitTable) do
		
		if GetItemCount(v)>=5  then
			castRunByName(v);
			return;
		end
	end
end

-----------------------------------------------------------------------------------
--战斗模块
-----------------------------------------------------------------------------------
local function getPlayer()
	local objs = ttGetObjects({
		IncludedTypes={"Player"},
		-- IncludedUnitReactions ("Hostile")
	});
	local player = nil
	if objs ~=nil and #objs>1 then
		local randomIndex = math.random(1,#objs+1) 
		player = objs[randomIndex]
	end
	return player
end


local randomTreatment = 0  --控制间隔
local tlast = nil --上一个对象
local tchange = 0 --转换目标的条件。每一次操作，都会执行5+1间隔。6秒就执行一次切换。。
--寻找身边的目标，判断距离，够近就刷血，不够就移动。随机选择然后 释放治疗技能。
--如果处于移动状态。则需要做个标记。不要重新获取对象。
function goRandomTreatment()
	-- body
	local pob = nil
	if randomTreatment < GetTime() then
		if tlast == nil then
			pob = getPlayer()
			tchange = 0 
		else
			pob = tlast
			tchange = tchange +1
		end

		if pob ~=nil then
			pobName = ttGetObjectName(pob)
			print(pobName)
			targetRunByName(pobName)
			--判断距离
			t = GetDistance(pob,ttGetObject('player'))
			--过远则位移。移动5秒。然后就不管了

			if t > 20 and tchange<=6 then
				tlast = pob
				ttClickToMove(pob)
				randomTreatment = GetTime()+5 --确保间隔 5秒
				return
			end
			castRunByName("恢复");
			tlast = nil
		end
		randomTreatment = GetTime()+1  --确保间隔1秒
	end
end

-------------------------------
--打怪的逻辑.
------------------------------


-------------------------------
--按照固定的点移动
------------------------------
frame = CreateFrame("Frame")
local moveAlongPositionsTime = 0
local i = 1
function moveAlongPositions(posList)
	-- body
	
	frame:SetScript("OnUpdate",function ()
		-- body
		if  GetTime() - moveAlongPositionsTime > 0.2 then
			moveAlongPositionsTime = GetTime()
			-- local X0,y0,z0,r0 = ttGetObjectPosition("player")
			local x1,y1,z1,r1 = posList[i][1],posList[i][2],posList[i][3],posList[i][4]
			-- print(x1,y1,z1,r1)
			local t = GetDistance({['X']=posList[i][1],['Y']=posList[i][2],['Z']=posList[i][3],['R']=posList[i][4]},ttGetObjectPosition('player'))
			if t > 5 then
				ttClickToMove({['X']=posList[i][1],['Y']=posList[i][2],['Z']=posList[i][3],['R']=posList[i][4]})
			else
				print("到达:",posList[i])
				print(i)
				if i == #posList then
					frame:SetScript("OnUpdate",nil)
					i = 1
				else
					i = i+1
				end
			end
		end
	end)
end


-------------------------------
--刷水枪玩具
------------------------------
local wayPoints ={{['X']='6058.252',['Y']='5093.655',['R']='11.317',['Z']='-42.350'},
                                 {['X']='6060.908',['Y']='5108.189',['R']='11.317',['Z']='-42.446'},
                                 {['X']='6047.505',['Y']='5115.494',['R']='11.317',['Z']='-42.762'}
                                    }


local  count =1
function goSpringCircle()
    if randomTreatment < GetTime() then
        position = wayPoints[count]
        print(count)
        ttClickToMove(position)
        randomTreatment = GetTime()+2 --确保间隔 5秒
        count = count+1
        if count >3 then
            count =1
        end
        return
    end
end

------------------------------------------
--牧师的攻击技能。
-----------------------------------------
local hurtT = 0
function hurtFromMS()
	-- body
	 if hurtT < GetTime() then
	 	castRunByName('神圣化身')
	 	castRunByName('神圣之火')
		castRunByName('圣言术：罚')
		castRunByName('神圣之星')
		castRunByName('神圣新星')
		castRunByName('惩击')
		hurtT = GetTime()+0.5
	 end
	 return
end
--AOE技能
function hurtFromMSByAoe()
	-- body
	 if hurtT < GetTime() then
	 	castRunByName('神圣新星')
		castRunByName('神圣之星')
		hurtT = GetTime()+0.5
	 end
	 return
end

------------------------------------------
--牧师的治疗技能
-----------------------------------------

local treatmentT = 0
function treatmentFromMS()
	-- body
	 if treatmentT < GetTime() then
		-- castRunByName('身心合一')
	 	castRunByName('圣言术：静')
		-- castRunByName('恢复')
	 	castRunByName('快速治疗')
		treatmentT = GetTime()+0.5
	 end
	 return
end

------------------------------------------
-- 给队伍中血量最低的人刷血
-----------------------------------------


------------------------------------------
-- 判断player是否战斗中 true 表示战斗中
-----------------------------------------
function isFire()
	-- body
	return InCombatLockdown()
end

------------------------------------------
-- 判断player是否马上。在马上，则是true
-----------------------------------------
function hiphpIsMounted()
	-- body
	return IsMounted()

end

------------------------------------------
-- 判断player是否在户外。户外的定义是可以使用坐骑。
-----------------------------------------
function hiphpIsOutdoors()
	-- body
	return IsOutdoors()

end

------------------------------------------
-- 使用群体治疗。指向性技能.
-----------------------------------------
function moreTreatment(name)
	-- body
	useRunByName(name)
	isPending = IsAoeSpellPending()
	if isPending then
		ClickTerrain('target')
	end
end



