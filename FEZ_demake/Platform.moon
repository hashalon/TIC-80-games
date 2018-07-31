

-- physical platform we can stand on
-- it is always horizontal so we only need the height of the platform and its bounds
-- we may also need the depth to cut it
-- (return -1 to remove self, return Platform to add it)
class Platform
    new:(u1,u2,v1,v2,depth)=>
        @u1,@u2,@v1,@v2,@depth = u1,u2,v1,v2,depth

    -- cut the platform based on the overlapping rectangle
    cut:(p)=>
        -- get rid of unimportant cases
        if     p.v1 < @v1 and p.v2 < @v1 then return
        elseif p.v1 > @v1 and p.v2 > @v1 then return
        elseif p.u1 < @u1 and p.u2 < @u1 then return
        elseif p.u1 > @u2 and p.u2 > @u2 then return


        -- if the platform is completely occluded by the rect, delete it
        if p.u1 < @u1 and @u2 < p.u2 then return -1
        -- if the platform is split in two
        elseif @u1 < p.u1 and p.u2 < @u2
            -- cut this platform and add a new one
            q = @@ p.u2,@u2,@v1,@v2,@depth
            @u2 = p.u1
            return q
        -- if only one part is occluded
        elseif  @u1 < p.u2 then @u1 = p.u2
        elseif p.u1 <  @u2 then @u2 = p.u1
