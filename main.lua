debug = true
dt = 0

potatoes = { amount = 0, items = {} }
buttons = {}

state = { main = 0, playing = 1, typing = 2, success = 3, fail = 4 }
game = { state = 1, round = 0, spawns = 0, spawnsLeft = 0 }

function love.load()
	love.graphics.setNewFont("assets/fonts/K26CasualComics.ttf", 15)
	potatoImg = love.graphics.newImage("assets/images/potato.png")
end

function love.update(deltaTime)
	dt = deltaTime
	potatoUpdate()
	buttonUpdate()
	if love.keyboard.isDown("x") then
		beginRound()
	end
end

function love.draw()
	if     state.playing == game.state then drawPotatoes()
	elseif state.typing  == game.state then drawTypingScreen()
	elseif state.success == game.state then drawSuccessScreen()
	elseif state.fail    == game.state then drawFailScreen()
	else drawMainMenu() end

	love.graphics.print("FPS "..love.timer.getFPS(), 10, 10)
	love.graphics.print("POTATOES "..potatoes.amount, 10, 30)
end

function drawMainMenu() end

function drawTypingScreen() end

function drawSuccessScreen() end

function drawFailScreen() end

function drawPotatoes()
	for i, potato in ipairs(potatoes.items) do
		if isEqualLocation(potato.l, potato.d, 2) then
			despawnPotato(i)
		else
			draw(potato.i, potato.l.x, potato.l.y, potato.r)
			potato.l = lerpLocation(potato.l, potato.d, dt*0.1)
			potato.r = potato.r + (potato.rs * dt)
		end
	end
end

function beginRound()
	game.playing = true
	game.spawns = love.math.random(1, 50)
	game.spawnsLeft = game.spawns
end

function addButton() end

function removeAllButtons() end

function buttonUpdate() end

function potatoUpdate()
	w, h, flags = love.window.getMode()
	if game.playing and game.spawnsLeft > 0 and love.math.random(1, 1000) == 1 then
		spawnPotato(w, h)
	end
end


function spawnPotato(w, h) -- requires window width and height
	locations = getSpawnAndDestination(w, h, 400)
	-- Potato has LOCATION, DESTINATION, ROTATION, ROTATION SPEED and IMAGE
	potato = { l = locations.spawn, d = locations.destination, r = 0, rs = love.math.random(1, 10), i = potatoImg }
	table.insert(potatoes.items, potato)
	potatoes.amount = potatoes.amount + 1
	game.spawnsLeft = game.spawnsLeft - 1
end

function despawnPotato(i)
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

function lerpLocation(a, b, t) 
	return { x = a.x+(b.x-a.x)*t, y = a.y+(b.y-a.y)*t } 
end

-- a, b, t (Threshold, in LERP values will never reach 0 so we need to use a "margin")
function isEqualLocation(a, b, t) 
	return math.abs(a.x - b.x) <= t and math.abs(a.y - b.y) <= t 
end

function draw(i, x, y, r)
	love.graphics.draw(i, x, y, r, .5, .5, i:getWidth()/2, i:getHeight()/2)
end
