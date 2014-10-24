--[[
	Project: SourceMode
	Version: 1.0
	Last Edited: 23/10/2014 (Jack)
	Authors: Jack
]]--

--Cache Data (do NOT touch as it contains client's account stuff)
local cacheData

--GUI stuff
local windows = {}
local edits = {}
local checkboxes = {}
local labels = {}
local buttons = {}

addEvent("onPlayerLoggedIn",true)

function onStart()
	local rX,rY = guiGetScreenSize() --Get the player's screen resolution (so we can make sure GUI fits in all resolutions)
	
	--Login Panel
	local width,height = 384,444
	local X,Y = exports.utils:getGUICenter(rX,rY,width,height)
	windows["login"] = guiCreateWindow(X,Y,width,height,"SourceMode - Login",false)
		guiCreateStaticImage(17,28,332,23,"images/mtalogo.png",false,windows["login"])
		labels["login-username"] = guiCreateLabel(119,181,147,18,"Username",false,windows["login"])
		edits["login-username"] = guiCreateEdit(25,199,332,23,"",false,windows["login"])
		labels["login-password"] = guiCreateLabel(119,233,147,18,"Password",false,windows["login"])
		edits["login-password"] = guiCreateEdit(25,251,332,23,"",false,windows["login"])
		checkboxes["remember"] = guiCreateCheckBox(132, 278, 124, 21, "Remember Details", true, false, windows["login"])
		buttons["login-login"] = guiCreateButton(27,299,330,26,"Login",false,windows["login"])
		buttons["login-register"] = guiCreateButton(27,335,330,26,"Register an account",false,windows["login"])
		buttons["login-recover"] = guiCreateButton(27,371,330,26,"Recover account",false,windows["login"])
		buttons["login-troll"] = guiCreateButton(287,418,87,16,"Skip Login",false,windows["login"]) --Comment this out if you're not the troll type ;)
	labels["login-status"] = guiCreateLabel(29,398,328,20,"",false,windwos["login"])
	
	--NOPE Panel--
	local width,height = 416,228
	local X,Y = exports.utils:getGUICenter(rX,rY,width,height)
	windows["NOPE"] = guiCreateWindow(X,Y,width,height,"SourceMode - NOPE",false)
		guiCreateStaticImage(128,23,165,98,"images/nope.jpg",false,windows["NOPE"])
		labels["info"] = guiCreateLabel(7,121,399,80,[[
			You need an account to play, otherwise everything you do will be lost. We don't want that! :|\n\n
			Register an account! it doesn't take too long."]],false,windows["NOPE"])
	buttons["NOPE-fine"] = guiCreateButton(128,201,165,23,"hhh... fine!",false,windows["NOPE"])
	
	--Register Panel--
	--TODO
	
	--Recovery Panel--
	--TODO
	
	--INSERT eventhandler stuff here, hide stuff, disable stuff, etc...
	
	loadCachedAccountData()
end
addEventHandler("onClientResourceStart",resourceRoot,onStart)

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
	guiCheckBoxSetSelected(checkboxes["remember"],exports.utils:convertToBool(remember))
	
	return true
end

function onPlayerLoggedIn(password,remember)
	if (remember) then
		--Password's already encrypted.
	end
end
addEventHandler("onPlayerLoggedIn",root,onPlayerLoggedIn)