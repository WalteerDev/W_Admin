ESX = nil
local inAnim = false
local showcoord = false
local vhedl = false
local noclip = false
local noclip_speed = 0.1
local ListPlayer = {}
local specjoueur = {}
local enspec = false
local activerposition = true
local activprint = true
Admin = { godmod = false, noclip = false, staminainfini = false, fastrun = false, }
print('[W_Admin] [Start] Le menu administration s\'est start correctement.')
print('[W_Admin] [Info] Copyright </Walteer>#0033, pour Equinoxe Rp V2. discord.gg/7b5VpsCxtT')

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


Citizen.CreateThread(function()
    while true do
		Citizen.Wait(1)
		if IsControlJustPressed(1,84) then
			 TriggerEvent('W_AdministrationMenu', source)
        end  
	end
end)
----------------------------------------------
--         Ouvrir le menu :   )             --
----------------------------------------------

----------------------------------------------
--                  Fonctions               --
---------------------------------------------- 


function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)
    blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end
function agivemoneybank()
	local amount = KeyboardInput("N_BOX_AMOUNT", "", "", 8)
	if amount ~= nil then
		amount = tonumber(amount)
		if type(amount) == 'number' then
			TriggerServerEvent('W_Administration:donnerbank', amount)
		end
	end
end
function agivemoney()
	local amount = KeyboardInput("N_BOX_AMOUNT", "", "", 8)
	if amount ~= nil then
		amount = tonumber(amount)
		if type(amount) == 'number' then
			TriggerServerEvent('W_Administration:donnercash', amount) 
		end
	end
end
function agivemoneysale()
	local amount = KeyboardInput("N_BOX_AMOUNT", "", "", 8)
	if amount ~= nil then
		amount = tonumber(amount)
		if type(amount) == 'number' then
			TriggerServerEvent('W_Administration:donnersale', amount)
		end
	end
end
function playernoclip()
	noclip = not noclip
	local ped = GetPlayerPed(-1)
	if noclip then -- activé
		SetEntityVisible(ped, false, false)
		DrawSub("~g~Noclip", 999999)
	else -- désactivé
		SetEntityVisible(ped, true, false)
		DrawSub("~r~Noclip", 2500)
	end
end
function getPosition()
	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
	return x,y,z
end
function getCamDirection()
	local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
	local pitch = GetGameplayCamRelativePitch()

	local x = -math.sin(heading*math.pi/180.0)
	local y = math.cos(heading*math.pi/180.0)
	local z = math.sin(pitch*math.pi/180.0)

	local len = math.sqrt(x*x+y*y+z*z)
	if len ~= 0 then
		x = x/len
		y = y/len
		z = z/len
	end

	return x,y,z
end
function isNoclip()
	return noclip
end
function admin_tp_playertome()
	local plyId = KeyboardInput("KREEZOX_BOX_ID", 'ID du joueur', "", 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)
		
		if type(plyId) == 'number' then
			local plyPedCoords = GetEntityCoords(plyPed)
			TriggerServerEvent('W_Admin:bringserver', plyId, plyPedCoords)
		end
	end
end
function admin_tp_toplayer()
	local plyId = KeyboardInput("KREEZOX_BOX_ID", 'ID du joueur', "", 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)
		
		if type(plyId) == 'number' then
			local targetPlyCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(plyId)))
			SetEntityCoords(plyPed, targetPlyCoords)
		end
	end
end
function admin_no_clip()
	return noclip
end
function admin_mode_fantome()
	invisible = not invisible
	if invisible then
		SetEntityVisible(plyPed, false, false)
		DrawSub('~g~Fantôme', 999999999)
	else
		SetEntityVisible(plyPed, true, false)
		DrawSub('~r~Fantôme', 1500)
	end
end
function admin_vehicle_repair()
	local car = GetVehiclePedIsIn(plyPed, false)
	SetVehicleFixed(car)
	SetVehicleDirtLevel(car, 0.0)
end
function admin_godmode()
	godmode = not godmode

	if godmode then
		SetEntityInvincible(plyPed, true)
		DrawSub('~g~Invincible', 999999999)
	else
		SetEntityInvincible(plyPed, false)
		DrawSub('~r~Invincible', 1500)
	end
