(function() {
  define(function() {
    $.extend(true, Clns, {
      desk: {
        freight: {
          createFreightName: function() {
            var $name;
            Clns.desk.freight.selects($('select.clns.freight'));
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
          inputs: function(inpts) {
            inpts.each(function() {
              var $id, $input, $sd;
              $input = $(this);
              $sd = $input.data();
              $id = $input.attr('id');
            });
          },
          selects: function(slcts) {
            slcts.each(function() {
              var $dialog, $id, $sd, $select;
              $select = $(this);
              $sd = $select.data();
              $id = $select.attr('id');
              if ($select.hasClass('clns') && $select.hasClass('freight')) {
                $dialog = Trst.desk.hdo.dialog;
                $select.on('change', function() {
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
                  if ($dialog === 'query') {
                    $url = "sys/partial/clns/freight/_select_freight_c?id_stats=" + $id_stats;
                    $('span.select-freight-c').load($url, function() {
                      Clns.desk.freight.selects($('select.clns.freight'));
                      Clns.desk.freight.buttons($('button'));
                    });
                  } else {
                    $url = "sys/clns/freight/" + $dialog + "?id_stats=" + $id_stats;
                    Trst.lst.setItem('url', $url);
                    Trst.desk.init($url);
                  }
                });
              }
              if ($select.hasClass('param')) {
                $select.on('change', function() {
                  Clns.desk.freight.buttons($('button'));
                });
              }
              if ($select.hasClass('day')) {
                $select.on('change', function() {
                  var $params, $url;
                  $params = jQuery.param($('.param, .fid').serializeArray());
                  $url = "sys/partial/clns/freight/_data_freight?" + $params;
                  Trst.msgShow();
                  $('.data-freight').load($url, function() {
                    Clns.desk.freight.selects($('select.param.day'));
                    Trst.msgHide();
                  });
                });
              }
              if ($select.hasClass('uid')) {
                $select.on('change', function() {
                  var $params, $url;
                  $params = jQuery.param($('.param').serializeArray());
                  $url = "sys/clns/freight/query?" + $params;
                  Trst.desk.init($url);
                });
              }
            });
          },
          buttons: function(btns) {
            btns.each(function() {
              var $bd, $button, $id, $params, $url, _ref;
              $button = $(this);
              $bd = $button.data();
              $id = $button.attr('id');
              if ($button.hasClass('query-firm')) {
                $params = jQuery.param($('.param').serializeArray());
                $url = "sys/partial/clns/freight/_data_firm?" + $params;
                $button.unbind();
                $button.on('click', function() {
                  Trst.msgShow();
                  $('.data-firm').load($url, function() {
                    Clns.desk.freight.buttons($('span.link'));
                    Trst.msgHide();
                  });
                });
              }
              if ($button.hasClass('query-unit')) {
                $params = jQuery.param($('.param').serializeArray());
                $url = "sys/partial/clns/freight/_data_unit?" + $params;
                $button.unbind();
                $button.on('click', function() {
                  Trst.msgShow();
                  $('.data-unit').load($url, function() {
                    Clns.desk.freight.buttons($('span.link'));
                    Trst.msgHide();
                  });
                });
              }
              if ($button.hasClass('query-freight')) {
                $params = jQuery.param($('.param').serializeArray());
                $url = "sys/clns/freight/query?" + $params;
                $button.unbind();
                $button.on('click', function() {
                  Trst.desk.init($url);
                });
              }
              if ($button.hasClass('uid')) {
                $params = jQuery.param($('.param').serializeArray());
                $url = "sys/clns/freight/query?" + $params + "&uid=" + $id;
                $button.on('click', function() {
                  Trst.desk.init($url);
                });
              }
              if ($button.hasClass('fid')) {
                $params = jQuery.param($('.param').serializeArray());
                $url = "sys/clns/freight/query?" + $params + "&fid=" + $id;
                $button.on('click', function() {
                  Trst.desk.init($url);
                });
              }
              if (Trst.desk.hdo.dialog === 'filter') {
                $('button[data-action="create"]').data().url = (_ref = Trst.lst.url) != null ? _ref.replace('filter', 'create') : void 0;
                Trst.lst.removeItem('url');
              }
            });
          },
          init: function() {
            if (Trst.desk.hdo.dialog === 'create') {
              Clns.desk.freight.createFreightName();
            }
            Clns.desk.freight.buttons($('button, span.link'));
            Clns.desk.freight.selects($('select'));
            return $log('Clns.desk.freight.init() OK...');
          }
        }
      }
    });
    return Clns.desk.freight;
  });

}).call(this);
