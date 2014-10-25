--[[
	Project: SourceMode
	Version: 1.0
	Last Edited: 25/10/2014 (Jack)
	Authors: Jack
]]--

local reset --Info status timer.

--GUI stuff
windows = {}
edits = {}
checkboxes = {}
labels = {}
buttons = {}

--Our custom event handlers
addEvent("onPlayerLoggedIn",true)
addEvent("returnLoginStatus",true)
addEvent("onCharacterDataLoaded",true)

function onStart()
	local rX,rY = guiGetScreenSize() --Get the player's screen resolution (so we can make sure GUI fits in all resolutions)
	loadCacheFile()
	
	--Login Panel
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
	remember = exports.utils:convertToBool(getCacheData("remember")) or false
	checkboxes["remember"] = guiCreateCheckBox(132, 278, 124, 21, "Remember Details", remember, false, windows["login"])
	buttons["login-attemptLogin"] = guiCreateButton(27,299,330,26,"Login",false,windows["login"])
	buttons["login-register"] = guiCreateButton(27,335,330,26,"Register an account",false,windows["login"])
	buttons["login-recover"] = guiCreateButton(27,371,330,26,"Recover my account",false,windows["login"])
	buttons["login-troll"] = guiCreateButton(287,418+16,87,16,"Skip Login",false,windows["login"]) --Comment this out if you're not the troll type ;)
	labels["login-status"] = guiCreateLabel(29,398,328,20+20,"Welcome to the network of SourceMode!",false,windows["login"])
	guiLabelSetHorizontalAlign(labels["login-status"], "center", true)
    guiLabelSetVerticalAlign(labels["login-status"], "top")
	addEventHandler("onClientGUIClick",buttons["login-attemptLogin"],onClick,false)
	addEventHandler("onClientGUIClick",buttons["login-register"],onClick,false)
	addEventHandler("onClientGUIClick",buttons["login-recover"],onClick,false)
	addEventHandler("onClientGUIClick",buttons["login-troll"],onClick,false)
	
	--NOPE Panel--
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
	addEventHandler("onClientGUIClick",buttons["NOPE-fine"],onClick,false)
	
	local width,height = 493,382
	local X,Y = exports.utils:getGUICenter(rX,rY,width,height)
	windows["register"] = guiCreateWindow(X,Y,width,height, "SourceMode - Register", false)
	guiSetAlpha(windows["register"],1)
	guiWindowSetMovable(windows["register"],false)
	guiWindowSetSizable(windows["register"],false)
	guiCreateStaticImage(66, 20, 365, 120, "images/mtalogo.png", false, windows["register"])
	edits["register-username"] = guiCreateEdit(27, 179, 270, 26, "", false, windows["register"])
	labels[4] = guiCreateLabel(98, 161, 122, 18, "Username", false, windows["register"])
	edits["register-password"] = guiCreateEdit(27, 223, 271, 27, "", false, windows["register"])
	guiEditSetMasked(edits["register-password"],true)
	labels[5] = guiCreateLabel(98, 205, 122, 18, "Password", false, windows["register"])
	edits["register-confirm"] = guiCreateEdit(27, 268, 271, 24, "", false, windows["register"])
	guiEditSetMasked(edits["register-confirm"],true)
	labels[6] = guiCreateLabel(98, 250, 122, 18, "Confirm Password", false, windows["register"])
	edits["register-email"] = guiCreateEdit(27, 314, 271, 24, "", false, windows["register"])
	labels[12] = guiCreateLabel(98, 296, 122, 18, "Email Address", false, windows["register"])
	labels["status-username"] = guiCreateLabel(335, 179, 144, 26, "Enter a username", false, windows["register"])
	labels["status-password"] = guiCreateLabel(335, 223, 144, 27, "Enter a password", false, windows["register"])
	labels["status-confirm"] = guiCreateLabel(335, 266, 144, 26, "Confirm your password", false, windows["register"])
	labels["status-email"] = guiCreateLabel(335, 312, 144, 26, "Enter your email address", false, windows["register"])
	labels[7] = guiCreateLabel(305, 172, 21, 168, "|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n", false, windows["register"])
	buttons["register-back"] = guiCreateButton(50, 350, 180, 22, "Go back to Log In", false, windows["register"])
	buttons["register-attemptRegister"] = guiCreateButton(258, 350, 180, 22, "Register account", false, windows["register"])
	addEventHandler("onClientGUIClick",buttons["register-back"],onClick,false)
	addEventHandler("onClientGUIClick",buttons["register-attemptRegister"],onClick,false)
	
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
	addEventHandler("onClientGUIClick",buttons["recovery-back"],onClick,false)
	addEventHandler("onClientGUIClick",buttons["recovery-attemptRecovery"],onClick,false)
	
	--Character GUI goes here

	--Loop through all labels and add centering
	for k,v in ipairs(labels) do
		guiLabelSetHorizontalAlign(v, "center", true)
        guiLabelSetVerticalAlign(v, "center")
	end

	guiSetVisible(windows["NOPE"],false)
	guiSetVisible(windows["register"],false)
	guiSetVisible(windows["recovery"],false)
	showCursor(true)
