

--启用位移。如果存在坐标点,则开启位移标记
local poss = _G.poss
if  poss and #poss > 1 then
	print('启动位移')
	_G.startMove = true
end