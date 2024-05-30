ESX = exports["es_extended"]:getSharedObject()

local search_zones
local pc_hack_zones = {}
local final_search_zones
local searchloc_total_zones
local number = 0
local deliveryblip
local robberystarted = false
local In_tp_loc = false
local exit_zone
botz_count = 0
local serverroom_item_change_Ped

finalreward = function()
    local v = Config.Final_location 
    final_search_zones = exports.ox_target:addBoxZone({
        coords = v.coords,
        size = v.size,
        rotation = v.rotation,
        debug = Config.debug,
        drawSprite = Config.debug,
        options = {
            {
                icon = 'fas fa-gem',
                label = 'Crack the pc!',
                distance = 1.5,
                onSelect = function()
                    --local success = true
                    local success = exports['SN-Hacking']:MemoryCards('easy')
                    if success then
                        exports.ox_target:removeZone(final_search_zones)
                        if lib.progressCircle({
                            duration = Config.EasterEggTimer,
                            position = 'bottom',
                            useWhileDead = false,
                            canCancel = false,
                            disable = {
                                car = true,
                                mouse =true,
                                move = true,
                                combat = true,
                                sprint = true
                            },
                            anim = v.anim,
                        }) then 
                            local pass = math.random(1,9999)
                            if Config.debug then print('pass',pass) end
                            lib.callback.await('botz_serverroom:setpassword',false,pass)
                            local data = lib.callback.await('botz_serverroom:robfinish', false,v.reward_items)
                            if data then
                                notify({des = 'Robbery Finished', status ='success'})
                            end
                        end
                    else
                        notify({des = 'Hack Failed', status ='error'})
                    end
                end
            }
        }
    })
end



Searchinglocations = function()
     
    number = math.random(1,999)
    exports['SN-Hacking']:ShowNumber(number, 3000)
    local k = math.random(1,13)
    local v = Config.SearchLocations[k]
    --print('k,v',k,v)
    PlaySoundFrontend(-1, 'Text_Arrive_Tone', 'Phone_SoundSet_Default', 1)
    lib.notify({
        title = 'Next Spot:',
        description = v.text,
        position = 'top',
        duration = 20000,
        style = {
            backgroundColor = '#141517',
            color = '#FFD700',
            ['.description'] = {
              color = '#FFD700'
            }
        },
        icon = 'fa-solid fa-server',
        iconColor = '#FFD700'
    })
    if Config.debug then print(v.text) end
    
    search_zones = exports.ox_target:addBoxZone({
        coords = v.coords,
        size = v.size,
        rotation = v.rotation,
        debug = Config.debug,
        drawSprite = Config.debug,
        options = {
            {
                icon = 'fas fa-gem',
                label = 'ROB!',
                distance = 1.5,
                onSelect = function()
                    if Config.debug then print(number) end
                    local input = lib.inputDialog('Server room', {'Enter the Data Code'})
                    local passwordpa = tonumber(input[1])
                    if number == passwordpa then
                        exports.ox_target:removeZone(search_zones)
                        if lib.progressCircle({
                            duration = Config.SearchTimer,
                            position = 'bottom',
                            useWhileDead = false,
                            canCancel = false,
                            disable = {
                                car = true,
                                mouse =true,
                                move = true,
                                combat = true,
                                sprint = true
                            },
                            anim = {
                                scenario = 'PROP_HUMAN_PARKING_METER'                                      
                            },
                        }) then 
                            botz_count = botz_count + 1
                            notify({des = 'Successfully Robbed', status ='success'})
                            if botz_count <= Config.iteration then 
                                Searchinglocations()
                            else
                                finalreward()
                                exit_zone:remove()
                                notify({des = 'You have finished searching for the hardisk now go to the Main PC and Crack it!', status ='error'})
                                return
                            end
                        end
                    else
                        notify({des = 'Hack Failed', status ='error'})
                    end
                end
            }
        }
    })
end

local function requestModels(model)
    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do 
        Wait(500)
    end 
end 

function botz_npc()
    local model = Config.Mission.NPCModel
    requestModels(model)
    missionNPCTable = {}
    for i = 1, #Config.Mission.NPCLocations, 1 do 
        missionNPCTable[i] = CreatePed(1, GetHashKey(Config.Mission.NPCModel), Config.Mission.NPCLocations[i], true, true)
        GiveWeaponToPed(missionNPCTable[i], GetHashKey('weapon_pistol'), 250, false, true)
        SetCurrentPedWeapon(missionNPCTable[i], GetHashKey('weapon_pistol'), true)
        SetPedCombatAbility(missionNPCTable[i], 100)
        SetPedRelationshipGroupHash(missionNPCTable[i], 'AGGRESSIVE_INVESTIGATE')
        Wait(500)
    end 
end


