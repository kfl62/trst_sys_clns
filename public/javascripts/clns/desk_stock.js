(function() {
  define(function() {
    $.extend(true, Clns, {
      desk: {
        stock: {
          calculate: function() {},
          inputs: function(inpts) {
            inpts.each(function() {
              var $ind, $input;
              $input = $(this);
              $ind = $input.data();
            });
          },
          selects: function(slcts) {
            slcts.each(function() {
              var $sd, $select;
              $select = $(this);
              $sd = $select.data();
            });
          },
          buttons: function(btns) {
            btns.each(function() {
              var $bd, $button, _ref;
              $button = $(this);
              $bd = $button.data();
              if (Trst.desk.hdo.dialog === 'filter') {
                if ((_ref = $bd.action) === 'create' || _ref === 'show' || _ref === 'edit' || _ref === 'delete') {
                  $bd.r_path = 'sys/clns/stock/filter';
                }
              }
            });
          },
          init: function() {
            Clns.desk.stock.buttons($('button'));
            return $log('Clns.desk.stock.init() OK...');
          }
        }
      }
    });
    return Clns.desk.stock;
  });

}).call(this);
