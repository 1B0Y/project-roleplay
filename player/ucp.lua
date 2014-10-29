function onStart() --This is triggered when the resource has been executed
	
	--Check if we have a supportive res
	local rX,rY = guiGetScreenSize()
	if (rX <= 800) or (rY <= 600) then
		addEventHandler("onClientRender",root,resWarning)
	end
end
addEventHandler("onClientResourceStart",resourceRoot,onStart)

local r,g,b = 0,0,0
local _r,_g,_b = true,false,true

function resWarning()
	local rX,rY = guiGetScreenSize()
	local text = "#FF0000[ #FFFFFFYOUR RESOLUTION IS #FF0000NOT #FFFFFFSUPPORTED! #FF0000]"
	local offset = 21
	local font = "sans"
	local width,height = dxGetTextWidth(text:gsub("#%x%x%x%x%x%x",""),1,font), dxGetFontHeight(font)

	dxDrawText(text,(rX/2)-(width/2),height,width,height,tocolor(255,255,255,255),1.00,font,"left","top",false,false,true,true,false)
end