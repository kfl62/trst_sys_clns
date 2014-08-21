(function() {
  define(function() {
    $.extend(true, Clns, {
      desk: {
        consumption: {
          consumptionCalculate: function() {
            var i, vf, vt, vtval;
            vf = $('tr.consumption-freight');
            vt = $('tr.consumption-freight-total');
            i = 0;
            vtval = 0;
            vf.each(function() {
              var $row;
              $row = $(this);
              $row.find('input').each(function() {
                var $input;
                $input = $(this);
                return $input.attr('name', $input.attr('name').replace(/\d/, i));
              });
              $row.find('span').each(function() {
                var $span;
                $span = $(this);
                if ($span.hasClass('val')) {
                  return vtval += parseFloat($span.text());
                }
              });
              return i += 1;
            });
            vt.find('span.val').text(vtval.toFixed(2));
          },
          freightInsert: function() {
            var i, id_date, r, v;
            r = Clns.desk.consumption.freightCalculate().result;
            v = Clns.desk.consumption.template.clone().removeClass('template');
            i = $('tr.consumption-freight').length;
            id_date = $('input#date_send').val();
            v.find('span.name').text(r.name);
            v.find('input.freight_id').val(r.freight_id);
            v.find('input.id_stats').val(r.id_stats);
            v.find('input.id_date').val($('input#date_send').val());
            v.find('input.id_intern').val($('input#id_intern').val());
            v.find('input.um').val(r.um);
            v.find('span.um').text(r.um);
            v.find('input.pu').val(r.pu);
            v.find('span.pu').text(r.pu.toFixed(4));
            v.find('span.stk.qu').text(r.qus.toFixed(2));
            v.find('input.qu').val(r.qu);
            v.find('span.out.qu').text(r.qu.toFixed(2));
            v.find('input.val').val(r.sval);
            v.find('span.val').text(r.sval.toFixed(2));
            $('tr.consumption-freight-header, tr.consumption-freight-total').removeClass('hidden');
            $('tr.consumption-freight-total').before(v);
            Clns.desk.consumption.buttons($('span.button'));
            Clns.desk.consumption.consumptionCalculate();
          },
          freightCalculate: function() {
            var $qus, $val, fid, idd, ids, name, pu, qu, qus, um, v;
            v = $('.add-freight');
            name = v.filter('.name').data('name');
            ids = v.filter('.name').data('id_stats');
            idd = v.filter('.name').data('id_date');
            fid = v.filter('.name').data('freight_id');
            qus = parseFloat(v.filter('.name').data('qu'));
            um = v.filter('.um').text();
            pu = parseFloat(v.filter('.pu').decFixed(4).text());
            qu = parseFloat(v.filter('input.qu').decFixed(2).val());
            if (qus - qu >= 0) {
              $val = (pu * qu).round(2);
              $qus = (qus - qu).round(2);
              v.filter('.val').text($val.toFixed(2));
              v.filter('span.qu').text((qus - qu).toFixed(2));
              return {
                result: {
                  freight_id: fid,
                  name: name,
                  id_stats: ids,
                  um: um,
                  pu: pu,
                  qu: qu,
                  qus: $qus,
                  sval: $val
                }
              };
            } else {
              alert(Trst.i18n.msg.consumption_negative_stock).replace(/%\{um\}/g, um).replace('%{stck}', qus.toFixed(2)).replace('%{res}', (qu - qus).toFixed(2));
              return $('.focus').focus().select();
            }
          },
          validate: {
            create: function() {
              if ($('input[name*="text"]').val() !== '') {
                if ($('tr.consumption-freight').length === 0) {
                  $('button[data-action="save"]').button('option', 'disabled', true);
                } else {
                  $('button[data-action="save"]').button('option', 'disabled', false);
                }
                return true;
              }
            }
          },
          selects: function(slcts) {
            return slcts.each(function() {
              var $id, $id_stats, $sd, $select;
              $select = $(this);
              $sd = $select.data();
              $id = $select.attr('id');
              if ($select.hasClass('clns freight')) {
                $id_stats = $('select.clns.freight.oid option:selected').data('id_stats') || '00000000';
                return $select.on('change', function() {
                  var $oid, $url, c0, c1, c2;
                  if (Clns.desk.consumption.validate.create()) {
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
                    if ($select.hasClass('oid')) {
                      $id_stats = $('select.clns.freight.oid option:selected').data('id_stats') || '00000000';
                      if ($('select.clns.freight.oid option:selected').val() !== 'null') {
                        $oid = $('select.clns.freight.oid option:selected').val();
                      }
                    } else {
                      $id_stats = c0 + c1 + c2 + "00";
                    }
                    $url = "/sys/partial/clns/shared/_doc_add_freight_stock?id_stats=" + $id_stats;
                    if ($oid) {
                      $url += "&oid=" + $oid;
                    }
                    return $('td.add-freight-container').load($url, function() {
                      Clns.desk.consumption.selects($('select.clns.freight'));
                      if ($id_stats.slice(-2) !== '00') {
                        $('span.button.flri').removeClass('hidden');
                        Clns.desk.consumption.buttons($('span.button'));
                        return $('.focus').focus().select();
                      }
                    });
                  } else {
                    alert(Trst.i18n.msg.consumption_not_complete);
                    $('button[data-action="save"]').button('option', 'disabled', true);
                    $url = "/sys/partial/clns/shared/_doc_add_freight_stock?id_stats=00000000";
                    return $('td.add-freight-container').load($url, function() {
                      return Clns.desk.consumption.selects($('select.clns.freight'));
                    });
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
                if (!Clns.desk.consumption.validate.create()) {
                  if ($bd.action === 'save') {
                    $button.button('option', 'disabled', true);
                  }
                }
                if ($button.hasClass('icon-refresh')) {
                  $button.off('click');
                  $button.on('click', function() {
                    return Clns.desk.consumption.freightCalculate();
                  });
                }
                if ($button.hasClass('icon-plus-sign')) {
                  $button.off('click');
                  $button.on('click', function() {
                    var $url;
                    Clns.desk.consumption.freightInsert();
                    $url = "/sys/partial/clns/shared/_doc_add_freight_stock?id_stats=00000000";
                    return $('td.add-freight-container').load($url, function() {
                      return Clns.desk.consumption.selects($('select.clns.freight'));
                    });
                  });
                }
                if ($button.hasClass('icon-minus-sign')) {
                  $button.off('click');
                  $button.on('click', function() {
                    $button.parentsUntil('tbody').last().remove();
                    Clns.desk.consumption.consumptionCalculate();
                    if ($('tr.consumption-freight').length === 0) {
                      $('tr.consumption-freight-header, tr.consumption-freight-total').addClass('hidden');
                      return $('button[data-action="save"]').button('option', 'disabled', true);
                    }
                  });
                }
              } else if (Trst.desk.hdo.dialog === 'show') {
                if ($bd.action === 'print') {
                  $button.on('click', function() {
                    Trst.msgShow(Trst.i18n.msg.report.start);
                    $.fileDownload("/sys/clns/consumption/print?id=" + Trst.desk.hdo.oid, {
                      successCallback: function() {
                        return Trst.msgHide();
                      },
                      failCallback: function() {
                        Trst.msgHide();
                        return Trst.desk.downloadError(Trst.desk.hdo.model_name);
                      }
                    });
                  });
                  return;
                }
              } else {

                /*
                Buttons default handler Trst.desk.buttons
                 */
              }
            });
          },
          init: function() {
            var min, now, _ref;
            if ($('#date_show').length) {
              now = new Date();
              min = Trst.lst.admin === 'true' ? new Date(now.getFullYear(), now.getMonth() - 1, 1) : min = new Date(now.getFullYear(), now.getMonth(), 1);
              $('#date_show').datepicker('option', 'maxDate', '+0');
              $('#date_show').datepicker('option', 'minDate', min);
            }
            Clns.desk.consumption.buttons($('button'));
            Clns.desk.consumption.selects($('select.clns,input.select2,input.repair'));
            Clns.desk.consumption.template = (_ref = $('tr.template')) != null ? _ref.remove() : void 0;
            return $log('Clns.desk.consumption.init() OK...');
          }
        }
      }
    });
    return Clns.desk.consumption;
  });

}).call(this);
