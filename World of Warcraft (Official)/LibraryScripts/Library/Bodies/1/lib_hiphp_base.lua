
-----------------------------------------------------------------------------------
--扩展的基础API
-----------------------------------------------------------------------------------
--基础函数扩展：table.contains
function table.contains(t, element)
        for _, value in pairs(t) do
                if equals(value, element) then
                        return true
                end
        end
        return false
end

--基础函数扩展：table.tostring
function table.tostring(t)
	if type(t)~="table" then return t;end
    local tempTab = {};
    for key, value in ipairs(t) do
        if type(value) == "table" then
            table.insert(tempTab,table.tostring(value));
        else
            local res="[\""..key.."\"]="
            if type(value)=="string" then
                res = res.."\""..value.."\"";
            else
                res = res..tostring(value).."";
            end
            table.insert(tempTab, res);
        end
    end
    return "{"..table.concat(tempTab, ", ").."}";
end

--基础函数扩展：equals
function equals(obj1, obj2)
        local type1 = type(obj1);
        local type2 = type(obj2);
        if type1 ~= type2 then
                return false;
        elseif type1 == "table" then
                if #obj1 ~= #obj2 then
                        return false;
                end
                for i=1, #(obj1) do  
                        if not equals(obj1, obj2) then
                                return false;
                        end
                end
                return true;
        else
                return rawequal(obj1,obj2);
        end
end

--基础函数扩展：打印table
function printTable(t)
    print(table.tostring(t));
end

--字符串处理，是否以某个字段开头
function string.startsWith(str, substr)
	if str == nil or substr == nil then
		return nil, "the string or the sub-stirng parameter is nil"
	end
	if string.find(str, substr) ~= 1 then
		return false
	else
		return true
	end
end


--打印。间隔打印
local pt = 0
function printBy1(msg)
    -- body
    if GetTime() > pt then
        print(msg)
        pt = GetTime()+1
    end
end

-----------------------------------------------------------------------------------
--泰坦API
-----------------------------------------------------------------------------------
tt={}
--[[
2. titanGuids = GetObjects({
    IncludedTypes: string[],
    ExcludedTypes: string[],
    IncludedNamePattern: string,
    ExcludedNamePattern: string,
    IncludedUnitReactions: string[],
    ExcludedUnitReactions: string[],
    Scales: {
        Center: {
            X: number,
            Y: number,
            Z: number
        },
        MinDistance: number,
        MaxDistance: number
    }[]
})
]]--
--获取范围内目标
function ttGetObjects(params)
	return GetObjects(params)
end

--objectTypes = GetObjectTypes(unitId | titanGuid)
function ttGetObjectTypes(obj)
	return GetObjectTypes(obj)
end

--object = GetObject(object | unitId | unitGUID)
function ttGetObject(id)
	return GetObject(id);
end

--unitReaction = GetUnitReaction(unit1, unit2)
function ttGetUnitReaction(unit1, unit2)
	return GetUnitReaction(unit1, unit2)
end

--objectName = GetObjectName(unitId | titanGuid)
function ttGetObjectName(obj)
	if not obj then
		return nil;
	else
		return GetObjectName(obj)
	end
end

--objectPosition({X,Y,Z,R}) = GetObjectPosition(unitId | titanGuid)
function ttGetObjectPosition(id)
	return GetObjectPosition(id);
end

--distance = GetDistance(position1, position2)
function ttGetDistance(position1, position2)
	return GetDistance(position1, position2)
end

--CheckIntersection(position1, position2, terrains)
--检查坐标1和坐标2之间是否有障碍物，其中terrains为string table用于指定障碍物类别，可取值为：BoundingModel | Structure | Ground | Liquid | MovableObject
----检查坐标1和坐标2之间是否有障碍物
function ttCheckIntersection(position1, position2, terrains)
	return CheckIntersection(position1, position2, terrains)
end

--点击坐标
function ttClickTerrain(position)
	ClickTerrain(position);
end

--获取指定单位的创建者GUID
function ttGetObjectCreator(id)
	return GetObjectCreator(id);
end

--获取指定单位的模型半径
function ttGetUnitBoundingRadius(id)
	return GetUnitBoundingRadius(id);
end

--获取指定单位的作战半径
function ttGetUnitCombatReach(id)
	return GetUnitCombatReach(id)
end

--获取指定单位的目标GUID
-- targetGuid = getUnitTarget(unitId | titanGuid)
function ttGetUnitTarget(id)
	return GetUnitTarget(id);
end

--重置AFK计时器（5分钟重新开始计算）
function ttResetAfkTimer()
	ResetAfkTimer();
end

--转身，r就是position中的R（弧度）
function ttSetFacing(r)
	SetFacing(r);
end

--获取物体高度。
--1. GetObjectHeight(object) 
function ttGetObjectHeight(object)
	return GetObjectHeight(object);
end

--将3D游戏坐标position（或指定物体的坐标）转换为WOW插件系统支持的屏幕坐标，其中dx,dy为0~1，表示坐标位置比例。
--2. {dx, dy} = GetScreenCoordinate(position | object)
function ttGetScreenCoordinate(positionOrObject)
	return GetScreenCoordinate(positionOrObject);
end

--3. ClickToMove(position | object)
--点击地面移动到指定坐标（或指定物体的坐标）。
function ttClickToMove(positionOrObject)
	return ClickToMove(positionOrObject);
end

--4. IsBobbing(object)
--获取指定鱼漂是否有鱼上钩。
function ttIsBobbing(object)
	return IsBobbing(object);
end

function ttInteractUnit(unit)
	return InteractUnit(unit)
end

--5. IsAoeSpellPending()
--获取当前是否有待施法绿圈。
function ttIsAoeSpellPending()
	return IsAoeSpellPending()
end

--6. CancelAoeSpell()
--取消施法绿圈。
function ttCancelAoeSpell()
	return CancelAoeSpell();
end