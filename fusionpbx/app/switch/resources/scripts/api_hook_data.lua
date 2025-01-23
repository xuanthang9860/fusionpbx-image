function urlencode(str)
    if (str) then
        str = string.gsub(str, "([^%w ])", function(c)
            return string.format("%%%02X", string.byte(c))
        end)
        str = string.gsub(str, " ", "%%20")
    end
    return str
end
local hook_url = argv[1];
data = env:serialize("json")
data = urlencode(data)
-- freeswitch.consoleLog("INFO","Here's everything:\n" .. dat .. "\n")
api = freeswitch.API()
api:execute("curl", hook_url .. " content-type 'application/JSON' post " .. data)