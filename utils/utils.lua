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
	return {}
end