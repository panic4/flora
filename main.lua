function love.load()
    label = "Today's Calories:"
    text = '2000'
    love.window.setMode(1152, 768) --window dimensions
    background = love.graphics.newImage('graphics/background.png') --background
    cloud1 = love.graphics.newImage('graphics/cloud2.png')
    frame = love.graphics.newImage('graphics/frame.png') --sapling
    
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
    love.graphics.rectangle('fill', 768, 0, 640, 768)
    love.graphics.draw(background) --background
    love.graphics.draw(cloud1, 0, 0, 0, 1, 1)
    love.graphics.draw(frame, 125, 150) --frame
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(label .. text, 768, 0, 384)
end
