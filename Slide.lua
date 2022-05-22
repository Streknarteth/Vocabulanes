--[[
    GD50 2018
    Pong Remake

    -- Ball Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a ball which will bounce back and forth between paddles
    and walls until it passes a left or right boundary of the screen,
    scoring a point for the opponent.
]]

Slide = Class{}

function Slide:init(num_options, x, y, width, height, dy, reverse)
    self.num_options = num_options
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = dy
    self.correct = math.random(1,num_options)
    self.reverse = reverse
end

function Slide:collides(paddle)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

function Slide:reset()
    self.num_options = 2
    self.x = 0
    self.y = -self.height
    self.dy = 25
    self.correct = math.random(1,self.num_options)
    self.reverse = 0
end

function Slide:update(dt)
    self.y = self.y + self.dy * dt
end

function Slide:render(tbl, englishWord, distractors)
    
    for i = 1,self.num_options,1 do
        if (i % 2 == 0) then
            love.graphics.setColor(117/255, 142/255, 183/255, 100/255)
        else 
            love.graphics.setColor(165/255, 202/255, 210, 100/255)
        end
        
        love.graphics.rectangle('fill', self.x+(self.width/self.num_options)*(i-1), self.y, self.width/self.num_options, self.height)

        if i == self.correct then 
            if self.reverse % 2 == 0 then
                love.graphics.setColor(255/255,87/255,51/255,255/255)
            else
                love.graphics.setColor(255/255,195/255,0/255,255/255)
            end
            love.graphics.printf(tbl[englishWord], self.x+(self.width/self.num_options)*(i-1), self.y+self.height/2-8, self.width/self.num_options, 'center')
        else
            if self.reverse % 2 == 0 then
                love.graphics.setColor(255/255,87/255,51/255,255/255)
            else
                love.graphics.setColor(255/255,195/255,0/255,255/255)
            end
            love.graphics.printf(distractors[i], self.x+(self.width/self.num_options)*(i-1), self.y+self.height/2-8, self.width/self.num_options, 'center')     
        end
    end
end
