debug = true
dt = 0

potatoes = { amount = 0, items = {} }
buttons = { amount = 0, items = {} }

state = { main = 0, typing = 2, success = 3, fail = 4 }
game = { state = 0, round = 0, spawns = 0, spawnsLeft = 0 }

function love.load()
	love.graphics.setNewFont("assets/fonts/K26CasualComics.ttf", 15)
	potatoImg = love.graphics.newImage("assets/images/potato.png")
	buttonImg = love.graphics.newImage("assets/images/button.png")
	setStateMain()
end

function love.update(deltaTime)
	dt = deltaTime
	potatoUpdate()
end

function love.draw()
	drawPotatoes()
	drawButtons()

	love.graphics.print("FPS "..love.timer.getFPS(), 10, 10)
	love.graphics.print("POTATOES "..potatoes.amount, 10, 30)
end

function love.mousepressed(x, y, button, istouch)
	buttonPressCheck(x, y)
end

-------- STATES --------

function setStateMain()
	game.state = state.main 
	addButton(buttonImg, 100, 100, 0, function()
		setStatePlaying()
	end)
end

function setStatePlaying()
	game.state = state.playing
	game.spawns = love.math.random(1, 50)
	game.spawnsLeft = game.spawns
end

function setStateTyping()
	game.state = state.typing
end

function setStateSuccess()
	game.state = state.success
end

function setStateFail()
	game.state = state.fail
end

-------- BUTTONS --------

function buttonPressCheck(x, y)
	for i , button in ipairs(buttons.items) do
		if clicked(button, x, y) then
			button.f()
		end
	end
end

function drawButtons()
	for i , button in ipairs(buttons.items) do
		draw(button)
	end
end

function addButton(i, x, y, r, f) 
	button = { i = i, l = {x = x, y = y}, r = r, f = f }
	table.insert(buttons.items, button)
	buttons.amount = buttons.amount + 1
end

function removeAllButtons() 
	for i = 1, buttons.amount, 1 do buttons.items[i] = nil end
	buttons.amount = 0
end

-------- POTATOES --------

function potatoUpdate()
	if game.state == state.playing and game.spawnsLeft > 0 and love.math.random(1, 100) == 1 then
		addPotato()
	end
end

function drawPotatoes()
	for i , potato in ipairs(potatoes.items) do
		if isEqualLocation(potato.l, potato.d, 2) then
			removePotato(i)
		else
			draw(potato)
			potato.l = lerpLocation(potato.l, potato.d, dt*0.1)
			potato.r = potato.r + (potato.rs * dt)
		end
	end
end

function addPotato()
	w, h, flags = love.window.getMode()
	locations = getSpawnAndDestination(w, h, 400)
	-- Potato has LOCATION, DESTINATION, ROTATION, ROTATION SPEED and IMAGE
	potato = { l = locations.spawn, d = locations.destination, r = 0, rs = love.math.random(1, 10), i = potatoImg }
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

-------- HELPERS --------

function lerpLocation(a, b, t) 
	return { x = a.x+(b.x-a.x)*t, y = a.y+(b.y-a.y)*t } 
end

-- a, b, t (Threshold, in LERP values will never reach 0 so we need to use a "margin")
function isEqualLocation(a, b, t) 
	return math.abs(a.x - b.x) <= t and math.abs(a.y - b.y) <= t 
end

function draw(e)
	love.graphics.draw(e.i, e.l.x, e.l.y, e.r, 1, 1, e.i:getWidth()/2, e.i:getHeight()/2)
end

function clicked(e, x, y)
	return x > e.l.x and x < e.l.x+e.i:getWidth() and y > e.l.y and y < e.l.y+e.i:getHeight()
end