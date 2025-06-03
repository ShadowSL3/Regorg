
gp3 = {
    extension = {
        "mp3",
        "wav",
        "ogg"
    },
    type = {
        "stream",
        "static"
    },
    source = "",
    pitch = 1.0, 
    volume = 1.0,
}


function gp3:load(filename, type)
    local ext = filename:match("^.+%.([^.]+)$"):lower() 

    if not (ext == "mp3" or ext == "wav" or ext == "ogg") then
        error("Unsupported audio format: " .. ext)
    end 

    type = type or "static"

    self.source = love.audio.newSource(filename, type)
    self.source:setPitch(self.pitch)
    self.source:setVolume(self.volume)
end

function gp3:play()
    if self.source then
        self.source:play()
end

function gp3:setVolume(volume)
    self.volume = volume
    if self.source then
        self.source:setVolume(volume)
    end
end
function gp3:setPitch(pitch)
    self.pitch = pitch
    if self.source then 
        self.source:setPitch(pitch)
    end
end
end
return gp3