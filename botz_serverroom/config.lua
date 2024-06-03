Config = {}

notify = function(data)	
	lib.notify({                              --ex -- notify({des = '',status =''})
		title = 'ServerRoom Heist',
		description = data.des,
    type = data.status,
		position = 'top',
    duration = 6000,
		
	})
end


function policealert() --Add your own Police alert here.
    /*exports["gksphone"]:JobDispatch('Server Room has been hacked', '', '["police"]', true)
    local playerPed = PlayerPedId()
    local coords = vec3(2049.7046, 2949.4631, 47.7358)
    local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
        job_table = {'police', 'govt'}, --{'police', 'sheriff} 
        coords = coords,
        title = 'Server Room Heist in Progress',
        message = 'A '..data.sex..'  robbing at Server Room  ',
        flash = 0,
        unique_id = tostring(math.random(0000000,9999999)),
        blip = {
            sprite = 521, 
            scale = 0.8, 
            colour = 1,
            flashes = false, 
            text = '10-90 Server Room',
            time = (5*60*1000), --(5 mins)
            sound = 1,
        }
    })*/

end

Config.server_item_change_Ped = {  --The Item you got from the server room(sr_hardisk) can be changed to any items with the below configuration.
    model = 's_m_m_highsec_01', --NPC Model.
    scenario = 'WORLD_HUMAN_SMOKING', --NPC Scenario.
    location = vector3(-1359.4882, -760.4712, 21.3045), --Location of the NPC.
    heading =  346.0598, --Heading of the NPC.
    distance = 40.0, --The Distance the player should be near to the NPC so that the NPC can spawn.
    target_label = 'Exchange Hard disk', --Target Label.
	target_icon = 'fa-solid fa-hard-drive', -- Target Icon(Refer fontawsome).
    giveitem = 'sr_hardisk', --The Item that should be removed from the Inventory in order to give the items.
    giveitem_count = 1, --The Count of the item that should be removed.
    change_items = {--The Items that should be added to the player's inventory.
        [1] = {item = 'black_money', count = 4},
        [2] = {item = 'bread', count = 3},
        [3] = {item = 'water', count = 2},
    }
}

Config.RequiredCopsCount = 0 --Minimum Cop Requirement for the heist to be started.
Config.cooldown_time = 60 --How much interval should be there between heists (In minutes).
Config.debug = true --Debug for ox_target and zones.
Config.hackLocation = vec3(2061.1096, 2954.5229, 47.4269) --Location where the Trigger location starts
Config.hacklocationsize = vec3(2.0, 3.0, 2.6)
Config.hacklocationrotation = 45.0

Config.robberystart_item ='vpn'
Config.hackTimer = 10000
Config.pc_hack_Timer = 10000
Config.SearchTimer = 10000
Config.finalTimer = 10000
Config.iteration = 10  --How much time should a player should search for servers before getting to the Final Reward.

Config.pc_hack_loc = { --After Triggering The Heist Where the player first should hack in order to get the location of the servers.
    [1] = {
        coords = vector3(2171.03, 2928.23, -81.08),
        size = vec3(1.2, 1, 1),
        rotation = 25.57
    },
    [2] = {
        coords = vector3(2174.92, 2914.18, -81.08),
        size = vec3( 0.8, 2.2, 1),
        rotation = 30.99
    },
    [3] = {
        coords = vector3(2167.96, 2926.12, -81.08),
        size = vec3(1.2, 1.4, 1),
        rotation =  35.28
    }
}

