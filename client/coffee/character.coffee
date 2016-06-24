map = require './map.coffee'

RANDOM_FACTOR = 10

firsttime = true

rand = (a, b) ->  Math.floor(Math.random() * (b - a)) + a  
shuffle = (arr) ->
    i = arr.length;
    if i == 0 then return false

    while --i
        j = Math.floor(Math.random() * (i+1))
        tempi = arr[i]
        tempj = arr[j]
        arr[i] = tempj
        arr[j] = tempi
    return arr

blocker_to_rectangle = (blocker) -> 
	new Kiwi.Geom.Rectangle blocker.ul.x, blocker.ul.y, (blocker.br.x - blocker.ul.x), (blocker.br.y - blocker.ul.y)
middle = (box) ->
	x: box.x + box.width / 2
	y: box.y + box.height / 2

# 	
#	Represent a character
#
class Character
	
	PER_TYPE:
		tri: 
			VELOCITY: 80
			ACCELERATION: 40
		squ:
			VELOCITY: 55
			ACCELERATION: 25
		rou:
			VELOCITY: 30
			ACCELERATION: 15
		
	
	#	Initialise the character
	constructor: (game, type, color, position) ->
		@type = type
		@color = color
		@state = game.ingame
		@game = game
		@spawn = position
		@sprite = new Kiwi.GameObjects.Sprite @state, @state.textures["#{type}_#{color}"], position.x, position.y, true
		@died = false
		
		@state.addChild @sprite
		@sprite.update = (=> @update())

		@sprite.physics = @sprite.components.add new Kiwi.Components.ArcadePhysics @sprite, @sprite.box
	
		@velocity = @PER_TYPE[@type].VELOCITY + rand(-RANDOM_FACTOR, RANDOM_FACTOR)
		@acceleration = @PER_TYPE[@type].ACCELERATION + rand(-RANDOM_FACTOR / 2, RANDOM_FACTOR / 2)
		
	#	Update the character (called directly by Kiwi.js)
	update: ->
		null
		

	#	Fight between two ennemies
	fight: (ennemy) ->
	
		if @type == 'rou' and ennemy.type == 'tri'
			@die()
		else if @type == 'rou' and ennemy.type == 'squ'
			ennemy.die()
		else if @type == 'rou' and ennemy.type == 'rou'
			if @velocity > ennemy.velocity then ennemy.die() else @die()
		else if @type == 'tri' and ennemy.type == 'tri'
			if [character for character in @game.characters when !character.died][0].length == 2
				if rand(1,2) == 1 then ennemy.die() else die()
		else if @type == 'tri' and ennemy.type == 'squ'
			if [character for character in @game.characters when character.color == 'w' and !character.died][0].length == 1
				ennemy.die()
			else
				@die()
		else if @type == 'tri' and ennemy.type == 'rou'
			ennemy.die()
		else if @type == 'squ' and ennemy.type == 'tri'
			if [character for character in @game.characters when character.color == 'b' and !character.died][0].length == 1
				@die()
			else
				ennemy.die()
		else if @type == 'squ' and ennemy.type == 'squ'
			ennemy.die()
			@die()
		else if @type == 'squ' and ennemy.type == 'rou'
			@die()
			
	die: ->
		@died = true
		@state.removeChild @, true
		@blood = new (Kiwi.GameObjects.Sprite)(@state, @state.textures['blood'], @sprite.x - 25, @sprite.y - 25)
		@state.addChild @blood
		@sprite.x = -10000
		@game.check_victory()
	
	respawn: ->
		@died = false
		@sprite.x = @spawn.x
		@sprite.y = @spawn.y
	
