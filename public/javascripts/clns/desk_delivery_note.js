(function() {
  define(function() {
    $.extend(true, Clns, {
      desk: {
        delivery_note: {
          dlnCalculate: function() {
            var i, vf, vt, vtval;
            vf = $('tr.dln-freight');
            vt = $('tr.dln-freight-total');
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
            r = Clns.desk.delivery_note.freightCalculate().result;
            v = Clns.desk.delivery_note.template.clone().removeClass('template');
            i = $('tr.dln-freight').length;
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
            v.find('input.pu_invoice').val(r.pu_invoice);
            v.find('input.val_invoice').val(r.val_invoice);
            $('tr.dln-freight-header, tr.dln-freight-total').removeClass('hidden');
            $('tr.dln-freight-total').before(v);
            Clns.desk.delivery_note.buttons($('span.button'));
            Clns.desk.delivery_note.dlnCalculate();
          },
          freightCalculate: function() {
            var $pu_invoice, $qus, $val, $val_invoice, fid, idd, ids, name, pu, qu, qus, um, v;
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
              $pu_invoice = v.filter('.pu_inv').prop('checked') ? 1.0 : 0.0;
              $val_invoice = v.filter('.pu_inv').prop('checked') ? 1.0 : 0.0;
              return {
                result: {
                  freight_id: fid,
                  name: name,
                  id_stats: ids,
                  um: um,
                  pu: pu,
                  qu: qu,
                  qus: $qus,
                  sval: $val,
                  pu_invoice: $pu_invoice,
                  val_invoice: $val_invoice
                }
              };
            } else {
              alert(Trst.i18n.msg.delivery_note_negative_stock).replace(/%\{um\}/g, um).replace('%{stck}', qus.toFixed(2)).replace('%{res}', (qu - qus).toFixed(2));
              return $('.focus').focus().select();
            }
          },
          validate: {
            filter: function() {
              var $url;
              if ($('#client_id').val() !== '' && $('#client_d_id').val() !== 'new') {
                $url = Trst.desk.hdf.attr('action');
                $url += "?client_id=" + ($('#client_id').val());
                if ($('#client_d_id').val() !== '' && $('#client_d_id').val() !== 'new') {
                  $url += "&client_d_id=" + ($('#client_d_id').val());
                }
                $('button.dln').data('url', $url);
                $('button.dln').button('option', 'disabled', false);
              } else {
                $('button.dln').button('option', 'disabled', true);
              }
            },
            create: function() {
              if ($('input[name*="doc_name"]').val() !== '' && $('input[name*="doc_plat"]').val() !== '') {
                if ($('tr.dln-freight').length === 0) {
                  $('button[data-action="save"]').button('option', 'disabled', true);
                } else {
                  $('button[data-action="save"]').button('option', 'disabled', false);
                }
                $('span.icon-plus-sign').show();
                return true;
              } else if ($('input[name*="doc_name"]').val() === '' && $('input[name*="doc_plat"]').val() !== '') {
                $('input[name*="doc_name"]').val("" + ($('input.id_intern').val().split('_')[1]) + "-" + ($('input.id_intern').val().split('-')[1]));
                return Clns.desk.delivery_note.validate.create();
              }
            }
          },
          selects: function(slcts) {
            slcts.each(function() {
              var $id, $id_stats, $ph, $sd, $select;
              $select = $(this);
              $sd = $select.data();
              $id = $select.attr('id');
              if ($select.hasClass('clns freight')) {
                $id_stats = $('select.clns.freight.oid option:selected').data('id_stats') || '00000000';
                $select.on('change', function() {
                  var $oid, $pu_inv, $url, c0, c1, c2;
                  if (Clns.desk.delivery_note.validate.create()) {
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
                    $pu_inv = $('input.add-freight.pu_inv').length ? $('input.add-freight.pu_inv').prop('checked') : false;
                    $url = "/sys/partial/clns/shared/_doc_add_freight_stock?id_stats=" + $id_stats;
                    if ($oid) {
                      $url += "&oid=" + $oid;
                    }
                    $url += "&pu_inv=" + $pu_inv;
                    return $('td.add-freight-container').load($url, function() {
                      Clns.desk.delivery_note.selects($('select.clns.freight'));
                      if ($id_stats.slice(-2) !== '00') {
                        $('span.button.flri').removeClass('hidden');
                        Clns.desk.delivery_note.buttons($('span.button'));
                        return $('.focus').focus().select();
                      }
                    });
                  } else {
                    alert(Trst.i18n.msg.delivery_note_not_complete);
                    $('button[data-action="save"]').button('option', 'disabled', true);
                    $url = "/sys/partial/clns/shared/_doc_add_freight_stock?id_stats=00000000";
                    return $('td.add-freight-container').load($url, function() {
                      return Clns.desk.delivery_note.selects($('select.clns.freight'));
                    });
                  }
                });
              } else if ($select.hasClass('select2')) {
                if ($id === 'client_id' || $id === 'transp_id') {
                  $ph = Trst.i18n.select[Trst.desk.hdo.js_ext][$sd.ph];
                  $select.select2({
                    placeholder: $ph,
                    minimumInputLength: $sd.minlength,
                    allowClear: true,
                    ajax: {
                      url: "/utils/search/" + $sd.search,
                      dataType: 'json',
                      quietMillis: 100,
                      data: function(term) {
                        return {
                          w: $id.split('_')[0],
                          q: term
                        };
                      },
                      results: function(data) {
                        return {
                          results: data
                        };
                      }
                    }
                  });
                  $select.unbind();
                  $select.on('change', function() {
                    var $dlg, $dlgph, $dlgsd;
                    if ($select.select2('data')) {
                      $select.next().select2('data', null);
                      $select.next().select2('destroy');
                      $dlg = $select.next();
                      $dlgsd = $dlg.data();
                      $dlgph = Trst.i18n.select[Trst.desk.hdo.js_ext][$dlgsd.ph];
                      $dlg.select2({
                        placeholder: $dlgph,
                        minimumInputLength: $dlgsd.minlength,
                        allowClear: true,
                        ajax: {
                          url: "/utils/search/" + $sd.search,
                          dataType: 'json',
                          data: function(term) {
                            return {
                              id: $select.select2('val')
                            };
                          },
                          results: function(data) {
                            return {
                              results: data
                            };
                          }
                        }
                      });
                      $dlg.unbind();
                      $dlg.on('change', function() {
                        var $dlgadd;
                        if ($dlg.select2('data')) {
                          if ($dlg.select2('data').id === 'new') {
                            $dlgadd = $dlg.next();
                            $dlgadd.data('url', '/sys/clns/partner_firm/person');
                            $dlgadd.data('r_id', $select.select2('val'));
                            $dlgadd.data('r_mdl', 'firm');
                            $dlgadd.show();
                          } else {
                            $dlg.next().hide();
                          }
                        } else {
                          $dlg.next().hide();
                        }
                        return Clns.desk.delivery_note.validate.filter();
                      });
                    } else {
                      $select.next().select2('data', null);
                      $select.next().select2('destroy');
                      $select.next().next().hide();
                    }
                    return Clns.desk.delivery_note.validate.filter();
                  });
                }
              } else if ($select.hasClass('repair')) {
                $ph = Trst.i18n.select[Trst.desk.hdo.js_ext][$sd.ph];
                $select.select2({
                  placeholder: $ph,
                  allowClear: true,
                  quietMillis: 1000,
                  ajax: {
                    url: "/utils/search/" + $sd.search,
                    dataType: 'json',
                    data: function(term) {
                      return {
                        uid: $sd.uid,
                        day: $('#date_send').val(),
                        q: term
                      };
                    },
                    results: function(data) {
                      return {
                        results: data
                      };
                    }
                  },
                  formatResult: function(d) {
                    var $markup;
                    $markup = "<div title='" + d.text.title + "'>";
                    $markup += "<span class='repair'>Doc: </span>";
                    $markup += "<span class='truncate-70'>" + d.text.doc_name + "</span>";
                    $markup += "<span class='repair'> - Firma: </span>";
                    $markup += "<span class='truncate-200'>" + d.text.client + "</span>";
                    $markup += "</div>";
                    return $markup;
                  },
                  formatSelection: function(d) {
                    return d.text.name;
                  },
                  formatSearching: function() {
                    return Trst.i18n.msg.searching;
                  },
                  formatNoMatches: function(t) {
                    return Trst.i18n.msg.no_matches;
                  }
                });
                $select.off();
                $select.on('change', function() {
                  var $url;
                  if ($select.select2('val') !== '') {
                    $url = Trst.desk.hdf.attr('action');
                    $url += "/" + ($select.select2('val'));
                    Trst.desk.closeDesk(false);
                    return Trst.desk.init($url);
                  }
                });
              } else {
                $log('Select not handled!');
              }
            });
          },
          buttons: function(btns) {
            btns.each(function() {
              var $bd, $button, $id;
              $button = $(this);
              $bd = $button.data();
              $id = $button.attr('id');
              if (Trst.desk.hdo.dialog === 'filter') {
                if ($id === 'client_d' || $id === 'transp_d') {
                  $button.hide();
                }
                if ($bd.action === 'create') {
                  if (!$id) {
                    $button.button('option', 'disabled', true);
                  }
                }
              } else if (Trst.desk.hdo.dialog === 'create') {
                if (!Clns.desk.delivery_note.validate.create()) {
                  if ($bd.action === 'save') {
                    $button.button('option', 'disabled', true);
                  }
                }
                if ($button.hasClass('icon-refresh')) {
                  $button.off('click');
                  $button.on('click', function() {
                    return Clns.desk.delivery_note.freightCalculate();
                  });
                }
                if ($button.hasClass('icon-plus-sign')) {
                  $button.off('click');
                  $button.on('click', function() {
                    var $url;
                    Clns.desk.delivery_note.freightInsert();
                    $url = "/sys/partial/clns/shared/_doc_add_freight_stock?id_stats=00000000";
                    return $('td.add-freight-container').load($url, function() {
                      return Clns.desk.delivery_note.selects($('select.clns.freight'));
                    });
                  });
                }
                if ($button.hasClass('icon-minus-sign')) {
                  $button.off('click');
                  $button.on('click', function() {
                    $button.parentsUntil('tbody').last().remove();
                    Clns.desk.delivery_note.dlnCalculate();
                    if ($('tr.dln-freight').length === 0) {
                      $('tr.dln-freight-header, tr.dln-freight-total').addClass('hidden');
                      return $('button[data-action="save"]').button('option', 'disabled', true);
                    }
                  });
                }
              } else if (Trst.desk.hdo.dialog === 'show') {
                if ($bd.action === 'print') {
                  $button.on('click', function() {
                    Trst.msgShow(Trst.i18n.msg.report.start);
                    $.fileDownload("/sys/clns/delivery_note/print?id=" + Trst.desk.hdo.oid, {
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
            Clns.desk.tmp.clear();
            if ($('#date_show').length) {
              now = new Date();
              min = Trst.lst.admin === 'true' ? new Date(now.getFullYear(), now.getMonth() - 1, 1) : new Date(now.getFullYear(), now.getMonth(), 1);
              $('#date_show').datepicker('option', 'maxDate', '+0');
              $('#date_show').datepicker('option', 'minDate', min);
            }
            $('.focus').focus();
            Clns.desk.delivery_note.buttons($('button'));
            Clns.desk.delivery_note.selects($('select.clns,input.select2,input.repair'));
            Clns.desk.delivery_note.template = (_ref = $('tr.template')) != null ? _ref.remove() : void 0;
            return $log('Clns.desk.delivery_note.init() OK...');
          }
        }
      }
    });
    return Clns.desk.delivery_note;
  });

}).call(this);
