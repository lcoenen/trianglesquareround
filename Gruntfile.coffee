module.exports = (grunt) ->
	
	grunt.initConfig
		coffeeify: 
			build:
				cwd: 'client/coffee'
				src: [ '*.coffee' ]
				dest: 'client/js' 
		shell:
			doc: 'codo client/coffee/*.coffee server/coffee/*.coffee'
			clean:	'rm client/js/* || rm doc/* -fr || 1'
			serve:	'coffee server/coffee/server.coffee'
	
	grunt.loadNpmTasks 'grunt-contrib-coffeeify'
	grunt.loadNpmTasks 'grunt-shell'
	
	grunt.registerTask('default', ['coffeeify', 'shell:serve'])
	grunt.registerTask('doc', ['shell:doc'])
	grunt.registerTask('clean', ['shell:clean'])
	grunt.registerTask('serve', ['shell:serve'])
	
	
