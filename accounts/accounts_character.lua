--[[
	Project: SourceMode
	Version: 1.0
	Last Edited: 26/10/2014 (Jack)
	Authors: Jack
]]--

local windows = {}
local gridlists = {}
local buttons = {}

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
	addEventHandler("onClientGUIClick",buttons["logout"],onCharacterClickClick,false)
	
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
	if (data) and (#data >= 1) then
		local data = fromJSON(data) --change back to a table!
		for k,v in ipairs(data) do
			local name = v.charName
			local row = guiGridListAddRow(gridlists["characters"])
			guiGridListSetItemText(gridlists["characters"],row,characters,name,false,false)
		end
	else
		local row = guiGridListAddRow(gridlists["characters"])
		guiGridListSetItemText(gridlists["characters"],row,characters,"You have no characters!",false,false)
	end
	setTimer(guiSetVisible,1000,1,windows["characters"],true)
	setTimer(guiSetVisible,1000,1,buttons["play"],true)
	setTimer(fadeCamera,1000,1,true,1.0)
	setTimer(setCameraMatrix,1000,1,1996.044921875, 1577.8408203125, 18.829193115234,1994.5673828125, 1579.44921875, 17.569759368896)
end
addEventHandler("onCharacterDataLoaded",root,loadCharacterData)

function onCharacterClickClick(button,state)
	if (button == "left" and state == "up") then
		if (source == buttons["logout"]) then
			triggerServerEvent("onPlayerAttemptLogout",localPlayer)
		end
	end
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