end
function admin_vehicle_spawn()
	local vehicleName = KeyboardInput("KREEZOX_BOX_VEHICLE_NAME", 'Nom du véhicule', "", 50)

	if vehicleName ~= nil then
		vehicleName = tostring(vehicleName)
		
		if type(vehicleName) == 'string' then
			local car = GetHashKey(vehicleName)
				
			Citizen.CreateThread(function()
				RequestModel(car)

				while not HasModelLoaded(car) do
					Citizen.Wait(0)
				end

				local x, y, z = table.unpack(GetEntityCoords(plyPed, true))

				local veh = CreateVehicle(car, x, y, z, 0.0, true, false)
				local id = NetworkGetNetworkIdFromEntity(veh)

				SetEntityVelocity(veh, 2000)
				SetVehicleOnGroundProperly(veh)
				SetVehicleHasBeenOwnedByPlayer(veh, true)
				SetNetworkIdCanMigrate(id, true)
				SetVehRadioStation(veh, "OFF")
				SetPedIntoVehicle(plyPed, veh, -1)
			end)
		end
	end
end
function admin_tp_marker()
	local WaypointHandle = GetFirstBlipInfoId(8)

	if DoesBlipExist(WaypointHandle) then
		local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

		for height = 1, 1000 do
			SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

			local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

			if foundGround then
				SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

				break
			end

			Citizen.Wait(0)
		end

		Popup("~g~Téléportation Effectuée")
	else
		Popup("~r~Aucun Marqueur...\n~w~Placez en un sur la carte")
	end
end
function drawTxt(x,y, width, height, scale, text, r,g,b,a, outline)
	SetTextFont(4)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropshadow(0, 0, 0, 0,255)
	SetTextDropShadow()
	if outline then SetTextOutline() end

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(x - width/2, y - height/2 + 0.005)
end
function Popup(txt)
	ClearPrints()
	SetNotificationBackgroundColor(140)
	SetNotificationTextEntry("STRING")
	AddTextComponentSubstringPlayerName(txt)
	DrawNotification(false, true)
