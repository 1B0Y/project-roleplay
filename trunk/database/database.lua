--[[
	Project: SourceMode
	Version: 1.0
	Last Edited: 25/10/2014 (Jack)
	Authors: Jack
]]--

local connection

function onStart()
	--Make sure we have the database information from settings
	if not (type(mysql.username) == "string") or not (#mysql.username >= 1) then error("[Database] Username required!") end
	if not (type(mysql.password) == "string") or not (#mysql.password >= 1) then error("[Database] Password required!") end
	if not (type(mysql.hostname) == "string") or not (#mysql.hostname >= 1) then error("[Database] Hostname required!") end
	if not (type(mysql.port) == "number") then mysql.port = 3302 end
	if not (type(mysql.database) == "string") or not (#mysql.database >= 1) then error("[Database] Database name required!") end
	
	--Attempt to create a new connection and connect
	connection = dbConnect("mysql","dbname="..mysql.database..";host="..mysql.host..";autoreconnect=1",tostring(mysql.username),tostring(mysql.password))
	if isElement(connection) then
		outputDebugString("[Database] Connection established.")
		return true
	else
		outputDebugString("[Database] Connection failed.",1)
		return false
	end
end
addEventHandler("onResourceStart",resourceRoot,onStart)

function getConnection()
	return connection or false
end

function forceReconnect()
	if isElement(connection) then
		outputDebugString("[Database] Connection is online, disconnecting...")
		destroyElement(connection)
	end
	
	outputDebugString("[Database] Starting new connection...")
	onStart()
end
