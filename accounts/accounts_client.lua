--[[
	Project: SourceMode
	Version: 1.0
	Last Edited: 23/10/2014 (Jack)
	Authors: Jack
]]--

--Cache Data (do NOT touch as it contains client's account stuff)
local cacheData

--GUI stuff
windows = {}
edits = {}
checkboxes = {}
labels = {}
buttons = {}

addEvent("onPlayerLoggedIn",true)

function onStart()
	local rX,rY = guiGetScreenSize() --Get the player's screen resolution (so we can make sure GUI fits in all resolutions)
	
	--Login Panel
	local width,height = 384,444
	local X,Y = exports.utils:getGUICenter(rX,rY,width,height)
	windows["login"] = guiCreateWindow(X,Y,width,height,"SourceMode - Login",false)
		guiCreateStaticImage(17, 28, 350, 145,"images/mtalogo.png",false,windows["login"])
		labels[1] = guiCreateLabel(119,181,147,18,"Username",false,windows["login"])
		edits["login-username"] = guiCreateEdit(25,199,332,23,"",false,windows["login"])
		labels[2] = guiCreateLabel(119,233,147,18,"Password",false,windows["login"])
		edits["login-password"] = guiCreateEdit(25,251,332,23,"",false,windows["login"])
		checkboxes["remember"] = guiCreateCheckBox(132, 278, 124, 21, "Remember Details", true, false, windows["login"])
		buttons["login-login"] = guiCreateButton(27,299,330,26,"Login",false,windows["login"])
		buttons["login-register"] = guiCreateButton(27,335,330,26,"Register an account",false,windows["login"])
		buttons["login-recover"] = guiCreateButton(27,371,330,26,"Recover account",false,windows["login"])
		buttons["login-troll"] = guiCreateButton(287,418,87,16,"Skip Login",false,windows["login"]) --Comment this out if you're not the troll type ;)
	labels["login-status"] = guiCreateLabel(29,398,328,20,"",false,windows["login"])
	
	--NOPE Panel--
	local width,height = 416,228
	local X,Y = exports.utils:getGUICenter(rX,rY,width,height)
	windows["NOPE"] = guiCreateWindow(X,Y,width,height,"SourceMode - NOPE",false)
		guiCreateStaticImage(128,23,165,98,"images/nope.jpg",false,windows["NOPE"])
		labels[3] = guiCreateLabel(7,121,399,80,[[
			You need an account to play, otherwise everything you do will be lost. We don't want that! :|\n\n
			Register an account! it doesn't take too long."]],false,windows["NOPE"])
	buttons["NOPE-fine"] = guiCreateButton(128,201,165,23,"hhh... fine!",false,windows["NOPE"])
	
	local width,height = 493,382
	local X,Y = exports.utils:getGUICenter(rX,rY,width,height)
	windows["register"] = guiCreateWindow(X,Y,width,height, "SourceMode - Register", false)
		guiCreateStaticImage(66, 20, 365, 120, "images/mtalogo.png", false, windows["register"])
		edits["register-username"] = guiCreateEdit(27, 179, 270, 26, "", false, windows["register"])
		labels[4] = guiCreateLabel(98, 161, 122, 18, "Username", false, windows["register"])
		edits["register-password"] = guiCreateEdit(27, 223, 271, 27, "", false, windows["register"])
		labels[5] = guiCreateLabel(98, 205, 122, 18, "Password", false, windows["register"])
		edits["register-confirm"] = guiCreateEdit(27, 268, 271, 24, "", false, windows["register"])
		labels[6] = guiCreateLabel(98, 250, 122, 18, "Confirm Password", false, windows["register"])
		edits["register-email"] = guiCreateEdit(27, 314, 271, 24, "", false, windows["register"])
		labels["register-email"] = guiCreateLabel(98, 296, 122, 18, "Email Address", false, windows["register"])
		labels["status-username"] = guiCreateLabel(335, 179, 144, 26, "Enter a username", false, windows["register"])
		labels["status-password"] = guiCreateLabel(335, 223, 144, 27, "Enter a password", false, windows["register"])
		labels["status-confirm"] = guiCreateLabel(335, 266, 144, 26, "Confirm your password", false, windows["register"])
		labels["status-email"] = guiCreateLabel(335, 312, 144, 26, "Enter your email address", false, windows["register"])
		labels[7] = guiCreateLabel(305, 172, 21, 168, "|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n", false, windows["register"])
		buttons["register-back"] = guiCreateButton(50, 350, 180, 22, "Go back to Log In", false, windows["register"])
	buttons["register-attemptRegister"] = guiCreateButton(258, 350, 180, 22, "Register \"..username..\"", false, windows["register"])
	
	local width,height = 384,284
	local X,Y = exports.utils:getGUICenter(rX,rY,width,height)
	windows["recovery"] = guiCreateWindow(X,Y,width,height, "SourceMode - Recover", false)
		guiCreateStaticImage(119, 20, 150, 68, "images/mtalogo.png", false, windows["recovery"])
		labels[11] = guiCreateLabel(7, 88, 367, 30, "Enter your username, email and security question to recover your password.", false, windows["recovery"])
		edits["recovery-username"] = guiCreateEdit(24, 136, 327, 21, "", false, windows["recovery"])
		edits["recovery-email"] = guiCreateEdit(24, 176, 327, 21, "", false, windows["recovery"])
		edits["recovery-securityQuestion"] = guiCreateEdit(24, 216, 327, 21, "", false, windows["recovery"])
		labels[8] = guiCreateLabel(115, 122, 154, 14, "Username", false, windows["recovery"])
		labels[9] = guiCreateLabel(115, 162, 154, 14, "Email Address", false, windows["recovery"])
		labels[10] = guiCreateLabel(115, 202, 154, 14, "Security Question", false, windows["recovery"])
		buttons["recovery-back"] = guiCreateButton(34, 247, 136, 24, "Go back to Log In", false, windows["recovery"])
	buttons["recovery-attemptRecover"] = guiCreateButton(205, 247, 136, 24, "Recover \"..username..\"", false, windows["recovery"])
	
	--Loop through all buttons and add eventhandlers
	for k,v in ipairs(buttons) do
		addEventHandler("onClientGUIClick",v,onClick,false)
	end
	
	--Loop through all labels and add centering
	for k,v in ipairs(labels) do
		guiLabelSetHorizontalAlign(v, "center", true)
        guiLabelSetVerticalAlign(v, "center")
	end
	
	guiSetVisible(windows["NOPE"],false)
	guiSetVisible(windows["register"],false)
	guiSetVisible(windows["recovery"],false)
	showCursor(true)
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