end
function DrawSub(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end 
function show_coord()
	showcoord = not showcoord
end
function admin_heal_player()
	local plyId = KeyboardInput("KREEZOX_BOX_ID", 'Réanimer un Joueur [ID]', "", 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)
		
		if type(plyId) == 'number' then
			TriggerServerEvent('esxambulancejob:revive', plyId)
		end
	end
end
function delveh(veh)
	local vhePed = PlayerPedId()

	if not IsPedSittingInAnyVehicle(vhePed) then
		Popup("~p~W_Administration\n~w~Vous devez etre dans un véhicule")
	elseif IsPedSittingInAnyVehicle(vhePed) then
		SetEntityAsMissionEntity(Object, 1, 1)
		DeleteEntity(Object)
		SetEntityAsMissionEntity(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1, 1)
		DeleteEntity(GetVehiclePedIsIn(GetPlayerPed(-1), false))
	end	
end
function FullVehicleBoost()
    local vhePed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
	if not IsPedSittingInAnyVehicle(vhePed) then	
        Popup("~p~W_Administration\n~w~Vous devez etre dans un véhicule")
    elseif IsPedSittingInAnyVehicle(vhePed) then
		
		SetVehicleModKit(vehicle, 0)
		SetVehicleMod(vehicle, 14, 0, true)
        SetVehicleNumberPlateTextIndex(vehicle, 5)
		ToggleVehicleMod(vehicle, 18, true)
		SetVehicleColours(vehicle, 0, 0)
		SetVehicleCustomPrimaryColour(vehicle, 0, 0, 0)
		SetVehicleModColor_2(vehicle, 5, 0)
		SetVehicleExtraColours(vehicle, 111, 111)
		SetVehicleWindowTint(vehicle, 2)
		ToggleVehicleMod(vehicle, 22, true)
		SetVehicleMod(vehicle, 23, 11, false)
		SetVehicleMod(vehicle, 24, 11, false)
		SetVehicleWheelType(vehicle, 120)
		SetVehicleWindowTint(vehicle, 3)
		ToggleVehicleMod(vehicle, 20, true)
		SetVehicleTyreSmokeColor(vehicle, 0, 0, 0)
		LowerConvertibleRoof(vehicle, true)
		SetVehicleIsStolen(vehicle, false)
		SetVehicleIsWanted(vehicle, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetCanResprayVehicle(vehicle, true)
		SetPlayersLastVehicle(vehicle)
		SetVehicleFixed(vehicle)
		SetVehicleDeformationFixed(vehicle)
		SetVehicleTyresCanBurst(vehicle, false)
		SetVehicleWheelsCanBreak(vehicle, false)
		SetVehicleCanBeTargetted(vehicle, false)
		SetVehicleExplodesOnHighExplosionDamage(vehicle, false)
		SetVehicleHasStrongAxles(vehicle, true)
		SetVehicleDirtLevel(vehicle, 0)
		SetVehicleCanBeVisiblyDamaged(vehicle, false)
		IsVehicleDriveable(vehicle, true)
		SetVehicleEngineOn(vehicle, true, true)
		SetVehicleStrong(vehicle, true)
		RollDownWindow(vehicle, 0)
		RollDownWindow(vehicle, 1)
		SetVehicleNeonLightEnabled(vehicle, 0, true)
		SetVehicleNeonLightEnabled(vehicle, 1, true)
		SetVehicleNeonLightEnabled(vehicle, 2, true)
		SetVehicleNeonLightEnabled(vehicle, 3, true)
		SetVehicleNeonLightsColour(vehicle, 0, 0, 255)
		
		SetPedCanBeDraggedOut(PlayerPedId(), false)
		SetPedStayInVehicleWhenJacked(PlayerPedId(), true)
		SetPedRagdollOnCollision(PlayerPedId(), false)
		ResetPedVisibleDamage(PlayerPedId())
		ClearPedDecorations(PlayerPedId())
        SetIgnoreLowPriorityShockingEvents(PlayerPedId(), true)
    end
end
function SpecJoueur(id)
    local joueur = GetPlayerPed(id)
    enspec = not enspec
    if enspec then
        RequestCollisionAtCoord(GetEntityCoords(joueur))
        NetworkSetInSpectatorModeExtended(true, joueur, true)
        ESX.ShowNotification("~g~Spectate~s~\n" .. GetPlayerName(id))
    else
        RequestCollisionAtCoord(GetEntityCoords(joueur))
        NetworkSetInSpectatorModeExtended(false, joueur, false)
        ESX.ShowNotification("~g~Spectate~s~\n" .. GetPlayerName(id))
    end
end
function getPlayers()
	local players = {}
	for i = 0,255 do
		if NetworkIsPlayerActive(i) then
			table.insert(players, i)
		end
	end
	return players
end
function activepointergun()
	activprint = not activprint
	if not activprint then
		DrawSub("~g~Super Sprint", 999999)
	elseif activprint then
		DrawSub("~r~Super Sprint", 2500)
	end
end
function activpos()
	activerposition = not activerposition
	local pPed = GetPlayerPed(-1)
	if not activerposition then
		showcoord = true
	elseif activerposition then
		showcoord = false
	end
end
function admin_showname()
	showname = not showname
end


----------------------------------------------
--                LogicThread               --
----------------------------------------------

Citizen.CreateThread(function()
	while true do
		plyPed = PlayerPedId()

		if showcoord then
			local playerPos = GetEntityCoords(plyPed)
			local playerHeading = GetEntityHeading(plyPed)
			drawTxt(0.55, 0.95, 1.0, 1.0, 0.6, ("\n~r~X: " .. playerPos.x .. "\n~g~Y: " .. playerPos.y .. "\n~b~Z: " .. playerPos.z .. "\n~p~A: " .. playerHeading), 255, 255, 255, 255)
		end
		Citizen.Wait(0)
	end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        getPlayers()
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if noclip then
			local ped = GetPlayerPed(-1)
			local x,y,z = getPosition()
			local dx,dy,dz = getCamDirection()
			local speed = noclip_speed
			SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001)
		if IsControlPressed(0,32) then -- MOVE UP
			x = x+speed*dx
			y = y+speed*dy
			z = z+speed*dz
		end
		if IsControlPressed(0,21) then -- Speed
			local speed = 5.5
			x = x+speed*dx
			y = y+speed*dy
			z = z+speed*dz
		end
		if IsControlPressed(0,269) then -- MOVE DOWN
			x = x-speed*dx
			y = y-speed*dy
			z = z-speed*dz
		end
		SetEntityCoordsNoOffset(ped,x,y,z,true,true,true)
		end
	end
end)


----------------------------------------------
--                    Menu                  --
----------------------------------------------

local players = getPlayers()
table.insert(ListPlayer, {name = "~h~~b~---------------------~g~Menu Administration~b~---------------------", Description = "Menu Admin by Walteer"})
table.insert(ListPlayer, {name = "Nom Steam", ask = "Id", askX = true, Description = "Menu Admin by Walteer"})
table.insert(ListPlayer, {name = "--------------", ask = "---", askX = true, Description = "Menu Admin by Walteer"})
for _, v in pairs(players) do
    refresh = true,
    table.insert(ListPlayer, {name = GetPlayerName(v), ask = GetPlayerServerId(v), askX = true, Description = "Menu Admin by Walteer"})
end
table.insert(ListPlayer, {name = "~h~~b~---------------------------------------------------------------------", Description = "Menu Admin by Walteer"})
table.insert(ListPlayer, {name = "~h~~r~Fermer le menu", ask = "", askX = true, Description = "Menu Admin by Walteer"})

local JoueurMenu = {	
	Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {0, 0, 0}, Title = "Equinoxe V2 Joueur" },
	Data = { currentMenu = "Joueur" },
	Events = {
		onSelected = function(self, _, btn, PMenu, menuData, currentButton, currentBtn, currentSlt, result, slide)
			local slide = btn.slidenum
			local btn = btn.name
			local check = btn.unkCheckbox
			local valuejoueur = GetPlayerServerId(v)
			local namejoueur = GetPlayerName(v)
			local joueurPed = GetPlayerPed(v)
			if btn == "TP au joueur" then
				SpecJoueur(v)
				SetEntityCoords(GetPlayerPed(-1), GetEntityCoords(joueurPed))
			elseif btn == "TP le joueur sur moi" then
				admin_tp_playertome()  
			elseif btn == "Kick (Raison)" then 
				raison = KeyboardInput("KICK_PLAYER", 'Raison du kick', "raison", 50)
				TriggerServerEvent('W_Administration:kickraison', valuejoueur, raison)
				ESX.ShowNotification('~p~Vous venez de kick ~s~ '.. GetPlayerName(GetPlayerFromServerId(valuejoueur)) ..'!')
				TriggerServerEvent("logsWalteer", '\n- a kick un joueur ')
			elseif btn == "Envoyer un message" then
				local messagejoueur = KeyboardInput("MESSAGE", 'Entrez un message', "", 50)
				TriggerServerEvent("W_Admin:envoyermessage", valuejoueur, messagejoueur)
			end
		end,
	},
	Menu = {
		["Joueur"] = {
			b = {
				{name = "~h~~b~---------------------~g~Menu Administration~b~---------------------", Description = "Menu Admin by Walteer"},
				{name = "TP au joueur", Description = "Menu Admin by Walteer"},
				{name = "TP le joueur sur moi", Description = "Menu Admin by Walteer"},
				{name = "Envoyer un message", Description = "Menu Admin by Walteer"},
				{name = "Kick (Raison)", Description = "Menu Admin by Walteer"},
				{name = "~h~~b~---------------------------------------------------------------------", Description = "Menu Admin by Walteer"},
				{name = "~h~~r~Fermer le menu", ask = "", askX = true, Description = "Menu Admin by Walteer"},
			}
		}
	}
}

