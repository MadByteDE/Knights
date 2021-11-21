
local Math = {}

function Math.clamp(val, min, max)
    if not val then return end
    return math.min(math.max(val, min), max)
end

function Math.angle(x1,y1, x2,y2)
    return math.atan2(y2-y1, x2-x1)
end

function Math.boxCollision(x1, x2, y1, y2, w1, w2, h1, h2)
    if x1 > x2 + w2 - 1 or y1 > y2 + h2 - 1 or x2 > x1 + w1 - 1 or y2 > y1 + h1 - 1 then
        return false
    else
        return true
    end
end

function Math.circleCollision(ax, ay, bx, by, ar, br)
	local dx = bx - ax
	local dy = by - ay
	return dx^2 + dy^2 < (ar + br)^2
end

function Math.distance(a, b) -- Get the distance between two objects
    return math.sqrt((a.x - b.x) ^ 2 + (a.y - b.y) ^ 2)
end

function Math.round(num, idp)
    local mult = 10^(idp or 0)
    if num >= 0 then
        return math.floor(num * mult + 0.5) / mult
    else
        return math.ceil(num * mult - 0.5) / mult
    end
end

-- Linear interpolation between two numbers.
function Math.lerp(a,b,t) return (1-t)*a + t*b end
function Math.lerp2(a,b,t) return a+(b-a)*t end

-- Cosine interpolation between two numbers.
function Math.cerp(a,b,t) local f=(1-math.cos(t*math.pi))*.5 return a*(1-f)+b*f end

return Math
