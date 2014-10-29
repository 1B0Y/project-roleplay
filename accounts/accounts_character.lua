--[[
	Project: SourceMode
	Version: 1.0
	Last Edited: 26/10/2014 (Jack)
	Authors: Jack
]]--

local windows = {}
local gridlists = {}
local buttons = {}
local edits = {}
local labels = {}
local scrollbars = {}

local skins = {
[0] = {model = 0, name = "CJ"},
[1] = {model = 1, name = "Truth"},
[2] = {model = 2, name = "Maccer"},
[3] = {model = 270, name = "Sweet"},
[4] = {model = 271, name = "Ryder"}
}

--General
local pedPosition = {1994.044921875, 1579.9517578125, 17.5625, 250}
local _characters --local copy of the player's characters
local selectedChar --Currently selected character
local character --ped
local ped -- temp ped
local checkTimer

--Character Creator
local creating = false
local rendering = false
local model
local name
local r,g,b = 255,255,255

--Character Deleting
local deleting = false
local charDelete

--Custom events
addEvent("sendPlayerCharacters",true)
addEvent("returnCreateStatus",true)
addEvent("characters:toggleGUI",true)
addEvent("returnCharacterNameCheck",true)
addEvent("onCharacterCreated",true)
addEvent("onCharacterDeleted",true)
addEvent("callSpawnTrigger",true)
addEvent("callDespawnTrigger",true)

function onStart()
	local rX,rY = guiGetScreenSize()
	
	--[[
		Character Selection
		Version 1
	]]
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
	
	--[[
		Character Creation
		Version 2
	]]
	local width,height = 295,298
	local X,Y = exports.utils:getGUICenter(rX,rY,width,height)
	windows["creator"] = guiCreateWindow(rX-width-5,Y,width,height,"SourceMode - Create new character",false)
	edits["name"] = guiCreateEdit(9,40,277,24,"",false,windows["creator"])
	labels["name"] = guiCreateLabel(10,17,276,23,"Character Name",false,windows["creator"])
	labels["status"] = guiCreateLabel(8,63,278,15,"Please enter a character name.",false,windows["creator"])
	labels["character"] = guiCreateLabel(40, 94, 211, 22,"My Character Name",false,windows["creator"])
	labels["line1"] = guiCreateLabel(8, 78, 278, 15, "________________________________________", false, windows["creator"])
	labels["line2"] = guiCreateLabel(8, 199, 278, 15, "________________________________________", false, windows["creator"])
	scrollbars["red"] = guiCreateScrollBar(34,116,221,21,true,false,windows["creator"])
	scrollbars["green"] = guiCreateScrollBar(34,147,221,21,true,false,windows["creator"])
	scrollbars["blue"] = guiCreateScrollBar(34,178,221,21,true,false,windows["creator"])
	buttons["attemptCreate"] = guiCreateButton(9,229,277,26,"Create character",false,windows["creator"])
	buttons["back"] = guiCreateButton(9,260,277,26,"Cancel",false,windows["creator"])
	
	--GUI stuff
	local width,height = 113,60
	local X,Y = exports.utils:getGUICenter(rX,rY,width,height)
	buttons["left"] = guiCreateButton(X-(X/3),Y,width,height,"<",false)
	buttons["right"] = guiCreateButton(X+(X/3),Y,width,height,">",false)
	
	
	--[[
		Delete confirmation
		Version 1
	]]
	local width,height = 399, 128
	local X,Y = exports.utils:getGUICenter(rX,rY,width,height)
	windows["confDelete"] = guiCreateWindow(X,Y,width,height, "SourceMode - Delete Character?", false)
	guiCreateStaticImage(9, 22, 69, 54, "images/warning.png", false, windows["confDelete"])
	labels["confirm"] = guiCreateLabel(81, 32, 306, 32, "Are you sure you want to delete your character?\nDeleting your character will delete it permanently!", false, windows["confDelete"])
	buttons["yes"] = guiCreateButton(34, 85, 126, 25, "Yes", false, windows["confDelete"])
	buttons["no"] = guiCreateButton(234, 85, 126, 25, "No", false, windows["confDelete"])
	
	--Apply fonts and layouts to labels
	for k,v in pairs(labels) do
		guiSetFont(v,"default-bold-small")
		guiLabelSetHorizontalAlign(v,"center",false)
		guiLabelSetVerticalAlign(v,"center")
	end
	--Set our scrollbars to 50.
	for k,v in pairs(scrollbars) do
		guiScrollBarSetScrollPosition(v,50)
	end
	--Sort the rest out
	guiLabelSetColor(labels["status"],255,255,0)
	guiWindowSetMovable(windows["creator"],false)
	guiWindowSetSizable(windows["creator"],false)
	guiSetAlpha(windows["creator"],1)
	guiSetAlpha(windows["confDelete"],1)
	guiSetFont(buttons["left"],"sa-header")
	guiSetFont(buttons["right"],"sa-header")
	
	--Character Selection
	addEventHandler("onClientGUIClick",buttons["logout"],onCharacterClick,false)
	addEventHandler("onClientGUIClick",buttons["play"],onCharacterClick,false)
	addEventHandler("onClientGUIClick",buttons["create"],onCharacterClick,false)
	addEventHandler("onClientGUIClick",gridlists["characters"],onCharacterClick,false)
	
	--Character Creator
	addEventHandler("onClientGUIClick",buttons["back"],onCharacterClick,false)
	addEventHandler("onClientGUIClick",buttons["left"],onCharacterClick,false)
	addEventHandler("onClientGUIClick",buttons["right"],onCharacterClick,false)
	addEventHandler("onClientGUIClick",buttons["attemptCreate"],onCharacterClick,false)
	addEventHandler("onClientGUIClick",scrollbars["red"],onClientChange,false)
	addEventHandler("onClientGUIClick",scrollbars["green"],onClientChange,false)
	addEventHandler("onClientGUIClick",scrollbars["blue"],onClientChange,false)
	
	--Character Delete
	addEventHandler("onClientGUIClick",buttons["yes"],onCharacterClick,false)
	addEventHandler("onClientGUIClick",buttons["no"],onCharacterClick,false)
	addEventHandler("onClientGUIClick",buttons["delete"],onCharacterClick,false)
	
	guiSetVisible(windows["characters"],false)
	guiSetVisible(windows["creator"],false)
	guiSetVisible(windows["confDelete"],false)
	guiSetVisible(buttons["play"],false)
	guiSetVisible(buttons["left"],false)
	guiSetVisible(buttons["right"],false)
	guiSetEnabled(buttons["play"],false)
	--guiSetEnabled(buttons["create"],false)
	--guiSetEnabled(buttons["delete"],false)
