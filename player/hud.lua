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
	local width,height = 350,145
	local angle = math.sin(getTickCount() / 1000) * 3.5
	
	dxDrawImage(rX-width+10,rY-height+25,width,height,"images/sourcemode.png",angle,0,0,tocolor(255,255,255,125),false)
end