--[[
	Project: SourceMode
	Version: 1.0
	Last Edited: 28/10/2014 (Jack)
	Authors: Jack
]]--

local protected = false

addEvent("updatePlayerProtection",true)

function onPlayerDamage()
	if protected then
		cancelEvent()
	end
end
addEventHandler("onClientPlayerDamage",root,onPlayerDamage)

function updateProtectedStatus(state)
	protected = state
end
addEventHandler("updatePlayerProtection",root,updateProtectedStatus)