end
addEventHandler("onClientResourceStart",resourceRoot,onStart)

function onCharacterClick(button,state)
	if (button == "left" and state == "up") then
		if (source == buttons["logout"]) then
			triggerServerEvent("onPlayerAttemptLogout",localPlayer)
		elseif (source == gridlists["characters"]) then
			processCharacter()
		elseif (source == buttons["create"]) then
			characterGUIManager("characters",nil,false)
			characterGUIManager("play",nil,false)
			toggleCreator(true)
		elseif (source == buttons["play"]) then
			if (character) then
				triggerServerEvent("onPlayerSelectCharacter",localPlayer,character)
				if character and isElement(character) then destroyElement(character) end
				character = nil --Clear some memory for the client
			else
				return false --no idea how he gets passed this.
			end
		--Character creation
		elseif (source == buttons["left"]) then	
			manageCharacterCreator("left")
		elseif (source == buttons["right"]) then
			manageCharacterCreator("right")
		elseif (source == buttons["attemptCreate"]) then
			manageCharacterCreator("create")
		elseif (source == buttons["back"]) then
			toggleCreator(false)
			characterGUIManager("characters",nil,true)
			characterGUIManager("play",nil,true)
		--Character deleting
		elseif (source == buttons["delete"]) then
			--Make sure we've got one of the characters selected
			local row,column = guiGridListGetSelectedItem(gridlists["characters"])
			local charName = guiGridListGetItemText(gridlists["characters"],row,1)
			if charName then
				for k,v in ipairs(_characters) do
					if (v.charName == charName) then
						charDelete = v
						break
					end
				end
				
				if (charDelete) then
					deleting = true
					characterGUIManager("confDelete",nil,true)
					characterGUIManager("characters",nil,false)
					characterGUIManager("play",nil,false)
					
					guiSetText(labels["confirm"],"Are you sure you want to delete "..charDelete.charName.."?\nDeleting your character will delete it permanently!")
				end
			end
		elseif (source == buttons["yes"]) then
			if (deleting) then
				deleteCharacter(charDelete)
			end
		elseif (source == buttons["no"]) then
			delete = false
			charDelete = nil
			characterGUIManager("confDelete",nil,false)
			characterGUIManager("characters",nil,true)
			characterGUIManager("play",nil,true)
		else
			outputChatBox("Unsupported feature.")
		end
	end