function server_exit_zone()
    In_tp_loc = true
    
    function onExit(self)
        if not In_tp_loc then
            if search_zones then
                exports.ox_target:removeZone(search_zones)
                if Config.debug then print('search reward removed') end
            end
            if final_search_zones then
                    exports.ox_target:removeZone(final_search_zones)
            end  
            if pc_hack_zones then
                for k,v in pairs(pc_hack_zones) do
                    exports.ox_target:removeZone(pc_hack_zones[k])
                    print('zone reward removed')
                end
            end  
            exit_zone:remove()
            local pass = math.random(1,9999)
            if Config.debug then print('pass',pass) end
            lib.callback.await('botz_serverroom:setpassword',false,pass)
        end
    end
    CreateThread(function()
        exit_zone = lib.zones.poly({
            points = {
                --vec(2081.5186, 2715.3389, 48.0584),
                vec(2041.1943, 2708.0039, 47.0),
                vec(1816.9620, 2929.0940, 47.0),
                vec(1875.8372, 3040.4988, 47.0),
                vec(2413.1648, 2979.4150, 47.0),
                
            },
            thickness = 50,
            debug = Config.debug,
            onExit = onExit
        })
    end)   
end


pchacking = function() 
    local pchacking_total_zones = 0
    CreateThread(function()
        for k,v in pairs(Config.pc_hack_loc) do
            pc_hack_zones[k] = exports.ox_target:addBoxZone({
                coords = v.coords,
                size = v.size,
                rotation = v.rotation,
                debug = Config.debug,
                drawSprite = Config.debug,
                options = {
                    {
                        icon = 'fa-solid fa-code',
                        label = 'Hack the PC',
                        distance = 1.5,
                        onSelect = function()
                            local ped = PlayerPedId()
                            TaskPlayAnim(ped, 'mp_fbi_heist', "loop", 3.0, -8, -1, 63, 0, false, false, false)
                            exports['ps-ui']:Circle(function(winner)
                            ClearPedTasksImmediately(cache.ped)    
                            --winner=true
                            if winner then
                                exports.ox_target:removeZone(pc_hack_zones[k]) 
                                if lib.progressCircle({
                                    duration = Config.pc_hack_Timer,
                                    position = 'bottom',
                                    useWhileDead = false,
                                    canCancel = false,
                                    disable = {
                                        car = true,
                                        mouse =true,
                                        move = true,
                                        combat = true,
                                        sprint = true
                                    },
                                    anim = {
                                        dict = 'mp_fbi_heist',
                                        clip = 'loop'                                     
                                    },
                                }) then 
                                    pchacking_total_zones = pchacking_total_zones - 1
                                    if pchacking_total_zones == 0 then
                                        notify({des = 'Security Gaurds has been alerted! KILL THEM', status ='success'})
                                        Searchinglocations()
                                        if not Config.debug then botz_npc() end
                                        server_exit_zone()
                                        return
                                    else
                                        notify({des = 'Search the next PC', status ='success'})
                                    end
                                end
                            end
                        end)
                        end
                    }
                }
            })
            pchacking_total_zones = 1 + pchacking_total_zones
        end
    end)
end
-----
--- starting point
------

exports.ox_target:addBoxZone({
    coords = Config.hackLocation,
    size = Config.hacklocationsize,
    rotation = Config.hacklocationrotation,
    debug = Config.debug,
    drawSprite = Config.debug,
    options = {
        {
            icon = 'fa-solid fa-laptop-code',
            label = 'Get Server Credentials',
            distance = 1.5,
            onSelect = function()
                local status = lib.callback.await('botz_serverroom:robberystatus', false)
                if status == 3 then
                    notify({des = 'Not enough police in the city.', status ='error'})
                elseif status == 2 then
                    exports['ps-ui']:VarHack(function(success)     
                    if success then  
                        local data = lib.callback.await('botz_serverroom:robberystart', false)
                        if data then
                            robberystarted = true
                            if lib.progressBar({
                                duration = Config.hackTimer,
                                label = 'Decrypting Server Credentials...',
                                useWhileDead = false,
                                canCancel = false,
                                disable = {
                                    car = true,
                                    mouse =true,
                                    move = true,
                                    combat = true,
                                    sprint = true
                                },
                                anim = {
                                    dict = 'anim@heists@prison_heiststation@cop_reactions',
                                    clip = 'cop_b_idle'                                        
                                },
                            }) then
                                policealert()
                                --exports["gksphone"]:JobDispatch('Serverroom Heist has been triggered!', '', '["police"]', true)
                                deliveryblip = AddBlipForCoord(2049.4490, 2949.9470, 47.7358)
                                SetBlipSprite(deliveryblip, 606)
                                SetBlipDisplay(deliveryblip, 4)
                                SetBlipScale(deliveryblip, 1.0)
                                SetBlipColour(deliveryblip, 1)
                                SetBlipAsShortRange(deliveryblip, true)
                                BeginTextCommandSetBlipName("STRING")
                                AddTextComponentString("Delivery point")
                                EndTextCommandSetBlipName(deliveryblip)
                                SetBlipRoute(deliveryblip, true)
                                pchacking()
                                local pass = math.random(1,9999)
                                exports['SN-Hacking']:ShowNumber(pass, 3000)
                                if Config.debug then print('pass',pass) end
                                lib.callback.await('botz_serverroom:setpassword',false,pass)
                                notify({des = 'Robbery Started..\nGo to the server room!', status ='success'})
                            end
                        else
                            notify({des = 'SomeThing Error ,Contact Admin', status ='error'})
                        end
                    else
                        --exports.ox_target:disableTargeting(false)
                        notify({des = 'Hack Failed..', status ='error'})
                    end   
                end,2,3)
                elseif status == 1 then
                    notify({des = 'You Don\'t have a Hacking item', status ='error'}) 
                else
                    notify({des = 'Robbery in cooldown..', status ='error'}) 
                end
            end        
        }
    }
})


