local utf8 = require('utf8')

function generateJournal(a, al, d, wg, eg, cg)
    return [[
journal = {
    age = ]]..tostring(a)..[[,
    alive = ]]..tostring(al)..[[,
    dying = ]]..tostring(d)..[[,
    waterGoal = ]]..tostring(wg)..[[,
    exerciseGoal = ]]..tostring(eg)..[[,
    calorieGoal = ]]..tostring(cg)..'\n}'
end

function love.load()
    label = "Today's Calories:\n"
    text = ''
    step = 0
    love.window.setMode(1152, 768) --window dimensions
    background = love.graphics.newImage('graphics/background.png') --background
    --sun = love.graphics.newImage('graphics/sun.png') --sun
    cloud1x = -450
    cloud1 = love.graphics.newImage('graphics/cloud1.png') --cloud1
    cloud2x = -300
    cloud2 = love.graphics.newImage('graphics/cloud2.png') --cloud2
    frame = love.graphics.newImage('graphics/frame.png') --frame
    if io.open('journal.lua') == nil then
        local file = io.open('journal.lua', 'w')
        io.output(file)
        io.write(generateJournal(0, true, false, 100, 30, 2000))
        io.close(file)
        newMode = true
    end
    require 'journal'
end

function love.textinput(t)
    text = text .. t
end

function love.keypressed(key)
    if key == 'backspace' then
        local offset = utf8.offset(text, -1)
        if offset then
            text = string.sub(text, 1, offset - 1)
        end
    end

    if key == 'return' and newMode and step == 2 then
        local file = io.open('journal.lua', 'w')
        io.output(file)
        io.write(generateJournal(0, true, false, journal.waterGoal, journal.exerciseGoal, journal.calorieGoal))
        io.close(file)
        newMode = false
    end

    if key == 'return' then
        text = ''
        step = (step + 1)%3
    end

    if key == 'return' and not newMode then
        if step == 0 then
            label = "Today's Calories:\n"
        end
        if step == 1 then
            label = "Today's Water Intake (fl. oz.):\n"
        end
        if step == 2 then
            label = "Today's Exercise (minutes):\n"
        end
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1) --default white
    love.graphics.draw(background) --background
    --love.graphics.draw(sun)--sun rotates
    love.graphics.draw(cloud1, cloud1x, 130) --cloud1
    love.graphics.draw(cloud2, cloud2x, 250) --cloud1
    cloud1x = cloud1x + .3 --cloud1 speed
    cloud2x = cloud2x + .5 --cloud2 speed
    if (cloud1x > 800) then --resets clouds to the beginning
        cloud1x = -260 
    end
    if (cloud2x > 1000) then
        cloud2x = -260
    end
    love.graphics.draw(frame, 125, 150) --frame
    love.graphics.setColor(1, 1, 237/255) --color side bar
    love.graphics.rectangle('fill', 768, 0, 384, 768) --side bar rectangle
    love.graphics.setColor(0, 0, 0) --text color
    if newMode then
        if step == 0 then
            love.graphics.printf('Enter Daily Calorie Goal:\n' .. text, 768, 0, 384)
            journal.calorieGoal = text
        end
        if step == 1 then
            love.graphics.printf('Enter Daily Water Goal (in fluid ounces):\n' .. text, 768, 0, 384)
            journal.waterGoal = text
        end
        if step == 2 then
            love.graphics.printf('Enter Daily Exercise Goal (in minutes):\n' .. text, 768, 0, 384)
            journal.exerciseGoal = text
        end
        return
    end
    love.graphics.printf(label .. text, 768, 0, 384)
end
