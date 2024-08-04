local Authorize, NotAuthorized = function() end,Kick

local data = "https://raw.githubusercontent.com/VIPFirstTime/"
local m = "/main"
local auth = "/authorized-user"
local lua = "/list.lua"

local url = data .. auth .. m .. lua
local success, response = pcall(function() return game:HttpGet(url) end)

if success then
    local authorizedUsersFunc, err = loadstring(response)
    if authorizedUsersFunc then
        local authorizedUsers = authorizedUsersFunc()

        local playerName = game.Players.LocalPlayer.Name
        if authorizedUsers[playerName] then
            Authorized()
        else
            game.Players.LocalPlayer:NotAuthorized()
        end
    else
        print("Error loading string: ", err)
    end
else
    print("Error getting HTTP response: ", response)
end
