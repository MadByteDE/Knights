
local Common = {}

function Common.assert(condition, str, ...)
    local string = string.format(str or "Assertion failed", ...)
    local success, ret = pcall(function()
        return assert(condition or false, string)
    end)
    if not success then
        local str = debug.traceback(ret, 2)
        if Log then
            Log:error(string)
        end
        error(str, 2)
    end
    return ret
end

function Common.spairs(t, order)
    -- https://stackoverflow.com/questions/15706270/sort-a-table-in-lua
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

return Common