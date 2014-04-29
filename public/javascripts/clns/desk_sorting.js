(function() {
  define(function() {
    $.extend(true, Clns, {
      desk: {
        sorting: {
          calculate: function() {
            var ffi, rfi, rfqu, rfstk;
            rfqu = 0;
            ffi = $('tr.from-freight').find('input');
            rfi = $('tr.resl-freight').find('input');
            rfi.filter('.qu').each(function() {
              var v;
              v = parseFloat($(this).val());
              if (v !== 0.0) {
                rfqu += v;
                $(this).parentsUntil('tbody').last().find('input.pu').val(ffi.filter('.pu').val());
              }
            });
            rfstk = parseFloat($('select.from-freight option:selected').data('qu'));
            $('tr.from-freight').find('span.qus').text(rfqu.toFixed(2));
            ffi.filter('.qu').val(rfqu.toFixed(2));
            $('tr.total').find('span.res').text(rfqu.toFixed(2));
            $('tr.from-freight').find('span.stk').text((rfstk - rfqu).toFixed(2));
            if (rfqu === 0.0) {
              $('button[data-action="save"]').button('option', 'disabled', true);
            } else {
              $('button[data-action="save"]').button('option', 'disabled', false);
            }
          },
          selects: function(slcts) {
            slcts.each(function() {
              var $sd, $select;
              $select = $(this);
              $sd = $select.data();
              if ($select.hasClass('from-freight')) {
                $select.on('change', function() {
                  var $sod, f;
                  $sod = $select.find('option:selected').data();
                  f = $('tr.from-freight');
                  f.find('span.um').text($sod.um);
                  f.find('span.pu').text(parseFloat($sod.pu).toFixed(4));
                  f.find('span.qus').text('0.00');
                  f.find('span.stk').text(parseFloat($sod.qu).toFixed(2));
                  f.find('input').each(function() {
                    $(this).val($sod[$(this).attr('class')]);
                    if ($(this).hasClass('id_date')) {
                      $(this).val($('#date_send').val());
                    }
                  });
                  $('select.resl-freight').val('null');
                  $('tr.resl-freight').find('input').val('');
                  $('tr.resl-freight').find('input.qu').val('0.00');
                  $('button[data-action="save"]').button('option', 'disabled', true);
                  if ($select.val() === 'null') {
                    $('tbody').addClass('hidden');
                  } else {
                    $('tbody').removeClass('hidden');
                  }
                });
              }
              if ($select.hasClass('resl-freight')) {
                $select.on('change', function() {
                  var $sod;
                  $sod = $select.find('option:selected').data();
                  $select.parent().find('input').each(function() {
                    $(this).val($sod[$(this).attr('class')]);
                    if ($(this).hasClass('id_date')) {
                      $(this).val($('#date_send').val());
                    }
                  });
                  $select.parentsUntil('tbody').last().find('input.qu').val('0.00').focus().select();
                  Clns.desk.sorting.calculate();
                });
              }
            });
          },
          inputs: function(inpts) {
            inpts.each(function() {
              var $input;
              $input = $(this);
              if ($input.attr('id') === 'date_show') {
                $input.on('change', function() {
                  if (Trst.desk.hdo.dialog === 'create') {
                    return $('input[name*="id_date"]').each(function() {
                      if ($(this).val() !== '') {
                        $(this).val($('#date_send').val());
                      }
                    });
                  }
                });
                return;
              }
              if ($input.attr('name').search(/resl_freight.+qu\]/) !== -1) {
                return $input.on('change', function() {
                  if ($input.parentsUntil('tbody').last().find('option:selected').val() !== 'null') {
                    $input.decFixed(2);
                    Clns.desk.sorting.calculate();
                  } else {
                    $input.val('0.00');
                    alert('Select error!');
                  }
                });
              }
            });
          },
          buttons: function(btns) {
            btns.each(function() {
              var $bd, $button, $id;
              $button = $(this);
              $bd = $button.data();
              $id = $button.attr('id');
              if (Trst.desk.hdo.dialog === 'create') {
                if ($bd.action === 'save') {
                  $button.button('option', 'disabled', true);
                  $button.data('remove', false);
                  $button.off('click', Trst.desk.buttons.action.save);
                  $button.on('click', Clns.desk.sorting.calculate);
                  return $button.on('click', Trst.desk.buttons.action.save);
                }
              } else if (Trst.desk.hdo.dialog === 'show') {
                if ($bd.action === 'print') {
                  return $button.on('click', function() {
                    Trst.msgShow(Trst.i18n.msg.report.start);
                    $.fileDownload("/sys/clns/sorting/print?id=" + Trst.desk.hdo.oid, {
                      successCallback: function() {
                        return Trst.msgHide();
                      },
                      failCallback: function() {
                        Trst.msgHide();
                        return Trst.desk.downloadError(Trst.desk.hdo.model_name);
                      }
                    });
                    return false;
                  });
                }
              } else {

                /*
                Buttons default handler Trst.desk.buttons
                 */
              }
            });
            $('span.icon-remove-sign').each(function() {
              var $button;
              $button = $(this);
              $button.on('click', function() {
                $button.parentsUntil('tbody').last().remove();
                Clns.desk.sorting.calculate();
              });
            });
          },
          init: function() {
            var min, now;
            if ($('#date_show').length) {
              now = new Date();
              min = Trst.lst.admin === 'true' ? new Date(now.getFullYear(), now.getMonth() - 1, 1) : new Date(now.getFullYear(), now.getMonth(), 1);
              $('#date_show').datepicker('option', 'maxDate', '+0');
              $('#date_show').datepicker('option', 'minDate', min);
            }
            Clns.desk.sorting.buttons($('button'));
            Clns.desk.sorting.selects($('select'));
            Clns.desk.sorting.inputs($('input'));
            return $log('Clns.desk.sorting.init() OK...');
          }
        }
      }
    });
    return Clns.desk.sorting;
  });

}).call(this);
