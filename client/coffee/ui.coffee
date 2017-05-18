Game = require './game.coffee'

header_resize = (big) ->
	if !big
		$('#header').animate
				width: 350 
				height: 40
			, 1000
	else 
		$('#header').animate
				width: 628 
				height: 78
			, 1000

endofgame = (winner) ->
	header_resize true
	$('#winner_team').html winner
	$('#winner_pic').attr 'src', "img/#{winner}winner.png"
	$('#gamecanvas').hide 'pulsate', 500
	$('#endofgame').show 'slide', 1000
	delete @game
	

startlocalgame = =>
	
	console.log @
	
	@game.respawn()
	
	header_resize false	
	$('#gamecanvas').show 'pulsate', 500
	$('#home').hide()
	$('#endofgame').hide()

menu = =>
	$('#endofgame').hide()
	$('#gamecanvas').hide()
	$('#learn_howto').hide()
	$('#home').show 'scale', 1000

learn_howto = =>
	$('#home').hide 'scale', 1000
	$('#learn_howto').show 'puff', 1000

$(=>
	
	@game = new Game()
	@game.start (winner) => endofgame winner
	
	$('.comeback').click => menu()
	$('.again').click => startlocalgame()
	$('.play_net').button disabled: true

	$('div.learn_howto').click => learn_howto()

	$('div.button').button()
	$('div.play_local').click => startlocalgame()
	
	$('#endofgame').hide()
	$('#gamecanvas').hide()
	$('#learn_howto').hide() 
	
#	menu()
		
)		
