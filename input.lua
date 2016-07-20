input = { visible = false, value = "" }

function drawInput()
	if input.visible then
		love.graphics.setColor(255, 255, 255, 80)
		love.graphics.rectangle("fill", input.x - 2, input.y - 2, input.width + 4, input.height + 4, 10, 10)
		love.graphics.setColor(255, 255, 255, 150)
		love.graphics.rectangle("fill", input.x - 1, input.y - 1, input.width + 2, input.height + 2, 10, 10)
		love.graphics.setColor(255, 255, 255)
		love.graphics.rectangle("fill", input.x, input.y, input.width, input.height, 10, 10)
		love.graphics.setColor(0, 0, 0)
		love.graphics.print(input.value, input.x + 10, input.y + 10)
	end
end

function inputValue()
	return tonumber(input.value)
end

function inputWrite(value)
	input.value = input.value..value
end

function inputDelete()
	input.value = input.value:sub(1, -2)
end

function restartInput()
	input.visible = false
	input.value = ""
end