end

function loadCharacterData(data)
	guiGridListClear(gridlists["characters"])
	if (data) then
		local data = fromJSON(data) --change back to a table!
		if (#data >= 1) then
			for k,v in ipairs(data) do
				local name = v.charName
				local color = v.color
				local row = guiGridListAddRow(gridlists["characters"])
				guiGridListSetItemText(gridlists["characters"],row,characters,name,false,false)
				guiGridListSetItemColor(gridlists["characters"],row,characters,color[1],color[2],color[3],255)
			end
		else
			local row = guiGridListAddRow(gridlists["characters"])
			guiGridListSetItemText(gridlists["characters"],row,characters,"You have no characters!",false,false)
			guiGridListSetItemColor(gridlists["characters"],row,characters,255,0,0,255)
		end
	else
		local row = guiGridListAddRow(gridlists["characters"])
		guiGridListSetItemText(gridlists["characters"],row,characters,"You have no characters!",false,false)
		guiGridListSetItemColor(gridlists["characters"],row,characters,255,0,0,255)
	end
	
	_characters = fromJSON(data) --Store this for later use.
end
addEventHandler("sendPlayerCharacters",root,loadCharacterData)

function processCharacter()
	--First, figure out if we've got anything selected
	local row,column = guiGridListGetSelectedItem(gridlists["characters"])
	if (row ~= -1 and columns ~= 1) then
		local charName = guiGridListGetItemText(gridlists["characters"],row,1)
		if charName then
			for k,v in ipairs(_characters) do
				if (v.charName == charName) then
					character = v
					break
				end
			end
			
			if (character) then
				local skin = character.model or 0 
				if ped and isElement(ped) then destroyElement(ped) end
				ped = createPed(tonumber(skin),pedPosition[1],pedPosition[2],pedPosition[3],pedPosition[4])
				setElementFrozen(ped,true)
				setPedAnimation(ped,"DANCING","dance_loop",-1,true,false)
				guiSetEnabled(buttons["play"],true)
				setElementDimension(ped,getElementDimension(localPlayer))
				return true
			end
		end
	end
	
	if ped and isElement(ped) then destroyElement(ped) end
	guiSetEnabled(buttons["play"],false)
	_character = nil
	return false
end

function onClientChange()
	if (source == edits["name"]) then
		name = guiGetText(edits["name"]):gsub("[%s]","")
		if #name >= 1 then
			guiSetText(labels["character"],name)
			if (#name >= 3) then
				guiSetText(labels["status"],"Checking character name...")
				guiLabelSetColor(labels["status"],255,255,0)
				
				if checkTimer and isTimer(checkTimer) then killTimer(checkTimer) end
				checkTimer = setTimer(checkCharacterName,1000,1)
			else
				guiSetText(labels["status"],"Your character name must be 3 chars long.")
				guiLabelSetColor(labels["status"],255,0,0)
				if checkTimer and isTimer(checkTimer) then killTimer(checkTimer) end
			end
		else
			guiSetText(labels["character"],"My Character Name")
			guiSetText(labels["status"],"Please enter a character name.")
			guiLabelSetColor(labels["status"],255,255,0)
			if checkTimer and isTimer(checkTimer) then killTimer(checkTimer) end
		end
	end
end
addEventHandler("onClientGUIChanged",root,onClientChange)

function checkCharacterName(available,name)	
	if available ~= nil then
		if (available == true) then
			guiSetText(labels["status"], name.." is available!")
			guiLabelSetColor(labels["status"],0,255,0)
		else
			guiSetText(labels["status"],name.." is not available!")
			guiLabelSetColor(labels["status"],255,0,0)
		end
		return --Stop here.
	end
	
	local name = guiGetText(edits["name"])
	name = name:gsub("%W","") --Causes graphical gliches.
	name = name:lower()
	triggerServerEvent("checkCharacterName",localPlayer,name)
end
addEventHandler("returnCharacterNameCheck",root,checkCharacterName)

function toggleCreator(state)
	if state then
		if not rendering then
			addEventHandler("onClientRender",root,drawSkinHud)
			rendering = true
		end
		if ped and isElement(ped) then destroyElement(ped) end
		name = ""
		model = 0
		ped = createPed(0,pedPosition[1],pedPosition[2],pedPosition[3],pedPosition[4]-25)
		setElementDimension(ped,getElementDimension(localPlayer))
	else
		if rendering then
			removeEventHandler("onClientRender",root,drawSkinHud)
			rendering = false
		end
		if ped and isElement(ped) then destroyElement(ped) end
	end
	
	creating = state
	guiSetVisible(windows["creator"],creating)
	guiSetVisible(buttons["left"],creating)
	guiSetVisible(buttons["right"],creating)
end

function getColorBasedOnScrollbars()
	local red = guiScrollBarGetScrollPosition(scrollbars["red"])
	local green = guiScrollBarGetScrollPosition(scrollbars["green"])
	local blue = guiScrollBarGetScrollPosition(scrollbars["blue"])
		
	--Now to get it in a "percentage"
	red = (red/100)*255
	green = (green/100)*255
	blue = (blue/100)*255
		
	r,g,b = red,green,blue
	guiLabelSetColor(labels["character"],r,g,b)
end

function drawSkinHud()
	local rX,rY = guiGetScreenSize()
	local skinName = skins[model].name
	local font = "bankgothic"
	local width,height = dxGetTextWidth(skinName),dxGetFontHeight(font)
	local X,Y = (rX-width), (rY-height)
	dxDrawText(skinName.." (".. model+1 ..")",X,Y,width,height, tocolor(255, 255, 255, 255), 1.00, "bankgothic", "center", "center", false, false, true, false, false)
	getColorBasedOnScrollbars()
end

function manageCharacterCreator(_function)
	if not creating then return false end
	if not ped or not isElement(ped) then return false end
	if _function == "left" then
		if (model - 1 < 0) then
			model = #skins
		else
			model = model - 1
		end
		setElementModel(ped,skins[model].model)
	elseif _function == "right" then
		if (model + 1 > #skins) then
			model = 0
		else
			model = model + 1
		end
		setElementModel(ped,skins[model].model)
	elseif _function == "create" then
		if not model then return false end
		if not name or #name < 1 then return false end
		
		--Pre-define the tag colors and other things we need
		if not (r) then r = math.random(255) end
		if not (g) then g = math.random(255) end
		if not (b) then b = math.random(255) end
		local skin = 0
		if (skins[model]) then 
			skin = skins[model].model
		end
		
		--attempt to create the new character
		triggerServerEvent("onPlayerCreateNewCharacter",localPlayer,name,skin,{math.floor(r),math.floor(g),math.floor(b)})
	end
end

function onCharacterCreated(characters)
	--Close the creator
	toggleCreator(false)
	
	--Load our new characters
	loadCharacterData(characters)
	
	--Open our characters window up
	characterGUIManager("characters",nil,true)
	characterGUIManager("play",nil,true)
end
addEventHandler("onCharacterCreated",root,onCharacterCreated)

function deleteCharacter(data,characters)
	if characters == nil then
		local character = data.charName
		triggerServerEvent("onPlayerDeleteCharacter",localPlayer,character)
		return
	end
	
	loadCharacterData(characters)
	characterGUIManager("confDelete",nil,false)
	characterGUIManager("characters",nil,true)
	characterGUIManager("play",nil,true)
end
addEventHandler("onCharacterDeleted",root,deleteCharacter)

function characterGUIManager(window,fade,state)
	if window == "all" then
		guiSetVisible(windows["characters"],state)
		guiSetVisible(windows["creator"],state)
		guiSetVisible(buttons["play"],state)
		guiSetVisible(buttons["left"],state)
		guiSetVisible(buttons["right"],state)
		if not state then toggleCreator(false) end
	else
		if (windows[window]) then
			guiSetVisible(windows[window],state)
		end
		
		if (buttons[window]) then
			guiSetVisible(buttons[window],state)
		end
	end
end
addEventHandler("characters:toggleGUI",root,characterGUIManager)

function onPlayerSpawned()
	triggerEvent("onClientPlayerSpawned",localPlayer)
end
addEventHandler("callSpawnTrigger",root,onPlayerSpawned)

function onPlayerDespawned()
	triggerEvent("onClientPlayerDespawned",localPlayer)
end
addEventHandler("callDespawnTrigger",root,onPlayerSpawned)