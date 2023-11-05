function love.load()
    love.window.setMode(1152, 768) --window dimensions
    background = love.graphics.newImage('graphics/background.png') --background
    cloud1 = love.graphics.newImage('graphics/cloud2.png')
    frame = love.graphics.newImage('graphics/frame.png') --sapling
end

function love.draw()
    love.graphics.setColor(1, 1, 1) --default white
    love.graphics.rectangle('fill', 768, 0, 640, 768)
    love.graphics.draw(background) --background
    love.graphics.draw(cloud1, 0, 0, 0, 1, 1)
    love.graphics.draw(frame, 125, 150) --frame
    love.graphics.setColor(0, 0, 0) --black bar
    love.graphics.rectangle('fill', 768, 0, 10, 768)
end
