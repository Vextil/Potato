potatoes = { amount = 0, items = {} }

function potatoUpdate()
	if game.state == state.playing and game.spawnsLeft > 0 and love.math.random(1, 500) == 1 then
		addPotato()
	elseif game.state == state.playing and game.spawnsLeft == 0 and potatoes.amount == 0 then
		setState(state.typing)
	end
end

function drawPotatoes(deltaTime)
	for i , p in ipairs(potatoes.items) do
		if isEqualLocation(p.location, p.destination, 20) then
			removePotato(i)
		else
			love.graphics.draw(p.image, p.location.x, p.location.y, p.rotation, 1, 1, p.image:getWidth()/2, p.image:getHeight()/2)
			p.location = lerpLocation(p.location, p.destination, dt)
			p.rotation = p.rotation + (p.rotationSpeed * deltaTime)
		end
	end
end

function addPotato()
	locations = getSpawnAndDestination(centerCoords.x * 2, centerCoords.y * 2, 200)
	potato = { 
		location = locations.spawn,
		destination = locations.destination,
		rotation = 0, 
		rotationSpeed = love.math.random(1, 10), 
		image = images.potato
	}
	table.insert(potatoes.items, potato)
	potatoes.amount = potatoes.amount + 1
	game.spawnsLeft = game.spawnsLeft - 1
end

function removePotato(i)
	table.remove(potatoes.items, i)
	potatoes.amount = potatoes.amount - 1
end

-- This algorithm generates a random point in a rectangle's perimeter and 
-- another random point in the opposing side (using padding to generate it outside the screen)
-- The generation is not uniform, all sides have the same chance
function getSpawnAndDestination(w, h, p)
	side = love.math.random(1, 4)
	spawnFactor = love.math.random()
	destinationFactor = love.math.random()
	x = ((w - p) * spawnFactor)
	y = ((h - p) * spawnFactor)
	dx = ((w - p) * destinationFactor)
	dy = ((h - p) * destinationFactor)
	if side == 1 or side == 3 then
		x = side == 1 and -p or w
		dx = side == 1 and w or -p
	else
		y = side == 2 and h or -p
		dy = side == 2 and -p or h
	end
	return {spawn = {x = x+p/2, y = y+p/2}, destination = {x = dx+p/2, y = dy+p/2}}
end