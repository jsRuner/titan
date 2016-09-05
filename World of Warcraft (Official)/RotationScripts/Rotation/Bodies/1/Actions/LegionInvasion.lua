--[[
按照固定的路线，来回飞。
如果是入侵。则自动停留。
等入侵结束以后。再飞走。

读取插件的数据.可以读取到地区，时间。

不断循环读取。如果读取到地区和时间。则执行移动逻辑

移动到地点以后，则继续下一个。

每到一个地点。
必须先触发
场景开始

BOSS站

场景结束

然后开始飞下一个地点。

先读取进度条数据。然后挨个飞一次

关注地区变化。如果进入指定的区域，没有场景事件，则继续飞下一个地点


--先录制位置，然后移动

--通过时间来判断。1秒执行一次。如果相同，则忽略

--]]


-- hiphp.writePlayerPositionToFile()

frame = nil

--初始化所有变量
if _G.start then
	
end

tNow = GetTime()

--每2秒获取一次位置。相同则忽略，不同则写入文件
tLast = tLast or 0

if tLast ~= 0 and tNow-tLast <= 2 then
	-- print('时间太短。。。')
	return
else
	path = hiphp.writePlayerPositionToFile()
	tLast = tNow
end








