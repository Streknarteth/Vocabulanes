Boss = Class()

function Boss:init(x1,y1,x2,y2,x3,y3,englishWord)
    self.x1 = x1
    self.y1 = y1
    self.x2 = x2
    self.y2 = y2
    self.x3 = x3
    self.y3 = y3
    self.R = math.random()
    self.G = math.random()
    self.B = math.random()
    self.englishWord = englishWord
end


function Boss:collides(paddle)
    if paddle.y > self.y3 then
        return false
    end
    return true
end

function yCoord(x1,y1,x2,y2,x)
    m = (y2-y1)/(x2-x1)
    c = y1 - m*x1
    y = m*x+c
    return y
end


function Boss:reset()
    self.y3 = 0
    self.R = math.random()
    self.G = math.random()
    self.B = math.random()
end

function Boss:update(dt,paddle)
    self.y3 = math.max(self.y3+20*dt)
    self.x3 = (paddle.x+paddle.width/2)
end

function Boss:render()
    love.graphics.setColor(self.R,self.G,self.B,0.8)
    love.graphics.polygon('fill', self.x1,self.y1,self.x2,self.y2,self.x3,self.y3)
    love.graphics.setColor(self.B,self.R,self.G,1)
    love.graphics.setFont(largeFont)
    love.graphics.printf(self.englishWord,self.x1,self.y1+10,self.x2-self.x1,'center')
end

