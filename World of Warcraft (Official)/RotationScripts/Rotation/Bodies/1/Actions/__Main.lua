-- print("开搞")
--hiphp.hr('啦啦啦啦')

--hiphp.hr('呵呵呵')


--[[


需要循环执行。不可以等待，否则程序卡死

先寻找鱼漂。没找到，则释放钓鱼技能

释放钓鱼技能以后，做个标记

找到鱼漂以后。做个标记。 

有则执行点击功能。无则继续循环。

停止的时候重置变量 

钓鱼22秒，如果22秒没有上钩。则重新开始

--]]

--重置所有变量.只一次
if _G.start then

	_G.diao =  0
	_G.piao =  0
	_G.piaoObj = nil

	_G.start = false
end



--现在的时间
tNow = GetTime()
--上一次点击鱼漂的时间。如果无则为0
tLast = tLast or 0









-- A = A or 1

-- if A==1 then
-- 	A =2
-- 	print(A)
-- end

-- if true then
-- 	return
-- end




_G.diao = _G.diao or 0
_G.piao = _G.piao or 0



--print(_G.diao)

--没有钓鱼则执行钓鱼技能
if  _G.diao == 0  then

	--留10秒 取鱼
	print(tLast)
	print(tNow-tLast)
	if tLast ~= 0 and tNow-tLast <= 5 then
		print('取鱼中。。。')
		return

	end


	print('释放钓鱼技能')
	ChatFrame10.editBox:SetText("/cast 钓鱼") 
	ChatEdit_SendText(ChatFrame10.editBox) 
	ChatFrame10.editBox:SetText("")
	_G.diao = 1
	_G.piaoObj = nil
end

--表示钓鱼中未发现鱼漂。则寻找鱼漂
if _G.diao == 1 and _G.piaoObj == nil then
	print('钓鱼中。。寻找鱼漂')
	_G.piaoObj = hiphp.getBobber()
	-- _G.piao = 1
	print(_G.piaoObj)
end

--找到鱼漂
if _G.piaoObj ~= nil then
	print('找到鱼漂')

	--第一次鱼漂的时间
	tPiao = tPiao or GetTime()

	print(_G.piaoObj)
	havefish = hiphp.goFish(_G.piaoObj)

	if havefish == 1 or tNow-tPiao >= 22  then
		--重置
		_G.piaoObj = nil
		_G.diao =  0
		_G.piao =  0
		_G.over = 1
		tPiao = nil

		tLast = GetTime()
	end
end
--[[


--找到鱼漂。
if _G.diao == 1 and _G.piao == 1 then
	print('找到鱼漂')
	hiphp.goFish(_G.piaoObj)

	--等待鱼上钩。
end
--]]
