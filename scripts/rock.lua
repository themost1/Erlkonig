require('scripts.object')

local P = {}

local rock0 = Object:new {
	x = 10,
	scale = 0.3,
	y = -60,
	height = 20,
	image = love.graphics.newImage("graphics/obstacles/obs0.png")
}

local rock1 = Object:new {
	x = 10,
	scale = 0.03,
	y = -45,
	height = 20,
	image = love.graphics.newImage("graphics/obstacles/obs1.png")
}

P.rock0 = rock0	
P.rock1 = rock1

return P