Bubble = Class()

function Bubble:init(x,y,radius,dx,dy,letter)
    self.x = x
    self.y = y
    self.radius = radius
    self.dx = dx
    self.dy = dy
    self.letter = letter
    self.popped = false
    self.R = math.random()
    self.G = math.random()
    self.B = math.random()
end

function Bubble:distance(paddle)
    return (paddle.x - self.x)/(paddle.y - self.y)
end

function Bubble:pop()
    self.popped = true
    self.x = -(self.radius*2)
    self.dx = 0
end

function Bubble:collides(paddle)
    if self:distance(paddle) > (self.radius+math.sqrt(paddle.width/2+paddle.height/2)) then
        return false
    end
    if self.y - self.radius > paddle.y + paddle.height then
        return false
    end
    if self.y + self.radius < paddle.y then 
        return false
    end
    if self.x + self.radius < paddle.x then 
        return false 
    end
    if self.x-self.radius > paddle.x+paddle.width then
        return false 
    end
    return true
end

function Bubble:bounce(bubble)
    if ((bubble.x - self.x)^2+(bubble.y - self.y)^2) > (self.radius+bubble.radius)^2 then 
        return false
    end
    return true
end

function Bubble:update(dt)
    self.y = self.y + self.dy * dt
    self.x = self.x + self.dx * dt
end

function Bubble:render()
    love.graphics.setColor(self.R,self.G,self.B,1)
    love.graphics.circle('line', self.x, self.y, self.radius)
    bubbleFont = love.graphics.newFont('ARLRDBD.ttf', self.radius, 'normal', 2)
    love.graphics.setFont(bubbleFont)
    love.graphics.printf(self.letter, self.x-self.radius,self.y-(self.radius/2)-2,2*self.radius,'center')
end

