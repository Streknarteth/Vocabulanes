--[[
    Vocabulary game: Vocabulanes

    -- Main Program --

    Author: Eric Bertschy

    
]]

-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
push = require 'push'

-- the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

-- our Paddle class, which stores position and dimensions for each Paddle
-- and the logic for rendering them
require 'Paddle'

-- our Slide class, which isn't much different than a Paddle structure-wise
-- but which will mechanically function very differently
require 'Slide'

require 'Obstacle'
-- size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size we're trying to emulate with push
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243
FONT_HEIGHT = 16

-- player movement speed
PADDLE_SPEED = 200

TRANSLATION_TBL = {
    ["week"] = "vecka",
    ["year"] = "år",
    ["today"] = "idag",
    ["tomorrow"] ="imorgon",
    ["yesterday"] = "igår",
    ["calendar"] = "Kalender",
    ["second"] = "sekund",
    ["hour"] = "timme",
    ["minute"] = "minut",
    ["clock"] = "klocka",
    ["one hour"] = "en timme",
    ["can"] = "kan",
    ["use"] = "använda",
    ["do"] = "göra",
    ["go"] = "gå",
    ["come"] = "komma",
    ["laugh"] = "skratta",
    ["yes"] = "ja",
    ["no"] = "nej",
    ["good"] = "bra",
    ["hello"] = "hej",
    ["morning"] = "morgan",
    ["night"] = "natt",
    ["please"] = "snalla",
    ["goodbye"] = "hej da",
    ["please"] = "snalla du",
    ["train"] = "taget",
    ["bus"] = "bussen",
    ["tram"] = "sparvagn",
    ["train station"] = "Tagstationen",
    ["my"] = "mitt",
    ["restrooms"] = "toalett",
    ["men"] = "herrar",
    ["women"] = "damer",
    ["open"] = "oppen",
    ["closed"] = "stangd",
    ["cheers"] = "skal",
    ["chill"] = "tagga ned",
    ["I"] = "jag",
    ["his"] = "hans",
    ["that"] = "att",
    ["as"] = "som",
    ["he"] = "han",
    ["was"] = "var",
    ["on"] = "på",
    ["with"] = "med",
    ["they"] = "de",
    ["be"] = "vara",
    ["at"] = "vid",
    ["one"] = "ett",
    ["have"] = "ha",
    ["this"] = "detta",
    ["from"] = "från",
    ["by"] = "genom",
    ["hot"] = "het",
    ["word"] = "ord"
}

englishWord = ""

OBSTACLE_TBL = {}

--[[
    Called just once at the beginning of the game; used to set up
    game objects, variables, etc. and prepare the game world.
]]

