--[[
	Project: Roleplay
	Version: 1.0
	Last Edited: 23/10/2014 (Jack)
	Authors: Jack
]]--

-- Let's start off by adding our custom events that we'll need for later.
addEvent("rp:onPlayerAttemptLogin",true)
addEvent("rp:onPlayerAttemptRegister",true)
addEvent("rp:onPlayerAttemptRecovery",true)

-- Setup some variables and tables we'll need.
local accounts = {} -- Account caching (So we don't exhaust the MySQL server as much).
local loggedIn = {} -- Login table - Helps us identify who's logged in or not.
local REGISTER_WAITTIME = 60 -- Registration limit between account registrations (to prevent players making multiple accounts quickly).

-- Setup some pre-definers since we'll be using custom functions
local _logIn = logIn
local _logOut = logOut
local _spawnPlayer = spawnPlayer
local _setAccountPassword = setAccountPassword
local _error = error

--attemptLogin: The preparation of the account being loaded from the database.
function attemptLogin(username,password,remember,encrypted)
	--Let's see if we have a player before we attempt to try login.
	if not client or not isElement(client) or not getElementType(client) == "player" then return end --No player = we stop here.
	
	--Now we know we have a player, we need to check if the username and password are presented.
	if username then username = string.lower(username) else error(client,"You must enter a username to log in!") return end
	if not password then error(client,"You must enter a password to log in!") return end
	
	-- Need to check if the password is already encrypted, otherwise we'll encrypt it.
	if not encrypted then
		password = sha256(password) --If you're using the SHA module, change this to sha512.
		encrypted = true
	end
	
	-- First, let's check if the player has his account already cached. If he has, we'll skip right to the logIn function.
	if (accounts[username]) then
		logIn(accounts[username],client,username,password,remember,encrypted)
		return
	end
	
	-- Now, we need to see if the database is online. If it is, we'll grab the connection
	if not exports.rpNetworking:isDatabaseOnline() then error(client,"The server is facing a networking issue. Please contact an admin. (Err: #1)") return end
	local connection = exports.rpNetworking:getDatabaseConnection()
	
	-- Time to query for that account we're wanting.
	dbQuery(logIn,{client,username,password,remember,encrypted},connection,"SELECT * FROM accounts WHERE username=? AND password=? ORDER BY ID ASC LIMIT 1",username,password)
end
addEventHandler("rp:onPlayerAttemptLogin",root,attemptLogin)

function logIn(query,player,username,password,remember,encrypted)
	--Now, first we need to check if we still have our player. Otherwise, we'll just release the query.
	if not player or not isElement(player) or not getElementType(player) == "player" then
		if query then dbFree(query) end --dbFree: releases the query from the list as it's no longer needed.
		return
	end
	
	--That's sorted, let's move onto polling our data (if the query is there)
	if not query then error(player,"An internal networking error has occured. Please contact an admin. (Err: #2)") return end
	local data = dbPoll(query,-1) -- -1 -> Wait for the data to be sent from the database.
	
	--Time to parse the data
	if (#data >= 1) then --We have an account!
		for k,v in ipairs(data) do
			--Check if it's the valid username
			if (v.username == username) then
				if (v.password ~= password) then
					error(player,"Wrong password entered. Please try again.") 
					return 
				end
			
			loggedIn[player] = {username}
			--preloadAccountData(client)
		end
	end
end