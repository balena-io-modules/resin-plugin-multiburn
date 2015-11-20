_ = require('lodash')

exports.getLongestLength = (lines) ->
	return _.max _.map lines, (line) ->
		return line.length
