(function() {
  define(function() {
    $.extend(true, Clns, {
      desk: {
        freight: {
          handleFreight: function($dialog) {
            if ($dialog == null) {
              $dialog = 'filter';
            }
            return $('select.clns.freight').each(function() {
              var $select;
              $select = $(this);
              return $select.on('change', function() {
                var $id_stats, $url, c0, c1, c2;
                if ($select.hasClass('c0')) {
                  c0 = $select.val();
                  c1 = "00";
                  c2 = "00";
                  $('select.clns.freight.c1').val(c1);
                  $('select.clns.freight.c2').val(c2);
                }
                if ($select.hasClass('c1')) {
                  c0 = $('select.clns.freight.c0').val();
                  c1 = $select.val();
                  c2 = "00";
                  $('select.clns.freight.c2').val(c2);
                }
                if ($select.hasClass('c2')) {
                  c0 = $('select.clns.freight.c0').val();
                  c1 = $('select.clns.freight.c1').val();
                  c2 = $select.val();
                }
                $id_stats = c0 + c1 + c2 + "00";
                $url = "sys/clns/freight/" + $dialog + "?id_stats=" + $id_stats;
                Trst.lst.setItem('url', $url);
                return Trst.desk.init($url);
              });
            });
          },
          handleIdStats: function() {
            var $name;
            Clns.desk.freight.handleFreight('create');
            $name = "Material";
            $('select.clns.freight').each(function() {
              var $select;
              $select = $(this);
              if ($select.val() !== "00") {
                return $name = $select.find(":selected").text();
              }
            });
            return $('input[name="\[clns\/freight\]\[name\]"]').val($name + ' - ');
          },
          init: function() {
            var _ref;
            if (Trst.desk.hdo.dialog === 'filter') {
              $('button[data-action="create"]').data().url = (_ref = Trst.lst.url) != null ? _ref.replace('filter', 'create') : void 0;
              Trst.lst.removeItem('url');
              Clns.desk.freight.handleFreight();
            }
            if (Trst.desk.hdo.dialog === 'create') {
              Clns.desk.freight.handleIdStats();
            }
            return $log('Clns.desk.freight.init() OK...');
          }
        }
      }
    });
    return Clns.desk.freight;
  });

}).call(this);