end
addEventHandler("onClientResourceStart",resourceRoot,onStart)

function onClick(button,state)
	if (button == "left") and (state == "up") then
		--open section
		if (source == buttons["login-troll"]) then
			guiSetVisible(windows["NOPE"],true)
			guiSetVisible(windows["login"],false)
			playSound("sound/nope.mp3")
		elseif (source == buttons["login-register"]) then
			--[[guiSetVisible(windows["register"],true)
			guiSetVisible(windows["login"],false)]]
			playSound("sound/nope.mp3")
		elseif (source == buttons["login-recover"]) then
			--[[guiSetVisible(windows["recovery"],true)
			guiSetVisible(windows["login"],false)]]
			playSound("sound/nope.mp3")
		
		--close section
		elseif (source == buttons["NOPE-fine"]) then
			guiSetVisible(windows["NOPE"],false)
			guiSetVisible(windows["login"],true)
		elseif (source == buttons["register-back"]) then
			guiSetVisible(windows["register"],false)
			guiSetVisible(windows["login"],true)
		elseif (source == buttons["recovery-back"]) then
			guiSetVisible(windows["recovery"],false)
			guiSetVisible(windows["login"],true)
		
		--attempt section
		elseif (source == buttons["login-attemptLogin"]) then
			--Check if the username and password information has been entered
			local username = guiGetText(edits["login-username"]):gsub("[%s]","") --Filter everything but characters
			local password = guiGetText(edits["login-password"])
			local remember = guiCheckBoxGetSelected(checkboxes["remember"]) or false
			local encrypted = getCacheData("encrypted") or false
			local encrypted = exports.utils:convertToBool(encrypted)
			
			if (#username >= 1) and (#password >= 1) then
				triggerServerEvent("onPlayerAttemptLogin",localPlayer,username,password,encrypted,remember)
				guiSetText(labels["login-status"],"Logging in as "..username.."...")
			else
				guiSetText(labels["login-status"],"You must have the username and password boxes filled in!")
				if reset and isTimer(reset) then killTimer(reset) end
				reset = setTimer(function() guiSetText(labels["login-status"],"") end, 3000, 1)
			end
		elseif (source == buttons["register-attemptRegister"]) then
			outputChatBox("NOPE")
			playSound("sound/nope.mp3") --We'll remove these later.
		elseif (source == buttons["recovery-attemptRecovery"]) then
			outputChatBox("NOPE")
			playSound("sound/nope.mp3") --We'll remove these later.
		else
			outputChatBox("unknown button!")
		end
	end
end

function onElementChanged(element)
	if (element == edits["login-username"]) then
		local username = guiGetText(edits["login-username"])
		if (#username >= 1) then
			guiSetText(buttons["login-attemptLogin"],"Log in as "..username)
		else
			guiSetText(buttons["login-attemptLogin"],"Login")
		end
	elseif (element == edits["login-password"]) then
		setCachedData("encrypted","false") --Disable this since the password was edited.
	elseif (element == edits["register-username"]) then
		local username = guiGetText(edits["register-username"])
		if (#username >= 1) then
			guiSetText(buttons["register-attemptRegister"],"Register as "..username)
		else
			guiSetText(buttons["register-attemptRegister"],"Register account")
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

function returnLoginState(text)
	guiSetText(labels["login-status"],tostring(text))
	if reset and isTimer(reset) then killTimer(reset) end
	reset = setTimer(function() guiSetText(labels["login-status"],"") end, 3000, 1)
end
addEventHandler("returnLoginStatus",root,returnLoginState)

function loadCharacterData(data)
	outputChatBox("I should create the character selection...")
	guiSetVisible(windows["login"],false)
	guiSetVisible(windows["NOPE"],false)
	guiSetVisible(windows["register"],false)
	guiSetVisible(windows["recovery"],false)
	showCursor(false)
end
addEventHandler("onCharacterDataLoaded",root,loadCharacterData)