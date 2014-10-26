--[[
	Project: SourceMode
	Version: 1.0
	Last Edited: 26/10/2014 (Jack)
	Authors: Jack
]]--

--[[
	Server Events
	Used for triggerClientEvents and triggerEvent.
]]
addEvent("onPlayerAttemptLogin",true)
addEvent("onPlayerAttemptLogout",true)
addEvent("onPlayerAttemptRegister",true)
addEvent("onPlayerAttemptRecovery",true)
addEvent("onAccountDataLoaded",true)
addEvent("checkUsernameAvailability",true)

--[[
	Local Vars
	nuff said.
]]
local REGISTER_WAITTIME = 60 -- Registration limit between account registrations (to prevent players making multiple accounts quickly).
local usernameCache = {} --Store all accounts usernames into this table
local USERNAME_LIMIT = 3 --Must be more than 3 chars!
local _logIn = logIn --Override the logIn function to our own! :D
local _logOut = logOut --Override! :D

--[[
	onStart
	Handles player's camera view and disables the hud. Also pulls all usernames from the database.
]]
function onStart()
	for k,v in ipairs(getElementsByType("player")) do
		setCameraMatrix(v,1966.75, 1542.896484, 36.1860351, 2004.199218, 1541.3876953, 13.5907506)
		showPlayerHudComponent(v,"all",false)
	end
	
	--Cache all usernames
	local connection = exports.database:getConnection()
	if not connection then return false end --We'll cache another time.
	
	dbQuery(cacheUsernames,{},connection,"SELECT username FROM accounts ORDER BY username ASC")
end
addEventHandler("onResourceStart",resourceRoot,onStart)

--[[
	cacheUsernames
	Stores all account usernames to a table for later use.
]]
function cacheUsernames(query)
	local results = dbPoll(query,-1)
	if (results) then
		for k,v in ipairs(results) do
			usernameCache[v.username] = true
		end
	end
end

--[[
	onStop
	Deals with the player (such as force saving), setting camera back to normal if they're on the main menu and so on.
]]
function onStop()
	for k,v in ipairs(getElementsByType("player")) do
		--kickPlayer(v,"Restarting...") --Force save!
		setCameraTarget(v)
		showPlayerHudComponent(v,"all",true)
	end
end
addEventHandler("onResourceStop",resourceRoot,onStop)

--[[
	logIn
	Custom login system. Handles the login stages of the player and pulls data for characters.
]]
function logIn(username,password,remember,encrypted)
	--Check if we have a database connection
	local connection = exports.database:getConnection()
	if not (connection) then
		triggerClientEvent(client,"returnUpdateStatus",client,"login","A networking issue has occured. Please contact an admin. (Err: #01)")
		return
	end

	--Check if the username, password and etc was passed through.
	if (username) and (password) and (type(encrypted) == "boolean") then
		local username = username:lower()
		
		if not encrypted then
			password = sha256(password)
			encrypted = true
		end
		
		if remember == nil then
			remember =  true
		end
		
		--Check if the username exists
		local query = dbQuery(connection,"SELECT * FROM accounts WHERE username=? LIMIT 1",username)
		local results = dbPoll(query,-1) --If your server experiences major lag (and i mean, MAJOR LAG), tell me.
		if not results then
			triggerClientEvent(client,"returnUpdateStatus",client,"login","An unexpected network issue has been detected. Please contact an admin. (Err: #02")
			return
		elseif results and #results == 0 then
			triggerClientEvent(client,"returnUpdateStatus",client,"login","The username "..username.." is not registered!")
			return
		end
		
		if (results[1].password == password) then
			--Make sure we don't allow double-logins! (FUTURE PROJECT)
			setElementData(client,"username",username)
			setElementData(client,"ID",results[1].id)
			dbExec(connection,"UPDATE accounts SET serial=? WHERE username=?",getPlayerSerial(client),username)
			triggerClientEvent(client,"returnUpdateStatus",client,"login","Handshaking...")
			triggerClientEvent(client,"updatePlayerCache",client,username,password,remember)
			if (isAccountDataLoaded(username)) then
				triggerEvent("onAccountDataLoaded",client,username)
			else
				loadAccountData(client,username)
			end
			triggerEvent("onPlayerLoggedIn",client)
		else
			triggerClientEvent(client,"returnUpdateStatus",client,"login","Incorrect password! Please try again.")
			return
		end
	end
end
addEventHandler("onPlayerAttemptLogin",root,logIn)

function logOut()
	if (isPlayerLoggedIn(client)) then
		saveAccountData(getElementData(client,"username")) --Force save the player's crap.
		removeElementData(client,"username")
		removeElementData(client,"ID")
		outputChatBox(getPlayerName(client).." logged out.",root,255,0,0)
		triggerClientEvent(client,"toggleGUI",client,"all",false)
		triggerClientEvent(client,"toggleGUI",client,"login",true)
		triggerEvent("onPlayerLoggedOut",client)
		setCameraMatrix(client,1966.75, 1542.896484, 36.1860351, 2004.199218, 1541.3876953, 13.5907506)
		return true
	else
		return false
	end
end
addEventHandler("onPlayerAttemptLogout",root,logOut)

--[[
	onAccountDataLoaded
	Triggers client event for characters when the data has been loaded.
]]
function onAccountDataLoaded(username)
	if source and isElement(source) and username then
		local characters = getAccountData(username,"characters")
		triggerClientEvent(source,"onCharacterDataLoaded",source,characters or {}) --If table is empty, we'll prompt the player to create a new one.
	end
end
addEventHandler("onAccountDataLoaded",root,onAccountDataLoaded)

--[[
	register
	Custom register system. Handles player's register data and checks if the username is available. From there, we make the account.
]]
function register(username,password,email)
	--Make sure we have a database connection
	local connection = exports.database:getConnection()
	if not connection then
		triggerClientEvent(client,"returnUpdateStatus",client,"register","A networking issue has occured. Please contact an admin. (Err: #03)")
		return
	end
	
	if (username) and (password) then
		--Make sure the username doesn't exist
		if (usernameCache[username]) then
			triggerClientEvent(client,"returnUpdateStatus",client,"register",username.." is already registered! Please choose another username.")
			return
		end
		
		--Create the account
		if (dbExec(connection,"INSERT INTO accounts (username,password,email,lastlogin) VALUES (?,?,?,now())",username,password,email or "NULL")) then
			triggerClientEvent(client,"onAccountRegistered",client,true,username,password)
		else
			triggerClientEvent(client,"returnUpdateStatus",client,"register","A network issue has occured. Please contact an admin. (Err: #04)")
			return
		end
	end --If you want to return an error, change this!
end
addEventHandler("onPlayerAttemptRegister",root,register)

--FUTURE NOTE: We'll have to do some PHP stuff with this (meaning the hoster might need a email service)
function recover(username,email)
	--Handle recovery crap here
end
addEventHandler("onPlayerAttemptRecovery",root,recover)

--[[
	checkUsername
	A client->server function to determine if a username is available for register.
]]
function checkUsername(username)
	if username and #username >= USERNAME_LIMIT then
		local username = username:lower()
		if (usernameCache[username]) then
			available = false
		else
			available = true
		end
		triggerClientEvent(client,"returnUsernameAvailability",client,username,available)
	else
		return false
	end
end
addEventHandler("checkUsernameAvailability",root,checkUsername)