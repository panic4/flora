local utf8 = require('utf8')

function generateJournal(a, s, al, d, wg, eg, cg)
    local file = io.open('journal.lua', 'w')
        io.output(file)
        io.write([[
journal = {
    age = ]]..tostring(a)..[[,
    streak = ]]..tostring(s)..[[,
    alive = ]]..tostring(al)..[[,
    dying = ]]..tostring(d)..[[,
    waterGoal = ]]..tostring(wg)..[[,
    exerciseGoal = ]]..tostring(eg)..[[,
    calorieGoal = ]]..tostring(cg)..'\n}')
    io.close(file)
end

function love.load()
    label = "Today's Calories:\n"
    text = ''
    step = 0
    goals = 0
    love.graphics.setNewFont('Monocraft.ttf', 32)
    love.window.setMode(1152, 768) --window dimensions
    background = love.graphics.newImage('graphics/background.png') --background
    sun = love.graphics.newImage('graphics/sun.png') --sun
    cloud1x = -450
    cloud1 = love.graphics.newImage('graphics/cloud1.png') --cloud1
    cloud2x = -300
    cloud2 = love.graphics.newImage('graphics/cloud2.png') --cloud2
    if io.open('journal.lua') == nil then
        generateJournal(0, 0, true, false, 100, 30, 2000)
        newMode = true
    end
    require 'journal'
    plantTexture = 'graphics/'..tostring(journal.age%4)..'.png'
            if journal.dying then
                plantTexture = 'graphics/dying/'..tostring(journal.age%4)..'.png'
            end
            if not journal.alive then
                plantTexture = 'graphics/dead.png'
            end
    plant = love.graphics.newImage(plantTexture)
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

    if key == 'return' and newMode then
        text=''
        if step == 2 then
            generateJournal(0, 0, true, false, journal.waterGoal, journal.exerciseGoal, journal.calorieGoal)
            saved = true
        end
    end

    if key == 'return' then
        step = (step + 1)%3
    end

    if key == 'return' and not newMode then
        if step == 0 then
            if tonumber(text) > journal.exerciseGoal then goals = goals + 1 end
            if goals == 3 then
                journal.age = journal.age + 1
            end
            if goals == 0 and journal.dying then
                journal.alive = false
            end
            if goals == 0 then
                journal.dying = true
            end
            label = "Come Back Tomorrow!\n"
            saved = true
            text = ''
            plantTexture = 'graphics/'..tostring(journal.age%4)..'.png'
            if journal.dying then
                plantTexture = 'graphics/dying/'..tostring(journal.age%4)..'.png'
            end
            if not journal.alive then
                plantTexture = 'graphics/dead.png'
            end
            plant = love.graphics.newImage(plantTexture)
            generateJournal(journal.age, journal.streak+1, journal.alive, journal.dying, journal.waterGoal, journal.exerciseGoal, journal.calorieGoal)
        end
        if step == 1 then
            if tonumber(text) > journal.calorieGoal then goals = goals + 1 end
            label = "Today's Water Intake (fl. oz.):\n"
            text = ''
        end
        if step == 2 then
            if tonumber(text) > journal.waterGoal then goals = goals + 1 end
            label = "Today's Exercise (minutes):\n"
            text = ''
        end
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1) --default white
    love.graphics.draw(background) --background
    love.graphics.draw(sun)--sun rotates
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
    love.graphics.draw(plant, 125, 150)
    love.graphics.setColor(1, 1, 237/255) --color side bar
    love.graphics.rectangle('fill', 768, 0, 384, 768) --side bar rectangle
    love.graphics.setColor(0, 0, 0) --text color
    if newMode and saved then
        love.graphics.printf('Check back tomorrow!\n' .. text, 768, 0, 384, 'center')
        text = ''
        return
    end
    if newMode then
        if step == 0 then
            love.graphics.printf('Enter Daily Calorie Goal:\n' .. text, 768, 0, 384, 'center')
            journal.calorieGoal = text
        end
        if step == 1 then
            love.graphics.printf('Enter Daily Water Goal (in fluid ounces):\n' .. text, 768, 2, 384, 'center')
            journal.waterGoal = text
        end
        if step == 2 then
            love.graphics.printf('Enter Daily Exercise Goal (in minutes):\n' .. text, 768, 2, 384, 'center')
            journal.exerciseGoal = text
        end
        return
    end
    if saved then love.graphics.printf('Saved!', 786, 393, 384, 'center') end
    love.graphics.printf(label .. text, 768, 2, 384, 'center')
    love.graphics.printf('Daily Calorie Goal: ' ..tostring(journal.calorieGoal)..' cal', 786, 512, 384, 'center')
    love.graphics.printf('Daily Water Goal: ' ..tostring(journal.waterGoal)..' fl. oz.', 786, 586, 384, 'center')
    love.graphics.printf('Daily Exercise Goal: ' ..tostring(journal.exerciseGoal)..' minutes', 786, 660, 384, 'center')
    love.graphics.printf('Streak: ' ..tostring(journal.streak)..' day(s)!', 786, 734, 384, 'center')
end