---- Created by: Joaquin Cuitiño ----

debug = true
dt = 0

images = {}

potatoes = { amount = 0, items = {} }
buttons = { amount = 0, items = {} }
text = { amount = 0, items = {} }

game = { state = 0, round = 0, spawns = 0, spawnsLeft = 0, points = 0 }

function love.load()
	love.graphics.setNewFont("assets/fonts/K26CasualComics.ttf", 15)
	images.potato = love.graphics.newImage("assets/images/potato.png")
	images.button = love.graphics.newImage("assets/images/button.png")
	setState(state.main)
end

function love.update(deltaTime)
	dt = deltaTime
	potatoUpdate()
end

function love.draw()
	drawPotatoes()
	drawButtons()
	drawText()

	love.graphics.print("FPS "..love.timer.getFPS(), 10, 10)
	love.graphics.print("POTATOES "..potatoes.amount, 10, 30)
end

function love.mousepressed(x, y, button, istouch)
	buttonPressCheck(x, y)
end

-------- STATES --------

-- Weird game state implementation.
-- By changing states this way I can avoid repeating code like game.state = (current state)
-- and removeAllButtons(), since they would have been needed in each state changing function.

state = { main = 1, playing = 2, typing = 3, success = 4, fail = 5 }

stateFunctions = {

	--[[MAIN]] function()
		addButton(images.button, 300, 300, function() setState(state.playing) end)
	end, 

	--[[PLAYING]] function()
		game.spawns = love.math.random(1, 50)
		game.spawnsLeft = game.spawns
	end, 

	--[[TYPING]] function()
		-- Create keyboard to type potato counting guess
		addButton(images.n0, 0, 0, function() inputWrite(1) end)
		addButton(images.n1, 0, 0, function() inputWrite(1) end)
		addButton(images.n2, 0, 0, function() inputWrite(1) end)
		addButton(images.n3, 0, 0, function() inputWrite(1) end)
		addButton(images.n4, 0, 0, function() inputWrite(1) end)
		addButton(images.n5, 0, 0, function() inputWrite(1) end)
		addButton(images.n6, 0, 0, function() inputWrite(1) end)
		addButton(images.n7, 0, 0, function() inputWrite(1) end)
		addButton(images.n8, 0, 0, function() inputWrite(1) end)
		addButton(images.n9, 0, 0, function() inputWrite(1) end)
		addButton(images.delete, 0, 0, function() inputDelete(1) end)
		addButton(images.accept, 0, 0, function() inputAccept(1) end)
	end,

	--[[SUCCESS]] function()
		game.points = game.points + game.spawns
		game.spawns = 0
		addButton(images.continue, 0, 0, function() setState(state.playing) end)
	end,

	--[[FAIL]] function()
		game.points = 0
		addButton(images.newGame, 0, 0, function() setState(state.playing) end)
	end
}

function setState(id)
	game.state = id
	removeAllButtons()
	removeAllText()
	stateFunctions[id]()
end

-------- TEXT -----------

function drawText()
	for i , t in ipairs(text.items) do
		love.graphics.print(t.i, t.x, t.i)
		love.graphics.draw(t.i, t.x, t.y, 0)
	end
end

function addText(i, x, y) 
	t = { i = i, x = x, y = y }
	table.insert(text.items, t)
	text.amount = text.amount + 1
end

function removeAllText() 
	for i = 1, text.amount, 1 do text.items[i] = nil end
	text.amount = 0
end

-------- BUTTONS --------

function drawButtons()
	for i , b in ipairs(buttons.items) do
		love.graphics.draw(b.i, b.x, b.y, b.r)
	end
end

function addButton(i, x, y, f) 
	b = { i = i, x = x, y = y, f = f }
	table.insert(buttons.items, b)
	buttons.amount = buttons.amount + 1
end

function removeAllButtons() 
	for i = 1, buttons.amount, 1 do buttons.items[i] = nil end
	buttons.amount = 0
end

function buttonPressCheck(x, y)
	for i , b in ipairs(buttons.items) do
		if clicked(b, x, y) then
			b.f()
		end
	end
end

-------- POTATOES --------

function potatoUpdate()
	if game.state == state.playing and game.spawnsLeft > 0 and love.math.random(1, 100) == 1 then
		addPotato()
	end
end

function drawPotatoes()
	for i , p in ipairs(potatoes.items) do
		if isEqualLocation(p.l, p.d, 2) then
			removePotato(i)
		else
			love.graphics.draw(p.i, p.x, p.y, p.r, 1, 1, p.i:getWidth()/2, p.i:getHeight()/2)
			p.l = lerpLocation(p.x, p.y, p.dx, p.dy, dt*0.1)
			p.r = p.r + (p.rs * dt)
		end
	end
end

function addPotato()
	w, h, flags = love.window.getMode()
	locations = getSpawnAndDestination(w, h, 400)
	potato = { 
		x = locations.spawn.x,
		y = locations.spawn.y,
		dx = locations.destination.x,
		dy = locations.destination.y, 
		r = 0, 
		rs = love.math.random(1, 10), 
		i = images.potato
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

-------- HELPERS --------

function lerpLocation(ax, ay, bx, by, t) 
	return { x = ax+(bx-ax)*t, y = ay+(by-ay)*t } 
end

-- a, b, t (Threshold, in LERP values will never reach 0 so we need to use a "margin")
function isEqualLocation(ax, ay, bx, by, t) 
	return math.abs(ax - bx) <= t and math.abs(ay - by) <= t 
end

function clicked(e, x, y)
	return x > e.x and x < e.x+e.i:getWidth() and y > e.y and y < e.y+e.i:getHeight()
end