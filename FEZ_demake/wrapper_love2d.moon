-- Löve 2D wrapper

-- allow multiple methods to get inputs...
-- https://love2d.org/wiki/love.keyboard
-- https://love2d.org/wiki/love.joystick

-- input check for love2d will be way more complex
class Input
    new:(num)=>
        @num = num
        @jumpTimer = 0
        @deltaTime = 1/60

    -- löve2d supports both keyboard and gamepad inputs
    move:=>
        return nil

    -- allow jumping just before touching the ground
    jump:=>
        if  @jumpTimer > 0
            @jumpTimer = 0
            return true
        false

    -- called every frame to update timers
    update:=>
        -- check if user is pressing jump button
        if  @jumpTimer > 0
            @jumpTimer -= @deltaTime
        if btnp @pad + 4
            @jumpTimer = 0.2