local Staff = {
	Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {0, 0, 0}, Title = "Equinoxe V2 Admin" },
    Data = {currentMenu = "  "},
    Events = {
        onSelected = function(self, _, btn, PMenu, menuData, currentButton, currentSlt, result)
			PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)	
			if btn.name == "TP un joueur sur moi" then
				admin_tp_playertome()
				TriggerServerEvent("logsWalteer", '\n- a teleporté un joueur sur lui')
			elseif btn.name == "TP sur un joueur" then
				admin_tp_toplayer()
				TriggerServerEvent("logsWalteer", '\n- s\'est teleporté sur un joueur')
            elseif btn.name == "S'octroyer de l'argent.." then
				agivemoneybank()
				TriggerServerEvent("logsWalteer", '\n- Give d\'argent en banque')
			elseif btn.name == "S'octroyer de l'argent." then
				agivemoney()	
				TriggerServerEvent("logsWalteer", '\n- Give d\'argent en cash')
			elseif btn.name == GetPlayerName(PlayerId()) then 
				CloseMenu('OwnerMenu')
				CreateMenu(JoueurMenu)
            elseif btn.name == "Afficher les Coords" then
				show_coord()
            elseif btn.name == "Réanimer un Joueur" then
				admin_heal_player()
				TriggerServerEvent("logsWalteer", '\n- a réanimé un joueur')
            elseif btn.name == "TP sur le marqueur" then
				admin_tp_marker()
				TriggerServerEvent("logsWalteer", '\n- s\'est téléporté sur un marqueur')
            elseif btn.name == "S'octroyer de l'argent..." then
				agivemoneysale()
				TriggerServerEvent("logsWalteer", '\n- Give d\'argent sale')
            elseif btn.name == "Mode Fantôme" then 
				admin_mode_fantome()
				TriggerServerEvent("logsWalteer", '\n- A activé le Mode Fantôme')
			elseif btn.name == "NoClip" then 
				ESX.ShowNotification('Appuyez sur SHIFT pour accelerer le NOCLIP')
				playernoclip()
			elseif btn.name == "Supprimer véhicule" then 
				delveh()
				TriggerServerEvent("logsWalteer", '\n- a supprimé un véhicule')
			elseif btn.name == "Customiser le véhicule" then 
				FullVehicleBoost()
				TriggerServerEvent("logsWalteer", '\n- A customisé sont véhicule')
            elseif btn.name == "Mode Invincible" then
				admin_godmode()
				TriggerServerEvent("logsWalteer", '\n- A activé le Mode Invincible')
			
            elseif btn.name == "Réparer mon véhicule" then
				admin_vehicle_repair()
				TriggerServerEvent("logsWalteer", '\n- A reparé un véhicule')
            elseif btn.name == "Apparaitre un véhicule" then
				admin_vehicle_spawn()
				TriggerServerEvent("logsWalteer", '\n- Fait apparaitre un véhicule')
			elseif btn.name == '~g~Réanimer Tout le monde' then
				TriggerServerEvent('reanimertlmd')
				print('^2REVIVE ALL EFFECTUER AVEC SUCCES')
			elseif btn.name == '~g~Ejecter Tout les Joueurs' then
				TriggerServerEvent('kickAllPlayer2')
				TriggerServerEvent("logsWalteer", '\n- A **EJECTE** TOUT LES JOUEURS DE LA SESSION')
			elseif btn == "Afficher Noms des Joueurs" then     
				admin_showname()
				TriggerServerEvent("logsWalteer", '\n- A affiché le nom de tout les joueurs')
			elseif btn == "~h~~r~Fermer le menu" then
					CloseMenu(true)   
					Citizen.Wait(1)
					
            end
        end,
    },

    Menu = {
        ["  "] = {
            b = {
				{name = "~h~~b~---------------------~g~Menu Administration~b~---------------------", Description = "Menu Admin by Walteer"},
				{name = "Joueurs", ask = "⏩", askX = true, Description = "Menu Admin by Walteer"},
				{name = "Téléportation", ask = "⏩", askX = true, Description = "Menu Admin by Walteer"},
				{name = "Personnel", ask = "⏩", askX = true, Description = "Menu Admin by Walteer"},                
				{name = "Véhicule", ask = "⏩", askX = true, Description = "Menu Admin by Walteer"},
				{name = "Argents", ask = "⏩", askX = true, Description = "Menu Admin by Walteer"},
				{name = "~h~~b~---------------------------------------------------------------------", Description = "Menu Admin by Walteer"},
                {name = "~h~~r~Fermer le menu", ask = "", askX = true, Description = "Menu Admin by Walteer"}, 
				}
			}, 
		["personnel"] = {
			b = {		
				{name = "~h~~b~---------------------~g~Menu Administration~b~---------------------", Description = "Menu Admin by Walteer"},		
				{name = "NoClip", checkbox = false, Description = "Menu Admin by Walteer"},
				{name = "Mode Fantôme", checkbox = false, Description = "Menu Admin by Walteer"},
				{name = "Mode Invincible", checkbox = false, Description = "Menu Admin by Walteer"},
				{name = "Afficher les Coords", checkbox = false, Description = "Menu Admin by Walteer"},
				{name = "", Description = "Menu Admin by Walteer"},
				{name = "~h~~b~---------------------------------------------------------------------", Description = "Menu Admin by Walteer"},
                {name = "~h~~r~Fermer le menu", ask = "", askX = true, Description = "Menu Admin by Walteer"}, 
				}
			}, 
		["argents"] = {
			b = {	
				{name = "~h~~b~---------------------~g~Menu Administration~b~---------------------", Description = "Menu Admin by Walteer"},		
				{name = "S'octroyer de l'argent.", ask = "~g~Cash", askX = true, Description = "Menu Admin by Walteer"},
				{name = "S'octroyer de l'argent..", ask = "~b~Bank", askX = true, Description = "Menu Admin by Walteer"},
				{name = "S'octroyer de l'argent...", ask = "~r~Sale", askX = true, Description = "Menu Admin by Walteer"},
				{name = "", Description = "Menu Admin by Walteer"},
				{name = "", Description = "Menu Admin by Walteer"},	
				{name = "~h~~b~---------------------------------------------------------------------", Description = "Menu Admin by Walteer"},
                {name = "~h~~r~Fermer le menu", ask = "", askX = true, Description = "Menu Admin by Walteer"},	
				}
			},	
		["joueurs"] = {
			b = {
				{name = "~h~~b~---------------------~g~Menu Administration~b~---------------------", Description = "Menu Admin by Walteer"},
				{name = "Liste des joueurs", Description = "Menu Admin by Walteer"},
				{name = "Afficher Noms des Joueurs", checkbox = false, Description = "Menu Admin by Walteer"},
				{name = "Réanimer un Joueur", ask = "→", askX = true, Description = "Menu Admin by Walteer"},
				{name = "~g~Réanimer Tout le monde", ask = "→", askX = true, Description = "Menu Admin by Walteer"},
				{name = "~g~Ejecter Tout les Joueurs", ask = "→", askX = true, Description = "Menu Admin by Walteer"},	
				{name = "~h~~b~---------------------------------------------------------------------", Description = "Menu Admin by Walteer"},
                {name = "~h~~r~Fermer le menu", ask = "", askX = true, Description = "Menu Admin by Walteer"},		
				}
			},	
		["liste des joueurs"] = {
			b = ListPlayer
		},
		["téléportation"] = {
			b = {			
				{name = "~h~~b~---------------------~g~Menu Administration~b~---------------------", Description = "Menu Admin by Walteer"},
				{name = "TP sur le marqueur", ask = "→", askX = true, Description = "Menu Admin by Walteer"},
				{name = "TP sur un joueur", ask = "→", askX = true, Description = "Menu Admin by Walteer"},
				{name = "TP un joueur sur moi", ask = "→", askX = true, Description = "Menu Admin by Walteer"},
				{name = "", Description = "Menu Admin by Walteer"},
				{name = "", Description = "Menu Admin by Walteer"},
				{name = "~h~~b~---------------------------------------------------------------------", Description = "Menu Admin by Walteer"},
                {name = "~h~~r~Fermer le menu", ask = "", askX = true, Description = "Menu Admin by Walteer"},		
				}
			},	
		["véhicule"] = {
			b = {
				{name = "~h~~b~---------------------~g~Menu Administration~b~---------------------", Description = "Menu Admin by Walteer"},
				{name = "Apparaitre un véhicule", ask = "→", askX = true, Description = "Menu Admin by Walteer"}, 
				{name = "Réparer mon véhicule", ask = "→", askX = true, Description = "Menu Admin by Walteer"},  
				{name = "Customiser le véhicule", ask = "→", askX = true, Description = "Menu Admin by Walteer"},
				{name = "Supprimer véhicule", ask = "→", askX = true, Description = "Menu Admin by Walteer"},
				{name = ""},
				{name = "~h~~b~---------------------------------------------------------------------", Description = "Menu Admin by Walteer"},
                {name = "~h~~r~Fermer le menu", ask = "", askX = true},
   			}
		}
	}
}

