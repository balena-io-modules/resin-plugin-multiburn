###
The MIT License

Copyright (c) 2015 Resin.io, Inc. https://resin.io.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
###

Promise = require('bluebird')
_ = require('lodash')
drives = require('./drives')
image = require('./image')
progress = require('./progress')

module.exports =
	signature: 'multiburn <image>'
	description: 'burn image to many drives in parallel'
	help: '''
		Use this command to burn an image to multiple drives at the same time.

		Examples:

			$ resin multiburn path/to/image.img
	'''
	permission: 'user'
	root: true
	action: (params, options, done) ->
		drives.select()
			.tap (selectedDrives) ->
				if _.isEmpty(selectedDrives)
					throw new Error('No drives selected, aborting.')
			.tap (selectedDrives) ->
				console.info('Preparing drives...')
				Promise.each(selectedDrives, drives.unmount)
			.tap (selectedDrives) ->
				return image.getStream(params.image).then (imageStream) ->
					bars = progress.initialize(params.image, selectedDrives)
					return Promise.all _.map selectedDrives, (drive) ->
						return image.write(imageStream, drive, _.partial(progress.updateBar, bars))
			.each(drives.unmount)
			.then ->
				console.info('\nDone.')
				progress.end()
		.nodeify(done)
