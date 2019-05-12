require('scripts.object')

local P = {}

P.pickup = Object:new {
	name = "pickup",
	xCoord = 0,
	yCoord = 0,
	height = 80,
	length = 320,
	radius = 10,
	img = love.graphics.newImage("graphics/lemon.png"),
	xscale = 0.3,
	yscale = 0.3,
	x = 0,
	y = 0
}

return P