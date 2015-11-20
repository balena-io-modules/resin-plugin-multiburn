_ = require('lodash')
Multimeter = require('multimeter')
utils = require('./utils')

multimeter = null

exports.initialize = (image, drives) ->
	multimeter = Multimeter(process)
	multimeter.charm.reset()
	multimeter.write("Burning #{image}\n\n")

	_.each drives, (drive) ->
		multimeter.write("  #{drive}:\n")

	longestLength = utils.getLongestLength(drives)

	return _.zipObject drives, _.map drives, (drive, index) ->
		return multimeter 4 + longestLength, 3 + index,
			width: 35
			before: ' ['
			after: '] '
			solid:
				background: null
				foreground: 'white'
				text: '='
			empty:
				background: null
				foreground: null
				text: ' '

exports.updateBar = (bars, drive, state) ->
	if state.percentage is 100
		eta = 'Done!'
	else
		eta = "#{state.eta}ms"

	bars[drive].percent(state.percentage, "#{Math.floor(state.percentage)}% #{eta}")

exports.end = ->
	multimeter?.charm?.destroy()
