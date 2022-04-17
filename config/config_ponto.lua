Config = {}

Config["locs"] = {
    ["POLICIA"] = {['x'] = 128.57, ['y'] = -1062.92, ['z'] = 29.2, ["blip"] = 2, ["color"] = {255,255,255,255}, ["rotate"] = true, ["effect"] = true, ["sync"] = true},
    -- ["HOSPITAL"] = {['x'] = -1576.28, ['y'] = -565.82, ['z'] = 34.98, ["blip"] = 30, ["color"] = {255,255,255,255}, ["rotate"] = true, ["effect"] = true, ["sync"] = true},
    -- ["MECANICA"] = {['x'] = 820.73, ['y'] = -936.69, ['z'] = 26.47, ["blip"] = 2, ["color"] = {255,255,255,255}, ["rotate"] = true, ["effect"] = true, ["sync"] = true}
}

Config["timer"] = 60 -- deixe 0 para que não tenha bloqueio de entrada e saída

Config["Webhooks"] = { -- WEBHOOKS

    ["POLICIA"] = "",
    ["HOSPITAL"] = "",
    ["MECANICA"] = "",
}

Config["showBlips"] = true
Config["Messages"] = { 
    ["POLICIA"] = "Policial em Serviço",
    ["HOSPITAL"] = "Medico em Serviço",
    ["MECANICA"] = "Mecanico em Serviço"
}

Config["Hierarquia"] = { -- DEVE DEIXAR A SEQUÊNCIA DA HIERARQUIA IGUAL NO [CONFIG_ROUPAS.LUA]

    ["POLICIA"] = {
        {["SERVICO"] = "Policia", ["SERVICO-OFF"] = "PaisanaPolicia"},
    },
    ["HOSPITAL"] = {
        -- {["SERVICO"] = "MEDICO1", ["SERVICO-OFF"] = "HVTPAISANA1"},
    },
    ["MECANICA"] = {
        -- {["SERVICO"] = "BENNYS1", ["SERVICO-OFF"] = "PAISANABENNYS1"}
    }
}


return Config