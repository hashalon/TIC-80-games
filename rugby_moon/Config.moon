-- CONFIG --
-- define the size of the screen
SCREEN =
	width:  240
	height: 136

-- define the properties of the entities of the game
PROPS =
	gravity: -0.3 -- gravity force
	speed:    0.1 -- speed of characters
	jump:     0.6 -- jump force of the characters
	ground:   0   -- ground level
	mass:     0.1 -- mass of the character

-- define the colors used
COLORS =
	sky:    13 -- color of the sky
	sun:    14 -- color of the sun
	green1:  5 -- first  color of the green
	green2: 11 -- second color of the green

-- additional properties
RUGBY =
	drop:        20 -- height where the ball is dropped
	speedFactor:  2 -- how faster should the ball move
	catchDist:   10 -- how far can we catch the ball

-- manage the display
DISPLAY = 
	-- how much margin are we putting when we display the field
	tilt:        5   -- how much will the height be visible
	shadow:     -1.7 -- how far down is the shadow of the entity
	widthDepth: 60   -- how many pixel the field will occupy on the screen
	topPad:     20   -- top margin
	bottomPad:  30   -- bottom margin
	-- stripes on the field
	n_stripes:   9 -- number of stripes to display on the field
	stripeBack: 16 -- width of the stripes in the background
	stripeFore: 32 -- width of the stripes in the foreground
	-- sprites of the characters
	spritesRed:  {16, 18} -- sprites used by team red
	spritesBlue: {48, 50} -- sprites used by team blue
	charWidth:    2  -- width  of the sprite
	charHeight:   2  -- height of the sprite
	charBg:      14  -- background of the sprite
	charShad:     3  -- the shadow of the character
	-- sprites of the ball
	spritesBall:  {1} -- sprites used by the ball
	ballSize:      1  -- size of the sprite of the ball
	ballBg:        0  -- background of the sprite
	ballShad:      2  -- the shadow of the ball

-- END CONFIG --


