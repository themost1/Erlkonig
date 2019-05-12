love.graphics.setDefaultFilter("nearest")


function love.load()
	love.graphics.setBackgroundColor(0, 0, 0.1)

	timeElapsed = 0

	setUpImages()
	horseImage = horseImages[0]

	height = 0
	jumpTime = -1

end

function setUpImages()
	moon = love.graphics.newImage("graphics/moon.png")
	rock = love.graphics.newImage("graphics/rock.png")
	tree = love.graphics.newImage("graphics/tree.png")

	horseImages = {}

	horseBase = "graphics/horse/horse"
	for i = 0, 7 do
		local horseString = horseBase..i..".png"
		local thisHorseImage = love.graphics.newImage(horseString)
		horseImages[i] = thisHorseImage
	end

end

function love.keypressed(key, scancode, isrepeat)
	if isrepeat then return end

	if (height == 0) then
		jumpTime = 0
	end
end
 
function handleJump(dt)
	if jumpTime < 0 then return end

	jumpTime = jumpTime + dt
	if jumpTime < 0.25 then
		height = height + 4
	elseif jumpTime < 0.5 then
		height = height + 2
	elseif jumpTime < 0.75 then
		height = height - 2
	else
		height = height-4
	end

	if jumpTime > 1 then
		height = 0
		jumpTime = -1
	end
end

function love.update(dt)
	handleJump(dt)

	timeElapsed = timeElapsed + dt

	local horseTime = timeElapsed % 1
	horseTime = horseTime * 100
	horseTime = horseTime - (horseTime % 1)

	if horseTime <= 16 then
		horseImage = horseImages[0]
	elseif horseTime <= 32 then
		horseImage = horseImages[1]
	elseif horseTime <= 48 then
		horseImage = horseImages[2]
	elseif horseTime <= 64 then
		horseImage = horseImages[3]
	elseif horseTime <= 80 then
		horseImage = horseImages[4]
	elseif horseTime <= 94 then
		horseImage = horseImages[5]
	elseif horseTime <= 100 then
		horseImage = horseImages[6]
	else
		horseImage = horseImages[7]
	end

end

function love.draw()
	--Shader: love.graphics.setShader(myShader) or love.graphics.setShader()
	--Draw: love.graphics.draw(bg, bgStart, 0, 0, love.graphics.getWidth()/bg:getWidth(), love.graphics.getHeight()/bg:getHeight(), 0, 32)
	love.graphics.draw(moon, 50, 100, 0, 2, 2, 0, 32)

	love.graphics.draw(rock, 50, love.graphics.getHeight(), 0, 4, 4, 0, 32)

	love.graphics.draw(tree, 50, love.graphics.getHeight(), 0, 4, 4, 0, 32)

	love.graphics.setColor(0.5, 0.5, 0.5, 1)
	love.graphics.draw(horseImage, 50, love.graphics.getHeight()-120-height, 0, 0.7, 0.7, 0, 32)


end