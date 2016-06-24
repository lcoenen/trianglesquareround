map = require './map.coffee'

RANDOM_FACTOR = 10

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
	constructor: (state, type, color, position) ->
		@type = type
		@color = color
		@state = state
		@sprite = new Kiwi.GameObjects.Sprite @state, @state.textures["#{type}_#{color}"], position.x, position.y, true
		state.addChild @sprite
		@sprite.update = (=> @update())

		@sprite.physics = @sprite.components.add new Kiwi.Components.ArcadePhysics @sprite, @sprite.box
	
		@velocity = @PER_TYPE[@type].VELOCITY + rand(-RANDOM_FACTOR, RANDOM_FACTOR)
		@acceleration = @PER_TYPE[@type].ACCELERATION + rand(-RANDOM_FACTOR / 2, RANDOM_FACTOR / 2)

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
		
	#	Update the character (called directly by Kiwi.js)
	update: ->	#	ICI POUR L'INERTIE
		old_x = @sprite.x
		old_y = @sprite.y
		
		if @state.rightKey.isDown and !@keypushed['right']
			@move.VX += @velocity; 
			@move.AX += @acceleration
		else if !@state.rightKey.isDown and @keypushed['right']
			@move.VX -= @velocity; 
			@move.AX -= @acceleration
		@keypushed['right'] = @state.rightKey.isDown
		
		if @state.leftKey.isDown and !@keypushed['left']
			@move.VX -= @velocity; 
			@move.AX -= @acceleration
		else if !@state.leftKey.isDown and @keypushed['left']
			@move.VX += @velocity; 
			@move.AX += @acceleration
		@keypushed['left'] = @state.leftKey.isDown
		
		if @state.upKey.isDown and !@keypushed['up']
			@move.VY -= @velocity; 
			@move.AY -= @acceleration
		else if !@state.upKey.isDown and @keypushed['up']
			@move.VY += @velocity; 
			@move.AY += @acceleration
		@keypushed['up'] = @state.upKey.isDown
		
		if @state.downKey.isDown and !@keypushed['down']
			@move.VY += @velocity; 
			@move.AY += @acceleration
		else if !@state.downKey.isDown and @keypushed['down']
			@move.VY -= @velocity; 
			@move.AY -= @acceleration
		@keypushed['down'] = @state.downKey.isDown
		
		@sprite.physics.acceleration = new Kiwi.Geom.Point(  @move.AX, @move.AY );
		@sprite.physics.velocity = new Kiwi.Geom.Point( @move.VX, @move.VY );
		
		#	NOTE: rétrocompatibilité, peut-être source de bug dans le futur
		@sprite.physics.update()
		
		if blocker = @detect_collision()
			@sprite.x = old_x
			@sprite.y = old_y
		console.log @detect_collision()
		
	detect_collision: ->
		
		blocker_to_rectangle = (blocker) -> 
			new Kiwi.Geom.Rectangle blocker.ul.x, blocker.ul.y, (blocker.br.x - blocker.ul.x), (blocker.br.y - blocker.ul.y)
		middle = (box) ->
			x: box.x + box.width / 2
			y: box.y + box.height / 2
		
		blockers = map.blockers

		for blocker in blockers
			circle = new Kiwi.Geom.Circle (middle @sprite.box.bounds).x, (middle @sprite.box.bounds).y, @sprite.box.bounds.width * 2/3
			if !(Kiwi.Geom.Intersect.circleToRectangle circle, blocker_to_rectangle blocker).result
				continue
			else
				return blocker
		return false
		
Character::spawn = (game) ->
	spawns = map.spawns.w
			
	spawns = shuffle spawns
	thisspawn = spawns[0]
	game.characters.push new Character game.ingame, obj_type, 'w', thisspawn for obj_type in ['tri','squ','rou']
	thisspawn = spawns[1]
	game.characters.push new Character game.ingame, obj_type, 'w', thisspawn for obj_type in ['squ','rou']
	thisspawn = spawns[2]
	game.characters.push new Character game.ingame, obj_type, 'w', thisspawn for obj_type in ['rou']
	 

module.exports = Character
