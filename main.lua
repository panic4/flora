function love.load()
    love.window.setMode(1152, 768) --window dimensions
    love.graphics.setBackgroundColor(114/255, 159/255, 207/255) --sets background to sky blue
end

function love.draw()
    love.graphics.setColor(1, 1, 1) --default white
    love.graphics.rectangle('fill', 768, 0, 640, 768)
    love.graphics.setColor(175/255, 1, 175/255) --green grass
    love.graphics.rectangle('fill', 0, 512, 768, 256)
end
