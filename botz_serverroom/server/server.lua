ESX = exports["es_extended"]:getSharedObject()

local lastrob = 0
local server_enter_pass 

lib.callback.register('botz_serverroom:robberystatus', function(source,index)
	local source = source
    if #ESX.GetExtendedPlayers('job', 'police') < Config.RequiredCopsCount then
        return 3
    elseif exports.ox_inventory:GetItem(source, Config.robberystart_item, nil, true) < 1 then 
        return 1
    elseif (os.time() - lastrob) < Config.cooldown_time* 60 and lastrob ~= 0 then
        return 0
    else
        return 2
    end
end)


lib.callback.register('botz_serverroom:checkitem', function(source,item)
	local source = source
    if exports.ox_inventory:GetItem(source, Config.robberydisk_item, nil, true) >= 1 then 
    return true
    end
end)

lib.callback.register('botz_serverroom:removeitem', function(source,item)
	local source = source
    exports.ox_inventory:RemoveItem(source, Config.robberydisk_item, 1)
end)
lib.callback.register('botz_serverroom:giveitem', function(source,item)
	local source = source
    exports.ox_inventory:AddItem(source,Config.robberydisk_item, 1)
end)

lib.callback.register('botz_serverroom:robberystart', function(source)
	local source = source

    SetTimeout((Config.cooldown_time - 1) * 60000, function()
        server_enter_pass = math.random(1,9999)
    end)
    if (os.time() - lastrob) < Config.cooldown_time and lastrob ~= 0 and not exports.ox_inventory:GetItem(source, Config.robberystart_item, nil, true) >= 1 then 
        return false
    else
        exports.ox_inventory:RemoveItem(source, Config.robberystart_item, 1)
        lastrob = os.time()
        SendToDiscord(source,'robberyProcess')
        return true
    end
end)

lib.callback.register('botz_serverroom:change_porul', function(source)
	local source = source

    if not (exports.ox_inventory:GetItem(source, Config.server_item_change_Ped.giveitem, nil, true) >= Config.server_item_change_Ped.giveitem_count) then 
        return false
    else
        exports.ox_inventory:RemoveItem(source, Config.server_item_change_Ped.giveitem, Config.server_item_change_Ped.giveitem_count)
        for _,i in pairs(Config.server_item_change_Ped.change_items) do
            exports.ox_inventory:AddItem(source, i.item, i.count)
        end
        return true
    end
end)

lib.callback.register('botz_serverroom:setpassword', function(source,pass)
    server_enter_pass = pass 
	--TriggerClientEvent('botz_serverroom:clientteleport', password1)
    return true
end)

lib.callback.register('botz_serverroom:getpassword', function(source)
    return server_enter_pass
end)

lib.callback.register('botz_serverroom:give_porul', function(source, item)
	local source = source
    for _,i in pairs(item) do
        exports.ox_inventory:AddItem(source, i.item, i.count)
    end
    return true
end)



lib.callback.register('botz_serverroom:robfinish', function(source,item)
	local source = source
    for _,i in pairs(item) do
        exports.ox_inventory:AddItem(source, i.item, i.count)
    end
    SendToDiscord(source,'robberyFinished')
    return true
end)

lib.callback.register('botz_serverroom:robCancel', function(source)
	local source = source
    SendToDiscord(source,'robberyCanceled')
    return true
end)


SendToDiscord = function(sourceid,TYPE)  -- robberyProcess  robberyFinished

	local source = ESX.GetPlayerFromId(sourceid)
    local source_discord = GetPlayerIdentifierByType(sourceid, 'discord')
	local source_discord_id = source_discord:gsub("discord:", "")
	local source_license = GetPlayerIdentifierByType(sourceid, 'license')
	local source_license_id = source_license:gsub("license:", "")
	
	local String_format = '\n\n**Player Information:**\nName: %s\nIdentifier: %s```%s```\nDiscord: <@%s>```%s```\nLicense: `%s`'
	local message = String_format:format(source.getName(), GetPlayerName(sourceid), source.identifier,source_discord_id,source_discord_id,source_license_id)
	local embed = {
		{
            ["color"] = Config.Webhooks.Colors[TYPE],
            ["author"] = {
                ["icon_url"] = Config.icon_url,
                ["name"] = 'Familia Maaligai Robbery - Logs',
            },
			["title"] = '**'.. Config.Webhooks.Locale[TYPE] ..'**',
			["description"] = message,
            ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%S'),
		    ["footer"] = {
		        ["text"] = "Chan Scripts",
                ["icon_url"] = Config.icon_url
		    },
		}
	}
	PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers) end, 'POST', json.encode({username = "Familia Log", embeds = embed}), { ['Content-Type'] = 'application/json' })
end