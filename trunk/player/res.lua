--[[
	Project: SourceMode
	Version: 1.0
	Last Edited: 29/10/2014 (Jack)
	Authors: Jack
]]--

function onStart() --This is triggered when the resource has been executed
	
	--Check if we have a supportive res
	local rX,rY = guiGetScreenSize()
	if (rX <= 800) or (rY <= 600) then
		addEventHandler("onClientRender",root,resWarning)
	end
end
addEventHandler("onClientResourceStart",resourceRoot,onStart)

function resWarning()
	-- Thanks Callum for the DX support! ;)
	local rX,rY = guiGetScreenSize()
	local text = "#FF0000[ #FFFFFFYOUR RESOLUTION IS #FF0000NOT #FFFFFFSUPPORTED! #FF0000]"
	local offset = 21
	local font = "sans"
	local width,height = dxGetTextWidth(text:gsub("#%x%x%x%x%x%x",""),1,font), dxGetFontHeight(font)

	dxDrawText(text,(rX/2)-(width/2),height,width,height,tocolor(255,255,255,255),1.00,font,"left","top",false,false,true,true,false)
end