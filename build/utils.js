var _;

_ = require('lodash');

exports.getLongestLength = function(lines) {
  return _.max(_.map(lines, function(line) {
    return line.length;
  }));
};
