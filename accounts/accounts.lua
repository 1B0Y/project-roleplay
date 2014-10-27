--[[
	Project: SourceMode
	Version: 1.0
	Last Edited: 26/10/2014 (Jack)
	Authors: Jack
]]--

local reset --Info status timer.

--GUI stuff
local windows = {}
local edits = {}
local checkboxes = {}
local labels = {}
local buttons = {}
local gridlists = {}

--Our custom event handlers
addEvent("onPlayerLoggedIn",true)
addEvent("returnUpdateStatus",true)
addEvent("returnUsernameAvailability",true)
addEvent("onAccountRegistered",true)
addEvent("toggleGUI",true)

function onStart()
	local rX,rY = guiGetScreenSize() --Get the player's screen resolution (so we can make sure GUI fits in all resolutions)
	loadCacheFile()
	
	--[[
		Login Panel
		Version 1
	]]
	local width,height = 384,444+16
	local X,Y = exports.utils:getGUICenter(rX,rY,width,height)
	windows["login"] = guiCreateWindow(X,Y,width,height,"SourceMode - Login",false)
	guiSetAlpha(windows["login"],1)
	guiWindowSetMovable(windows["login"],false)
	guiWindowSetSizable(windows["login"],false)
	guiCreateStaticImage(17, 28, 350, 145,"images/mtalogo.png",false,windows["login"])
	labels[1] = guiCreateLabel(119,181,147,18,"Username",false,windows["login"])
	edits["login-username"] = guiCreateEdit(25,199,332,23,getCacheData("username") or "",false,windows["login"])
	labels[2] = guiCreateLabel(119,233,147,18,"Password",false,windows["login"])
	edits["login-password"] = guiCreateEdit(25,251,332,23,getCacheData("password") or "",false,windows["login"])
	guiEditSetMasked(edits["login-password"],true)
	remember = exports.utils:convertToBool(getCacheData("remember"))
	if not remember then remember = false end
	checkboxes["remember"] = guiCreateCheckBox(132, 278, 124, 21, "Remember Details", remember, false, windows["login"])
	buttons["login-attemptLogin"] = guiCreateButton(27,299,330,26,"Login",false,windows["login"])
	buttons["login-register"] = guiCreateButton(27,335,330,26,"Register an account",false,windows["login"])
	buttons["login-recover"] = guiCreateButton(27,371,330,26,"Recover my account",false,windows["login"])
	buttons["login-troll"] = guiCreateButton(287,418+16,87,16,"Skip Login",false,windows["login"]) --Comment this out if you're not the troll type ;)
	labels["login-status"] = guiCreateLabel(29,398,328,20+20,"Welcome to the network of SourceMode!",false,windows["login"])
	guiLabelSetHorizontalAlign(labels["login-status"], "center", true)
	guiLabelSetVerticalAlign(labels["login-status"], "top")
	addEventHandler("onClientGUIClick",buttons["login-attemptLogin"],onAccountClick,false)
	addEventHandler("onClientGUIClick",buttons["login-register"],onAccountClick,false)
	addEventHandler("onClientGUIClick",buttons["login-recover"],onAccountClick,false)
	addEventHandler("onClientGUIClick",buttons["login-troll"],onAccountClick,false)
	
	--[[
		NOPE Panel
		Version 1
	]]
	local width,height = 416,228
	local X,Y = exports.utils:getGUICenter(rX,rY,width,height)
	windows["NOPE"] = guiCreateWindow(X,Y,width,height,"SourceMode - NOPE",false)
	guiSetAlpha(windows["NOPE"],1)
	guiWindowSetMovable(windows["NOPE"],false)
	guiWindowSetSizable(windows["NOPE"],false)
	guiCreateStaticImage(128,23,165,98,"images/nope.jpg",false,windows["NOPE"])
	labels[3] = guiCreateLabel(7,121,399,80,[[You need an account to play, otherwise everything you do will be lost. We don't want that! :|
		Register an account! it doesn't take too long.]],false,windows["NOPE"])
	buttons["NOPE-fine"] = guiCreateButton(128,201,165,23,"hhh... fine!",false,windows["NOPE"])
	addEventHandler("onClientGUIClick",buttons["NOPE-fine"],onAccountClick,false)
	
	--[[
		Register Panel
		Version 3
	]]
	windows["register"] = guiCreateWindow(489, 116, 303, 498, "SourceMode - Register", false)
	guiWindowSetSizable(windows["register"], false)
	guiWindowSetMovable(windows["register"],false)
	guiSetAlpha(windows["register"], 1.00)
	guiCreateStaticImage(71, 20, 174, 109, "images/mtalogo.png", false, windows["register"])
	edits["register-username"] = guiCreateEdit(16, 137, 271, 26, "", false, windows["register"])
	edits["register-password"] = guiCreateEdit(16, 197, 271, 26, "", false, windows["register"])
	guiEditSetMasked(edits["register-password"],true)
	edits["register-confirm"] = guiCreateEdit(16, 257, 271, 26, "", false, windows["register"])
	guiEditSetMasked(edits["register-confirm"],true)
	edits["register-email"] = guiCreateEdit(16, 317, 271, 26, "", false, windows["register"])
	labels["status-username"] = guiCreateLabel(16, 163, 271, 34, "Choose a username.", false, windows["register"])
	labels["status-password"] = guiCreateLabel(16, 223, 271, 34, "Choose a password.", false, windows["register"])
	labels["status-confirm"] = guiCreateLabel(16, 283, 271, 34, "Confirm your chosen password.", false, windows["register"])
	labels["status-email"] = guiCreateLabel(16, 343, 271, 34, "Enter your email address.\nOptional, but recommended!", false, windows["register"])
	labels["register-status"] = guiCreateLabel(22, 378, 260, 35, "", false, windows["register"])
	guiLabelSetHorizontalAlign(labels["status-username"], "center", true)
	guiLabelSetHorizontalAlign(labels["status-password"], "center", true)
	guiLabelSetHorizontalAlign(labels["status-confirm"], "center", true)
	guiLabelSetHorizontalAlign(labels["status-email"], "center", true)
	guiLabelSetHorizontalAlign(labels["register-status"], "center", true)
	buttons["register-attemptRegister"] = guiCreateButton(41, 387+30, 215, 29, "Register my account", false, windows["register"])
	buttons["register-cancel"] = guiCreateButton(41, 426+28, 215, 29, "Cancel, back to login.", false, windows["register"])	
	addEventHandler("onClientGUIClick",buttons["register-attemptRegister"],onAccountClick,false)
	addEventHandler("onClientGUIClick",buttons["register-cancel"],onAccountClick,false)
	
	--[[
		Recovery Panel
		Version 1
	]]
	local width,height = 384,284
	local X,Y = exports.utils:getGUICenter(rX,rY,width,height)
	windows["recovery"] = guiCreateWindow(X,Y,width,height, "SourceMode - Recover", false)
	guiSetAlpha(windows["recovery"],1)
	guiWindowSetMovable(windows["recovery"],false)
	guiWindowSetSizable(windows["recovery"],false)
	guiCreateStaticImage(119, 20, 150, 68, "images/mtalogo.png", false, windows["recovery"])
	labels[11] = guiCreateLabel(7, 88, 367, 30, "Enter your username, email and security question to recover your password.", false, windows["recovery"])
	edits["recovery-username"] = guiCreateEdit(24, 136, 327, 21, "", false, windows["recovery"])
	edits["recovery-email"] = guiCreateEdit(24, 176, 327, 21, "", false, windows["recovery"])
	edits["recovery-securityQuestion"] = guiCreateEdit(24, 216, 327, 21, "", false, windows["recovery"])
	labels[8] = guiCreateLabel(115, 122, 154, 14, "Username", false, windows["recovery"])
	labels[9] = guiCreateLabel(115, 162, 154, 14, "Email Address", false, windows["recovery"])
	labels[10] = guiCreateLabel(115, 202, 154, 14, "Security Question", false, windows["recovery"])
	buttons["recovery-back"] = guiCreateButton(34, 247, 136, 24, "Go back to Log In", false, windows["recovery"])
	buttons["recovery-attemptRecovery"] = guiCreateButton(205, 247, 136, 24, "Recover account", false, windows["recovery"])
	addEventHandler("onClientGUIClick",buttons["recovery-back"],onAccountClick,false)
	addEventHandler("onClientGUIClick",buttons["recovery-attemptRecovery"],onAccountClick,false)

	--Loop through all labels and add centering
	for k,v in ipairs(labels) do
		guiLabelSetHorizontalAlign(v, "center", true)
		guiLabelSetVerticalAlign(v, "center")
	end

	--Hide main windows except login!
	guiSetVisible(windows["NOPE"],false)
	guiSetVisible(windows["register"],false)
	guiSetVisible(windows["recovery"],false)
	showCursor(true)
	guiSetInputMode("no_binds") --Disable chat and etc..
end
addEventHandler("onClientResourceStart",resourceRoot,onStart)

--onClick: Handles all buttons within the account system.
function onAccountClick(button,state)
	if (button == "left") and (state == "up") then
		--open section
		if (source == buttons["login-troll"]) then
			guiSetVisible(windows["NOPE"],true)
			guiSetVisible(windows["login"],false)
			playSound("sound/nope.mp3")
		elseif (source == buttons["login-register"]) then
			guiSetVisible(windows["register"],true)
			guiSetVisible(windows["login"],false)
		elseif (source == buttons["login-recover"]) then
			--[[guiSetVisible(windows["recovery"],true)
			guiSetVisible(windows["login"],false)]]
			playSound("sound/nope.mp3")
		
		--close section
		elseif (source == buttons["NOPE-fine"]) then
			guiSetVisible(windows["NOPE"],false)
			guiSetVisible(windows["login"],true)
		elseif (source == buttons["register-cancel"]) then
			guiSetVisible(windows["register"],false)
			guiSetVisible(windows["login"],true)
		elseif (source == buttons["recovery-back"]) then
			guiSetVisible(windows["recovery"],false)
			guiSetVisible(windows["login"],true)
		
		--attempt section
		elseif (source == buttons["login-attemptLogin"]) then
			sendLoginData()
		elseif (source == buttons["register-attemptRegister"]) then
			sendRegisterData()
		elseif (source == buttons["recovery-attemptRecovery"]) then
			outputChatBox("NOPE")
			playSound("sound/nope.mp3") --We'll remove these later.
		else
			outputChatBox("unknown button!")
		end
	end
end

--sendLoginData: Function to send account data to the server for logging in.
function sendLoginData()
	--Check if the username and password information has been entered
	local username = guiGetText(edits["login-username"]):gsub("[%s]","") --Filter everything but characters
	local password = guiGetText(edits["login-password"])
	local remember = guiCheckBoxGetSelected(checkboxes["remember"]) or false
	local encrypted = getCacheData("encrypted") or false
	local encrypted = exports.utils:convertToBool(encrypted)
	
	if (#username >= 3) and (#password >= 5) then
		triggerServerEvent("onPlayerAttemptLogin",localPlayer,username,password,remember,encrypted)
		guiSetText(labels["login-status"],"Logging in as "..username.."...")
	else
		guiSetText(labels["login-status"],"You must have the username and password boxes filled in!")
		if reset and isTimer(reset) then killTimer(reset) end
		reset = setTimer(function() guiSetText(labels["login-status"],"") end, 3000, 1)
	end
end

--sendRegisterData: Function to send account data to the server for registering.
function sendRegisterData()
	outputDebugString("sendRegisterData")
	local username = guiGetText(edits["register-username"]):gsub("[%s]","")
	local password = guiGetText(edits["register-password"])
	local passwordConf = guiGetText(edits["register-confirm"])
	local email = guiGetText(edits["register-email"])
	
	if not (#username >= 1) then
		guiSetText(labels["status-username"],"Enter a username!")
		guiLabelSetColor(labels["status-username"],255,0,0)
		if reset and isTimer(reset) then killTimer(reset) end
		reset = setTimer(function() guiLabelSetColor(labels["status-username"],255,255,255) end, 3000, 1)
		return
	elseif not (#password >= 5) then
		guiSetText(labels["status-password"],"Enter a password!")
		guiLabelSetColor(labels["status-password"],255,0,0)
		if reset and isTimer(reset) then killTimer(reset) end
		reset = setTimer(function() guiLabelSetColor(labels["status-password"],255,255,255) end, 3000, 1)
		return
	elseif not (#passwordConf >= 5) then
		guiSetText(labels["status-confirm"],"Re-enter your password!")
		guiLabelSetColor(labels["status-confirm"],255,0,0)
		if reset and isTimer(reset) then killTimer(reset) end
		reset = setTimer(function() guiLabelSetColor(labels["status-confirm"],255,255,255) end, 3000, 1)
		return
	elseif not (password == passwordConf) then
		guiSetText(labels["status-confirm"],"Confirm password is not the same!")
		guiLabelSetColor(labels["status-confirm"],255,0,0)
		if reset and isTimer(reset) then killTimer(reset) end
		reset = setTimer(function() guiLabelSetColor(labels["status-confirm"],255,255,255) end, 3000, 1)
		return
	elseif not (#email >= 1) then
		email = "NULL" --He can set this later.
	end
	
	triggerServerEvent("onPlayerAttemptRegister",localPlayer,username,password,email)
	return true
end

--GUIAccepted: Pressing "Enter" will toggle the functions below.
addEventHandler("onClientGUIAccepted",root,
function(box)
	if (box == edits["login-username"]) or (box == edits["login-password"]) then
		sendLoginData()
	elseif (box == edits["register-username"]) or (box == edits["register-password"]) or (box == edits["register-confirm"]) or (box == edits["register-email"]) then
		sendRegisterData()
	end
end)

--onElementChanged: Alters the GUI based on the user inputs. Also checks usernames for Register.
local usernameChecker
function onElementChanged(element)
	if (element == edits["login-username"]) then
		local username = guiGetText(edits["login-username"])
		if (#username >= 1) then
			guiSetText(buttons["login-attemptLogin"],"Log in as "..username)
		else
			guiSetText(buttons["login-attemptLogin"],"Login")
		end
	elseif (element == edits["login-password"]) then
		setCacheData("encrypted","false") --Disable this since the password was edited.
	elseif (element == edits["register-username"]) then
		local username = guiGetText(edits["register-username"])
		if (#username >= 1) then
			guiSetText(buttons["register-attemptRegister"],"Register as "..username)
		else
			guiSetText(buttons["register-attemptRegister"],"Register account")
		end
		
		local username = guiGetText(edits["register-username"])
		if (#username >= 3) then
			if usernameChecker and isTimer(usernameChecker) then killTimer(usernameChecker) end
			usernameChecker = setTimer(triggerServerEvent,1000,1,"checkUsernameAvailability",localPlayer,username)
			guiSetText(labels["status-username"],"Checking username...")
			guiLabelSetColor(labels["status-username"],255,255,0)
		else
			guiSetText(labels["status-username"],"Choose a username.")
			guiLabelSetColor(labels["status-username"],255,255,255)
		end
	elseif (element == edits["recovery-username"]) then
		local username = guiGetText(edits["recovery-username"])
		if (#username >= 1) then
			guiSetText(buttons["recovery-attemptRecovery"],"Recover username "..username)
		else
			guiSetText(buttons["recovery-attemptRecovery"],"Recover account")
		end
	end
end
addEventHandler("onClientGUIChanged",root,onElementChanged)

--returnLoginState: Displays information regarding login (like networking issues, wrong password, ...)
function returnUpdateStatus(gui,text)
	local element
	if (gui == "login") then
		element = labels["login-status"]
	elseif (gui == "register") then
		element = labels["register-status"]
	else
		return
	end
	
	guiSetText(element,tostring(text))
	if reset and isTimer(reset) then killTimer(reset) end
	reset = setTimer(function() guiSetText(element,"") end, 3000, 1)
end
addEventHandler("returnUpdateStatus",root,returnUpdateStatus)

--usernameAvailable: Returns if the username is available to use or not.
function usernameAvailable(username,available)
	if (available) then
		guiSetText(labels["status-username"],username.." is available!")
		guiLabelSetColor(labels["status-username"],0,255,0)
	else
		guiSetText(labels["status-username"],username.." is not available!")
		guiLabelSetColor(labels["status-username"],255,0,0)
	end
end
addEventHandler("returnUsernameAvailability",root,usernameAvailable)

--onAccountRegistered: Switch from register to login for the player.
function onAccountRegistered(state,username,password)
	if state then
		guiSetVisible(windows["login"],true)
		guiSetVisible(windows["register"],false)
		returnUpdateStatus("login","Your account "..username.." was successfully registered. Press login to get going!")
		
		--Enter the account information in for the player
		guiSetText(edits["login-username"],username)
		guiSetText(edits["login-password"],password)
		guiCheckBoxSetSelected(checkboxes["remember"],true)
		
		--Update cache
		setCacheData("username",username)
		setCacheData("password",password)
		setCacheData("remember","true")
		setCacheData("encrypted","true")
	else
		returnUpdateStatus("register","An unexpected issue has occured while registering, please try again or contact an admin.")
		return
	end
end
addEventHandler("onAccountRegistered",root,onAccountRegistered)

function toggleWindows(window,state)
	if (window == "all") then
		guiSetVisible(windows["login"],state)
		guiSetVisible(windows["NOPE"],state)
		guiSetVisible(windows["register"],state)
		guiSetVisible(windows["recovery"],state)
		toggleCharacterWindows("all",state) --Turn off character windows aswell.
		if state then guiSetInputMode("no_binds") else guiSetInputMode("allow_binds") end
	elseif (window == "hud") then
		showPlayerHudComponent("all",state)
	else
		if (windows[window]) then
			guiSetVisible(windows[window],state)
		elseif (window == "characters") or (window == "characters_create") then --We'll allow characters window control from here.
			toggleCharacterWindows(window,state)
		end
	end
end
addEventHandler("toggleGUI",root,toggleWindows)