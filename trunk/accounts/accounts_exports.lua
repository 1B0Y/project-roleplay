--[[
	Project: SourceMode
	Version: 1.0
	Last Edited: 25/10/2014 (Jack)
	Authors: Jack
]]--

--getPlayerAccount: returns (string) username if player is logged in, (boolean) false otherwise.
function getPlayerAccount(player)
	if not player or not isElement(player) or not (getElementType(player) == "player") then return false end
	
	return getElementData(player,"username") or false
end

--isPlayerLoggedIn: returns (boolean) true if player is logged in, false otherwise.
function isPlayerLoggedIn(player)
	if not player or not isElement(player) or not (getElementType(player) == "player") then return false end
	
	if getElementData(player,"username") then return true else return false end
end

function isPlayerSpawned(player)
	if not player or not isElement(player) or not (getElementType(player) == "player") then return false end
	
	if getElementData(player,"character") then return true else return false end
end

function logoutPlayer(player)
	if not player or not isElement(player) or not (getElementType(player) == "player") then return false end
	
	logOut(player)
	return true
end

function changeCharacter(player)
	if not player or not isElement(player) or not (getElementType(player) == "player") then return false end
	
	onCharacterChange(player)
	return true
end