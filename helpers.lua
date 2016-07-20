function lerpLocation(a, b, t) 
	return { x = a.x+(b.x-a.x)*t, y = a.y+(b.y-a.y)*t } 
end

-- a, b, t (Threshold, in LERP values will never reach 0 so we need to use a "margin")
function isEqualLocation(a, b, t) 
	return math.abs(a.x - b.x) <= t and math.abs(a.y - b.y) <= t 
end
