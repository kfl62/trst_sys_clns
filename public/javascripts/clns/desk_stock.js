(function() {
  define(function() {
    $.extend(true, Clns, {
      desk: {
        stock: {
          init: function() {
            $('.focus').focus();
            return $log('Clns.desk.stock.init() OK...');
          }
        }
      }
    });
    return Clns.desk.stock;
  });

}).call(this);
