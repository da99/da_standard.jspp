/* jshint strict: true, undef: true */
/* globals be, is_enumerable, is_function, eachs */

function each_x(coll, f) {
  "use strict";

  be(is_enumerable, coll);
  be(is_function, f);

  return eachs(coll, function (_i, x) {
    return f(x);
  });

}
