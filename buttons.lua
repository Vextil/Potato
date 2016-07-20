buttons = { amount = 0, items = {} }

function drawButtons()
	for i , b in ipairs(buttons.items) do
		love.graphics.setColor(100, 100, 0, 80)
		x = centerCoords.x + b.x - (b.width / 2)
		y = centerCoords.y + b.y - (b.height / 2)
		love.graphics.rectangle("fill", x - 2, y - 2, b.width + 4, b.height + 4, buttons.radius.x, buttons.radius.y)
		love.graphics.setColor(100, 100, 0, 150)
		love.graphics.rectangle("fill", x - 1, y - 1, b.width + 2, b.height + 2, buttons.radius.x, buttons.radius.y)
		love.graphics.setColor(100, 100, 0)
		love.graphics.rectangle("fill", x, y, b.width, b.height, buttons.radius.x, buttons.radius.y)
		love.graphics.setColor(0, 0, 0)
		love.graphics.print(b.text, x + buttons.padding.x, y + buttons.padding.y + 1)
		love.graphics.setColor(255, 255, 255)
		love.graphics.print(b.text, x + buttons.padding.x, y + buttons.padding.y)
	end
end

function addButton(text, x, y, onClick) 
	b = {}
	b.text = text 
	b.x = x
	b.y = y 
	b.onClick = onClick 
	b.font = fonts.comic 
	b.width = b.font:getWidth(text) + (buttons.padding.x * 2)
	b.height = b.font:getHeight(text) + (buttons.padding.y * 2)
	table.insert(buttons.items, b)
	buttons.amount = buttons.amount + 1
end

function removeAllButtons() 
	for i = 1, buttons.amount, 1 do 
		buttons.items[i] = nil 
	end
	buttons.amount = 0
end

function buttonPressCheck(x, y)
	for i , b in ipairs(buttons.items) do
		if clicked(b, x, y) then
			b.onClick()
		end
	end
end

function clicked(b, x, y)
	bx = centerCoords.x + b.x - (b.width / 2)
	by = centerCoords.y + b.y - (b.height / 2)
	return x > bx and x < bx + b.width and 
		   y > by and y < by + b.height
end