-- Function that teleports player from entry point to shell location
local EnterShell = function(coords, heading)
    DoScreenFadeOut(1500)
    Wait(1000)
    Wait(2000)
    SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, false, false, false, false)
    SetEntityHeading(cache.ped, heading)
    DoScreenFadeIn(1500)
    In_tp_loc = true
    Wait(2500)
end

-- Function that teleports player from shell to entry point
local ExitShell = function(coords, heading)
    DoScreenFadeOut(1500)
    Wait(1000)
    Wait(2000)
    SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, false, false, false, false)
    SetEntityHeading(cache.ped, heading)
    DoScreenFadeIn(1500)
    In_tp_loc = false
    Wait(2500)
end


CreateThread(function()
    for i = 1, #Config.Shells do
        exports.ox_target:addSphereZone({
            coords = Config.Shells[i].enterShell,
            radius = 0.75,
            debug = Config.Debug,
            options = {
                {
                    label = Config.Shells[i].enterLabel,
                    icon = Config.Shells[i].enterIcon,
                    onSelect = function()
                        if deliveryblip then RemoveBlip(deliveryblip) end
                        local pass = lib.callback.await('botz_serverroom:getpassword',false)
                        local input = lib.inputDialog('Server Room', {'Enter the passcode to enter!'}) 
                        local passwordpa = tonumber(input[1])
                        if passwordpa==nil then return end
                        if pass == passwordpa then
                            EnterShell(Config.Shells[i].exitShell, Config.Shells[i].enterHeading)
                        end 
                    end,
                    distance = 2
                },
                {
                    
                    label = 'Special Entry',
                    icon = Config.Shells[i].enterIcon,
                    onSelect = function()
                        EnterShell(Config.Shells[i].exitShell, Config.Shells[i].enterHeading)
                    end,
                    groups = {
                        ['police'] = 0,
                        ['govt'] = 0
                    },
                    distance = 2
                }
            }
        })
        exports.ox_target:addSphereZone({
            coords = Config.Shells[i].exitShell,
            radius = 0.75,
            debug = Config.Debug,
            options = {
                {
                    label = Config.Shells[i].exitLabel,
                    icon = Config.Shells[i].exitIcon,
                    onSelect = function()
                        ExitShell(Config.Shells[i].enterShell, Config.Shells[i].exitHeading)
                    end,
                    distance = 2
                }
            }
        })
    end
end)


-- Function that handles the actual spawning of the ped, etc
serverroom_item_change_Ped = function()
    lib.RequestModel(Config.server_item_change_Ped.model)
    serverroom_item_change_Ped = CreatePed(0, Config.server_item_change_Ped.model, Config.server_item_change_Ped.location, Config.server_item_change_Ped.heading, false, true)
    FreezeEntityPosition(serverroom_item_change_Ped, true)
    SetBlockingOfNonTemporaryEvents(serverroom_item_change_Ped, true)
    SetEntityInvincible(serverroom_item_change_Ped, true)
    TaskStartScenarioInPlace(serverroom_item_change_Ped, Config.server_item_change_Ped.scenario, 0, true) ----- ANIMATION OF THE PED
end

local function onEnterped(self)
    serverroom_item_change_Ped()
    exports.ox_target:addLocalEntity(serverroom_item_change_Ped, {
        name = 'server_item_change_Ped',
        icon = self.target_icon,
        label = self.target_label,
        distance = 2,
        canInteract = function(entity, coords, distance)
            return IsPedOnFoot(cache.ped) and not IsPlayerDead(cache.ped)
        end,
        onSelect = function()
            lib.callback.await('botz_serverroom:change_porul', false)
        end
    })
end

-- Deletes the mission start ped when player exits the defined area
local function onExitped(self)
    DeleteEntity(serverroom_item_change_Ped)
    exports.ox_target:removeLocalEntity(serverroom_item_change_Ped, nil)
end
 
local points = lib.points.new({
    coords = Config.server_item_change_Ped.location,
    heading = Config.server_item_change_Ped.heading,
    distance = Config.server_item_change_Ped.distance,
    model = Config.server_item_change_Ped.model,
    scenario = Config.server_item_change_Ped.scenario,
    target_label = Config.server_item_change_Ped.target_label,
	target_icon = Config.server_item_change_Ped.target_icon,
    change_items = Config.server_item_change_Ped.change_items,
    giveitem = Config.server_item_change_Ped.giveitem,
    giveitem_count = Config.server_item_change_Ped.giveitem_count,
    onEnter = onEnterped,
    onExit = onExitped,
})