function love.load()
    -- set love's default filter to "nearest-neighbor", which essentially
    -- means there will be no filtering of pixels (blurriness), which is
    -- important for a nice crisp, 2D look
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- set the title of our application window
    love.window.setTitle('Vocabulanes')

    -- seed the RNG so that calls to random are always random
    math.randomseed(os.time())

    -- initialize our nice-looking retro text fonts
    smallFont = love.graphics.newFont('ARLRDBD.ttf', 8, 'normal', 2)
    largeFont = love.graphics.newFont('ARLRDBD.ttf', 16, 'normal', 2)
    scoreFont = love.graphics.newFont('ARLRDBD.ttf', 32, 'normal', 2)
    love.graphics.setFont(smallFont)

    -- set up our sound effects; later, we can just index this table and
    -- call each entry's `play` method
    sounds = {
        ['correct'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['death'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['speed_up'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }
    
    -- initialize our virtual resolution, which will be rendered within our
    -- actual window no matter its dimensions
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true,
        canvas = false
    })

    -- initialize our player paddles; make them global so that they can be
    -- detected by other functions and modules
    player1 = Paddle(10, VIRTUAL_HEIGHT-70, 10, 10)

    -- place a ball in the middle of the screen
    slide = Slide(2, 0, -60, VIRTUAL_WIDTH, 60)

    -- initialize score variables
    player1Score = 0

    -- the state of our game; can be any of the following:
    -- 1. 'start' (the beginning of the game, before first slide)
    -- 2. 'play' (the slide is in play, bouncing between paddles)
    -- 3. 'done' (the game is over, with a victor, ready for restart)
    gameState = 'start'
end

--[[
    Called whenever we change the dimensions of our window, as by dragging
    out its bottom corner, for example. In this case, we only need to worry
    about calling out to `push` to handle the resizing. Takes in a `w` and
    `h` variable representing width and height, respectively.
]]
function love.resize(w, h)
    push:resize(w, h)
end

--[[
    Called every frame, passing in `dt` since the last frame. `dt`
    is short for `deltaTime` and is measured in seconds. Multiplying
    this by any changes we wish to make in our game will allow our
    game to perform consistently across all hardware; otherwise, any
    changes we make will be applied as fast as possible and will vary
    across system hardware.
]]

function randomkey(tbl)
    choice = "F"
    n = 0
    for i, o in pairs(tbl) do
        n = n + 1
        if math.random() < (1/n) then 
            choice = i
        end
    end
    return choice
end

function distractors(tbl, englishWord)
    n = 0
    temptbl = {}
    temptbl2 = {}
    
    for k, v in pairs(tbl) do
        if k ~= englishWord then
            n = n + 1
            temptbl[n] = v
        end
    end
    for i = 1,slide.num_options,1 do
        randval = math.random(1,#temptbl)
        temptbl2[i] = table.remove(temptbl,randval)
    end
    return temptbl2
end

function love.update(dt)
    if gameState == 'start' then
        englishWord = randomkey(TRANSLATION_TBL)
        swedishWords = distractors(TRANSLATION_TBL,englishWord)
    end
    if gameState == 'play' then
        if player1Score == 0 then
            slide.dy = 25
        end
        if slide:collides(player1) then
            if slide.x+(slide.width/slide.num_options)*(slide.correct-1) < player1.x+player1.width/2 and
            slide.x+(slide.width/slide.num_options)*(slide.correct) > player1.x+player1.width/2 then
                player1Score = player1Score + 1
                if player1Score % 3 == 0 and #OBSTACLE_TBL < 6 then
                    OBSTACLE_TBL[player1Score/3] = Obstacle(math.min(60,math.max(20,math.random(10,#OBSTACLE_TBL*15))), math.min(60,math.max(20,math.random(10,#OBSTACLE_TBL*15))), math.random(30,slide.dy))
                end
                if player1Score % 5 == 0 and slide.num_options < 5 then
                    FONT_HEIGHT = FONT_HEIGHT - 2
                    largeFont = love.graphics.newFont('ARLRDBD.ttf', FONT_HEIGHT, 'normal', 2)
                    slide = Slide(slide.num_options+1, 0, -60, VIRTUAL_WIDTH, 60, math.min(80, slide.dy*1.05))
                else
                    slide = Slide(slide.num_options, 0, -60, VIRTUAL_WIDTH, 60, math.min(80, slide.dy*1.05))
                end
                sounds['correct']:play()
                englishWord = randomkey(TRANSLATION_TBL)
                swedishWords = distractors(TRANSLATION_TBL,englishWord)
            else
                sounds['death']:play()
                gameState = 'death'
                for i = 1, #OBSTACLE_TBL,1 do
                    OBSTACLE_TBL[i]:reset()
                end
                OBSTACLE_TBL = {}
                slide:reset()
                FONT_HEIGHT = 16
            end
        end
        for i = 1, #OBSTACLE_TBL,1 do
            if OBSTACLE_TBL[i].x < 0 or OBSTACLE_TBL[i].x > VIRTUAL_WIDTH-OBSTACLE_TBL[i].width or OBSTACLE_TBL[i].y > VIRTUAL_HEIGHT then
                OBSTACLE_TBL[i]:reset()
                OBSTACLE_TBL[i].width = math.min(60,math.max(20,math.random(10,#OBSTACLE_TBL*15)))
                OBSTACLE_TBL[i].width = math.min(60,math.max(20,math.random(10,#OBSTACLE_TBL*15)))
            end
            if OBSTACLE_TBL[i]:collides(player1) then
                sounds['death']:play()
                gameState = 'death'
                slide:reset()
                for i = 1, #OBSTACLE_TBL,1 do
                    OBSTACLE_TBL[i]:reset()
                end
                OBSTACLE_TBL = {}
                FONT_HEIGHT = 16
                break
            end
        end
        if player1Score == 100 then
            gameState = 'done'
            slide:reset()
            for i = 1, #OBSTACLE_TBL,1 do
                OBSTACLE_TBL[i]:reset()
            end
            OBSTACLE_TBL = {}
            FONT_HEIGHT = 16
        end
    end

    --
    -- paddles can move no matter what state we're in
    --
    -- player 1
    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        player1.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        player1.dx = PADDLE_SPEED
    else
        player1.dx = 0
    end

    if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') or love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    -- update our ball based on its DX and DY only if we're in play state;
    -- scale the velocity by dt so movement is framerate-independent
    if gameState == 'play' then
        slide:update(dt)
        for i = 1, #OBSTACLE_TBL,1 do
            OBSTACLE_TBL[i]:update(dt)
        end
    end

    player1:update(dt)
end

--[[
    A callback that processes key strokes as they happen, just the once.
    Does not account for keys that are held down, which is handled by a
    separate function (`love.keyboard.isDown`). Useful for when we want
    things to happen right away, just once, like when we want to quit.
]]
function love.keypressed(key)
    -- `key` will be whatever key this callback detected as pressed
    if key == 'escape' then
        -- the function LÖVE2D uses to quit the application
        love.event.quit()
    elseif key == 'space' then
        gameState = 'start'
        slide:reset()
        -- reset scores to 0
        player1Score = 0

    elseif key == 'enter' or key == 'return' then
        if gameState == 'done' or gameState == 'death' or gameState == 'start' then
            englishWord = randomkey(TRANSLATION_TBL)
            swedishWords = distractors(TRANSLATION_TBL,englishWord)
            gameState = 'play'
            -- reset scores to 0
            player1Score = 0
        end
    end
end

--[[
    Called each frame after update; is responsible simply for
    drawing all of our game objects and more to the screen.
]]
function love.draw()
    -- begin drawing with push, in our virtual resolution
    push:start()

    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    
    -- render different things depending on which part of the game we're in
    if gameState == 'start' then
        -- UI messages
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Vocabulanes!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press space to return to this menu at any time.', 0, 50, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        love.graphics.setFont(scoreFont)
        love.graphics.printf(englishWord, 0, VIRTUAL_HEIGHT-50, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'death' then
        love.graphics.setFont(scoreFont)
        love.graphics.setColor(255/255, 0, 0, 255/255)
        love.graphics.printf(englishWord, 0, VIRTUAL_HEIGHT/2-40, VIRTUAL_WIDTH, 'center')
        love.graphics.printf(TRANSLATION_TBL[englishWord], 0, VIRTUAL_HEIGHT/2+10, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to begin!', 0, VIRTUAL_HEIGHT-30, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'done' then
        -- UI messages
        love.graphics.setFont(largeFont)
        love.graphics.printf('You win!',0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
    end

    -- show the score before ball is rendered so it can move over the text
    displayScore()
    
    player1:render()

    love.graphics.setFont(largeFont)
    slide:render(TRANSLATION_TBL, englishWord, swedishWords)

    if gameState == 'play' then
        for i = 1, #OBSTACLE_TBL,1 do
            OBSTACLE_TBL[i]:render()
        end
    end

    -- end our drawing to push
    push:finish()
end
--[[
    Renders the current score.
]]
function displayScore()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print('Score: ' .. tostring(player1Score), 10, 10)
    love.graphics.setColor(255, 255, 255, 255)
end
