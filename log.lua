
local Log = {}
Log.__index = Log

local sformat = string.format
local fs = love.filesystem


local function log(Log, status, msg, ...)
    local _, lines = fs.read(Log.filepath):gsub("\n", "")
    local table = {
        lines,
        status,
        os.date("%H:%M:%S"),
        debug.getinfo(2, "Sl").short_src,
        sformat(msg, unpack({...}))
    }

    local string = "%s [%s %s] %s: %s"
    local output = sformat(string, unpack(table))
    print(output)

    fs.append(Log.filepath, output.."\n")
end


function Log.new(dirpath, filename)
    dirpath = dirpath or "logs/"
    filename = filename or "latest.log"

    local self = setmetatable({
        filename = filename,
        dirpath = dirpath,
        filepath = dirpath .. filename,
    }, Log)

    -- Create directory if needed
    if not fs.getInfo(self.dirpath) then
        local ok = fs.createDirectory(self.dirpath)
        if not ok then
            print("Unable to create directory at path '"..self.dirpath.."'")
        end
    end

    -- initialize / write start up message
    self:init()

    return self
end


function Log:init()
    local datetime = os.date("%Y-%m-%d %H:%M:%S")
    local startup_string = sformat("%s %s - %s\n", _TITLE, _VERSION, datetime)
    local absolute_path = fs.getSaveDirectory() .."/".. self.filepath

    -- Create a new file with a start up message
    self.file = fs.write(self.filepath, startup_string)

    -- Push inital path info message
    self:info("Created log file at '%s'", absolute_path)
end


function Log:info(msg, ...)
    log(self, "INFO", msg, ...)
end


function Log:warning(msg, ...)
    log(self, "WARN", msg, ...)
end


function Log:error(msg, ...)
    log(self, "ERROR", msg, ...)
end


function Log:debug(msg, ...)
    if _DEBUG then log(self, "DEBUG", msg, ...) end
end

return Log