text = { amount = 0, items = {} }

function drawText()
	love.graphics.setColor(255, 255, 255)
	for i, t in ipairs(text.items) do
		x = centerCoords.x - (fonts.comic:getWidth(t.text) / 2) + t.x
		y = centerCoords.y - (fonts.comic:getHeight(t.text) / 2) + t.y
		love.graphics.print(t.text, x, y)
	end
end

function addText(i, x, y) 
	t = { text = i, x = x, y = y }
	table.insert(text.items, t)
	text.amount = text.amount + 1
end

function removeAllText() 
	for i = 1, text.amount, 1 do 
		text.items[i] = nil 
	end
	text.amount = 0
end