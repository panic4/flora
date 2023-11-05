local utf8 = require('utf8')

function love.load()
    label = "Today's Calories:"
    text = '2000'
    love.window.setMode(1152, 768) --window dimensions
    background = love.graphics.newImage('graphics/background.png') --background
    sun = love.graphics.newImage('graphics/sun.png') --sun
    cloud1x = -450
    cloud1 = love.graphics.newImage('graphics/cloud1.png') --cloud1
    cloud2x = -300
    cloud2 = love.graphics.newImage('graphics/cloud2.png') --cloud2
    frame = love.graphics.newImage('graphics/frame.png') --frame
    
end

function love.textinput(t)
    text = text .. t
end

function love.keypressed(key)
    if key == "backspace" then
        -- get the byte offset to the last UTF-8 character in the string.
        local offset = utf8.offset(text, -1)

        if offset then
            -- remove the last UTF-8 character.
            -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
            text = string.sub(text, 1, offset - 1)
        end
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1) --default white
    love.graphics.draw(background) --background
    love.graphics.draw(sun)--sun rotates
    love.graphics.draw(cloud1, cloud1x, 130) --cloud1
    love.graphics.draw(cloud2, cloud2x, 250) --cloud1
    cloud1x = cloud1x + .25 --cloud1 speed
    cloud2x = cloud2x + .5 --cloud2 speed
    if (cloud1x > 800) then --resets clouds to the beginning
        cloud1x = -260 
    end
    if (cloud2x > 1000) then
        cloud2x = -260
    end
    love.graphics.draw(frame, 125, 150) --frame
    love.graphics.setColor(255/255, 255/255, 237/255) --color side bar
    love.graphics.rectangle('fill', 768, 0, 384, 768) --side bar rectangle
    love.graphics.setColor(0, 0, 0) --text color
    love.graphics.printf(label .. text, 768, 0, 384)
    
end
