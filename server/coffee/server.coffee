_w = require 'when'
express = require 'express'

fs = require 'fs'

port = process.env.PORT || 3000;

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
		console.log 'Serving localhost:', port 
		@app.listen(port)

server = new Server
server.start()
