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