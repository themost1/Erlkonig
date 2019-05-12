require('scripts.object')

local P = {}

P.iceCube = Object:new {
	name = "iceCube",
	xCoord = 0,
	yCoord = 0,
	height = 80,
	length = 320,
	radius = 10,
	img = love.graphics.newImage("graphics/iceplatform.png"),
	crackedImg = love.graphics.newImage("graphics/crack3.png"),
	xscale = 0.3,
	yscale = 0.4,
	cracked = false,
	cracks = 0,
	x = 0,
	y = 0
}

function P.iceCube:update()
	if self.cracks > 15 then
		self.img = self.crackedImg
	end
	if self.cracks > 30 then
		self.cracked = true
	end
end

return P