--[[
	Project: SourceMode
	Version: 1.0
	Last Edited: 24/10/2014 (Jack)
	Authors: Jack
]]--

local accountData = {} --Data cache

function loadAccountData(player,username)
	if player and isElement(player) and username then
		local connection = exports.database:getConnection() or error("No database connection!")
		
		dbQuery(cacheAccountData,{player,username},connection,"SELECT * FROM accountdata WHERE username=? ORDER BY id ASC",username)
	end
end

function cacheAccountData(query,player,username)
	if (accountData[username]) then
		dbFree(query) --Release, we don't need it.
		return
	end
	
	accountData[username] = {}
	local results = dbPoll(query,-1)
	if (results) then
		if (#results >= 1) then
			for k,v in ipairs(results) do
				table.insert(accountData[username], [v.key] = {v.value})
			end
		end
	end
	
	triggerEvent("onAccountDataLoaded",player,username)
	return true
end

function getAllAccountData(username)
	return accountData[username] or false
end

function getAccountData(username,key)
	if not accountData[username] then
		return false
	end
	
	return accountData[username][key]
end

function setAccountData(username,key,value)
	if not (accountData[username]) then
		return false
	end
	
	local connection = exports.database:getConnection() or return false
	
	if not (accountData[username][key]) then
		dbExec(connection,"INSERT INTO accountdata (username,key,value) VALUES (?,?,?)",username,tostring(key),tostring(value))
	end
	
	accountData[username][key] = value
	return true
end