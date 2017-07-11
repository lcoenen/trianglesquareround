_w = require 'when'
express = require 'express'

fs = require 'fs'

#
#	Main class of the server
#	
class Server
	#	Initalise the server
	constructor: ->
		console.log 'New server'
		@app = express()
		@app.use express.static 'client/'
	start: ->
		console.log 'Serving localhost:8080'
		@app.listen(8080)
		
			

server = new Server
server.start()
