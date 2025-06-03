local Flipbook = {}
Flipbook.__index = Player

function Flipbook:new(flipbookImg, numRows, numColumns)
    local self          = setmetatable({}, Flipbook)
    self.flipbookImg    = flipbookImg
    self.numRows        = numRows
    self.numColumns     = numColumns
    return self
end

function Flipbook:constructFlipbook(flipbookImg, numRows, numColumns)
    self.flipbookImg    = flipbookImg
    self.numRows        = numRows
    self.numColumns     = numColumns

    local flipbookW, flipbookH = self.flipbookImg:getWidth(), self.flipbookImg:getHeight()
    local TileW, TileH = flipbookW/self.numRows, flipbookH/self.numColumns
    local Quads = {}
    local index = 0

    for row=0,self.numRows-1 do
        for column=0,self.numColumns-1 do
            Quads[index] = love.graphics.newQuad(column*TileW, row*TileH, TileW, TileH, flipbookW, flipbookH)
            index = index + 1
        end
    end

    return Quads
end

function Flipbook:getTileSize()
    local flipbookW, flipbookH = self.flipbookImg:getWidth(), self.flipbookImg:getHeight()
    local TileW, TileH = flipbookW/self.numRows, flipbookH/self.numColumns

    return TileW/2, TileH/2
end

return Flipbook
