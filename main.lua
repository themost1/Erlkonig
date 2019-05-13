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
	trees = {}
	treeSpawned = false

	lastRockSpawn = 0
	startHorseX = 200
	horseX = startHorseX
	elfX = -170

	singer = ""
	theEnd = false
	ai = false

	jostle = 0

	starNum = 0
end

function setUpImages()
	moon = love.graphics.newImage("graphics/moon.png")
	darkMoon = love.graphics.newImage("graphics/darkMoon.png")
	tree = love.graphics.newImage("graphics/tree.png")
	boy = love.graphics.newImage("graphics/boy.png")
	father = love.graphics.newImage("graphics/father.png")
	elf = love.graphics.newImage("graphics/elfFrontCrown.png")
	crown = love.graphics.newImage("graphics/crown.png")
	spotlight = love.graphics.newImage("graphics/spotlight.png")
	mountains = love.graphics.newImage("graphics/mountains.png")
	hills = love.graphics.newImage("graphics/hills.png")
	star = love.graphics.newImage("graphics/star.png")

	horseImages = {}

	hillLocs = {}
	for i = 0, 100 do
		hillLocs[i+1] = -50 + (hills:getWidth()-65) * i
	end

	mountainLocs = {}
	for i = 0, 50 do
		mountainLocs[i+1] = -50 + (mountains:getWidth() - 65) * i
	end

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

		if key == "a" then
			ai = true
		end
		return
	elseif paused then
		song:play()
		setUpGame()
		paused = false
		if key == "a" then
			ai = true
		end
		return
	end

	if (height == 0) and not ai then
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

	singer = ""
	if timeElapsed >= 21 and timeElapsed <= 48 then
		singer = "narrator"
	elseif timeElapsed >= 54 and timeElapsed <= 61 then
		singer = "father"
	elseif timeElapsed >= 62 and timeElapsed <= 75 then
		singer = "boy"
	elseif timeElapsed >= 77 and timeElapsed <= 83 then
		singer = "father"
	elseif timeElapsed >= 86 and timeElapsed <= 109 then
		singer = "elf"
	elseif timeElapsed >= 110 and timeElapsed <= 120 then
		singer = "boy"
	elseif timeElapsed >= 121 and timeElapsed <= 129 then
		singer = "father"
	elseif timeElapsed >= 131 and timeElapsed <= 146 then
		singer = "elf"
	elseif timeElapsed >= 147 and timeElapsed <= 159 then
		singer = "boy"
	elseif timeElapsed >= 160 and timeElapsed <= 170 then
		singer = "father"
	elseif timeElapsed >= 176 and timeElapsed <= 186 then
		singer = "elf"
	elseif timeElapsed >= 187 and timeElapsed <= 198 then
		singer = "boy"
	elseif timeElapsed >= 200 and timeElapsed <= 235 then
		singer = "narrator"
	end

	--[[starNum = 0
	if singer == "elf" or singer == "narrator" then
		local timeInt = timeElapsed - timeElapsed % 0.25
		timeInt = timeInt * 8
		if timeInt % 200 == 0 then
			starNum = 1
		elseif timeInt % 312 == 0 then
			starNum = 2
		elseif timeInt % 418 == 0 then
			starNum = 3
		end
	end]]
	starNum = 3

	if timeElapsed >= 121 and not treeSpawned then
		trees[1] = 1000
		treeSpawned = true
	end

	if timeElapsed > 235 then
		theEnd = true
	end
	if timeElapsed > 237 then
		paused = true
	end

	if (not started) or paused then
		return
	end

	handleJump(dt)

	timeElapsed = timeElapsed + dt

	jostle = (timeElapsed % 1)/16
	jostle = 0.03 - jostle
	jostle = math.abs(jostle)
	jostle = jostle * 300

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

		if math.abs(horseCenter - rockCenter) < 100 then
			if ai and height==0 then
				jumpTime = 0
				return
			end
		end

		if math.abs(horseCenter - rockCenter) < 70 then
			if height < rocks[i].height then
				paused = true
				song:stop()
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
	horseX = startHorseX - (startHorseX) * timeElapsed/240 * 1.25

	for i = 1, #rocks do
		rocks[i].x = rocks[i].x - 250*dt
	end

	for i = 1, #hillLocs do
		hillLocs[i] = hillLocs[i] - 100 * dt
	end

	for i = 1, #mountainLocs do
		mountainLocs[i] = mountainLocs[i] - 50 * dt
	end

	for i = 1, #trees do
		trees[i] = trees[i] - 250 * dt
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
	local thisMoon = moon
	if singer ~= "narrator" then
		love.graphics.setColor(0.3, 0.3, 0.3)
		thisMoon = darkMoon
	end
	love.graphics.draw(thisMoon, 50, 105, 0, 2.5, 2.5, 0, 32)

	love.graphics.setColor(0.1, 0.1, 0.1)
	love.graphics.draw(star, 700, 50, 0.2, 0.05, 0.05, 0, 32)
	love.graphics.draw(star, 400, 200, 0.4, 0.05, 0.05, 0, 32)
	love.graphics.draw(star, 200, 110, 0.8, 0.05, 0.05, 0, 32)

	love.graphics.setColor(0.1, 0.1, 0.1)
	for i = 1, #mountainLocs do
		love.graphics.draw(mountains, mountainLocs[i], -200, 0, 1, 1, 0, 32)
	end
	love.graphics.setColor(0.15, 0.15, 0.15)
	for i = 1, #hillLocs do
		love.graphics.draw(hills, hillLocs[i], 100, 0, 1, 1, 0, 32)
	end

	--[[if (singer == "narrator") then
		love.graphics.setColor(0.8, 0.8, 0.2, 1)
		love.graphics.draw(spotlight, horseX-170, 70, 0, 1, 1, 0, 32)
		love.graphics.setColor(1,1,1)
	end]]

	love.graphics.setColor(0.2, 0.24, 0.2)
	for i = 1, #trees do
		love.graphics.draw(tree, trees[i], 355, 0, 0.25, 0.25, 0, 32)
	end


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

	if singer == "father" then
		love.graphics.setColor(0.9, 0.9, 0.5)
	else
		love.graphics.setColor(0.5, 0.5, 0.5)
	end
	love.graphics.draw(father, horseX+50, love.graphics.getHeight()-195-height + jostle, 0, 0.17, 0.17, 0, 32)
	love.graphics.setColor(1,1,1)

	if not theEnd then

		if singer == "elf" then
			love.graphics.setColor(0.8, 0.8, 0.3)
		else
			love.graphics.setColor(0.4, 0.4, 0.4)
		end
		love.graphics.draw(elf, elfX, love.graphics.getHeight()-450, 0.4, 0.5, 0.5, 0, 32)
		--love.graphics.draw(crown, elfX+220, love.graphics.getHeight()-400, 0.2, 0.07, 0.07, 0, 32)
		love.graphics.setColor(1,1,1,1)
	end

	if singer == "boy" then
		love.graphics.setColor(0.9, 0.9, 0.5)
	else
		love.graphics.setColor(0.5, 0.5, 0.5)
	end
	if theEnd then
		love.graphics.setColor(0.7, 0.3, 0.3)
	end
	love.graphics.draw(boy, horseX+30, love.graphics.getHeight()-175-height + jostle, 0, 0.25, 0.25, 0, 32)
	love.graphics.setColor(1,1,1)


