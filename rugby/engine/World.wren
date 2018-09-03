/*
	a world containing entities
*/
class World {
	
	/* GETTERs */
	static world {__world}

	camera   {_camera  }
	entities {_entities}

	[number] {_players[number]}

	/* SETTERs */


	/* CONSTRUCTORs */
	construct new (camera, nb_players) {
		__world   = this   // singleton
		_camera   = camera // render the world
		_entities = []     // list of entities
		_players  = []     // up to 4 players

		// setup players
		for (i in 0...nb_players) _players.add(Player.new(i))
	}

	/* METHODs */

	// update the world
	update () {
		// update each entity and each player input
		for (entity in _entities) entity.update()
		for (player in _players ) player.update()
	}

	// draw the world
	draw () {
		// build an array to define the draw order
		var ents = Util.sortDecreasing(_entities)

		// draw the shadows and then the sprites
		for (entity in ents) entity.drawShadow()
		for (entity in ents) entity.drawSprite()
	}

	
	// add and remove entities from the world
	add (entity) {_entities.add(entity)}

	remove (entity) {
		for (i in 0..._entities.count) {
			if (_entities[i] == entity) {
				_entities.removeAt(i)
				return this
			}
		}
	}

	clear () {_entities.clear()}

	// project position to the ground
	projectToGround (position) {
		// ground is at height 0
		var p = position.clone()
		p.y = 0
		return p
	}
}

