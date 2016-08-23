-- message("sample section!");

function hr(msg)
	-- body
	print(msg)
end

function getTest()
	-- body
	return GetUnitCombatReach("player")
end

function movetotest()
	-- body
	tp = GetObjectPosition("player")
	for key, value in pairs(tp) do  
    	print(key..value)
	end 
	--ClickToMove(tp)
end



--获取鱼漂的对象
function findPiaoObj()
	-- body
	ots = GetObjects({})
	--[[
	for key, value in pairs(ots) do 
	 	objectName = GetObjectName(value) 
	 	print(objectName)
    	if objectName == "鱼漂" then
    		print(key..value)
    		return value
    	end
	end 
	--]]
	for i = 1, #ots do
  		objectName = GetObjectName(ots[i]) 
	 	print(objectName)
    	if objectName == "鱼漂" then
    		print(ots[i])
    		return ots[i]
    	end
	end
end

function getBobber()
	local objs = GetObjects({
		IncludeNamePattern = "鱼漂",
		})
	local bobber;
	for i = 1,#objs do
		local obj = objs[i]
		if GetObjectCreator(obj) == UnitGUID(GetObject("player")) then
			bobber = obj
			break;
		end
	end

	return bobber
end

--判断是否有鱼上钩
function goFish(obj)
	-- body
	if IsBobbing(obj) then
		-- op = GetObjectPosition(obj)
		InteractUnit(obj)
		print('有鱼上钩')
		--避免暂离
		ResetAfkTimer()
		return 1
	else
		-- print('等待。。。')
		return 0
	end


end