end

function drawStartText()
	local title = "ERLKONIG: A Game Based on a Lied Based on a Poem"
	love.graphics.setColor(0.1, 0.4, 0.1, 1)
	love.graphics.print(title, 50, 100, 0, 2, 2)

	love.graphics.setColor(1,1,1,1)
	local startText = "Press a to run the AI, or any other key to play yourself.\n\nWhen playing without AI, press any key to jump over obstacles.\n\nHelp the father and son escape the Erlkonig!"
	love.graphics.print(startText, 50, 200, 0, 1.5, 1.5)
end

function drawPausedText()
	local title = ""
	if not theEnd then
		title = "Oh no! You hit an obstacle!"
	else
		title = "The Erlkonig killed the boy!"
	end
	love.graphics.setColor(0.5, 0.1, 0.1, 1)
	love.graphics.print(title, 50, 100, 0, 2, 2)

	love.graphics.setColor(1,1,1,1)
	local pausedText = ""
	if not theEnd then
		pausedText = "The Erlkonig will surely catch you now.\n\nPress a to start the AI, or any other key to restart."
	else
		pausedText = "You won the game, despite losing the boy.\n\nPress any key to play again; the 'a' key will start the AI."
	end
	love.graphics.print(pausedText, 50, 190, 0, 1.5, 1.5)
end