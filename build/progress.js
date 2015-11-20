var Multimeter, multimeter, utils, _;

_ = require('lodash');

Multimeter = require('multimeter');

utils = require('./utils');

multimeter = null;

exports.initialize = function(image, drives) {
  var longestLength;
  multimeter = Multimeter(process);
  multimeter.charm.reset();
  multimeter.write("Burning " + image + "\n\n");
  _.each(drives, function(drive) {
    return multimeter.write("  " + drive + ":\n");
  });
  longestLength = utils.getLongestLength(drives);
  return _.zipObject(drives, _.map(drives, function(drive, index) {
    return multimeter(4 + longestLength, 3 + index, {
      width: 35,
      before: ' [',
      after: '] ',
      solid: {
        background: null,
        foreground: 'white',
        text: '='
      },
      empty: {
        background: null,
        foreground: null,
        text: ' '
      }
    });
  }));
};

exports.updateBar = function(bars, drive, state) {
  var eta;
  if (state.percentage === 100) {
    eta = 'Done!';
  } else {
    eta = "" + state.eta + "ms";
  }
  return bars[drive].percent(state.percentage, "" + (Math.floor(state.percentage)) + "% " + eta);
};

exports.end = function() {
  var _ref;
  return multimeter != null ? (_ref = multimeter.charm) != null ? _ref.destroy() : void 0 : void 0;
};
