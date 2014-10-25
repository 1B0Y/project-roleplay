--[[
	Project: SourceMode
	Version: 1.0
	Last Edited: 24/10/2014 (Jack)
	Authors: Jack
]]--

-- Let's start off by adding our custom events that we'll need for later.
addEvent("onPlayerAttemptLogin",true)
addEvent("onPlayerAttemptRegister",true)
addEvent("onPlayerAttemptRecovery",true)
addEvent("onAccountDataLoaded",true)

-- Setup some variables and tables we'll need.
local REGISTER_WAITTIME = 60 -- Registration limit between account registrations (to prevent players making multiple accounts quickly).

-- Setup some pre-definers since we'll be using custom functions
local _logIn = logIn


function logIn(username,password,encrypted,remember)
	--Check if we have a database connection
	if not (exports.database:getConnection()) then
		triggerClientEvent(client,"returnLoginStatus",client,"A networking issue has occured. Please contact an admin. (Err: #01)")
		return
	end
	local connection = exports.database:getConnection()

	--Check if the username, password and etc was passed through.
	if (username) and (password) and (type(encrypted) == "boolean") and (remember) then
		local username = username:lower()
		
		if not encrypted then
			password = sha256(password)
			encrypted = true
		end
		
		--Check if the username exists
		local query = dbQuery(connection,"SELECT * FROM accounts WHERE username=? LIMIT 1",username)
		local results = dbPoll(query,-1) --If your server experiences major lag (and i mean, MAJOR LAG), tell me.
		if not results then
			triggerClientEvent(client,"returnLoginStatus",client,"An unexpected network issue has been detected. Please contact an admin. (Err: #02")
			return
		elseif results and #results == 0 then
			triggerClientEvent(client,"returnLoginStatus",client,"The username "..username.." is not registered!")
			return
		end
		
		if (results[1].password == password) then
			triggerClientEvent(client,"returnLoginStatus",client,"Handshaking...")
			triggerClientEvent(client,"updatePlayerCache",client,username,password,remember)
			loadAccountData(client,username)
		else
			triggerClientEvent(client,"returnLoginStatus",client,"Incorrect password! Please try again.")
			return
		end
	end
end
addEventHandler("onPlayerAttemptLogin",root,logIn)

function onAccountDataLoaded(username)
	if source and isElement(source) and username then
		local characters = getAccountData(username,"characters")
		triggerClientEvent(source,"onCharacterDataLoaded",source,characters or {}) --If table is empty, we'll prompt the player to create a new one.
	end
end
addEventHandler("onAccountDataLoaded",root,onAccountDataLoaded)

function register(username,password,email)
	--Handle the register crap here
end
addEventHandler("onPlayerAttemptRegister",root,register)

--FUTURE NOTE: We'll have to do some PHP stuff with this (meaning the hoster might need a email service)
function recover(username,email)
	--Handle recovery crap here
end
addEventHandler("onPlayerAttemptRecovery",root,recover)

function tempReg(player,cmd,username,password)
	if (username) and (#username >= 1) and (password) and (#password >= 1) then
		local connection = exports.database:getConnection()
		if (connection) then
			dbExec(connection,"INSERT INTO accounts (username,password,lastlogin) VALUES (?,?,now())",tostring(username),tostring(password))
			outputChatBox("Account inserted.")
		else
			error("No database connection.")
		end
	end
end
addCommandHandler("dReg",tempReg)