Config.Mission = { --Where Npc Should Spawn (NPC Spawns after you hack all the PC Hacking(Config.pc_hack_loc) )
    NPCModel = 'g_m_y_lost_02',
    NPCLocations = {
        vec4(2192.4849, 2911.7637, -84.8001, 74.0832),
        vec4(2183.3723, 2902.9038, -84.8000, 20.5926),
        vec4(2152.2319, 2907.2212, -84.8000, 274.2213),
        vec4(2144.0005, 2920.4937, -84.8000, 252.2643),
        vec4(2153.2668, 2938.9053, -84.8001, 240.9409),
        vec4(2170.3435, 2936.9846, -84.8000, 192.0733),
        vec4(2207.4810, 2938.3267, -84.8001, 42.9655),
        vec4(2216.9670, 2921.1238, -84.8000, 109.7392),
        vec4(2220.9133, 2913.8972, -84.8001, 85.8066),
        vec4(2204.0398, 2927.8347, -84.8000, 113.6719),
    },
}
Config.SearchLocations = {
    [1] = {
        num = 1,
        text = 'A38',
        coords = vec3(2329.93, 2921.3, -84.8),
        size = vec3(1.0, 4.0, 1.5),
        rotation = 70.866142,


    },
        [2] = {
        num = 2,
        text = 'B5',
        coords = vec3(2194.92, 2904.2, -84.72),
        size = vec3(0.8, 0.4, 1.5),
        rotation = 0,


    },  
        [3] = {
        num = 3,
        text = 'A34',
        coords = vec3(2303.24, 2929.58, -84.72),
        size = vec3(1.0, 4.0, 1.5),
        rotation = 0,


    },  
        [4] = {
        num = 4,
        text = 'B37',
        coords = vec3(2323.23, 2904.85, -84.72),
        size = vec3(1.0, 4.0, 1.5),
        rotation = 0,


    },  
        [5] = {
        num = 5,
        text = 'B30',
        coords = vec3(2293.81, 2894.84, -84.72),
        size = vec3(0.6, 0.8, 1.5),
        rotation = 0,


    },  
        [6] = {
        num =6,
        text = 'B28',
        coords = vec3(2283.32, 2912.99, -84.72),
        size = vec3(0.2, 1.0, 1.5),
        rotation = 70.866142,


    },  
        [7] = {
        num = 7,
        text = 'B19',
        coords = vec3(2243.76, 2896.44, -84.72),
        size = vec3(0.2, 1, 1.5),
        rotation = 0,


    },  
        [8] = {
        num = 8,
        text = 'C1',
        coords = vec3(2154.61, 2906.66, -84.72),
        size = vec3(0.2, 1,1.5),
        rotation = 70.866142,


    },  
        [9] = {
        num = 9,
        text = 'C9',
        coords = vec3(2114.41, 2899.41, -84.72),
        size = vec3(1.0, 4.0, 1.5),
        rotation = 0.866142,


    },    
        [10] = {
        num =10,
        text = 'D23',
        coords = vec3(2072.81, 2920.06, -84.72),
        size = vec3(0.2, 1, 1.5),
        rotation = 70.866142,


    },    
        [11] = {
        num = 11,
        text = 'D31',
        coords = vec3(2022.37, 2929.84, -84.72),
        size = vec3(0.8, 1, 1.5),
        rotation = 0.866142,


    },    
        [12] = {
        num = 12,
        text = 'D38',
        coords = vec3(2002.4, 2947.03, -84.72),
        size = vec3(0.2, 1, 1.5),
        rotation = 0.866142,
    },    
        [13] = {
        num = 13,
        text = 'D41',
        coords = vec3(1982.39, 2938.6, -84.72),
        size = vec3(0.2, 1, 1.5),
        rotation = 0.866142,
    },
    

}



Config.Final_location = {
        num = 1,
        coords = vec3(2150.0, 2929.0, -85.0),
        size = vec3(1, 3.0, 3.0),
        rotation = 0.0,
        anim = {
            dict = 'mini@repair',
            clip = 'fixing_a_ped'
        },
        reward_items = {
            [1] = {item = 'sr_hardisk', count = 1},
            --[2] = {item = 'vpn_receiver', count = 1},  //Add how many items as you want.
        }
}

Config.DiscordWebhook = '' --Add your webhook
Config.icon_url = 'https://cdn.discordapp.com/attachments/1112335008678563960/1112383696771756113/1.png'
Config.Webhooks = {
    Locale = {
        ['robberyProcess'] = '⌛ Robbery started...',
        ['robberyFinished'] = '✅ Robbery finished.',
        ['robberyCanceled'] = '❌ Robbery Canceled..',
    },

    -- To change a webhook color you need to set the decimal value of a color, you can use this website to do that - https://www.mathsisfun.com/hexadecimal-decimal-colors.html
    Colors = {
        ['robberyProcess'] = 3145631, 
        ['robberyFinished'] = 3093151,
        ['robberyCanceled'] = 16711680,
    }
}

Config.Shells = {
    {
        enterLabel = 'Enter', -- The target label used to enter at the serverroom location
        enterIcon = 'fas fa-sign-out-alt', -- The target icon used for the enterLabel
        exitLabel = 'Exit', -- The target label used to exit at the exit location
        exitIcon = 'fas fa-sign-out-alt', -- The target icon used for the exitLabel
        enterShell = vec3(2049.8418, 2950.1941, 47.7357), -- The location the target exists to enter the Serverroom
        enterHeading = 0.0, -- The heading (direction) a player is facing when entering the serverroom
        exitShell = vec3(2156.3301, 2921.7820, -81.0802), -- The location the target exists to exit the Serverroom
        exitHeading = 48.0, -- The heading (direction) a player is facing when exiting the Serverroom
    },
    -- Create more locations here following the format above
}
