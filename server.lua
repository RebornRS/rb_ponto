Tunnel = module("vrp","lib/Tunnel")
Proxy = module("vrp","lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

rebornSV = {}
Tunnel.bindInterface(GetCurrentResourceName(),rebornSV)

-- [CONFIGS]
Clothes = module(GetCurrentResourceName(),"config/config_roupas")
Config = module(GetCurrentResourceName(),"config/config_ponto")

-- [TABELA DO PONTO]
local timePonto = {}

-- [VARIÁVEL DE SEGUNDOS PARA INICIAR SERVIÇO NOVAMENTE]

-- [FUNÇÃO PARA CHECAR E INICIAR/SAIR O EMPREGO]
rebornSV.playerCheck = function(hierarquia,type)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        for k,v in pairs(hierarquia) do
            local groups = vRP.getUserGroups(user_id)
            if groups[v["SERVICO"]] then
                vRP.removeUserGroup(user_id,v["SERVICO"]) -- remove o grupo de serviço
                vRP.addUserGroup(user_id,v["SERVICO-OFF"]) -- adiciona o grupo de fora de serviço
                vRP.removeCloak(source) -- volta a roupa antiga do player
                
                TriggerEvent("vrp_sysblips:ExitService",source)

                SetTimeout(3000, function()
                    TriggerEvent("disney-barbershop:init",source) -- resolver o problema da cara de joelho
                    TriggerEvent("nation_barbershop:init",user_id) -- resolver o problema da cara de joelho
                end)


                TriggerClientEvent("Notify",source, "aviso","Você saiu de serviço")
                SendWebhookMessage(Config["Webhooks"][type],"```prolog\n[PASSAPORTE]: "..user_id.."\n[S-ATUAL]: "..v["SERVICO-OFF"].." \r```","SAIU DE SERVICO") 
            elseif groups[v["SERVICO-OFF"]] then
                if not timePonto[user_id] then
                    timePonto[user_id] = Config["timer"]
                    vRP.removeUserGroup(user_id,v["SERVICO-OFF"]) -- remove o grupo de fora de serviço
                    vRP.addUserGroup(user_id,v["SERVICO"]) -- adiciona o grupo de serviço
                    if Clothes["ChangePonto"] then -- CHECA SE NAS CONFIG O CHANGEPONTO ESTÁ TRUE PARA MUDAR DE ROUPA
                        custom = Clothes["Roupas"][type][k][v["SERVICO"]]
                        if Clothes["Roupas"][type][k][v["SERVICO"]] then
                            if custom[1885233650] or custom[-1667301416] then -- para setar a roupa de serviço
                                local old_custom = vRPclient.getCustomization(source)
                                local idle_copy = {}
                                idle_copy = vRP.save_idle_custom(source,old_custom)
                                idle_copy.modelhash = nil
                                for l,w in pairs(custom[old_custom.modelhash]) do
                                    idle_copy[l] = w
                                end
                                vRPclient.setCustomization(source,idle_copy)
                            end
                        end
                    end

                    TriggerClientEvent("vrp_sysblips:ToggleService",source,Config["Messages"][type],47)
                    TriggerClientEvent("Notify",source, "aviso","Você entrou em seviço")
                    SendWebhookMessage(Config["Webhooks"][type],"```prolog\n[PASSAPORTE]: "..user_id.." \n[S-ATUAL]: "..v["SERVICO"].."\r```","ENTROU EM SERVICO") 
                else
                    TriggerClientEvent("Notify",source,"negado","Você deve aguardar "..timePonto[user_id].." para entrar em serviço novamente ")
                end
            end
        end
    end
end

-- [EVENTO PARA QUANDO O PLAYER SPAWNAR ELE FICAR FORA DE SERVIÇO!]
AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
    local groups = vRP.getUserGroups(user_id)
    for k,v in pairs(Config["Hierarquia"]) do
        if groups[v["SERVICO"]] then
            vRP.removeUserGroup(user_id,v["SERVICO"]) -- remove o grupo de serviço
            vRP.addUserGroup(user_id,v["SERVICO-OFF"]) -- adiciona o grupo de fora de serviço
            vRP.removeCloak(source) -- volta a roupa antiga do player
        end
    end
end)

-- [LOOP PRA INICIAR O SERVIÇO NOVAMENTE]
CreateThread(function()
    while true do
        for k,v in pairs(timePonto) do
            if timePonto[k] > 0 then
                timePonto[k] = timePonto[k] - 1
                if timePonto[k] < 1 then
                    timePonto[k] = nil
                end
            end
        end
        Wait(1000)
    end
end)

-- [FUNÇÃO PARA ENVIAR WEBHOOK]
function SendWebhookMessage(webhook,message,title)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
            avatar_url = "http://reihosting-websites.com/images/reborn_logo_3-1.png",
            username = "Reborn Resources",
            embeds = {
                {     ------------------------------------------------------------
                  title = "BATE-PONTO\n⠀",
                  thumbnail = {
                    url = "http://reihosting-websites.com/images/reborn_logo_3-1.png"
                  }, 
                  fields = {
                    { 
                      name = ""..title.."\n",
                      value = message
                    }
                  }, 
                  footer = { 
                    text = "Data e hora: " ..os.date("%d/%m/%Y | %H:%M:%S"),
                    icon_url = "https://www.autoriafacil.com/wp-content/uploads/2019/01/icone-data-hora.png"
                  },
                  color = 13991687
                }
              }
            }), 
        {['Content-Type'] = 'application/json' })
	end
end