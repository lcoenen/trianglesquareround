map = 
	spawns: 
		w: [
				x:65
				y:65
			,
				x: 65
				y: 275
			, 
				x: 65
				y: 505]
	blockers:
		[
				#	Bordure gauche
				ul: 
					x:0
					y:0
				br:
					x: 25
					y: 600
			,
				#	Bordure bas
				ul: 
					x:30
					y:575
				br:
					x: 1200
					y: 600
			,
				#	Bordure haut
				ul: 
					x:-5
					y:0
				br:
					x:1200
					y:30
			,
				#	Bordure droite
				ul: 
					x:1175
					y:0
				br:
					x:1200
					y:600
			,
				#	Piece A - haut gauche, bas gauche, haut droite, bas droite
				ul:
					x: 30
					y: 135
				br:
					x: 85
					y: 190
			,
				ul:
					x: 30
					y: 410
				br:
					x: 85
					y: 465
			,
				ul:
					x: 1115
					y: 135
				br:
					x: 1175
					y: 190
			,
				ul:
					x: 1115
					y: 410
				br:
					x: 1175
					y: 460
			,
				#	Piece B - haut gauche
				ul: 
					x:145
					y:30
				br:
					x:200
					y:240
			,
				ul: 
					x:200
					y:30
				br:
					x:230
					y:165
			,		
				ul:
					x: 230
					y: 30
				br:
					x: 290
					y: 110
			,
				ul:
					x: 290
					y: 30
				br:
					x: 335
					y: 155
			,
				#	Piece B - haut droite
				ul:
					x: 860
					y: 30
				br:
					x: 910
					y: 155
			,
				ul:
					x: 910
					y: 30
				br:
					x: 970
					y: 100
			,
				ul:
					x: 975
					y: 30
				br:
					x: 1055
					y: 160
			,
				ul:
					x: 1000
					y: 160
				br:
					x: 1055
					y: 240
			,

				# 	Piece B - bas gauche
				ul: 
					x:145
					y:360
				br:
					x:200
					y:575
			,		
				ul:
					x: 200
					y: 430
				br:
					x: 225
					y: 575
			,
				ul:
					x: 228
					y: 500
				br:
					x: 286
					y: 472
			,				
				ul:
					x: 290
					y: 440
				br:
					x: 340
					y: 573
				#	Piece B - bas droite
			,
				ul:
					x: 855
					y: 435
				br:
					x: 910
					y: 546
			,
				ul:
					x: 915
					y: 495
				br:
					x: 970
					y: 545
			,
				ul:
					x: 975
					y: 440
				br:
					x: 1055
					y: 570
			,
				ul:
					x: 1000
					y: 350
				br:
					x: 1055
					y: 440


				#	Piece C - gauche et droite
			,
				ul:
					x: 296
					y: 255
				br:
					x: 395
					y: 345
			,
				ul:
					x: 810
					y: 250
				br:
					x: 900
					y: 345
				
				#	Piece D - haut
			,
				ul:
					x: 490
					y: 30
				br:
					x: 515
					y: 80
			,
				ul:
					x: 515
					y: 80
				br:
					x: 540
					y: 135
			,
				ul:
					x: 545
					y: 135
				br:
					x: 570
					y: 190
			,
				ul:
					x: 570
					y: 190
				br:
					x: 630
					y: 240
			,
				ul:
					x: 630
					y: 135
				br:
					x: 655
					y: 190
			,
				ul:
					x: 655
					y: 90
				br:
					x: 685
					y: 135
			,
				ul:
					x: 655
					y: 90
				br:
					x: 685
					y: 135
			,
				ul:
					x: 680
					y: 30
				br:
					x: 715
					y: 80
					
				#	Piece D (bas)
			,
				ul:
					x: 575
					y: 365
				br:
					x: 625
					y: 570
			,
				ul:
					x: 545
					y: 410
				br:
					x: 655
					y: 465
			,
				ul:
					x: 520
					y: 465
				br:
					x: 685
					y: 515
			,
				ul:
					x: 490
					y: 520
				br:
					x: 710
					y: 570
		]
				

module.exports = map

