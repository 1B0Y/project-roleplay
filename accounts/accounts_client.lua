--[[
	Project: SourceMode
	Version: 1.0
	Last Edited: 23/10/2014 (Jack)
	Authors: Jack
]]--

local cacheData

addEvent("onPlayerLoggedIn",true)

function onStart()
	local rX,rY = guiGetScreenSize() --Get the player's screen resolution (so we can make sure GUI fits in all resolutions)
	local width,height = 0,0 --Set this later
	local X,Y = (rX/2) - (width/2), (rY/2) - (height/2)
	--Create main window
	
	--...
	loadCachedAccountData()
end
addEventHandler("onResourceStart",resourceRoot,onStart)

function loadCachedAccountData()
	cacheData = xmlLoadFile("@account.xml")
	
	if not cacheData then
		cacheData = xmlCreateFile("@account.xml","account")
		return false --Stop here, since we have no data to load
	end
	
	local username = xmlNodeGetAttribute(cacheData,"username") or "" --In case nothing's set, we'll just put an empty string in it's place.
	local password = xmlNodeGetAttribute(cacheData,"password") or "" --Same for this.
	local remember = xmlNodeGetAttribute(cacheData,"remember") or "false"
	guiSetText(edits["login-username"],username)
	guiSetText(edits["login-password"],password)
	guiCheckBoxSetSelected(checks["remember"],exports.utils:convertToBool(remember))
	
	return true
end

function onPlayerLoggedIn(password,remember)
	if (remember) then
		--Password's already encrypted.
	end
end
addEventHandler("onPlayerLoggedIn",root,onPlayerLoggedIn)