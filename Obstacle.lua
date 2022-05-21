Obstacle = Class{}

function Obstacle:init(width, height, maxspeed)
    self.x = math.random(0,VIRTUAL_WIDTH)
    self.width = width
    self.height = height
    self.y = -self.height
    self.maxspeed = maxspeed
    self.dy = math.random(10,self.maxspeed)
    self.dx = math.random(-40,40)
    self.colorR = math.random(0,255)/255
    self.colorG = math.random(0,255)/255
    self.colorB = math.random(0,255)/255
end

function Obstacle:collides(paddle)
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

function Obstacle:reset()
    self.x = math.random(0,VIRTUAL_WIDTH)
    self.y = -self.height
    self.dy = math.random(10,self.maxspeed)
    self.dx = math.random(-40,40)
    self.colorR = math.random(0,255)/255
    self.colorG = math.random(0,255)/255
    self.colorB = math.random(0,255)/255
end 

function Obstacle:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Obstacle:render()
    --love.graphics.setColor(math.random(0,255)/255, math.random(0,255)/255, math.random(0,255)/255, 255)
    love.graphics.setColor(self.colorR,self.colorG,self.colorB,250)
    --love.graphics.setColor(255/255, 0, 0, 255/255)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    love.graphics.setColor(255, 255, 255, 255)
end