--[[
	Project: SourceMode
	Version: 1.0
	Last Edited: 23/10/2014 (Jack)
	Authors: Jack
]]--

--converToBool
function convertToBool(string)
	if not (type(string) == "string") then return false end --Make sure the var is a string
	
	string = string:lower() --Force all chars to lower-characters
	if (string == "true") then
		return true
	elseif (string == "false") then
		return false
	else
		return false
	end
end

function getGUICenter(rX,rY,width,height)
	if not (localPlayer) then return nil end --Clientside function
	
	if (rX) and (rY) and (width) and (height) then
		return (rX/2) - (width/2), (rY/2) - (height/2)
	end
	return false
end

function getPlayerWeapons(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then return false end

	local weapons = {}
	for slot = 0,12 do
		weapon = getPedWeapon(player,slot)
		if weapon > 0 then
			ammo = getPedTotalAmmo(player,slot)
			if ammo > 0 then
				weapons[weapon] = ammo
			end
		end
	end
	
	return weapons
end

function rgbToHex(r,g,b,a)
	if not r or not g or not b then return false end
	if (a) then
		return string.format("#%.2X%.2X%.2X%.2X", r,g,b,a)
	else
		return string.format("#%.2X%.2X%.2X", r,g,b)
	end
end

function convertToMoney( theNumber )  
	local formatted = theNumber  
	while true do      
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')    
	if (k==0) then      
		break   
		end  
	end  
	return formatted
end

function findPlayer( namePart )
	local result = false
    if namePart then
        for i, player in ipairs(getElementsByType("player")) do
            if string.find(getPlayerName(player):lower(), tostring(namePart):lower(), 1, true) then
				if result then return false end
					result = player 
				end
			end
		end
    return result
end

function findPlayer(name)
	local player
	if name and #name >= 1 then
		for k,v in ipairs(getElementsByType("player")) do
			if string.find(getPlayerName(v):lower(), tostring(name):lower(), 1, true) then
				player = v
				break
			end
		end
	end
	
	return player
end

--Dang, this is a big function :O
function getDateAndTime()
	local now = getRealTime()
	
	--Do some extra work for hours, minutes and etc.
	if (now.month >= 0) and (now.month < 10) then
		month = "0"..now.month
	else
		month = now.month
	end
	
	if (now.monthday+1 >= 0) and (now.monthday < 10) then
		day = "0"..now.monthday
	else
		day = now.monthday
	end
	
	if (now.hour >= 0) and (now.hour < 10) then
		hour = "0"..now.hour
	else
		hour = now.hour
	end
	
	if (now.minute >= 0) and (now.minute < 10) then
		minute = "0"..now.minute
	else
		minute = now.minute
	end
	
	if (now.second >= 0) and (now.second < 10) then
		second = "0"..now.second
	else
		second = now.second
	end
	
	local year,month,day = 1900+now.year,month,day
	
	local dat = year.."-"..month.."-"..day.." "..hour..":"..minute..":"..second
	
	return dat
end