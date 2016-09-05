--[[
user login /name:username /password:password

game list
game set id
game info

profile list
profile create /name:profileName
profile set id
profile start

script refresh

rotation list
rotation create /name:rotationName

library list
library create /name:libraryName /namespace:namespace
]]--


--------------------------------------------------------------
--基础函数扩展：table.contains
--------------------------------------------------------------
function table.contains(t, element)
        for _, value in pairs(t) do
                if equals(value, element) then
                        return true
                end
        end
        return false
end

--------------------------------------------------------------
--基础函数扩展：table.tostring
--------------------------------------------------------------
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

--------------------------------------------------------------
--基础函数扩展：equals
--------------------------------------------------------------
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

--------------------------------------------------------------
--基础函数扩展：打印table
--------------------------------------------------------------
function printTable(t)
    print(table.tostring(t));
end

startsWith = function(str, substr)
	if str == nil or substr == nil then
		return nil, "the string or the sub-stirng parameter is nil"
	end
	if string.find(str, substr) ~= 1 then
		return false
	else
		return true
	end
end

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
function getObjs(params)
	return GetObjects(params)
end

--object = GetObject(object | unitId | unitGUID)
function getObj(id)
	return GetObject(id);
end

--objectName = GetObjectName(unitId | titanGuid)
function objName(obj)
	if not obj then
		return nil;
	else
		return GetObjectName(obj)
	end
end

function filterObjs(conditionFunction, objs, returnAll)
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

--objectTypes = GetObjectTypes(unitId | titanGuid)
function objType(obj)
	return GetObjectTypes(obj)
end

--fish
function isObjectByUnit(unit,object)
	if unit and object then
		if GetObjectCreator(object)~=nil and getObj(unit)==getObj(GetObjectCreator(object)) then
			return true;
		end
	end
	return false;
end

local function getBobber()
	local objs = getObjs({});
	local bobber = filterObjs(function(obj)
		return objName(obj)=="鱼漂" and isObjectByUnit("player", obj);
	end,objs,false)
	return bobber;
end

local function isBobbing()
	local bobber = getBobber();
	local bobberObj = getObj(bobber)
	--print("bobber: "..bobber)
	--print("bobberObj: "..bobberObj)
	--print("bobberObjType: "..type(bobberObj))
	--print(bobberObj.name)
    local bobbing = 0;--ObjectField(bobber, 0x1E0,Types.Byte)
	if bobbing == 1 then
		return true
	else
		return false
	end
end

local GotoFish = 0
function goFish()
	ResetAfkTimer();
	local bobber = getBobber()
	if bobber then
		local position = GetObjectPosition(bobber)
		local position2 = GetObjectPosition("player")
		--print(#position.."#"..#position2)
		--print("position:"..table.tostring(position))
		--print("position2:"..table.tostring(position2))
		--ClickTerrain(position)
		--print("click: "..table.tostring(position))
		if isBobbing() == true then
			ObjectInteract(getBobber())
			return true
		end
	else
        if GotoFish < GetTime() then
            CastSpellByName(tostring(select(1,GetSpellInfo(131474))))
            GotoFish = GetTime()
            return;
        end
	end
    return;
end