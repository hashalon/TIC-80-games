-- PICO-8 wrapper

-- in PICO-8, math functions are not stored into a table
-- so we recreate this math table for convenience
math =
    pi: 3.1415926535897932384626433832795

    max: max
    min: min

    floor: flr
    ceil:  ceil

    sin:(a)-> sin( a / math.pi * 2)
    cos:(a)-> cos(-a / math.pi * 2)
    atan2: atan2

    sqrt: sqrt
    abs:  abs

    deg:(a)-> a * 180 / math.pi
    rad:(a)-> a * math.pi / 180

MIN = -32768
MAX =  32767.99999


class Input
    new:(num)=>
        @player = num
        @jumpTimer = 0
        @deltaTime = 1/60

    -- PICO-8 use btn and btnp for inputs
    -- btn button_index, player_index
    -- 0: left
    -- 1: right
    -- 2: up
    -- 3: down
    -- 4: button 1
    -- 5: button 2
    move:=>
        m = 0
        m -= 1 if btn 0, @player
        m += 1 if btn 1, @player
        m

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
