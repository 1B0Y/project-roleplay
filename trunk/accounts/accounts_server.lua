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
		
		--Do username check and login stages within a callback function.
		local query = dbQuery(
			function(query,player)
				local results = dbPoll(query,-1)
				if results and type(results) == "table" and #results >= 1 then
					triggerClientEvent(player,"returnLoginStatus",player,"Logged in as "..username..".")
				else
					triggerClientEvent(player,"returnLoginStatus",player,"The username "..username.." is not registered.")
					return
				end
			end, {client}, connection, "SELECT * FROM accounts WHERE username=? LIMIT 1",username
		)
	end
end
addEventHandler("onPlayerAttemptLogin",root,logIn)

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