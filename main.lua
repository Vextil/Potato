---- Created by: Joaquin Cuitiño ----

require "state"
require "helpers"
require "text"
require "input"
require "buttons"
require "potatoes"

debug = true
dt = 0

images = {}

fonts = {}

game = { round = 0, spawns = 0, spawnsLeft = 0, points = 0 }

centerCoords = { x = 0, y = 0 }

function love.load()
	fonts.comic = love.graphics.newFont("assets/fonts/K26CasualComics.ttf", 20)
	love.graphics.setFont(fonts.comic)
	images.potato = love.graphics.newImage("assets/images/potato.png")

	buttons.font = fonts.comic
	buttons.padding = { x = 10, y = 10 }
	buttons.radius = {x = 10, y = 10}

	setState(state.main)
end

function love.update(deltaTime)
	dt = deltaTime
	w, h, flags = love.window.getMode()
	centerCoords.x = w/2
	centerCoords.y = h/2
	potatoUpdate()
end

function love.draw()
	drawPotatoes(dt)
	drawButtons()
	drawInput()
	drawText()

	love.graphics.print("FPS "..love.timer.getFPS(), 10, 10)
	love.graphics.print("POTATOES "..potatoes.amount, 10, 30)
end

function love.mousepressed(x, y, button, istouch)
	buttonPressCheck(x, y)
end

function guess(amount)
	if amount == game.spawns then
		setState(state.success)
	else
		setState(state.fail)
	end
end