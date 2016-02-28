/* jshint strict: true, undef: true */
/* globals _, to_string */


function find_key(k, _args) {
  "use strict";

  var args = _.toArray(arguments);
  args.shift();
  var o = _.detect(args, function (x) { return x.hasOwnProperty(k); });

  if (!o)
    throw new Error('Key, ' + to_string(k) + ', not found in any: ' + to_string(args));

  return o[k];
}