class PlayerCharacter extends Character
	keys :
		w:
			leftKey: 'leftKey'
			rightKey: 'rightKey'
			upKey: 'upKey'
			downKey: 'downKey'
		b:
			leftKey: 'altLeftKey'
			rightKey: 'altRightKey'
			upKey: 'altUpKey'
			downKey: 'altDownKey'
		
	constructor: (state, type, color, position) ->
		@keypushed = 
			left: false
			right: false
			up: false
			down: false
		@move = 
			VX:0
			VY:0
			AX:0
			AY:0
			
		super(state, type, color, position)
		
	update: ->
		old_x = @sprite.x
		old_y = @sprite.y
		
		keys = @keys[@color]
		
		if @state[keys.rightKey].isDown and !@keypushed['right']
			@move.VX += @velocity; 
			@move.AX += @acceleration
		else if !@state[keys.rightKey].isDown and @keypushed['right']
			@move.VX -= @velocity; 
			@move.AX -= @acceleration
		@keypushed['right'] = @state[keys.rightKey].isDown
		
		if @state[keys.leftKey].isDown and !@keypushed['left']
			@move.VX -= @velocity; 
			@move.AX -= @acceleration
		else if !@state[keys.leftKey].isDown and @keypushed['left']
			@move.VX += @velocity; 
			@move.AX += @acceleration
		@keypushed['left'] = @state[keys.leftKey].isDown
		
		if @state[keys.upKey].isDown and !@keypushed['up']
			@move.VY -= @velocity; 
			@move.AY -= @acceleration
		else if !@state[keys.upKey].isDown and @keypushed['up']
			@move.VY += @velocity; 
			@move.AY += @acceleration
		@keypushed['up'] = @state[keys.upKey].isDown
		
		if @state[keys.downKey].isDown and !@keypushed['down']
			@move.VY += @velocity; 
			@move.AY += @acceleration
		else if !@state[keys.downKey].isDown and @keypushed['down']
			@move.VY -= @velocity; 
			@move.AY -= @acceleration
		@keypushed['down'] = @state[keys.downKey].isDown
		
		@sprite.physics.acceleration = new Kiwi.Geom.Point(  @move.AX, @move.AY );
		@sprite.physics.velocity = new Kiwi.Geom.Point( @move.VX, @move.VY );
		
		#	NOTE: rétrocompatibilité, peut-être source de bug dans le futur
		@sprite.physics.update()
		
		if (colliders = @detect_collision()).length
			reinitialise_x_axis = false
			reinitialise_y_axis = false
			
			for collider in colliders
				if @sprite.x < collider.br.x and @sprite.x > collider.ul.x and @keypushed.left
					reinitialise_x_axis = true
				if (@sprite.x + @sprite.width) > collider.ul.x and (@sprite.x + @sprite.width) < collider.br.x and @keypushed.right
					reinitialise_x_axis = true
				if @sprite.y < collider.br.y and @sprite.y > collider.ul.y and @keypushed.up
					reinitialise_y_axis = true
				if (@sprite.y + @sprite.width) > collider.ul.y and (@sprite.y + @sprite.width) < collider.br.y and @keypushed.down
					reinitialise_y_axis = true
			if reinitialise_x_axis then @sprite.x = old_x
			if reinitialise_y_axis then @sprite.y = old_y
	
	#	Detect collision with the foreground
	detect_collision: ->
		
		blockers = map.blockers
		colliders = []		
		
		for blocker in blockers
			circle = new Kiwi.Geom.Circle (middle @sprite.box.bounds).x, (middle @sprite.box.bounds).y, @sprite.box.bounds.width * 2/3
			if (Kiwi.Geom.Intersect.circleToRectangle circle, blocker_to_rectangle blocker).result
				colliders.push blocker				
		return colliders
	
	#	Detect collision with the ennemy
	detect_ennemy_collision: (ennemies) ->
		for ennemy in ennemies
			mine = middle @sprite.box.bounds; his = middle ennemy.sprite.box.bounds
			if (Kiwi.Geom.Intersect.distance mine.x, mine.y, his.x, his.y) < @sprite.box.bounds.width* 2/3
				@fight ennemy
					
Character::spawn = (game) ->

	#	Our spawns
	spawns = shuffle map.spawns.w
	thisspawn = spawns[0]
	game.characters.push new PlayerCharacter game, obj_type, 'w', thisspawn for obj_type in ['tri','squ','rou']
	thisspawn = spawns[1]
	game.characters.push new PlayerCharacter game, obj_type, 'w', thisspawn for obj_type in ['squ','rou']
	thisspawn = spawns[2]
	game.characters.push new PlayerCharacter game, obj_type, 'w', thisspawn for obj_type in ['rou']
	
	#	Their spawns
	spawns = shuffle map.spawns.b
	thisspawn = spawns[0]
	game.characters.push new PlayerCharacter game, obj_type, 'b', thisspawn for obj_type in ['tri','squ','rou']
	thisspawn = spawns[1]
	game.characters.push new PlayerCharacter game, obj_type, 'b', thisspawn for obj_type in ['squ','rou']
	thisspawn = spawns[2]
	game.characters.push new PlayerCharacter game, obj_type, 'b', thisspawn for obj_type in ['rou']
	
Character::ennemy_collision = (game) ->
	ennemies = [character for character in game.characters when character.color is 'b'][0]
	allies = [character for character in game.characters when character.color is 'w'][0]
	allie.detect_ennemy_collision(ennemies) for allie in allies


module.exports = Character
