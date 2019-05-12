iceCubes = require('scripts.iceCube')

local P = {}

P.lemon = iceCubes.iceCube:new {
	name = "lemon",
	xCoord = 0,
	yCoord = 0,
	height = 80,
	length = 320,
	radius = 10,
	img = love.graphics.newImage("graphics/lemonslice.png"),
	xscale = 0.4,
	yscale = 0.4,
	x = 0,
	y = 0
}

return P