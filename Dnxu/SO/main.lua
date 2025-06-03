function love.draw()
	love.graphics.printf("Hello World!", 0, 300, love.graphics.getWidth(), 'center')
	love.graphics.printf(
		string.format("Time: %f - FPS: %f\nOS: %s Ver: %d.%d.%d\nScreen: %d x %d",
			love.timer.getTime(), love.timer.getFPS(),
			love.system.getOS(), love._version_major, love._version_minor, love._version_revision,
			love.graphics.getWidth(), love.graphics.getHeight()
		), love.graphics.getWidth() - 305, 3, 300, 'right')
end