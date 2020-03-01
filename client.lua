local Proxy = module("vrp", "lib/Proxy")

tvRP = Proxy.getInterface("vRP")

local intrunk = false

local function LoadAnim(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(10)
	end
end


RegisterNetEvent("vrp:trunk:in")
AddEventHandler("vrp:trunk:in", function()
		LoadAnim("amb@world_human_bum_slumped@male@laying_on_right_side@base")
		local PlayerPed = PlayerPedId()
		local Coords = GetEntityCoords(PlayerPed)
		local Vehicle = GetClosestVehicle(Coords.x, Coords.y, Coords.z, 3.5, 0, 70)
		local VehicleCoords = GetEntityCoords(Vehicle)
		local Distance = Vdist(VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, Coords.x, Coords.y, Coords.z)
		if Distance < 5.0 and not IsPedInAnyVehicle(PlayerPed, false) then
			AttachEntityToEntity(PlayerPed, Vehicle, 0, 0.2, -1.6, 1.0, 0.0, 0.0, 179.0, 0.0, false, false, false, false, 2, true)
			TaskPlayAnim(PlayerPedId(), 'amb@world_human_bum_slumped@male@laying_on_right_side@base', 'base', 8.0, 8.0, -1, 69, 1, false, false, false)
			tvRP.notify("~g~Вы залезли в багажник")
			intrunk = true
		else
			tvRP.notify("~r~Рядом нету автомобиля")
		end
	end)

RegisterNetEvent("vrp:trunk:out")
AddEventHandler("vrp:trunk:out", function()
	local PlayerPed = PlayerPedId()
	local Coords = GetEntityCoords(PlayerPed)
	local Vehicle = GetClosestVehicle(Coords.x, Coords.y, Coords.z, 3.5, 0, 70)
	if intrunk == true then
		DetachEntity(Vehicle, true, true)
		tvRP.stopAnim(true) -- upper
		tvRP.stopAnim(false) -- full
		tvRP.notify("~g~Вы вылезли из багажника")
		tvRP.teleport(Coords.x-1.8, Coords.y-0.7, Coords.z)
		intrunk = false
	else
		tvRP.notify("~r~Вы не в багажнике")
	end
end)