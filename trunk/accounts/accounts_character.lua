--[[
	Project: SourceMode
	Version: 1.0
	Last Edited: 26/10/2014 (Jack)
	Authors: Jack
]]--

local windows = {}
local gridlists = {}
local buttons = {}
local pedPosition = {1994.044921875, 1580.0517578125, 17.5625, 17}
local characters --local copy of the player's characters
local selectedChar --Currently selected character
local character --ped

addEvent("onCharacterDataLoaded",true)

function onStart()
	local rX,rY = guiGetScreenSize()
	local width,height = 304, 425
	local X,Y = exports.utils:getGUICenter(rX,rY,width,height)
	windows["characters"] = guiCreateWindow(rX-width-5,Y,width,height, "SourceMode - Your Characters", false)
	guiWindowSetSizable(windows["characters"], false)
	guiWindowSetSizable(windows["characters"], false)
	gridlists["characters"] = guiCreateGridList(9, 86, 285, 272, false, windows["characters"])
	characters = guiGridListAddColumn(gridlists["characters"], "Characters", 0.9)
	guiCreateStaticImage(159, 168, 126, 104, "images/mtalogo.png", false, gridlists["characters"])
	buttons["create"] = guiCreateButton(9, 26, 285, 59, "Create a new character", false, windows["characters"])
	buttons["delete"] = guiCreateButton(9, 363, 285, 24, "Delete Character", false, windows["characters"])
	buttons["logout"] = guiCreateButton(9, 392, 285, 24, "Logout", false, windows["characters"])
	
	local width,height = 173, 68
	local X,Y = exports.utils:getGUICenter(rX,rY,width,height) --get center stuff
	buttons["play"] = guiCreateButton(X,Y+((Y/2)*1.6),width,height, "LET'S PARTY!", false)
	
	--button eventhandlers
	addEventHandler("onClientGUIClick",buttons["logout"],onCharacterClick,false)
	addEventHandler("onClientGUIClick",buttons["play"],onCharacterClick,false)
	addEventHandler("onClientGUIClick",gridlists["characters"],onCharacterClick,false)
	
	guiSetVisible(windows["characters"],false)
	guiSetVisible(buttons["play"],false)
	guiSetEnabled(buttons["play"],false)
	guiSetEnabled(buttons["create"],false)
	guiSetEnabled(buttons["delete"],false)
	guiSetEnabled(buttons["logout"],false)
end
addEventHandler("onClientResourceStart",resourceRoot,onStart)

function loadCharacterData(data)
	fadeCamera(false,1.0,0,0,0)
	toggleWindows("all",false)
	guiGridListClear(gridlists["characters"])
	if (data) then
		local data = fromJSON(data) --change back to a table!
		if (#data >= 1) then
			for k,v in ipairs(data) do
				local name = v.charName
				local row = guiGridListAddRow(gridlists["characters"])
				guiGridListSetItemText(gridlists["characters"],row,characters,name,false,false)
			end
		else
			local row = guiGridListAddRow(gridlists["characters"])
			guiGridListSetItemText(gridlists["characters"],row,characters,"You have no characters!",false,false)
		end
	else
		local row = guiGridListAddRow(gridlists["characters"])
		guiGridListSetItemText(gridlists["characters"],row,characters,"You have no characters!",false,false)
	end
	
	characters = fromJSON(data) --Store this for later use.
	setTimer(guiSetVisible,1000,1,windows["characters"],true)
	setTimer(guiSetVisible,1000,1,buttons["play"],true)
	setTimer(fadeCamera,1000,1,true,1.0)
	setTimer(setCameraMatrix,1000,1,1996.044921875, 1577.8408203125, 18.829193115234,1994.5673828125, 1579.44921875, 17.569759368896)
end
addEventHandler("onCharacterDataLoaded",root,loadCharacterData)

function onCharacterClick(button,state)
	if (button == "left" and state == "up") then
		if (source == buttons["logout"]) then
			triggerServerEvent("onPlayerAttemptLogout",localPlayer)
		elseif (source == gridlists["characters"]) then
			processCharacter()
		elseif (source == buttons["play"]) then
			if (character) then
				triggerServerEvent("onPlayerSelectCharacter",localPlayer,character)
				character = nil --Clear some memory for the client
			else
				return false --no idea how he gets passed this.
			end
		end
	end
end

function processCharacter()
	--First, figure out if we've got anything selected
	local row,column = guiGridListGetSelectedItem(gridlists["characters"])
	if (row ~= -1 and columns ~= 1) then
		local charName = guiGridListGetItemText(gridlists["characters"],row,1)
		if charName then
			for k,v in ipairs(characters) do
				if (v.charName == charName) then
					character = v
					break
				end
			end
			
			if (character) then
				local skin = character.model or 0 
				if ped and isElement(ped) then destroyElement(ped) end
				ped = createPed(tonumber(skin),pedPosition[1],pedPosition[2],pedPosition[3],250)
				setElementFrozen(ped,true)
				setPedAnimation(ped,"DANCING","dance_loop",-1,true,false)
				guiSetEnabled(buttons["play"],true)
				return true
			end
		end
	end
	
	if ped and isElement(ped) then destroyElement(ped) end
	guiSetEnabled(buttons["play"],false)
	character = nil
	return false
end

function toggleCharacterWindows(window,state)
	if (window == "all") then
		guiSetVisible(windows["characters"],state)
		guiSetVisible(buttons["play"],state)
	else
		--I should find a cleaner way to do this...
		if (windows[window]) then
			guiSetVisible(windows[window],state)
		elseif (buttons[window]) then
			guiSetVisible(buttons[window],state)
		end
	end
end