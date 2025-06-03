
local tween = {}

function tween.new(duration, subject, target, easing)
    local t = {
        duration = duration,
        subject = subject,
        target = target,
        easing = tween.easing[easing or "linear"],
        time = 0,
        initial = {},
        update = function(self, dt)
            self.time = self.time + dt
            local t = math.min(1, self.time / self.duration)
            local easeT = self.easing(t)
            for k, v in pairs(self.target) do
                self.subject[k] = self.initial[k] + (v - self.initial[k]) * easeT
            end
        end
    }
    for k, v in pairs(target) do
        t.initial[k] = subject[k]
    end
    return t
end

tween.easing = {
    linear = function(t) return t end,
    inOutQuad = function(t)
        if t < 0.5 then
            return 2 * t * t
        else
            return -1 + (4 - 2 * t) * t
        end
    end
}

return tween
