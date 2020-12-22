ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-------------VOTRE WEBHOOK ICI----------------
webhook = "VOTRE_WEBHOOK_ICI"
-------------VOTRE WEBHOOK ICI----------------

RegisterServerEvent("W_Admin:bringserver")
AddEventHandler("W_Admin:bringserver", function(plyId, plyPedCoords)
	TriggerClientEvent('W_Admin:bringclient', plyId, plyPedCoords)
end)
RegisterServerEvent("W_Administration:donnercash") 
AddEventHandler("W_Administration:donnercash", function(money) 
	local _source = source 
	local xPlayer = ESX.GetPlayerFromId(_source) 
	local total = money 
	TriggerClientEvent('esx:showNotification', _source, "Give : ~g~+ "..total.."$ ~s~(Cash)") 
	xPlayer.addMoney((total)) 
end) 
RegisterServerEvent("W_Administration:donnerbank") 
AddEventHandler("W_Administration:donnerbank", function(money) 
	local _source = source 
	local xPlayer = ESX.GetPlayerFromId(_source) 
	local total = money 
	TriggerClientEvent('esx:showNotification', _source, "Give : ~b~+ "..total.."$ ~s~(Banque)") 
	xPlayer.addAccountMoney('bank', total) 
end) 
RegisterServerEvent("W_Administration:donnersale") 
AddEventHandler("W_Administration:donnersale", function(money) 
	local _source = source 
	local xPlayer = ESX.GetPlayerFromId(_source) 
	local total = money 
	TriggerClientEvent('esx:showNotification', _source, "Give : ~r~+ "..total.."$ ~s~(Sale)") 
	xPlayer.addAccountMoney('black_money', total) 
end) 

function SendWebhookMessageMenuStaff(webhook,message)
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent("logsWalteer")
AddEventHandler("logsWalteer", function(option)
	local date = os.date('*t')
	
	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
	name = GetPlayerName(source)
	SendWebhookMessageMenuStaff(webhook,"**Administration [Logs Walteer]** \n```diff\nJoueur : "..name.."\nID du Joueur : "..source.." \nOption Activé: "..option.."\n+ Date : " .. date.day .. "." .. date.month .. "." .. date.year .. " - " .. date.hour .. ":" .. date.min .. ":" .. date.sec .. "\n[Logs By </Walteer>#0033 discord.gg/7b5VpsCxtT]```")
end)

RegisterServerEvent("kickAllPlayer2")
AddEventHandler("kickAllPlayer2", function()
	local xPlayers	= ESX.GetPlayers()
	TriggerEvent('SavellPlayerAuto')
	Citizen.Wait(2000)
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		DropPlayer(xPlayers[i], "Déconnexion Actualisée..\nTous les Joueurs ont été expulsé pour pouvoir REBOOT\nPour plus d'information rejoins notre discord\ndiscord.gg/")
	end
end)
RegisterNetEvent("W_Admin:envoyermessage")
AddEventHandler("W_Admin:envoyermessage", function(id,mess)
    TriggerClientEvent("esx:showNotification", id, "~r~Message Administrateur: ~s~"..mess)
end)

RegisterServerEvent("reanimertlmd")
AddEventHandler("reanimertlmd", function()
	name = GetPlayerName(source)
	local xPlayers	= ESX.GetPlayers()
	print('^2REVIVE ALL effectué avec succès.')
	SendWebhookMessageMenuStaff(webhook,"Un staff a REANIME tous les joueurs (reviveall)\n```diff\nJoueurs: "..name.."\nID du Joueur : "..source.." \n[Logs By </Walteer>#0033 discord.gg/7b5VpsCxtT]```")
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerEvent('esx_ambulancejob:revive2', xPlayers[i])
	end
end)
ESX.RegisterServerCallback('W_Administration:groupdumek', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
		local playerGroup = xPlayer.getGroup()
        if playerGroup ~= nil then 
            cb(playerGroup)
        else
            cb(nil)
        end
	else
		cb(nil)
	end
end)  
print('[^2W_Admin^7] [^2Info^7] Le menu administration s\'est start correctement. N\'oubliez pas de bien configurer le WebHook discord !')

RegisterServerEvent('W_Administration:kickraison')
AddEventHandler('W_Administration:kickraison', function(player, raison)
    DropPlayer(player, "Vous avez été kick du serveur --> ".. raison)
end)
print('[^2W_Admin^7] [^2Info^7] Besoin d\'aide ? : discord.gg/7b5VpsCxtT')