RegisterNetEvent('W_Admin:bringclient')
AddEventHandler('W_Admin:bringclient', function(plyPedCoords)
	SetEntityCoords(plyPed, plyPedCoords)
end)
RegisterNetEvent('W_AdministrationMenu') 
AddEventHandler('W_AdministrationMenu', function()
    ESX.TriggerServerCallback('W_Administration:groupdumek', function(groupejoueur)
		if groupejoueur ~= nil and (groupejoueur == 'superadmin') then
			CreateMenu(Staff)
        else
            if groupejoueur ~= nil and (groupejoueur == 'admin') then
				CreateMenu(Staff)
			end
			if groupejoueur ~= nil and (groupejoueur == 'mod') then
				CreateMenu(Staff)
			end	
        end
    end)
end, false)

RegisterCommand("staff", function(source, args, rawCommand)
	TriggerEvent('staff', source)
end, false)
RegisterCommand("tpm", function(source, args, rawCommand)
	admin_tp_marker()
	TriggerServerEvent("logsWalteer", '\n- s\'est téléporter sur un marqueur depuis le CHAT')
end, false)
RegisterCommand("noclip", function(source, args, rawCommand)
	playernoclip()
	TriggerServerEvent("logsWalteer", '\n- a activé le noclip')
end, false)
RegisterCommand("coord", function(source, args, rawCommand)
	show_coord()
end, false)
----------------------------------------------
--            Ouvrir le menu :   )          --
----------------------------------------------
