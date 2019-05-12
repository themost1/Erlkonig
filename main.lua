--love.graphics.setDefaultFilter("nearest")

obstacles = require("scripts.rock")

function love.load()
	love.window.setTitle("ERLKONIG")
	local iconData = love.image.newImageData("graphics/elfIcon.png")
	love.window.setIcon(iconData)
	love.graphics.setBackgroundColor(0, 0, 0.1)

	setUpGame()

	started = false
	paused = false

	song = love.audio.newSource("audio/song.mp3", "stream")

end

function setUpGame()
	timeElapsed = 0

	setUpImages()
	horseImage = horseImages[0]

	height = 0
	jumpTime = -1

	rocks = {}
	spawnStartRocks()

	lastRockSpawn = 0
	horseX = 50
end

function setUpImages()
	moon = love.graphics.newImage("graphics/moon.png")
	tree = love.graphics.newImage("graphics/tree.png")
	boy = love.graphics.newImage("graphics/boy.png")
	father = love.graphics.newImage("graphics/father.png")

	horseImages = {}

	horseBase = "graphics/horse/horse"
	for i = 0, 7 do
		local horseString = horseBase..i..".png"
		local thisHorseImage = love.graphics.newImage(horseString)
		horseImages[i] = thisHorseImage
	end

end

function spawnStartRocks()
	rocks[1] = obstacles.rock0:new()
	rocks[1].x = 1000
end

function love.keypressed(key, scancode, isrepeat)

	if (not started) then
		startGame()
		return
	elseif paused then
		setUpGame()
		paused = false
		return
	end

	if (height == 0) then
		jumpTime = 0
	end
end

function startGame()
	started = true
	song:play()
end
 
function handleJump(dt)
	if jumpTime < 0 then return end

	jumpTime = jumpTime + dt
	if jumpTime < 0.25 then
		height = height + 250*dt
	elseif jumpTime < 0.5 then
		height = height + 125*dt
	elseif jumpTime < 0.75 then
		height = height - 125*dt
	else
		height = height - 250*dt
	end

	if jumpTime > 1 then
		height = 0
		jumpTime = -1
	end
end

function love.update(dt)
	if (not started) or paused then
		return
	end

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

	moveLeft(dt)

	checkDeath()

	if timeElapsed - lastRockSpawn > 1 then
		attemptRockSpawn()
	end

end

function checkDeath()
	for i = 1, #rocks do
		local horseCenter = horseX + 100
		local rockCenter = rocks[i].x + 40

		if math.abs(horseCenter - rockCenter) < 70 then
			if height < rocks[i].height then
				paused = true
				return
			end
		end
	end
end


function attemptRockSpawn()
	local shouldSpawn = love.math.random()
	if shouldSpawn > 0.98 then
		lastRockSpawn = timeElapsed
		local whichRock = love.math.random(2)
		local newRock = obstacles.rock0:new()
		--[[if whichRock == 2 then
			newRock = obstacles.rock1:new()
		end]]

		newRock.x = 1000
		rocks[#rocks+1] = newRock
	end
end


function moveLeft(dt)

	for i = 1, #rocks do
		rocks[i].x = rocks[i].x - 250*dt
	end

end

function love.draw()

	if not started then
		drawStartText()
		return
	elseif paused then
		drawPausedText()
		--return
	end

	--Shader: love.graphics.setShader(myShader) or love.graphics.setShader()
	--Draw: love.graphics.draw(bg, bgStart, 0, 0, love.graphics.getWidth()/bg:getWidth(), love.graphics.getHeight()/bg:getHeight(), 0, 32)
	love.graphics.draw(moon, 50, 100, 0, 2, 2, 0, 32)

	--love.graphics.draw(tree, 50, love.graphics.getHeight(), 0, 4, 4, 0, 32)


	love.graphics.setColor(0.4, 0.4, 0.4, 1)
	for i = 1, #rocks do
		local rock = rocks[i]
		local rockImage = rocks[i].image
		local x = rock.x
		local y = rock.y
		local scale = rock.scale
		love.graphics.draw(rockImage, x, love.graphics.getHeight()+y, 0, scale, scale, 0, 32)
	end


	love.graphics.setColor(0.5, 0.5, 0.42, 1)
	love.graphics.draw(horseImage, horseX, love.graphics.getHeight()-120-height, 0, 0.7, 0.7, 0, 32)
	love.graphics.setColor(0.9, 0.9, 0.5)
	love.graphics.draw(father, horseX+50, love.graphics.getHeight()-195-height, 0, 0.17, 0.17, 0, 32)
	love.graphics.setColor(0.5, 0.5, 0.5)
	love.graphics.draw(boy, horseX+30, love.graphics.getHeight()-175-height, 0, 0.25, 0.25, 0, 32)
	love.graphics.setColor(1,1,1,1)


end

function drawStartText()
	local title = "ERLKONIG: A Game Based on a Lied Based on a Poem"
	love.graphics.setColor(0.1, 0.4, 0.1, 1)
	love.graphics.print(title, 50, 100, 0, 2, 2)

	love.graphics.setColor(1,1,1,1)
	local startText = "Press any key to start.\n\nDuring the game, press any key to jump over obstacles.\n\nHelp the father and son escape the Erlkonig!"
	love.graphics.print(startText, 50, 200, 0, 1.5, 1.5)
end

function drawPausedText()
	local title = "Oh no! You hit an obstacle!"
	love.graphics.setColor(0.5, 0.1, 0.1, 1)
	love.graphics.print(title, 50, 100, 0, 2, 2)

	love.graphics.setColor(1,1,1,1)
	local pausedText = "The Erlkonig will surely catch you now.\n\nPress any key to restart."
	love.graphics.print(pausedText, 50, 200, 0, 1.5, 1.5)
end