--[[
	Project: SourceMode
	Version: 1.0
	Last Edited: 25/10/2014 (Jack)
	Authors: Jack
]]--

local windows = {}
local gridlists = {}
local buttons = {}

addEvent("onCharacterDataLoaded",true)

function onStart()
	local rX,rY = guiGetScreenSize()
	local width,height = 265,414
	local X,Y = exports.utils:getGUICenter(rX,rY,width,height)
	windows["character"] = guiCreateWindow(X+(X),Y+(Y/4),width,height, "SourceMode - Select Character", false)
	guiWindowSetMovable(windows["character"], false)
	guiWindowSetSizable(windows["character"], false)
	guiSetAlpha(windows["character"], 1.00)
	gridlists["characters"] = guiCreateGridList(9, 91, 246, 278, false, windows["character"])
	character = guiGridListAddColumn(gridlists["characters"], "Character", 0.3)
	duration = guiGridListAddColumn(gridlists["characters"], "Duration", 0.3)
	money = guiGridListAddColumn(gridlists["characters"], "Money", 0.3)
	buttons["join"] = guiCreateButton(9, 22, 246, 59, "LET'S PARTY!", false, windows["character"])
	buttons["create"] = guiCreateButton(20, 376, 225, 28, "Create new character", false, windows["character"])
	
	guiSetVisible(windows["character"],false)
	guiSetEnabled(buttons["join"],false)
end
addEventHandler("onClientResourceStart",resourceRoot,onStart)

function loadCharacterData(data)
	fadeCamera(false,1.0,0,0,0)
	toggleAccountWindows(false)
	if (data) and (#data >= 1) then
		--Parse it
	else
		row = guiGridListAddRow(gridlists["characters"])
		guiGridListSetItemText(gridlists["characters"],row,character,"N/A",false,false)
		guiGridListSetItemText(gridlists["characters"],row,duration,"N/A",false,false)
		guiGridListSetItemText(gridlists["characters"],row,money,"N/A",false,false)
	end
	setTimer(guiSetVisible,1000,1,windows["character"],true)
	setTimer(fadeCamera,1000,1,true,1.0)
	setTimer(setCameraMatrix,1000,1,1996.044921875, 1577.8408203125, 18.829193115234,1994.5673828125, 1579.44921875, 17.569759368896)
end
addEventHandler("onCharacterDataLoaded",root,loadCharacterData)