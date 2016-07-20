-- Weird game state implementation.
-- By changing states this way I can avoid repeating code like game.state = (current state)
-- and removeAllButtons(), since they would have been needed in each state changing function.

state = { current = 0, main = 1, playing = 2, typing = 3, success = 4, fail = 5 }

stateFunctions = {

	--[[MAIN]] function()
		addText("EL PAPINADOR 3000", 0, -100)
		addButton("JUGAR!", 0, 0, function() setState(state.playing) end)
	end, 

	--[[PLAYING]] function()
		game.spawns = love.math.random(1, 10)
		game.spawnsLeft = game.spawns
	end, 

	--[[TYPING]] function()
		-- Create keyboard to type potato counting guess
		addButton("1", -75, -75, function() inputWrite(1) end)
		addButton("2",  0,  -75, function() inputWrite(2) end)
		addButton("3",  75, -75, function() inputWrite(3) end)
		addButton("4", -75,  0, function() inputWrite(4) end)
		addButton("5",  0,   0, function() inputWrite(5) end)
		addButton("6",  75,  0, function() inputWrite(6) end)
		addButton("7", -75,  75, function() inputWrite(7) end)
		addButton("8",  0,   75, function() inputWrite(8) end)
		addButton("9",  75,  75, function() inputWrite(9) end)
		addButton("0",  0,  150, function() inputWrite(0) end)
		addButton("BORRAR", -75, 225, function() inputDelete() end)
		addButton("ACEPTAR", 75, 225, function() guess(inputValue()) end)
		input.visible = true
		input.x = centerCoords.x - 100
		input.y = centerCoords.y - 200
		input.width = 200
		input.height = 50
	end,

	--[[SUCCESS]] function()
		game.points = game.points + game.spawns
		game.spawns = 0
		addText("CORRECTO! Puntos: "..game.points, 0, -100)
		addButton("CONTINUAR", 0, 100, function() setState(state.playing) end)
	end,

	--[[FAIL]] function()
		love.graphics.setColor(255, 255, 255)
		addText("PERDISTE CON "..game.points.."! SOS UNA PIJA...", 0, -100)
		addButton("NUEVO JUEGO", 0, 100, function() setState(state.playing) end)
	end
}

function setState(id)
	game.state = id
	removeAllButtons()
	removeAllText()
	restartInput()
	stateFunctions[id]()
end