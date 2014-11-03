local interiors = {
{marker = {1960,1560.45,11,0,0}, coords = {1948.22,1576,-46.71,1,1000, 180}}, --Club Enterance
{marker = {1948,1578.65,-46,1,1000}, coords = {1960,1558.3,10.45,0,0, 180}}, --Club Exit
{marker = {1937,1566,-46,1,1000}, coords = {1926,1563,-46.71,1,1000, 180}}, --Toilet Enterance
{marker = {1926,1565,-46,1,1000}, coords = {1939.84, 1566, -46.71,1,1000, 180}} --Toilet Exit
}
local markers = {}

function onStart()
	for k,v in pairs(interiors) do
		v = interiors[k]
		local marker = createMarker(v.marker[1],v.marker[2],v.marker[3]-1.5,"cylinder",1.5,255,27,147,150)
		setElementInterior(marker,v.marker[4])
		setElementDimension(marker,v.marker[5])
		markers[marker] = {index = k}
	end
	
	--TEST--
	if (fileExists("club.map")) then
		outputConsole("Map found.")
	else
		outputConsole("Map not found.")
	end
end
addEventHandler("onResourceStart",resourceRoot,onStart)

function onHit(hitEl, md)
	if not source then return false end
	if not hitEl or not isElement(hitEl) or not getElementType(hitEl) == "player" then return false end
	
	if markers[source] then
		local index = markers[source].index
		local v = interiors[index]
		
		local x,y,z = v.coords[1],v.coords[2],v.coords[3]
		local int = v.coords[4]
		local dim = v.coords[5]
		local rot = v.coords[6]
		
		setTimer(
			function(player,x,y,z,int,dim, rot)
				setElementPosition(player,x,y,z)
				setElementInterior(player,int)
				setElementDimension(player,dim)
				setElementRotation(player,0,0,rot)
			end, 1000, 1, hitEl, x, y, z, int, dim, rot
		)
	end
end
addEventHandler("onMarkerHit",root,onHit)