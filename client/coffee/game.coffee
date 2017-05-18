Character = require './character.coffee'

console.log 'Character:', Character

#
#	Main game class
#
class Game
	
	options:
		width: 1200
		height: 600		
	characters_names: ['tri_w', 'tri_b', 'squ_w', 'squ_b', 'squ_w', 'rou_w', 'rou_b']

	#	Initialise kiwi.js and all objects
	constructor: ->
		console.log 'New game'		
		@game = new Kiwi.Game 'gamecanvas', 'Triangle Round Square', null, @options

		@ingame = new (Kiwi.State)('ingame')

		thisgame = @

		thisgame.characters = []

		@ingame.preload = ->
			Kiwi.State::preload.call this
			@addImage 'blood', 'img/blood.png'
			@addImage 'map_top', 'img/map_top.png'
			@addImage 'map_bottom', 'img/map_bottom.png'
			(@addImage character, "img/#{character}.png") for character in thisgame.characters_names
			console.log @textures
			return

		@ingame.create = ->
			Kiwi.State::create.call this
			@map_bottom = new (Kiwi.GameObjects.StaticImage)(this, @textures['map_bottom'])
			@addChild @map_bottom
			
			Character::spawn thisgame
			
			@map_top = new (Kiwi.GameObjects.StaticImage)(this, @textures['map_top'])
			@addChild @map_top
			
			@addAudio( 'dying1', 'assets/sound/dying1.mp3' );
			
			@leftKey = @game.input.keyboard.addKey Kiwi.Input.Keycodes.LEFT
			@rightKey = @game.input.keyboard.addKey Kiwi.Input.Keycodes.RIGHT
			@upKey = @game.input.keyboard.addKey Kiwi.Input.Keycodes.UP
			@downKey = @game.input.keyboard.addKey Kiwi.Input.Keycodes.DOWN
			
			@altLeftKey = @game.input.keyboard.addKey Kiwi.Input.Keycodes.A
			@altRightKey = @game.input.keyboard.addKey Kiwi.Input.Keycodes.D
			@altUpKey = @game.input.keyboard.addKey Kiwi.Input.Keycodes.W
			@altDownKey = @game.input.keyboard.addKey Kiwi.Input.Keycodes.S

		@ingame.update = ->
			Kiwi.State::update.call this
			Character::ennemy_collision thisgame
			
	#	Respawn
	respawn: ->
		character.respawn() for character in @characters
		
	
	#	Start the game		
	start: (onquit) ->
		@game.states.addState @ingame, true
		@onquit = onquit
	
	#	Check for victory
	check_victory: ->
		black_left = [character for character in @characters when character.color is 'b' and !character.died][0].length
		white_left = [character for character in @characters when character.color is 'w' and !character.died][0].length
		
		if !black_left then	@onquit 'white'
		if !white_left then @onquit 'black'
		
		
module.exports = Game
