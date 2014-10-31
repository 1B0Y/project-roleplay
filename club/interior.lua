local entranceDiscoMarker = createMarker(1960, 1560.45, 11, "arrow", 1.5, 255, 20, 147, 150)
function onDiscoIntEnter(hitBy, dimensionMatch)
	if dimensionMatch and getElementType(hitBy) == "player" and not isPedInVehicle(hitBy) then
		setPedFrozen(hitBy, true)
		setTimer(setPedFrozen, 1000, 1, hitBy, false)
		setTimer(setElementInterior, 1000, 1, hitBy, 1)
		setTimer(setElementDimension, 1000, 1, hitBy, 1000)
		setTimer(setElementPosition, 1000, 1, hitBy, 1948.22, 1576.5, -46.71)
		setTimer(setPedRotation, 1000, 1, hitBy, 180)
		fadeCamera(hitBy, false, 1, 0, 0, 0)
		setTimer(fadeCamera, 1000, 1, hitBy, true, 1)
	end
end
addEventHandler("onMarkerHit", entranceDiscoMarker, onDiscoIntEnter)

local exitDiscoMarker = createMarker(1948.22, 1578.65, -46, "arrow", 1.5, 255, 20, 147, 150)
setElementInterior(exitDiscoMarker, 1)
setElementDimension(exitDiscoMarker, 1000)
function onDiscoIntLeave(hitBy, dimensionMatch)
	if dimensionMatch and getElementType(hitBy) == "player" and not isPedInVehicle(hitBy) then
		setPedFrozen(hitBy, true)
		setTimer(setPedFrozen, 1000, 1, hitBy, false)
		setTimer(setElementInterior, 1000, 1, hitBy, 0)
		setTimer(setElementDimension, 1000, 1, hitBy, 0)
		setTimer(setElementPosition, 1000, 1, hitBy, 1960, 1558.3, 10.45)
		setTimer(setPedRotation, 1000, 1, hitBy, 180)
		fadeCamera(hitBy, false, 1, 0, 0, 0)
		setTimer(fadeCamera, 1000, 1, hitBy, true, 1)
	end
end
addEventHandler("onMarkerHit", exitDiscoMarker, onDiscoIntLeave)

local entranceDiscoToiletMarker = createMarker(1937.84, 1566, -46, "arrow", 1.5, 255, 20, 147, 150)
setElementInterior(entranceDiscoToiletMarker, 1)
setElementDimension(entranceDiscoToiletMarker, 1000)
function onDiscoToiletEnter(hitBy, dimensionMatch)
	if dimensionMatch and getElementType(hitBy) == "player" and not isPedInVehicle(hitBy) then
		setPedFrozen(hitBy, true)
		setTimer(setPedFrozen, 1000, 1, hitBy, false)
		setTimer(setElementPosition, 1000, 1, hitBy, 1926.62, 1563.6, -46.71)
		setTimer(setPedRotation, 1000, 1, hitBy, 180)
		fadeCamera(hitBy, false, 1, 0, 0, 0)
		setTimer(fadeCamera, 1000, 1, hitBy, true, 1)
	end
end
addEventHandler("onMarkerHit", entranceDiscoToiletMarker, onDiscoToiletEnter)

local exitDiscoToiletMarker = createMarker(1926.62, 1565.6, -46, "arrow", 1.5, 255, 20, 147, 150)
setElementInterior(exitDiscoToiletMarker, 1)
setElementDimension(exitDiscoToiletMarker, 1000)
function onDiscoToiletLeave(hitBy, dimensionMatch)
	if dimensionMatch and getElementType(hitBy) == "player" and not isPedInVehicle(hitBy) then
		setPedFrozen(hitBy, true)
		setTimer(setPedFrozen, 1000, 1, hitBy, false)
		setTimer(setElementPosition, 1000, 1, hitBy, 1939.84, 1566, -46.71)
		setTimer(setPedRotation, 1000, 1, hitBy, 270)
		fadeCamera(hitBy, false, 1, 0, 0, 0)
		setTimer(fadeCamera, 1000, 1, hitBy, true, 1)
	end
end
addEventHandler("onMarkerHit", exitDiscoToiletMarker, onDiscoToiletLeave)