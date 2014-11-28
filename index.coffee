async = require 'async'
exec = require('child_process').exec
rimraf = require 'rimraf'
util = require 'gulp-util'

###
@function
@param {object} gulp - Instance of gulp.
@param {array} modules - List of names of modules. When you use `npm link some-module`, some-module should be in the array: ["some-module"].
###
module.exports = (gulp, modules) ->
	gulp.task 'link', (done) ->
		removeModules = (cb) ->
			modulePaths = modules.map (module) -> "./node_modules/#{module}"
			async.each modulePaths , rimraf, (err) -> cb()

		linkModules = (cb) ->
			moduleCommands = modules.map (module) -> 
				util.log "Linked: #{module}"
				"npm link #{module}"
			async.each moduleCommands, exec, (err) -> cb()

		async.series [removeModules, linkModules], (err) ->
			return gutil.log err if err?
			done()

	gulp.task 'unlink', (done) ->
		unlinkModules = (cb) ->
			moduleCommands = modules.map (module) -> 
				util.log "Unlinked: #{module}"
				"npm unlink #{module}"
			async.each moduleCommands, exec, (err) -> cb()

		installModules = (cb) ->
			exec 'npm i', cb

		async.series [unlinkModules, installModules], (err) ->
			return gutil.log err if err?
			done()