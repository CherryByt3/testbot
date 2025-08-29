local HttpService = game:GetService("HttpService")
local key = "TESTKEY123"
local server_ip = "<your_phone_ip>"  -- Find with `ifconfig` in Termux

local function getScript(scriptName)
    local url = "http://"..server_ip..":5000/getscript?key="..key.."&script="..scriptName
    local response = HttpService:GetAsync(url)
    if response == "invalid" then
        error("Invalid key!")
    elseif response == "ip_mismatch" then
        error("IP mismatch! Key locked to another device.")
    elseif response == "script_not_found" then
        error("Script not found!")
    end
    loadstring(response)()
end

-- Example usage: load example.lua from GitHub
getScript("example.lua")
