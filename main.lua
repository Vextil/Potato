debug = true
game = {playing = false, round = 0, spawns = 0, spawnsLeft = 0}
potatoes = {}
spawned = 0

function love.load()
	casual = love.graphics.newFont("assets/fonts/K26CasualComics.ttf", 15)
	potatoImg = love.graphics.newImage("assets/images/potato.png")
end

function love.update(dt)
	w, h, flags = love.window.getMode()
	if game.playing and game.spawnsLeft > 0 and love.math.random(1, 100) == 1 then
		spawnPotato(w, h)
	end
	if love.keyboard.isDown("x") then
		beginRound()
	end
end

function love.draw()
	drawPotatoes(love.timer.getDelta())
	love.graphics.setFont(casual)
	love.graphics.print("FPS "..love.timer.getFPS(), 10, 10)
	love.graphics.print("POTATOES "..spawned, 10, 30)
end

function drawPotatoes(dt)
	for i, potato in ipairs(potatoes) do
		if isEqualLocation(potato.location, potato.destination, 2) then
			table.remove(potatoes, i)
			spawned = spawned - 1
		else
			love.graphics.draw(potato.img, potato.location.x, potato.location.y, potato.r, 1, 1, potato.img:getWidth()/2, potato.img:getHeight()/2)
			potato.location = lerpLocation(potato.location, potato.destination, dt)
			potato.r = potato.r + (10 * dt)
		end
	end
end

function beginRound()
	game.playing = true
	game.spawns = love.math.random(1, 50)
	game.spawnsLeft = game.spawns
end


-- requires window width and height
function spawnPotato(w, h)
	locations = getSpawnAndDestination(w, h, 400)
	potato = { 
		location = locations.spawn,
		destination = locations.destination,
		r = 0, 
		img = potatoImg
	}
	table.insert(potatoes, potato)
	spawned = spawned + 1
	game.spawnsLeft = game.spawnsLeft - 1
end

-- width, height, padding (so we can make potatoes spawn outside the screen)
function getSpawnAndDestination(w, h, p)
	p = p or 0
	side = love.math.random(1, 4)
	spawnFactor = love.math.random()
	destinationFactor = love.math.random()
	if side == 1 then
		x = -(p/2)
		y = ((h - p) * spawnFactor) + p/2
		dx = w + (p/2)
		dy = ((h - p) * destinationFactor) + p/2
	elseif side == 2 then
		x = ((w - p) * spawnFactor) + p/2
		y = h + (p/2)
		dx = ((w - p) * destinationFactor) + p/2
		dy = -(p/2)
	elseif side == 3 then
		x = w + (p/2)
		y = ((h - p) * spawnFactor) + p/2
		dx = -(p/2)
		dy = ((h - p) * destinationFactor) + p/2
	else
		x = ((w - p) * spawnFactor) + p/2
		y = -(p/2)
		dx = ((w - p) * destinationFactor) + p/2
		dy = h + (p/2)
	end
	return {spawn = {x = x, y = y}, destination = {x = dx, y = dy}}
end

function lerpLocation(a, b, t)
	return {
		x = a.x + (b.x - a.x) * t, 
		y = a.y + (b.y - a.y) * t
	}
end

-- a, b, t (Threshold, in LERP values will never reach 0 so we need to use a "margin")
function isEqualLocation(a, b, t)
	t = t or 0
	return math.abs(a.x - b.x) <= t and math.abs(a.y - b.y) <= t
end