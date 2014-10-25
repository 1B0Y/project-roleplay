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
	end
	return true
end

function getCachedData(key)
	if not cacheData then
		loadCachedAccountData()
	end
	
	local nodes = xmlNodeGetChildren(cacheData)
	for k,v in ipairs(nodes) do
		local nodeName = xmlNodeGetName(v)
		if (nodeName == key) then
			return xmlNodeGetValue(v)
		end
	end
	return false
end

function setCachedData(key,value)
	if not cacheData then
		loadCachedAccountData()
	end
	
	--Check if the key already exists, otherwise create it
	local node = xmlNodeGetChildren(cacheData)
	local found = false
	
	for k,v in ipairs(node) do
		if (xmlNodeGetName(v) == tostring(key)) then
			xmlNodeSetValue(v,tostring(value))
			xmlSaveFile(cacheData) --save here, as we're returning true (and won't reach xmlSaveFile at the bottom of the function)
			return true
		end
	end
	
	--Key doesn't exist, meaning we'll have to create one
	local node = xmlCreateChild(cacheData,tostring(key))
	xmlNodeSetValue(node,tostring(value))
	
	--Save it
	xmlSaveFile(cacheData)
	return true --return true anyways.
end