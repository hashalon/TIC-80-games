-- TIC-80 wrapper

class Input
    new:(num)=>
        @pad = num * 8
        @jumpTimer = 0
        @deltaTime = 1/60

    -- TIC-80 use btn and btnp for inputs
    -- btn button_index
    -- 0: up
    -- 1: down
    -- 2: left
    -- 3: right
    -- 4: button 1
    -- 5: button 2
    -- 6: button 3
    -- 7: button 4
    move:=>
        m = 0
        m -= 1 if btn @pad + 2
        m += 1 if btn @pad + 3
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
