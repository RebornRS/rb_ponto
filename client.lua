Tunnel = module("vrp","lib/Tunnel")
Proxy = module("vrp","lib/Proxy")

rebornSV = Tunnel.getInterface(GetCurrentResourceName())

RegisterKeyMapping("+rb:ponto", "INICIAR PONTO","KEYBOARD","E")
RegisterCommand("+rb:ponto", function()
    local ped = PlayerPedId()
    for k,v in pairs(Config['locs']) do
        local distance = #(GetEntityCoords(ped) - vector3(v.x,v.y,v.z))   
        if distance < 1.5 then 
            rebornSV.playerCheck(Config["Hierarquia"][k],k)
        end
    end
end)

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        for k,v in pairs(Config['locs']) do
            local distance = #(GetEntityCoords(ped) - vector3(v.x,v.y,v.z))   
            if distance < 2.5 then 
                DrawMarker(v["blip"], v["x"],v["y"],v["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, v["color"][1], v["color"][2], v["color"][3], v["color"][4], v["effect"], v["sync"], 2, v["rotate"])
            end
        end
        Wait(4)
    end
end)