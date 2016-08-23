
--是否钓鱼技能
ChatFrame10.editBox:SetText("/cast 钓鱼") 
ChatEdit_SendText(ChatFrame10.editBox) 
ChatFrame10.editBox:SetText("") 


time = GetTime()

for i=1,100000 do
	print(i)
end

print('寻找鱼漂')

--寻找鱼漂

ob = hiphp.findFishObj()

print(ob)

--while true do 
    --hiphp.gofish(ob)
--end


--[[
money = floor(GetMoney()/10000)

pitch = GetUnitPitch("player")

myname = UnitName("player")

unitCombatReach = hiphp.getTest()

hiphp.movetotest()

hiphp.getfishobj()

if (print) then
	print(money)
	print(pitch)
	print(myname)
	print(unitCombatReach);


	--print(tp[x])
	--print(tp[y])
	--print(tp[z])
end
--]]