--[[
	Project: SourceMode
	Version: 1.0
	Last Edited: 25/10/2014 (Jack)
	Authors: Jack
	NOTE: ONLY use this for account data! make sure you encrypt any passwords and so on. Do NOT use for normal storage
	as it can be easily lost if the player formats his hard drive or changes computer.
]]--

local cacheData

function loadCachedAccountData()
	cacheData = xmlLoadFile("@account.xml")
	
	if not cacheData then
		cacheData = xmlCreateFile("@account.xml","account")
		xmlSaveFile(cacheData)
		return false --Stop here, since we have no data to load
	end
	return true
end

function getCachedData(key)
	if not cacheData then
		loadCachedAccountData()
	end
	
	local key = xmlFindChild(cacheData,tostring(key))
	return xmlNodeGetAttribute(key) or false
end

function setCachedData(key,value)
	if not cacheData then
		loadCachedAccountData()
	end
	
	--Check if the key already exists, otherwise create it
	local node = xmlFindChild(cacheData,tostring(key))
	if (node) then
		xmlNodeSetAttribute(node,tostring(value))
		return true
	end
	
	--Key doesn't exist, meaning we'll have to create one
	local node = xmlCreateChild(cacheData,tostring(key))
	xmlNodeSetAttribute(node,tostring(value)
	
	--Save it
	xmlSaveFile(cacheData)
	return true --return true anyways.
end