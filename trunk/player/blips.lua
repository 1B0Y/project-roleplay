--[[
	Project: SourceMode
	Version: 1.0
	Last Edited: 26/10/2014 (Jack)
	Authors: Jack
]]--

local pBlips = {}

function blipManager(player,state)
	if not player or not isElement(player) then return false end
	
	if state then
		if pBlips[player] and isElement(pBlips[player]) then destroyElement(pBlips[player]) end
		
		pBlips[player] = createBlipAttachedTo(player,0,2,0,0,0,0)
		setBlipVisibleDistance(pBlips[player],500)
	else
		if pBlips[player] and isElement(pBlips[player]) then destroyElement(pBlips[player]) end
	end
end

function onStart()
	for k,v in ipairs(getElementsByType("player")) do
		blipManager(v,true) --Create a new blip for the current players
	end
end
addEventHandler("onClientResourceStart",resourceRoot,onStart)

function onJoin()
	blipManager(source,true)
end
addEventHandler("onClientPlayerJoin",root,onJoin)

function onQuit()
	blipManager(source,false)
end
addEventHandler("onClientPlayerQuit",root,onQuit)

function onRender()
	for k,v in pairs(pBlips) do
		if not (isElement(k)) then pBlips[k] = nil return end
		
		if not (k == localPlayer) then
			if (getElementAlpha(k) == 0) then
				setBlipColor(v,255,255,255,0)
			else
				local r,g,b = getPlayerNametagColor(k)
				setBlipColor(v,r,g,b,255)
			end
		end
	end
end
addEventHandler("onClientRender",root,onRender)