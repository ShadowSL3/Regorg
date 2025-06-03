local pixelcam = {}

local function new(factor)
	factor = factor or 1
	local canvas = love.graphics.newCanvas(love.graphics.getWidth()/factor, love.graphics.getHeight()/factor, "normal", 0) -- (width, height, format, msaa)
	canvas:setFilter("nearest", "nearest")
	return setmetatable({factor = factor, canvas = canvas}, {__index = pixelcam})
end

function pixelcam:startRecording()
	love.graphics.setCanvas(self.canvas)
	love.graphics.push()
	love.graphics.scale(1/self.factor)
	love.graphics.push()
end

function pixelcam:stopRecording()
	love.graphics.setCanvas()
	love.graphics.pop()
	love.graphics.pop()
end

function pixelcam:draw()
	local blendmode = love.graphics.getBlendMode()
	love.graphics.setBlendMode("premultiplied")
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.push()
	love.graphics.origin()
	love.graphics.scale(self.factor)
	love.graphics.draw(self.canvas)
	self.canvas:clear()
	love.graphics.pop()
	love.graphics.setBlendMode(blendmode)
	love.graphics.setColor(r, g, b, a)
end

return setmetatable({new = new},
	{__call = function(_, ...) return new(...) end}) 