local oxlogger = exports["oxlib"].logger
local config = LoadConfig()

AddEventHandler("playerConnecting", function(name, setCallback, deferrals)
    deferrals.defer()
    oxlogger.log("join", {player = name})
    NotifyAllPlayersWithPermission(config.joinMessage, config.permissions.join)
    deferrals.done()
end)

AddEventHandler("playerShotWeapon", function(player)
    oxlogger.log("shoot", {player = player})
    NotifyAllPlayersWithPermission(config.shootMessage, config.permissions.shoot)
end)

AddEventHandler("playerDied", function(player, reason, killer)
    oxlogger.log("kill", {victim = player, killer = killer, reason = reason})
    NotifyAllPlayersWithPermission(config.killMessage, config.permissions.kill)
end)

AddEventHandler("playerDropped", function(reason)
    local player = source
    oxlogger.log("leave", {player = player, reason = reason})
    NotifyAllPlayersWithPermission(config.leaveMessage, config.permissions.leave)
end)

RegisterServerEvent("txadmin:commandEntered")
AddEventHandler("txadmin:commandEntered", function(command)
    oxlogger.log("txadmin_action", {command = command})
    NotifyAllPlayersWithPermission(config.txAdminMessage, config.permissions.txadmin)
end)

function LoadConfig()
    local configFile = LoadResourceFile(GetCurrentResourceName(), "config.json")
    if configFile then
        return json.decode(configFile)
    else
        return {
            joinMessage = "Spieler {player} ist dem Spiel beigetreten.",
            shootMessage = "Ein Spieler hat geschossen.",
            killMessage = "Spieler {victim} wurde von {killer} getötet.",
            leaveMessage = "Spieler {player} hat das Spiel verlassen.",
            txAdminMessage = "txAdmin-Aktion: {command}",
            notifyEvent = "esx:showNotification",
            permissions = {
                join = "custom.perm.join",
                shoot = "custom.perm.shoot",
                kill = "custom.perm.kill",
                leave = "custom.perm.leave",
                txadmin = "custom.perm.txadmin"
            }
        }
    end
end

function NotifyAllPlayersWithPermission(message, permission)
    local players = GetPlayersWithPermission(permission)
    for _, player in ipairs(players) do
        TriggerClientEvent(config.notifyEvent, player, message)
    end
end

function GetPlayersWithPermission(permission)
    local players = {}
    for _, player in ipairs(GetPlayers()) do
        if IsPlayerAceAllowed(player, permission) then
            table.insert(players, player)
        end
    end
    return players
end
