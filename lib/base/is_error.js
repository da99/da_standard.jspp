/* jshint strict: true, undef: true */
/* globals spec, to_string, is_something */
/* globals exports */

spec(is_error, [new Error('anything')], true);
spec(is_error, ['anything'],            false);

exports.is_error = is_error;
function is_error(v) {
  "use strict";

  return is_something(v) && v.constructor === Error;
}