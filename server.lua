local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrpex_bong")

local function ch_trunk_in(player,choice)
  TriggerClientEvent("vrp:trunk:in",player)
end

local function ch_trunk_out(player,choice)
  TriggerClientEvent("vrp:trunk:out",player)
end

local function ch_trunk_source_in(player,choice)
  local nplayer = vRPclient.getNearestPlayer(player,10)
  if nplayer then
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id then
      TriggerClientEvent("vrp:trunk:in",nplayer)
    else
      vRPclient._notify("~r~Рядом нету игрокa")
    end
  end
end

local function ch_trunk_source_out(player,choice)
  local nplayer = vRPclient.getNearestPlayer(player,10)
  if nplayer then
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id then
      TriggerClientEvent("vrp:trunk:out",nplayer)
    else
      vRPclient._notify("~r~Рядом нету игрокa")
    end
  end
end

vRP.registerMenuBuilder("main", function(add, data)
  local user_id = vRP.getUserId(data.player)
  if user_id then
    local choices = {}

    -- build trunk menu
    choices["Багажник"] = {function(player,choice)
      local menu  = vRP.buildMenu("trunkmenu", {player = player})
      menu.name = "Багажник"
      menu.css={top="75px",header_color="#9167dd"}
      menu.onclose = function(player) vRP.openMainMenu(player) end -- onclose event and open main menu

      if vRP.hasPermission(user_id,"player.list") then 
        menu["Залезть в багажник"] = {ch_trunk_in, "Залезть в багажник"}
      end
      
      if vRP.hasPermission(user_id,"player.list") then 
        menu["Вылезти из багажника"] = {ch_trunk_out, "Вылезти из багажника"}
      end

      if vRP.hasPermission(user_id,"player.list") then 
        menu["Закинуть в багажник"] = {ch_trunk_source_in}
      end

      if vRP.hasPermission(user_id,"player.list") then
        menu["Вытащить из багажника"] = {ch_trunk_source_out}
      end

      vRP.openMenu(player,menu)
    end}

    add(choices)
  end
end)