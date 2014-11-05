--[[
	Project: SourceMode
	Version: 1.0
	Last Edited: 29/10/2014 (Jack)
	Authors: Jack
]]--

local rX,rY = guiGetScreenSize()

function onStart() --This is triggered when the resource has been executed
	
	--Check if we have a supportive res
	if (rX <= 800) or (rY <= 600) then
		addEventHandler("onClientRender",root,resWarning)
	end
	
	addEventHandler("onClientRender",root,logo)
	addEventHandler("onClientRender",root,info) --Bank, Nogoto
end
addEventHandler("onClientResourceStart",resourceRoot,onStart)

function resWarning()
	-- Thanks Callum for the DX support! ;)
	local text = "#FF0000[ #FFFFFFYOUR RESOLUTION IS #FF0000NOT #FFFFFFSUPPORTED! #FF0000]"
	local offset = 21
	local font = "sans"
	local width,height = dxGetTextWidth(text:gsub("#%x%x%x%x%x%x",""),1,font), dxGetFontHeight(font)

	dxDrawText(text,(rX/2)-(width/2),height,width,height,tocolor(255,255,255,255),1.00,font,"left","top",false,false,true,true,false)
end

function logo()
	--if not (getResourceState(getResourceFromName("accounts")) == "running") then return false end
	if not (exports.accounts:isPlayerLoggedIn()) or not (exports.accounts:isPlayerSpawned()) then return false end
	local scale = .75
	local width,height = 350*scale,145*scale
	local speed = 7500 --Increase to go slower, decrease to go faster.
	local angle = math.cos(getTickCount() / speed) * 5
	
	dxDrawImage(rX/1.15-width/2,rY/1.1-height/2,width,height,"images/sourcemode.png",angle,0,0,tocolor(255,255,255,175),false)
end

function info()
	if not (exports.accounts:isPlayerLoggedIn()) or not (exports.accounts:isPlayerSpawned()) then return false end
	
	local bankMoney = 999999999 --Change this to the export later
	local nogoto = getElementData(localPlayer,"nogoto")
	local font = "pricedown"
	
	--hud = "Bank: #00FF00$"..exports.utils:convertToMoney(bankMoney).."\n" --Start off with drawing the Bank hud
	hud = ""
	
	--Process it more by adding the Nogoto state
	if nogoto == true then
		hud = hud .. "#FFFFFFNogoto: #7cbb00Enabled"
	elseif nogoto == false then
		hud = hud .. "#FFFFFFNogoto: #f65314Disabled"
	end
	
	local width,height = dxGetTextWidth(hud:gsub("#%x%x%x%x%x%x",""),1,font), dxGetFontHeight(1,font)
	
	--Thank you ccw for debugging this part.
	local x,y,w,h = rX/1.17-width/2, rY/3.3-height/2, width, height
	dxDrawText(hud,x,y,x+w,y+h,tocolor(255,255,255,255),1,font,"center", "center", false, false, false, true, true)
	--dxDrawRectangle(x,y,w,h,tocolor(255,255,255,128))
end